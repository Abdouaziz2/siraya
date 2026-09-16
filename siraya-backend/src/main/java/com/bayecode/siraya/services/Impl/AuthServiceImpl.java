package com.bayecode.siraya.services.Impl;

import com.bayecode.siraya.entity.OtpEntity;
import com.bayecode.siraya.entity.UserEntity;
import com.bayecode.siraya.exception.ResourceNotFoundException;
import com.bayecode.siraya.mapper.UserMapper;
import com.bayecode.siraya.model.auth.AuthResponseDTO;
import com.bayecode.siraya.model.auth.OtpRequestDTO;
import com.bayecode.siraya.model.auth.OtpRequestResponseDTO;
import com.bayecode.siraya.model.auth.OtpVerifyDTO;
import com.bayecode.siraya.model.auth.PinCreateDTO;
import com.bayecode.siraya.model.auth.PinLoginDTO;
import com.bayecode.siraya.repository.OtpRepository;
import com.bayecode.siraya.repository.UserRepository;
import com.bayecode.siraya.services.AuthService;
import com.bayecode.siraya.services.OtpSender;
import com.bayecode.siraya.services.TokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.HexFormat;
import java.util.regex.Pattern;

@Service
@Transactional
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[1-9]\\d{7,14}$");
    private static final Pattern PIN_PATTERN = Pattern.compile("^\\d{4}$");

    private final OtpRepository otpRepository;
    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final OtpSender otpSender;
    private final TokenService tokenService;
    private final SecureRandom secureRandom = new SecureRandom();
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Value("${siraya.auth.otp-expiration-minutes:5}")
    private long otpExpirationMinutes;

    @Value("${siraya.auth.otp-max-attempts:3}")
    private int otpMaxAttempts;

    @Override
    public OtpRequestResponseDTO requestOtp(OtpRequestDTO request) {
        String phoneNumber = normalizePhoneNumber(request.getPhoneNumber());
        validatePhoneNumber(phoneNumber);

        otpRepository.findFirstByPhoneNumberAndUsedFalseOrderByCreatedAtDesc(phoneNumber)
                .ifPresent(otp -> {
                    otp.setUsed(true);
                    otpRepository.save(otp);
                });

        String code = generateOtpCode();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiresAt = now.plusMinutes(otpExpirationMinutes);

        OtpEntity otp = new OtpEntity();
        otp.setPhoneNumber(phoneNumber);
        otp.setCodeHash(hashCode(code));
        otp.setExpiresAt(expiresAt);
        otp.setAttemptCount(0);
        otp.setMaxAttempts(otpMaxAttempts);
        otp.setUsed(false);
        otp.setCreatedAt(now);
        otpRepository.save(otp);

        otpSender.send(phoneNumber, code);

        return new OtpRequestResponseDTO(phoneNumber, expiresAt);
    }

    @Override
    public AuthResponseDTO verifyOtp(OtpVerifyDTO request) {
        String phoneNumber = normalizePhoneNumber(request.getPhoneNumber());
        validatePhoneNumber(phoneNumber);

        OtpEntity otp = otpRepository.findFirstByPhoneNumberAndUsedFalseOrderByCreatedAtDesc(phoneNumber)
                .orElseThrow(() -> new ResourceNotFoundException("No active OTP found for phone number: " + phoneNumber));

        if (LocalDateTime.now().isAfter(otp.getExpiresAt())) {
            otp.setUsed(true);
            otpRepository.save(otp);
            throw new IllegalArgumentException("OTP has expired");
        }

        if (otp.getAttemptCount() >= otp.getMaxAttempts()) {
            otp.setUsed(true);
            otpRepository.save(otp);
            throw new IllegalArgumentException("Maximum OTP attempts exceeded");
        }

        otp.setAttemptCount(otp.getAttemptCount() + 1);

        if (!hashCode(request.getCode()).equals(otp.getCodeHash())) {
            otpRepository.save(otp);
            throw new IllegalArgumentException("Invalid OTP code");
        }

        UserEntity user = userRepository.findByPhoneNumber(phoneNumber)
                .orElseGet(() -> createUserFromVerifiedPhone(phoneNumber));

        user.setPhoneVerified(true);
        user.setUpdatedAt(LocalDateTime.now());
        UserEntity savedUser = userRepository.save(user);

        otp.setUsed(true);
        otpRepository.save(otp);

        boolean profileComplete = isProfileComplete(savedUser);
        return new AuthResponseDTO(tokenService.generateToken(savedUser), userMapper.asDto(savedUser), profileComplete);
    }

    @Override
    public AuthResponseDTO createPin(PinCreateDTO request) {
        String phoneNumber = normalizePhoneNumber(request.getPhoneNumber());
        validatePhoneNumber(phoneNumber);
        validatePin(request.getPin());

        if (!request.getPin().equals(request.getPinConfirmation())) {
            throw new IllegalArgumentException("PIN confirmation does not match");
        }

        UserEntity user = userRepository.findByPhoneNumber(phoneNumber)
                .orElseGet(() -> createUserFromVerifiedPhone(phoneNumber));

        if (hasText(request.getFirstName())) {
            user.setFirstName(request.getFirstName().trim());
        }
        if (hasText(request.getLastName())) {
            user.setLastName(request.getLastName().trim());
        }
        user.setPinHash(passwordEncoder.encode(request.getPin()));
        user.setPhoneVerified(true);
        user.setUpdatedAt(LocalDateTime.now());

        UserEntity savedUser = userRepository.save(user);
        return new AuthResponseDTO(tokenService.generateToken(savedUser), userMapper.asDto(savedUser), isProfileComplete(savedUser));
    }

    @Override
    public AuthResponseDTO loginWithPin(PinLoginDTO request) {
        String phoneNumber = normalizePhoneNumber(request.getPhoneNumber());
        validatePhoneNumber(phoneNumber);
        validatePin(request.getPin());

        UserEntity user = userRepository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new IllegalArgumentException("Invalid phone number or PIN"));

        if (user.getPinHash() == null || !passwordEncoder.matches(request.getPin(), user.getPinHash())) {
            throw new IllegalArgumentException("Invalid phone number or PIN");
        }

        return new AuthResponseDTO(tokenService.generateToken(user), userMapper.asDto(user), isProfileComplete(user));
    }

    private UserEntity createUserFromVerifiedPhone(String phoneNumber) {
        UserEntity user = new UserEntity();
        user.setPhoneNumber(phoneNumber);
        user.setPhoneVerified(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    private boolean isProfileComplete(UserEntity user) {
        return hasText(user.getFirstName()) && hasText(user.getLastName());
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }

    private String normalizePhoneNumber(String phoneNumber) {
        return phoneNumber == null ? null : phoneNumber.replace(" ", "").trim();
    }

    private void validatePhoneNumber(String phoneNumber) {
        if (phoneNumber == null || !PHONE_PATTERN.matcher(phoneNumber).matches()) {
            throw new IllegalArgumentException("Invalid phone number format");
        }
    }

    private void validatePin(String pin) {
        if (pin == null || !PIN_PATTERN.matcher(pin).matches()) {
            throw new IllegalArgumentException("PIN must contain exactly 4 digits");
        }
    }

    private String generateOtpCode() {
        return String.valueOf(100000 + secureRandom.nextInt(900000));
    }

    private String hashCode(String code) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(digest.digest(code.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to hash OTP code", ex);
        }
    }
}
