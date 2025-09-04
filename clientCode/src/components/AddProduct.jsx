import { useState } from 'react';
import './AddProduct.css';

const AddProduct = ({ onClose }) => {
  const [product, setProduct] = useState({
    name: '',
    description: '',
    price: '',
    imageUrl: ''
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle product submission
    console.log('Product submitted:', product);
    onClose(); // Close modal after submission
  };

  return (
    <div className="add-product">
      <button 
        className="close-btn" 
        onClick={onClose}
        type="button"
        aria-label="Close"
      >
        ×
      </button>
      <h2>Add New Product</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Product Name</label>
          <input
            type="text"
            id="name"
            value={product.name}
            onChange={(e) => setProduct({...product, name: e.target.value})}
            required
          />
        </div>
        
        <div className="form-group">
          <label htmlFor="description">Description</label>
          <textarea
            id="description"
            value={product.description}
            onChange={(e) => setProduct({...product, description: e.target.value})}
            required
          />
        </div>
        
        <div className="form-group">
          <label htmlFor="price">Price ($)</label>
          <input
            type="number"
            id="price"
            step="0.01"
            min="0"
            value={product.price}
            onChange={(e) => setProduct({...product, price: e.target.value})}
            required
          />
        </div>
        
        <button type="submit" className="submit-btn">Add Product</button>
      </form>
    </div>
  );
};

export default AddProduct;