import { useEffect, useState } from 'react';
import './ProductList.css';
import { apiFetch } from '../utils/api';

const ProductList = ({ addToCart }) => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [quantities, setQuantities] = useState({});

  useEffect(() => {
    (async () => {
      try {
        const data = await apiFetch('/api/v1/products');
        setProducts(data || []);
      } catch (e) {
        setError(e.message || 'Failed to load products');
      } finally {
        setLoading(false);
      }
    })();
  }, []);

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

  if (loading) return <div className="product-list"><h2>Products</h2><p>Loading...</p></div>;
  if (error) return <div className="product-list"><h2>Products</h2><p style={{color:'red'}}>{error}</p></div>;

  return (
    <div className="product-list">
      <h2>Products</h2>
      <div className="products-grid">
        {products.map(product => (
          <div key={product.id} className="product-card">

           
            
            {product.image_url && (
              <img src={product.image_url} alt={product.name} className="product-image" />
            )}
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
