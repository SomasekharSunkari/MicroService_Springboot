package com.sekhar.authservice.exceptions;


import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionhandler {
    @ExceptionHandler(UserNameAlreadyExistsException.class)
    public ResponseEntity<Map<String,Object>> handleUsernameAlreadyExists(UserNameAlreadyExistsException ex){
        Map<String,Object> body = new HashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("status", HttpStatus.CONFLICT.value());
        body.put("error", "Conflict");
        body.put("message", ex.getMessage());
        return new ResponseEntity<>(body, HttpStatus.CONFLICT); // 409 Conflict

    }

    @ExceptionHandler({SQLException.class, DataAccessException.class})
    public String handleDatabaseConnectionError(Exception ex) {
        return "Database connection failed: " + ex.getMessage();
    }
}
