package com.sekhar.ecommerce.product;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Setter
@Getter
@Entity

public class Product {

    @Id
    @GeneratedValue
    private Integer id;
    private String name;
    private String description;
    private double availableQuantity;
private BigDecimal price;
    @ManyToOne
    @JoinColumn(name="category_id")
    private Category category;
    private String image_url;

}
