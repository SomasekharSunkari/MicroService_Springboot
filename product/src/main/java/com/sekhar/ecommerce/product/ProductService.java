package com.sekhar.ecommerce.product;

import com.sekhar.ecommerce.exceptions.ProductPurchaseException;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {


    private final ProductrRepository repository;
    private final ProductMapper mappper;
    public Integer createProduct(@Valid ProductRequest request) {
        var product = mappper.toProduct(request);
        return repository.save(product).getId();
    }

    public List<ProductPurchaseResponse> purchaseProducts(List<ProductPurchaseRequest> request) {
        var productIds  = request.stream().map(ProductPurchaseRequest::productId).toList();
        var storedProducts = repository.findAllByIdInOrderById(productIds);
        if(productIds.size() != storedProducts.size()){
            throw new ProductPurchaseException("One or more products does not exists");
        }
        var storesRequests = request.stream().sorted(Comparator.comparing(ProductPurchaseRequest::productId)).toList();
        var purchasedProducts = new ArrayList<ProductPurchaseResponse>();
        for(int i=0;i<storesRequests.size();i++){
            var product = storedProducts.get(i);
            var productRequest =  storesRequests.get(i);
            if(product.getAvailableQuantity() < productRequest.quantity())
            {
                throw  new ProductPurchaseException("Insufficient quantity for product with id : " + product.getId());
            }
            var newAvaialableQuantity = product.getAvailableQuantity() - productRequest.quantity();
            product.setAvailableQuantity(newAvaialableQuantity);
            repository.save(product);
            purchasedProducts.add(mappper.toProductPurChaseResponse(product,productRequest.quantity()));
        }

        return purchasedProducts;
    }

    public ProductResponse findById(Integer productId) {
        return repository.findById(productId).map(mappper::toProductResponse).orElseThrow(()->
                new EntityNotFoundException("Producvt not found with the id "+ productId));
    }

    public List<ProductResponse> findAll() {
        return repository.findAll().stream().map(mappper::toProductResponse).collect(Collectors.toList());
    }
}
