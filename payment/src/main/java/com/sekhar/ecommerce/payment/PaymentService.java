package com.sekhar.ecommerce.payment;

import com.sekhar.ecommerce.Notification.NotificationProducer;
import com.sekhar.ecommerce.Notification.PaymentNotificationRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PaymentService {
    private final NotificationProducer notificationProducer;
    private final PaymentRespository paymentRespository;
    private  final Paymentmapper paymentmapper;

    public Integer createPayment(@Valid PaymentRequest paymentRequest) {

        var payment = paymentRespository.save(paymentmapper.toPayment(paymentRequest));
        notificationProducer.sendNotification(new PaymentNotificationRequest(
                paymentRequest.orderReference(),
                paymentRequest.amount(),
                paymentRequest.paymentMethod(),
                paymentRequest.customer().firstname(),
                paymentRequest.customer().lastname(),
                paymentRequest.customer().email()
        ));
        return payment.getId();
    }
}
