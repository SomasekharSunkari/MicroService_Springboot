package com.sekhar.ecommerce.filters;

import com.sekhar.ecommerce.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.http.HttpHeaders;

import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;


@Component
public class CustomHeaderGatewayFilter extends AbstractGatewayFilterFactory<CustomHeaderGatewayFilter.Config> {
    @Autowired
            private RouteValidator validator;
    @Autowired
            private JwtUtil jwtUtil;
    CustomHeaderGatewayFilter(){
        super(Config.class);
    }
    @Override
    public GatewayFilter apply(Config config) {
        return (((exchange, chain) -> {
            ServerHttpRequest  mutatedRequest =  exchange.getRequest();

            if(validator.isSecured.test(exchange.getRequest())){
                if(!exchange.getRequest().getHeaders().containsKey(HttpHeaders.AUTHORIZATION)){
                    throw  new RuntimeException("Missing Authorization header");
                }

                String authHeader = exchange.getRequest().getHeaders().get(HttpHeaders.AUTHORIZATION).get(0);
                if(authHeader!=null && authHeader.startsWith("Bearer ")){
                    authHeader = authHeader.substring(7);
                }
                try {
                    System.out.println(authHeader);
                        jwtUtil.validateToken(authHeader);
                    mutatedRequest =  exchange.getRequest().mutate().header("loggedInUser",jwtUtil.extractUsername(authHeader)).build();
                }
                catch (Exception e){
                    System.out.println("Invalid Access...!");
                    throw new RuntimeException("An authorized access to application");
                }
            }
            return  chain.filter(exchange.mutate().request(mutatedRequest).build());
        }));
    }

    public static class Config {
        private String headerName;
        private String headerValue;

        // getters and setters
        public String getHeaderName() { return headerName; }
        public void setHeaderName(String headerName) { this.headerName = headerName; }
        public String getHeaderValue() { return headerValue; }
        public void setHeaderValue(String headerValue) { this.headerValue = headerValue; }
    }
}
