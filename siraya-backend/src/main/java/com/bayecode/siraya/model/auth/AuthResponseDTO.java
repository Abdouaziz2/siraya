package com.bayecode.siraya.model.auth;

import com.bayecode.siraya.model.UserDTO;

public class AuthResponseDTO {

    private String token;
    private UserDTO user;
    private Boolean profileComplete;

    public AuthResponseDTO() {
    }

    public AuthResponseDTO(String token, UserDTO user, Boolean profileComplete) {
        this.token = token;
        this.user = user;
        this.profileComplete = profileComplete;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }

    public Boolean getProfileComplete() {
        return profileComplete;
    }

    public void setProfileComplete(Boolean profileComplete) {
        this.profileComplete = profileComplete;
    }
}
