package com.sekhar.ecommerce.product;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductrRepository  extends JpaRepository<Product,Integer> {
    List<Product> findAllByIdInOrderById(List<Integer> productIds);
}
