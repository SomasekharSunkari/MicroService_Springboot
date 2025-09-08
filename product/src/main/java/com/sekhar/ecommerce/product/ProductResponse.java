package com.sekhar.ecommerce.product;

import java.math.BigDecimal;

public record ProductResponse(
         Integer id,
         String name,
         String description,
         double availableQuantity,
         BigDecimal price,
         int categoryId,
         String catrgoryName,
         String categoryDescription,
         String image_url
) {
}
