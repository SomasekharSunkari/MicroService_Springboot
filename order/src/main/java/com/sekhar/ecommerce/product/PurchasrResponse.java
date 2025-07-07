package com.sekhar.ecommerce.product;

import java.math.BigDecimal;

public record PurchasrResponse(
        Integer productId,
        String name,
        String description,
        BigDecimal price,


        double quantity
) {
}
