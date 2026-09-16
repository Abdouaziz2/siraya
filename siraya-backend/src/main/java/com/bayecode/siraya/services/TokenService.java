package com.bayecode.siraya.services;

import com.bayecode.siraya.entity.UserEntity;

public interface TokenService {

    String generateToken(UserEntity user);
}
