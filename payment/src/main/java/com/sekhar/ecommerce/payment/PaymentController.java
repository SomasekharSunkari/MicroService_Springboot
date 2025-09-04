package com.sekhar.ecommerce.payment;


import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/payments")
@RequiredArgsConstructor
public class PaymentController {
    private final PaymentService paymentService;

    @PostMapping
    public ResponseEntity<Integer> createPayment(@RequestBody @Valid PaymentRequest paymentRequest, @RequestHeader(value = "loggedInUser",required = false) String loggedInUser) {
        System.out.println("LoggedIn User from Gateway: "+ loggedInUser);
        return  ResponseEntity.ok(paymentService.createPayment(paymentRequest));


    }
}
