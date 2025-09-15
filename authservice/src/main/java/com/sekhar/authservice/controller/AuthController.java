package com.sekhar.authservice.controller;


import com.sekhar.authservice.dto.AuthRequest;
import com.sekhar.authservice.entity.UserCredential;
import com.sekhar.authservice.exceptions.UserNameAlreadyExistsException;
import com.sekhar.authservice.exceptions.UserNotFoundException;
import com.sekhar.authservice.exceptions.InvalidCredentialsException;
import com.sekhar.authservice.repository.UserCredentialRepository;
import com.sekhar.authservice.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    @Autowired
    private AuthService service;
    @Autowired
    private UserCredentialRepository userCredentialRepository;
    @Autowired
    private AuthenticationManager authenticationManager;

    @PostMapping("/register")
    public Map<String, String> addNewUser(@RequestBody UserCredential user) throws Exception {
        if(userCredentialRepository.findByNameIgnoreCase(user.getName()).isPresent()){
            throw  new UserNameAlreadyExistsException("Username already Taken");
        }
        return service.saveUser(user);
    }

    @PostMapping("/token")
    public Map<String,String> getToken(@RequestBody AuthRequest authRequest) {
        Authentication authenticate = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword()));
        if (authenticate.isAuthenticated()) {
            UserCredential user = userCredentialRepository
                    .findByNameIgnoreCase(authRequest.getUsername())
                    .orElseThrow(() -> new UserNotFoundException("User not found with username: " + authRequest.getUsername()));

            String token= service.generateToken(authRequest.getUsername(),String.valueOf(user.getId()));
            return Map.of("token",token);
        } else {
            throw new InvalidCredentialsException("Invalid username or password");
        }
    }

    @GetMapping("/validate")
    public String validateToken(@RequestParam("token") String token) {
        service.validateToken(token);
        return "Token is valid";
    }

    @GetMapping("/users/{id}")
    public UserCredential getUserById(@PathVariable("id") Integer id){
        return userCredentialRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
    }

    @GetMapping("/users/by-name/{name}")
    public UserCredential getUserByName(@PathVariable("name") String name){
        return userCredentialRepository.findByNameIgnoreCase(name)
                .orElseThrow(() -> new UserNotFoundException("User not found with name: " + name));
    }

    @GetMapping("/users/by-email/{email}")
    public UserCredential getUserByEmail(@PathVariable("email") String email){
        return userCredentialRepository.findByEmailIgnoreCase(email)
                .orElseThrow(() -> new UserNotFoundException("User not found with email: " + email));
    }
}
