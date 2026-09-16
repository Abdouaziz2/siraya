package com.bayecode.siraya.model.auth;

import jakarta.validation.constraints.NotEmpty;

public class PinCreateDTO {

    private String firstName;

    private String lastName;

    @NotEmpty(message = "Phone number is required")
    private String phoneNumber;

    @NotEmpty(message = "PIN is required")
    private String pin;

    @NotEmpty(message = "PIN confirmation is required")
    private String pinConfirmation;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

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

    public String getPinConfirmation() {
        return pinConfirmation;
    }

    public void setPinConfirmation(String pinConfirmation) {
        this.pinConfirmation = pinConfirmation;
    }
}
