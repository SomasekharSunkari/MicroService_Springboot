package com.sekhar.authservice.repository;

import com.sekhar.authservice.entity.UserCredential;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserCredentialRepository  extends JpaRepository<UserCredential,Integer> {
    Optional<UserCredential> findByNameIgnoreCase(String name);
    Optional<UserCredential> findByEmailIgnoreCase(String email);
}