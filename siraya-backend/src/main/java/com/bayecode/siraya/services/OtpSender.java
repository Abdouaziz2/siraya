package com.bayecode.siraya.services;

public interface OtpSender {

    void send(String phoneNumber, String code);
}
