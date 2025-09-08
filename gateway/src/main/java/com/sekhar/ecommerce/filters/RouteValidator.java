package com.sekhar.ecommerce.filters;

import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.function.Predicate;

@Component
public class RouteValidator {

    public  static  final List<String> openApiEndpoints = List.of(
            "/api/v1/auth/register",
            "/api/v1/auth/token",
            "/api/v1/auth/validate",
            "/api/v1/auth/users",
            "/api/v1/auth/users/",


            "/eureka");

    public Predicate<ServerHttpRequest> isSecured = serverHttpRequest -> openApiEndpoints
            .stream().
            noneMatch(uri -> serverHttpRequest.getURI().getPath().contains(uri));
}
