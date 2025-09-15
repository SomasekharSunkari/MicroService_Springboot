package com.sekhar.ecommerce.product;


import com.sekhar.ecommerce.exceptions.BusinessException;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
 import org.springframework.http.HttpHeaders;
import java.util.List;
import static org.springframework.http.HttpHeaders.CONTENT_TYPE;
import static org.springframework.http.HttpMethod.POST;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
@Service
@RequiredArgsConstructor
public class ProductClient {

    @Value("${application.config.product-url}")
    private String productUrl;
    private final RestTemplate restTemplate;

    public List<PurchasrResponse> purchaseProducts(List<PurchaseRequest> requestbody){

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.set(CONTENT_TYPE,APPLICATION_JSON_VALUE);
        HttpEntity<List<PurchaseRequest>> requestEntity = new HttpEntity<>(requestbody,httpHeaders);
        ParameterizedTypeReference<List<PurchasrResponse>> responseType = new ParameterizedTypeReference<>() {};
        ResponseEntity<List<PurchasrResponse>> responseEntity = restTemplate.exchange(

                productUrl + "/purchase",
                POST,
                requestEntity,
                responseType
        );

        if (responseEntity.getStatusCode().isError()) {
            throw new BusinessException("An error occurred while processing the products purchase: " + responseEntity.getStatusCode());
        }
        return  responseEntity.getBody();
    }


}
