package com.sekhar.ecommerce.order;

import org.springframework.stereotype.Service;

@Service
public class Ordermapper {


    public Order toOrder(OrderRequest request) {
        if (request == null) {
            return null;
        }
        return Order.builder()
                .totalAmount(request.getAmount())
                .paymentMethod(request.getPaymentMethod())
                .customerId(request.getCustomerId())
                .build();
    }

    public OrderResponse fromOrder(Order order) {
        return new OrderResponse(
                order.getId(),
                order.getReference(),
                order.getTotalAmount(),
                order.getPaymentMethod(),
                order.getCustomerId()
        );
    }
}
