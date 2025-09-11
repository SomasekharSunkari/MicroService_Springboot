import { Link } from 'react-router-dom';
import './OrderSuccess.css';

const OrderSuccess = ({ orderReference }) => {
  return (
    <div className="order-success">
      <div className="success-card">
        <div className="success-icon">✓</div>
        <h2>Payment Successful!</h2>
        <p>Your order {orderReference} has been placed successfully.</p>
        <div className="success-actions">
          <Link to="/orders" className="view-orders-btn">
            View My Orders
          </Link>
          <Link to="/" className="continue-shopping-btn">
            Continue Shopping
          </Link>
        </div>
      </div>
    </div>
  );
};

export default OrderSuccess;