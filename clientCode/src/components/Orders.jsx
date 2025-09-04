import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Orders.css';

const Orders = () => {
  // Mock orders data - in real app this would come from an API
  const [orders] = useState([
    {
      id: '1',
      date: '2023-09-02',
      total: 899.97,
      status: 'Delivered',
      items: [
        { id: 1, name: 'Smartphone X', quantity: 1, price: 699.99 },
        { id: 2, name: 'Wireless Headphones', quantity: 1, price: 199.98 }
      ]
    },
    {
      id: '2',
      date: '2023-09-01',
      total: 1299.99,
      status: 'Processing',
      items: [
        { id: 3, name: 'Laptop Pro', quantity: 1, price: 1299.99 }
      ]
    }
  ]);

  const navigate = useNavigate();

  return (
    <div className="orders">
      <div className="orders-header">
        <button className="back-btn" onClick={() => navigate('/')}>
          ← Back to Products
        </button>
        <h2>My Orders</h2>
      </div>

      {orders.length === 0 ? (
        <p>No orders found</p>
      ) : (
        <div className="orders-list">
          {orders.map(order => (
            <div key={order.id} className="order-card">
              <div className="order-header">
                <div>
                  <h3>Order #{order.id}</h3>
                  <p className="order-date">Placed on {order.date}</p>
                </div>
                <span className={`order-status ${order.status.toLowerCase()}`}>
                  {order.status}
                </span>
              </div>
              <div className="order-items">
                {order.items.map(item => (
                  <div key={item.id} className="order-item">
                    <span>{item.name} x {item.quantity}</span>
                    <span>${item.price.toFixed(2)}</span>
                  </div>
                ))}
              </div>
              <div className="order-total">
                <strong>Total:</strong> ${order.total.toFixed(2)}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default Orders;