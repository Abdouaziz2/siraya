package com.bayecode.siraya.mapper;

import com.bayecode.siraya.entity.UserEntity;
import com.bayecode.siraya.model.UserDTO;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface UserMapper extends EntityMapper<UserDTO, UserEntity> {
}
