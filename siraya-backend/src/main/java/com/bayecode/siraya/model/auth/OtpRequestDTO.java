package com.bayecode.siraya.model.auth;

import jakarta.validation.constraints.NotEmpty;

public class OtpRequestDTO {

    @NotEmpty(message = "Phone number is required")
    private String phoneNumber;

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
