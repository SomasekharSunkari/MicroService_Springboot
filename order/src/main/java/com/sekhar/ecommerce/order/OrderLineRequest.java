package com.sekhar.ecommerce.order;

public record OrderLineRequest(
        Integer id,
        Integer orderId,Integer productId,double quantity
) {
}
