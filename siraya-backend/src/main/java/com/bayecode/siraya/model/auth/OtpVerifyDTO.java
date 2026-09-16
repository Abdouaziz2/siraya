package com.bayecode.siraya.model.auth;

import jakarta.validation.constraints.NotEmpty;

public class OtpVerifyDTO {

    @NotEmpty(message = "Phone number is required")
    private String phoneNumber;

    @NotEmpty(message = "OTP code is required")
    private String code;

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
