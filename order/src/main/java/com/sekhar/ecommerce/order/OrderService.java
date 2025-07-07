package com.sekhar.ecommerce.order;

import com.sekhar.ecommerce.exceptions.BussinessException;
import com.sekhar.ecommerce.product.ProductClient;
import com.sekhar.ecommerce.product.PurchaseRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import com.sekhar.ecommerce.customer.CustomerClient;
import org.springframework.stereotype.Service;
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final CustomerClient customerClient;
    private final ProductClient productClient;
    private final Ordermapper orderMapper;
    private final OrderLineService orderLineService;


    public Integer createOrder(@Valid OrderRequest request) {
        var customer = customerClient.findCustomerById(request.customerId()).orElseThrow(()->new BussinessException("Cannot create order:: No customer exists with id "+request.customerId()));
        this.productClient.purchaseProducts(request.products());
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
      return 1;
    }
}
