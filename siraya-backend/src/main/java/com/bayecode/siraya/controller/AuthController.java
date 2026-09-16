package com.bayecode.siraya.controller;

import com.bayecode.siraya.model.Response;
import com.bayecode.siraya.model.auth.OtpRequestDTO;
import com.bayecode.siraya.model.auth.OtpVerifyDTO;
import com.bayecode.siraya.model.auth.PinCreateDTO;
import com.bayecode.siraya.model.auth.PinLoginDTO;
import com.bayecode.siraya.services.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("auth")
@RequiredArgsConstructor
@CrossOrigin("*")
public class AuthController {

    private final AuthService authService;

    @Operation(summary = "Request OTP", description = "Generate and send an OTP to the provided phone number")
    @ApiResponses(value = {@ApiResponse(responseCode = "200", description = "OTP generated"), @ApiResponse(responseCode = "400", description = "Invalid phone number")})
    @PostMapping("/otp/request")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> requestOtp(@Valid @RequestBody OtpRequestDTO request) {
        var dto = authService.requestOtp(request);
        return Response.ok().setPayload(dto).setMessage("OTP envoyé");
    }

    @Operation(summary = "Verify OTP", description = "Verify OTP and return an authentication token")
    @ApiResponses(value = {@ApiResponse(responseCode = "200", description = "OTP verified"), @ApiResponse(responseCode = "400", description = "Invalid or expired OTP")})
    @PostMapping("/otp/verify")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> verifyOtp(@Valid @RequestBody OtpVerifyDTO request) {
        var dto = authService.verifyOtp(request);
        return Response.ok().setPayload(dto).setMessage("Authentification réussie");
    }

    @Operation(summary = "Create PIN", description = "Create a 4-digit PIN after confirming it")
    @ApiResponses(value = {@ApiResponse(responseCode = "200", description = "PIN created"), @ApiResponse(responseCode = "400", description = "Invalid PIN")})
    @PostMapping("/pin/create")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> createPin(@Valid @RequestBody PinCreateDTO request) {
        var dto = authService.createPin(request);
        return Response.ok().setPayload(dto).setMessage("PIN créé");
    }

    @Operation(summary = "Login with PIN", description = "Authenticate a user with phone number and 4-digit PIN")
    @ApiResponses(value = {@ApiResponse(responseCode = "200", description = "Authenticated"), @ApiResponse(responseCode = "400", description = "Invalid credentials")})
    @PostMapping("/pin/login")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> loginWithPin(@Valid @RequestBody PinLoginDTO request) {
        var dto = authService.loginWithPin(request);
        return Response.ok().setPayload(dto).setMessage("Authentification réussie");
    }
}
