package com.bayecode.siraya.model.auth;

import jakarta.validation.constraints.NotEmpty;

public class PinLoginDTO {

    @NotEmpty(message = "Phone number is required")
    private String phoneNumber;

    @NotEmpty(message = "PIN is required")
    private String pin;

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPin() {
        return pin;
    }

    public void setPin(String pin) {
        this.pin = pin;
    }
}
