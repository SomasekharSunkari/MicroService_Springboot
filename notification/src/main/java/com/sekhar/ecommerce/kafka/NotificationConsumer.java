package com.sekhar.ecommerce.kafka;


import com.sekhar.ecommerce.email.EmailService;
import com.sekhar.ecommerce.kafka.order.OrderConfirmation;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sekhar.ecommerce.kafka.payment.PaymentConfirmation;
import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

import static com.sekhar.ecommerce.notification.NotificationType.ORDER_CONFIRMATION;
import static com.sekhar.ecommerce.notification.NotificationType.PAYMENT_CONFIRMATION;
import static java.lang.String.format;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationConsumer {

    private final EmailService emailService;
    private final ObjectMapper objectMapper = new ObjectMapper();


    @KafkaListener(topics = "payment-topic" , groupId = "paymentGroup")
    public void consumePaymentSuccessNotification(PaymentConfirmation paymentConfirmation) throws MessagingException {
        try {
            log.info(format("Consuming the message from payment-topic Topic:: %s", paymentConfirmation));
            var customerName = paymentConfirmation.customerFirstname() + " " + paymentConfirmation.customerLastname();
        emailService.sendPaymentSuccessEmail(
                paymentConfirmation.customerEmail(),
                customerName,
                paymentConfirmation.amount(),
                paymentConfirmation.orderReference()
        );
        } catch (Exception e) {
            log.error("Failed to parse payment message: {}", paymentConfirmation, e);
        }
    }

    @KafkaListener(topics = "order-topic" ,groupId = "orderGroup")
    public void consumeOrderConfirmationNotifications(OrderConfirmation orderConfirmation) throws MessagingException {
        try {
            log.info(format("Consuming the message from order-topic Topic:: %s", orderConfirmation));
            var customerName = orderConfirmation.customer().firstname() + " " + orderConfirmation.customer().lastname();
            emailService.sendOrderConfirmationEmail(
                    orderConfirmation.customer().email(),
                    customerName,
                    orderConfirmation.totalAmount(),
                    orderConfirmation.orderReference(),
                    orderConfirmation.products()
            );
        } catch (Exception e) {
            log.error("Failed to parse order message: {}", orderConfirmation, e);
        }
    }
}
