package com.sekhar.ecommerce.exceptions;

public class AuthorizationHeaderMissingException extends RuntimeException {
    public AuthorizationHeaderMissingException(String message) {
        super(message);
    }
}