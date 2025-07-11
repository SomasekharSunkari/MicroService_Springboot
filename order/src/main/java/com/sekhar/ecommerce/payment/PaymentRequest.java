package com.sekhar.ecommerce.payment;

import com.sekhar.ecommerce.customer.CustomerResponse;
import com.sekhar.ecommerce.order.PaymentMethod;

import java.math.BigDecimal;

public record PaymentRequest(
        BigDecimal amount,
        PaymentMethod paymentMethod,
        Integer orderId,
        String orderReference,
        CustomerResponse customer
) {


}
