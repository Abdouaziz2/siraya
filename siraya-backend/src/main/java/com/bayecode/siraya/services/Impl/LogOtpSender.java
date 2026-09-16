package com.bayecode.siraya.services.Impl;

import com.bayecode.siraya.services.OtpSender;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class LogOtpSender implements OtpSender {

    private static final Logger log = LoggerFactory.getLogger(LogOtpSender.class);

    @Override
    public void send(String phoneNumber, String code) {
        log.info("OTP for {} is {}", phoneNumber, code);
    }
}
