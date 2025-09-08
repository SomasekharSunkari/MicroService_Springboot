package com.sekhar.ecommerce.config;


import feign.RequestInterceptor;
import feign.RequestTemplate;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;

@Configuration
public class FeignAuthForwardingConfig {

    @Bean
    public RequestInterceptor authHeaderForwardingInterceptor() {
        return new RequestInterceptor() {
            @Override
            public void apply(RequestTemplate template) {
                RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
                if (requestAttributes instanceof ServletRequestAttributes servletRequestAttributes) {
                    HttpServletRequest currentRequest = servletRequestAttributes.getRequest();
                    String authHeader = currentRequest.getHeader("Authorization");
                    if (authHeader != null && !authHeader.isBlank()) {
                        template.header("Authorization", authHeader);
                    }
                }
            }
        };
    }
}


