//package com.sekhar.ecommerce.notification;
//
//
//import com.sekhar.ecommerce.kafka.order.OrderConfirmation;
//import com.sekhar.ecommerce.kafka.payment.PaymentConfirmation;
//import lombok.*;
//import org.springframework.data.annotation.Id;
//import org.springframework.data.mongodb.core.mapping.Document;
//
//import java.time.LocalDateTime;
//
//@AllArgsConstructor
//@NoArgsConstructor
//@Builder
//@Getter
//@Setter
//@Document
//public class Notification {
//    @Id
//    private String id;
//    private NotificationType type;
//    private LocalDateTime notificationDate;
//    private OrderConfirmation orderConfirmation;
//    private PaymentConfirmation paymentConfirmation;
//}
