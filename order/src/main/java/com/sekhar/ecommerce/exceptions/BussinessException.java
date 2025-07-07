package com.sekhar.ecommerce.exceptions;

import jakarta.annotation.security.DeclareRoles;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data

public class BussinessException extends RuntimeException {
    private final String msg;
}
