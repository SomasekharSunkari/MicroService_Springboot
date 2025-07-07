package com.sekhar.ecommerce.product;


import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Setter
@Getter
@Entity
public class Category {
    @Id
    @GeneratedValue
    private Integer id;
    private String name;
    private String description;
    @OneToMany( mappedBy = "category", cascade = CascadeType.REMOVE)
    private List<Product> products;

}
