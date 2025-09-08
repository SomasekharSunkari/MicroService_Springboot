package com.sekhar.ecommerce.order;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import java.security.Key;
@Component
public class JwtService {
    private static final String SECRET = "5367566B59703373367639792F423F4528482B4D6251655468576D5A71347437"; // must be SAME as in AuthService

    public Claims extractAllClaims(String token) {
        return Jwts.parser()
                .setSigningKey(getSignKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public String extractCustomerId(String token) {
        Claims claims = extractAllClaims(token);
        Object customerId = claims.get("customerId");
        return customerId.toString();
    }


    private Key getSignKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
