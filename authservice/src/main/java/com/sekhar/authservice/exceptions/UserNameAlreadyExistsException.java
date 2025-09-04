package com.sekhar.authservice.exceptions;


public class UserNameAlreadyExistsException extends  RuntimeException{
    public UserNameAlreadyExistsException(String message){
        super(message);
    }
}
