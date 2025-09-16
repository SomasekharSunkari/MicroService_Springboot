package com.sekhar.authservice.controller;

import com.sekhar.authservice.entity.UserCredential;
import com.sekhar.authservice.repository.UserCredentialRepository;
import com.sekhar.authservice.service.AuthService;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthControllerTest {
    @Mock
    UserCredentialRepository userCredentialRepository;

    @Mock
    AuthService authService;
    @InjectMocks
    AuthController authController;

    @Test
    void testUserRegistrationSuccess() throws Exception {
        // Arrange
        UserCredential user = new UserCredential();
        user.setName("sekhar123");
        user.setFirstname("Sekhar");
        user.setLastname("Sunkari");
        user.setEmail("sekhar@example.com");
        user.setPassword("plainPassword");
        user.setStreet("Main Street");
        user.setHouseNumber("12A");
        user.setZipCode("500001");

        // Repository says "username is free"
        when(userCredentialRepository.findByNameIgnoreCase("sekhar123")).thenReturn(Optional.empty());

        // Service saves user successfully
        when(authService.saveUser(user)).thenReturn(Map.of("message", "user added to the system"));

        // Act
        Map<String, String> response = authController.addNewUser(user);

        // Assert
        assertEquals("user added to the system", response.get("message"));
        verify(userCredentialRepository, times(1)).findByNameIgnoreCase("sekhar123");
        verify(authService, times(1)).saveUser(user);
    }
    @Test
    void checkTokenValidty(){

        String token = "valid-token";

        // Stub the service call (do nothing since it's void)
        doNothing().when(authService).validateToken(token);

        // Act
        String response = authController.validateToken(token);

        // Assert
        assertEquals("Token is valid", response);
        verify(authService,times(1)).validateToken(token);

    }
}