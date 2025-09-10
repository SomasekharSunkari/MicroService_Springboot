import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Checkout.css';
import { apiFetch } from '../utils/api';

const Checkout = ({ cartItems, onComplete }) => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: '',
    firstName: '',
    lastName: '',
    address: '',
    city: '',
    zipCode: '',
    cardNumber: '',
    expiryDate: '',
    cvv: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const total = cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const paymentData = {
        amount: total,
        paymentMethod: 'CREDIT_CARD',
        customer: {
          id: "1",
          firstname: formData.firstName,
          lastname: formData.lastName,
          email: formData.email
        }
      };

      const response = await fetch('http://public-ms-balancer-968609518.eu-north-1.elb.amazonaws.com/api/v1/payments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('jwt_token')}`
        },
        body: JSON.stringify(paymentData)
      });

      if (!response.ok) {
        throw new Error('Payment failed');
      }

      const paymentResponse = await response.json();
      
      // Call onComplete and navigate to confirmation
      onComplete(paymentResponse.orderReference);
      navigate('/order-confirmation', { 
        state: { orderReference: paymentResponse.orderReference }
      });

    } catch (err) {
      setError(err.message || 'An error occurred during checkout');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="checkout">
      <button className="back-btn" onClick={() => navigate('/cart')}>
        ← Back to Cart
      </button>
      <h2>Checkout</h2>
      {error && <div className="error-message">{error}</div>}
      <div className="checkout-container">
        <form onSubmit={handleSubmit}>
          <div className="form-section">
            <h3>Contact Information</h3>
            <input
              type="email"
              name="email"
              placeholder="Email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-section">
            <h3>Shipping Information</h3>
            <div className="form-row">
              <input
                type="text"
                name="firstName"
                placeholder="First Name"
                value={formData.firstName}
                onChange={handleChange}
                required
              />
              <input
                type="text"
                name="lastName"
                placeholder="Last Name"
                value={formData.lastName}
                onChange={handleChange}
                required
              />
            </div>
            <input
              type="text"
              name="address"
              placeholder="Address"
              value={formData.address}
              onChange={handleChange}
              required
            />
            <div className="form-row">
              <input
                type="text"
                name="city"
                placeholder="City"
                value={formData.city}
                onChange={handleChange}
                required
              />
              <input
                type="text"
                name="zipCode"
                placeholder="ZIP Code"
                value={formData.zipCode}
                onChange={handleChange}
                required
              />
            </div>
          </div>

          <div className="order-summary">
            <h3>Order Summary</h3>
            {cartItems.map(item => (
              <div key={item.id} className="order-item">
                <span>{item.name} x {item.quantity}</span>
                <span>${(item.price * item.quantity).toFixed(2)}</span>
              </div>
            ))}
            <div className="total">
              <strong>Total:</strong> ${total.toFixed(2)}
            </div>
          </div>

          <button 
            type="submit" 
            className="place-order-btn" 
            disabled={loading}
          >
            {loading ? (
              <div className="loading-state">
                <span className="spinner"></span>
                Processing Order...
              </div>
            ) : (
              'Place Order'
            )}
          </button>
        </form>
      </div>
    </div>
  );
};

export default Checkout;