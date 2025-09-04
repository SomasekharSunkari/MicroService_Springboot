import { useState } from 'react';
import './ProductList.css';

const dummyProducts = [
  {
    id: 1,
    name: "Smartphone X",
    description: "Latest smartphone with amazing features",
    price: 699.99,
    image: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&auto=format"
  },
  {
    id: 2,
    name: "Laptop Pro",
    description: "High-performance laptop for professionals",
    price: 1299.99,
    image: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&auto=format"
  },
  {
    id: 3,
    name: "Wireless Headphones",
    description: "Premium noise-cancelling headphones",
    price: 199.99,
    image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format"
  },
  {
    id: 4,
    name: "Smart Watch",
    description: "Fitness tracking and notifications",
    price: 249.99,
    image: "https://via.placeholder.com/200"
  },
  {
    id: 5,
    name: "Tablet Ultra",
    description: "Perfect for work and entertainment",
    price: 499.99,
    image: "https://via.placeholder.com/200"
  },
  {
    id: 6,
    name: "Gaming Console",
    description: "Next-gen gaming experience",
    price: 499.99,
    image: "https://via.placeholder.com/200"
  },
  {
    id: 7,
    name: "Wireless Speaker",
    description: "360-degree sound experience",
    price: 129.99,
    image: "https://via.placeholder.com/200"
  },
  {
    id: 8,
    name: "Camera Pro",
    description: "Professional-grade digital camera",
    price: 899.99,
    image: "https://via.placeholder.com/200"
  },
  {
    id: 9,
    name: "Smart Home Hub",
    description: "Control your entire home",
    price: 149.99,
    image: "https://via.placeholder.com/200"
  },
  {
    id: 10,
    name: "Fitness Tracker",
    description: "Track your health and activities",
    price: 79.99,
    image: "https://via.placeholder.com/200"
  }
];

const ProductList = ({ addToCart }) => {
  const [quantities, setQuantities] = useState({});

  const handleQuantityChange = (productId, value) => {
    setQuantities(prev => ({
      ...prev,
      [productId]: Math.max(1, (prev[productId] || 1) + value)
    }));
  };

  const handleAddToCart = (product) => {
    const quantity = quantities[product.id] || 1;
    addToCart(product, quantity);
    setQuantities(prev => ({ ...prev, [product.id]: 1 })); // Reset quantity after adding
  };

  return (
    <div className="product-list">
      <h2>Products</h2>
      <div className="products-grid">
        {dummyProducts.map(product => (
          <div key={product.id} className="product-card">
            <img src={product.image} alt={product.name} className="product-image" />
            <h3>{product.name}</h3>
            <p>{product.description}</p>
            <p className="price">${product.price}</p>
            <div className="quantity-controls">
              <button onClick={() => handleQuantityChange(product.id, -1)}>-</button>
              <span>{quantities[product.id] || 1}</span>
              <button onClick={() => handleQuantityChange(product.id, 1)}>+</button>
            </div>
            <button 
              className="add-to-cart-btn"
              onClick={() => handleAddToCart(product)}
            >
              Add to Cart
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ProductList;