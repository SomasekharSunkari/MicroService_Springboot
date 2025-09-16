package com.sekhar.authservice.service;

import com.sekhar.authservice.entity.UserCredential;
import com.sekhar.authservice.repository.UserCredentialRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.webauthn.api.CredentialRecord;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


//@SpringBootTest
@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    UserCredentialRepository userCredentialRepository;

    @Mock
    PasswordEncoder encoder;

    @InjectMocks
    AuthService authService;

    @Test
    void saveUserNullTest(){
    NullPointerException exception = assertThrows(NullPointerException.class,()-> authService.saveUser(null));
    assertEquals("Credentials cannot be Null",exception.getMessage());
    }
    @Test
    void TestUserSave(){
        UserCredential userCredential = new UserCredential();
        userCredential.setEmail("sekhar@gmail.com");
        userCredential.setPassword("sekhar");

        when(encoder.encode("sekhar")).thenReturn("123sekhar");
        Map<String,String> result = authService.saveUser(userCredential);
        assertEquals("123sekhar",userCredential.getPassword());
        verify(userCredentialRepository,times(1)).save(userCredential);
        assertEquals("user added to the system",result.get("message"));

    }

}