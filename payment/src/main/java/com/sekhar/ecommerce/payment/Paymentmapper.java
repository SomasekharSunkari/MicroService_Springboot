package com.sekhar.ecommerce.payment;


import org.springframework.stereotype.Service;

@Service
public class Paymentmapper {

    public Payment toPayment(PaymentRequest paymentRequest) {
        if(paymentRequest == null){
            return  null;
        }
        return Payment.builder()
                        .id(paymentRequest.id()).
                        paymentMethode(paymentRequest.paymentMethod()).
                        amount(paymentRequest.amount()).
                        orderId(paymentRequest.orderId()).
                        build();
    }
}
