package com.sekhar.ecommerce.handler;


import com.sekhar.ecommerce.exceptions.BusinessException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    record ApiError(OffsetDateTime timestamp, int status, String error, String message, Map<String,String> details) {}

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiError> handleBusiness(BusinessException e){
        return build(HttpStatus.UNPROCESSABLE_ENTITY, e.getMessage(), null);
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(EntityNotFoundException e){
        return build(HttpStatus.NOT_FOUND, e.getMessage(), null);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException e){
        var errors = new HashMap<String,String>();
        e.getBindingResult().getAllErrors().forEach(error -> {
            var fieldName = ((FieldError) error).getField();
            var errorMsg = error.getDefaultMessage();
            errors.put(fieldName, errorMsg);
        });
        return build(HttpStatus.BAD_REQUEST, "Validation failed", errors);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleAny(Exception e){
        e.printStackTrace();

        return build(
                HttpStatus.INTERNAL_SERVER_ERROR,
                e.getClass().getSimpleName() + ": " + e.getMessage(),  // show actual exception
                null
        );    }

    private ResponseEntity<ApiError> build(HttpStatus status, String message, Map<String,String> details){
        return ResponseEntity.status(status)
                .body(new ApiError(OffsetDateTime.now(), status.value(), status.getReasonPhrase(), message, details));
    }
}


