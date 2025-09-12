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
      const token = localStorage.getItem('jwt_token');
      if (!token) {
        alert('Please sign in first.');
        setLoading(false);
        return;
      }

      // Step 1: Create order
      const orderRequest = {
        amount: total,
        paymentMethod: 'CREDIT_CARD',
        customerId: formData.email, // Or actual customer id if available
        products: cartItems.map(i => ({ productId: i.id, quantity: i.quantity }))
      };

      const createdOrderId = await apiFetch('/api/v1/orders/order', { 
        method: 'POST', 
        body: orderRequest 
      });

      // Step 2: Fetch order details to get reference
      const orderDetails = await apiFetch(`/api/v1/orders/${createdOrderId}`);

      // Step 3: Process payment
      const paymentRequest = {
        id: null,
        amount: orderDetails.amount,
        paymentMethod: orderDetails.paymentMethod,
        orderId: orderDetails.id,
        orderReference: orderDetails.reference,
        customer: {
          firstname: formData.firstName,
          lastname: formData.lastName,
          email: formData.email
        }
      };

      await apiFetch('/api/v1/payments/pay', { 
        method: 'POST', 
        body: paymentRequest 
      });

      // Step 4: Navigate to confirmation page
      onComplete(orderDetails.reference);
      navigate('/order-confirmation', { 
        state: { orderReference: orderDetails.reference }
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
