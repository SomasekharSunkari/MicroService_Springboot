package com.sekhar.ecommerce.orderline;

import com.sekhar.ecommerce.order.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;


@Repository
public interface OrderLineRepository  extends JpaRepository<OrderLine,Integer> {
    List<OrderLine> findAllByOrderId(Integer orderId);
}
