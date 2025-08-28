package com.sekhar.ecommerce.order;

import com.sekhar.ecommerce.exceptions.BussinessException;
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
        var customer = customerClient.findCustomerById(request.customerId()).orElseThrow(()->new BussinessException("Cannot create order:: No customer exists with id "+request.customerId()));
      var purchasedProducts =   this.productClient.purchaseProducts(request.products());
        var order = this.orderRepository.save(orderMapper.toOrder(request));
        for (PurchaseRequest purchaseRequest : request.products()) {
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
                request.reference(),
                request.amount(),
                request.paymentMethod(),
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
