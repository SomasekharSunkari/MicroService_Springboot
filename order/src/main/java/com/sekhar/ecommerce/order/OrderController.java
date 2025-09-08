package com.sekhar.ecommerce.order;


import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;
    private final JwtService jwtService;

    @PostMapping
    public ResponseEntity<Integer> createOrder(@RequestBody @Valid OrderRequest request,@RequestHeader("Authorization") String authHeader) {
        String token = authHeader.replace("Bearer ", "");

        // Extract customerId from JWT
        String customerId = jwtService.extractCustomerId(token);

        // Inject into request
        request.setCustomerId(customerId);
        System.out.println(authHeader +"  While creating the order ok ");
        System.out.println("Error before creating order also");
        return ResponseEntity.ok(orderService.createOrder(request));
    }

    @GetMapping
    public ResponseEntity<List<OrderResponse>> findAll(){
        return ResponseEntity.ok(orderService.findAllOrders());
    }
    @GetMapping("/{order-id}")
    public ResponseEntity<OrderResponse> findById(
            @PathVariable("order-id") Integer orderId

    ) {
        return ResponseEntity.ok(orderService.findById(orderId));
    }
}
