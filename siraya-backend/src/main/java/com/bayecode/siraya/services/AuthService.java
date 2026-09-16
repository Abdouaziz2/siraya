package com.bayecode.siraya.services;

import com.bayecode.siraya.model.auth.AuthResponseDTO;
import com.bayecode.siraya.model.auth.OtpRequestDTO;
import com.bayecode.siraya.model.auth.OtpRequestResponseDTO;
import com.bayecode.siraya.model.auth.OtpVerifyDTO;
import com.bayecode.siraya.model.auth.PinCreateDTO;
import com.bayecode.siraya.model.auth.PinLoginDTO;

public interface AuthService {

    OtpRequestResponseDTO requestOtp(OtpRequestDTO request);

    AuthResponseDTO verifyOtp(OtpVerifyDTO request);

    AuthResponseDTO createPin(PinCreateDTO request);

    AuthResponseDTO loginWithPin(PinLoginDTO request);
}
