package com.bayecode.siraya.repository;

import com.bayecode.siraya.entity.OtpEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OtpRepository extends JpaRepository<OtpEntity, Long> {

    Optional<OtpEntity> findFirstByPhoneNumberAndUsedFalseOrderByCreatedAtDesc(String phoneNumber);
}
