package com.bayecode.siraya.model.auth;

import java.time.LocalDateTime;

public class OtpRequestResponseDTO {

    private String phoneNumber;
    private LocalDateTime expiresAt;

    public OtpRequestResponseDTO() {
    }

    public OtpRequestResponseDTO(String phoneNumber, LocalDateTime expiresAt) {
        this.phoneNumber = phoneNumber;
        this.expiresAt = expiresAt;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }
}
