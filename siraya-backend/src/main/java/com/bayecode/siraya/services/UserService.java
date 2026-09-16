package com.bayecode.siraya.services;

import com.bayecode.siraya.model.UserDTO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Map;

public interface UserService {

    UserDTO createUser(UserDTO userDTO);

    UserDTO updateUser(UserDTO userDTO);

    void deleteUser(Long id);

    UserDTO getUser(Long id);

    Page<UserDTO> getAllUsers(Map<String, String> searchParams, Pageable pageable);
}
