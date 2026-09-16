package com.bayecode.siraya.controller;

import com.bayecode.siraya.model.Response;
import com.bayecode.siraya.model.UserDTO;
import com.bayecode.siraya.services.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("users")
@RequiredArgsConstructor
@CrossOrigin("*")
public class UserController {

    private final UserService userService;

    @Operation(summary = "Create user", description = "This endpoint creates a user")
    @ApiResponses(value = {@ApiResponse(responseCode = "201", description = "Success"), @ApiResponse(responseCode = "400", description = "Request sent by the client was syntactically incorrect"), @ApiResponse(responseCode = "500", description = "Internal server error during request processing")})
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Response<Object> createUser(@Valid @RequestBody UserDTO userDTO) {
        var dto = userService.createUser(userDTO);
        return Response.created().setPayload(dto).setMessage("Utilisateur créé");
    }

    @PutMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> updateUser(@Parameter(name = "id", description = "the user id to update") @PathVariable("id") Long id, @Valid @RequestBody UserDTO userDTO) {
        userDTO.setId(id);
        var dto = userService.updateUser(userDTO);
        return Response.ok().setPayload(dto).setMessage("Utilisateur modifié");
    }

    @Operation(summary = "Read user", description = "This endpoint is used to read user by id")
    @ApiResponses(value = {@ApiResponse(responseCode = "200", description = "Success"), @ApiResponse(responseCode = "400", description = "Request sent by the client was syntactically incorrect"), @ApiResponse(responseCode = "404", description = "Resource access does not exist"), @ApiResponse(responseCode = "500", description = "Internal server error during request processing")})
    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> getUser(@Parameter(name = "id", description = "the user id") @PathVariable Long id) {
        var dto = userService.getUser(id);
        return Response.ok().setPayload(dto).setMessage("Utilisateur trouvé");
    }

    @Operation(summary = "Read all users", description = "It takes page parameters and returns the matching users")
    @ApiResponses(value = {@ApiResponse(responseCode = "200", description = "Success"), @ApiResponse(responseCode = "500", description = "Internal server error during request processing")})
    @GetMapping("/all")
    @ResponseStatus(HttpStatus.OK)
    public Response<Object> getAllUsers(@RequestParam Map<String, String> searchParams, Pageable pageable) {
        var page = userService.getAllUsers(searchParams, pageable);
        Response.PageMetadata metadata = Response.PageMetadata.builder().number(page.getNumber()).totalElements(page.getTotalElements()).size(page.getSize()).totalPages(page.getTotalPages()).build();
        return Response.ok().setPayload(page.getContent()).setMetadata(metadata);
    }

    @Operation(summary = "Delete user", description = "Delete user by id")
    @ApiResponses(value = {@ApiResponse(responseCode = "204", description = "No content"), @ApiResponse(responseCode = "400", description = "Request sent by the client was syntactically incorrect"), @ApiResponse(responseCode = "404", description = "Resource access does not exist"), @ApiResponse(responseCode = "500", description = "Internal server error during request processing")})
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUser(@PathVariable("id") Long id) {
        userService.deleteUser(id);
    }
}
