package com.sekhar.ecommerce.exception;


import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class BussinessEception extends RuntimeException {
  private final String msg;
}
