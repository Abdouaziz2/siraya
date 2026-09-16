package com.bayecode.siraya.services.Impl;

import com.bayecode.siraya.entity.UserEntity;
import com.bayecode.siraya.services.TokenService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

@Service
public class SimpleTokenService implements TokenService {

    @Value("${siraya.auth.token-secret:change-this-secret}")
    private String tokenSecret;

    @Value("${siraya.auth.token-expiration-seconds:86400}")
    private long tokenExpirationSeconds;

    @Override
    public String generateToken(UserEntity user) {
        long issuedAt = Instant.now().getEpochSecond();
        long expiresAt = issuedAt + tokenExpirationSeconds;
        String payload = user.getId() + ":" + user.getPhoneNumber() + ":" + issuedAt + ":" + expiresAt;
        String signature = sign(payload);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(payload.getBytes(StandardCharsets.UTF_8)) + "." + signature;
    }

    private String sign(String payload) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(tokenSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(mac.doFinal(payload.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to generate authentication token", ex);
        }
    }
}
