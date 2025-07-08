package com.sekhar.ecommerce.kafka;

import com.sekhar.ecommerce.customer.CustomerResponse;
import com.sekhar.ecommerce.order.PaymentMethod;
import com.sekhar.ecommerce.product.PurchasrResponse;

import java.math.BigDecimal;
import java.util.List;

public record OrderConfirmation(
        String orderReference,
        BigDecimal totalAmount,
        PaymentMethod paymentMethod,
        CustomerResponse customerResponse,
        List<PurchasrResponse> products
) {
}
