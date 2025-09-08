import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Orders.css';
import { apiFetch } from '../utils/api';

const Orders = () => {
  const [ordersList, setOrdersList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    (async () => {
      try {
        const data = await apiFetch('/api/v1/orders');
        
        // Take only first 10 orders and map to simplified objects
        const simplifiedOrders = Array.isArray(data) 
          ? data.slice(0, 10).map(order => ({
              id: order.id,
              reference: order.reference,
              amount: order.amount,
              paymentMethod: order.paymentMethod
            }))
          : [];

        setOrdersList(simplifiedOrders);
      } catch (e) {
        setError(e.message || 'Failed to load orders');
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  if (loading) return <div className="orders"><h2>My Orders</h2><p>Loading...</p></div>;
  if (error) return <div className="orders"><h2>My Orders</h2><p style={{ color: 'red' }}>{error}</p></div>;

  return (
    <div className="orders">
      <div className="orders-header">
        <button className="back-btn" onClick={() => navigate('/')}>
          ← Back to Products
        </button>
        <h2>Recent Orders</h2>
      </div>

      {ordersList.length === 0 ? (
        <p>No orders found</p>
      ) : (
        <div className="orders-list">
          {ordersList.map(order => (
            <div key={order.id} className="order-card">
              <div className="order-header">
                <h3>Order #{order.id}</h3>
                <span className="order-reference">
                  Ref: {order.reference || 'N/A'}
                </span>
              </div>
              <div className="order-summary">
                <div className="order-info">
                  <span>Payment: {order.paymentMethod}</span>
                  <span className="amount">
                    ${order.amount?.toFixed(2) || 0}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default Orders;
