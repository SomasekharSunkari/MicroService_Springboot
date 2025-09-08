package com.sekhar.ecommerce.order;

import com.sekhar.ecommerce.product.PurchaseRequest;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Data
@Getter
@Setter
public class OrderRequest {
        @Positive(message = "Order amount should be positive")
        private BigDecimal amount;
        @NotNull(message = "Payment method should be precised")
        private PaymentMethod paymentMethod;
//        @NotBlank(message = "Customer ID should be present")
        private String customerId;
        @NotEmpty(message = "You should at least purchase one product")
        private List<PurchaseRequest> products;
}