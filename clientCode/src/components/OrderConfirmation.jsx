import { useLocation, Link } from 'react-router-dom';
import './OrderConfirmation.css';

const OrderConfirmation = () => {
  const location = useLocation();
  const { orderReference } = location.state || {};

  return (
    <div className="order-confirmation">
      <div className="confirmation-card">
        <div className="success-checkmark">✓</div>
        <h2>Thank You for Your Order!</h2>
        <p className="confirmation-message">
          Your order has been successfully placed.
          {orderReference && (
            <span className="order-reference">
              Order Reference: {orderReference}
            </span>
          )}
        </p>
        <div className="confirmation-actions">
          <Link to="/" className="home-button">
            Return to Home
          </Link>
          <Link to="/orders" className="view-orders">
            View My Orders
          </Link>
        </div>
      </div>
    </div>
  );
};

export default OrderConfirmation;