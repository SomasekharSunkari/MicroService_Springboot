package com.sekhar.ecommerce.order;

import com.sekhar.ecommerce.exceptions.BusinessException;
import com.sekhar.ecommerce.kafka.OrderConfirmation;
import com.sekhar.ecommerce.kafka.OrderProducer;
import com.sekhar.ecommerce.orderline.OrderLineRequest;
import com.sekhar.ecommerce.orderline.OrderLineService;
import com.sekhar.ecommerce.product.ProductClient;
import com.sekhar.ecommerce.product.PurchaseRequest;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import com.sekhar.ecommerce.customer.CustomerClient;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final CustomerClient customerClient;
    private final ProductClient productClient;
    private final Ordermapper orderMapper;
    private final OrderLineService orderLineService;
    private final OrderProducer orderProducer;

    public Integer createOrder(@Valid OrderRequest request) {
        var customer = customerClient.findCustomerById(request.getCustomerId()).orElseThrow(()->new BusinessException("Cannot create order:: No customer exists with id "+request.getCustomerId()));
        System.out.println("Customer id before eror");
        var purchasedProducts = this.productClient.purchaseProducts(request.getProducts());
        System.out.println(purchasedProducts);

        // Generate server-side order reference (Option A)
        String generatedReference = "ORD-" + System.currentTimeMillis() + "-" + java.util.UUID.randomUUID().toString().substring(0,8).toUpperCase();
        System.out.println(generatedReference);
        var order = orderMapper.toOrder(request);
        order.setReference(generatedReference);
        order = this.orderRepository.save(order);
        System.out.println("Order ID is "+ order.getId());
        for (PurchaseRequest purchaseRequest : request.getProducts()) {
            orderLineService.saveOrderLine(
                    new OrderLineRequest(
                            null,
                            order.getId(),
                            purchaseRequest.productId(),
                            purchaseRequest.quantity()
                    )
            );
        }
        orderProducer.sendOrderConfirmation(new OrderConfirmation(
                order.getReference(),
                request.getAmount(),
                request.getPaymentMethod(),
                customer,
                purchasedProducts
        ));
      return order.getId();
    }

    public List<OrderResponse> findAllOrders() {
        return orderRepository.findAll()
                .stream()
                .map(orderMapper::fromOrder)
                .collect(Collectors.toList());

    }

    public OrderResponse findById(Integer id) {
        return orderRepository.findById(id)
                .map(orderMapper::fromOrder)
                .orElseThrow(() -> new EntityNotFoundException(String.format("No order found with the provided ID: %d", id)));
    }
}
