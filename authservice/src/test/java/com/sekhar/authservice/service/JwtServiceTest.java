package com.sekhar.authservice.service;

import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class JwtServiceTest {

    @Mock
    JwtService jwtService;

    @BeforeEach
    void setUp(){
        jwtService = new JwtService();
    }

    @Test
    void generateToken(){
        String username= "sekhar";
        String customerId = "C123";

        String token = jwtService.generateToken(username,customerId);

        assertNotNull(token);

        assertDoesNotThrow(()->jwtService.validateToken(token));

    }

    @Test
    void extractUsernametest(){
        String username = "Sekhar";
        String token = jwtService.generateToken(username,"123");

        Claims claims =  jwtService.extractAllClaims(token);

        assertEquals(username,claims.getSubject());
    }


    @Test
    void testExtractClaims(){
        String token = jwtService.generateToken("sekhar","123");

        Claims claims = jwtService.extractAllClaims(token);

        assertEquals("sekhar",claims.getSubject());
        assertEquals("123",claims.get("customerId"));
    }
    @Test
    void testExtractCustomerId(){
        String customerId = "123";
        String token = jwtService.generateToken("sekhar",customerId);
        String tokenaExtracted = jwtService.extractCustomerId(token);

        assertEquals(customerId,tokenaExtracted);
    }

}