import { useLocation, useNavigate } from 'react-router-dom';
import './OrderSuccess.css';

const OrderSuccess = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { orderReference } = location.state || {};

  return (
    <div className="order-success">
      <div className="success-card">
        <div className="success-icon">✓</div>
        <h1>Order Successful!</h1>
        <p>Thank you for your purchase</p>
        {orderReference && (
          <p className="order-reference">Order Reference: {orderReference}</p>
        )}
        <div className="action-buttons">
          <button onClick={() => navigate('/orders')}>
            View Orders
          </button>
          <button onClick={() => navigate('/')}>
            Continue Shopping
          </button>
        </div>
      </div>
    </div>
  );
};

export default OrderSuccess;