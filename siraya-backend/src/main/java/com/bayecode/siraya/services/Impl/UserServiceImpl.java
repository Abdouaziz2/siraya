package com.bayecode.siraya.services.Impl;

import com.bayecode.siraya.entity.UserEntity;
import com.bayecode.siraya.exception.DuplicateResourceException;
import com.bayecode.siraya.exception.ResourceNotFoundException;
import com.bayecode.siraya.mapper.UserMapper;
import com.bayecode.siraya.model.UserDTO;
import com.bayecode.siraya.repository.UserRepository;
import com.bayecode.siraya.services.UserService;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Map;
import java.util.Objects;

@Service
@Transactional
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    @Override
    public UserDTO createUser(UserDTO userDTO) {
        validateUniquePhoneNumber(userDTO.getPhoneNumber(), null);

        var entity = userMapper.asEntity(userDTO);
        var savedEntity = userRepository.save(entity);
        return userMapper.asDto(savedEntity);
    }

    @Override
    public UserDTO updateUser(UserDTO userDTO) {
        var entity = getUserEntity(userDTO.getId());
        validateUniquePhoneNumber(userDTO.getPhoneNumber(), userDTO.getId());

        entity.setFirstName(userDTO.getFirstName());
        entity.setLastName(userDTO.getLastName());
        entity.setPhoneNumber(userDTO.getPhoneNumber());
        entity.setEmail(userDTO.getEmail());
        entity.setStatus(userDTO.getStatus());
        entity.setPhoneVerified(userDTO.getPhoneVerified());

        var updatedEntity = userRepository.save(entity);
        return userMapper.asDto(updatedEntity);
    }

    @Override
    public void deleteUser(Long id) {
        userRepository.delete(getUserEntity(id));
    }

    @Override
    public UserDTO getUser(Long id) {
        return userMapper.asDto(getUserEntity(id));
    }

    @Override
    public Page<UserDTO> getAllUsers(Map<String, String> searchParams, Pageable pageable) {
        return userRepository.findAll(buildSearch(searchParams), pageable)
                .map(userMapper::asDto);
    }

    private Specification<UserEntity> buildSearch(Map<String, String> searchParams) {
        return (root, query, criteriaBuilder) -> {
            var predicates = new ArrayList<Predicate>();

            if (Objects.nonNull(searchParams)) {
                if (searchParams.containsKey("firstName")) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("firstName")), like(searchParams.get("firstName"))));
                }
                if (searchParams.containsKey("lastName")) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("lastName")), like(searchParams.get("lastName"))));
                }
                if (searchParams.containsKey("email")) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), like(searchParams.get("email"))));
                }
                if (searchParams.containsKey("phoneNumber")) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("phoneNumber")), like(searchParams.get("phoneNumber"))));
                }
                if (searchParams.containsKey("status")) {
                    predicates.add(criteriaBuilder.equal(root.get("status").as(String.class), searchParams.get("status")));
                }
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
    }

    private String like(String value) {
        return "%" + value.toLowerCase() + "%";
    }

    private void validateUniquePhoneNumber(String phoneNumber, Long currentUserId) {
        if (phoneNumber == null || phoneNumber.isBlank()) {
            return;
        }

        boolean exists = currentUserId == null
                ? userRepository.existsByPhoneNumber(phoneNumber)
                : userRepository.existsByPhoneNumberAndIdNot(phoneNumber, currentUserId);

        if (exists) {
            throw new DuplicateResourceException("Phone number already exists: " + phoneNumber);
        }
    }

    private UserEntity getUserEntity(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
    }
}
