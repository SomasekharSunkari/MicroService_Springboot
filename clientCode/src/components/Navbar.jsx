import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './NavBar.css';

const NavBar = ({ 
  cartItemCount, 
  setShowCart, 
  setShowAddProduct, 
  isAuthenticated, 
  setIsAuthenticated 
}) => {
  const navigate = useNavigate();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSignIn, setIsSignIn] = useState(true);
  const [formData, setFormData] = useState({
    name: '',
    username: '',
    password: ''
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (!isSignIn) {
        // Registration
        const response = await fetch('http://localhost:8222/api/v1/auth/register', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            name: formData.name,
            email: formData.username,
            password: formData.password
          })
        });

        const data = await response.json();
        if (!response.ok) {
          throw new Error(data.message || 'Registration failed');
        }

        setIsSignIn(true);
        setFormData({ ...formData, name: '' });
      } else {
        // Login
        const response = await fetch('http://localhost:8222/api/v1/auth/token', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            username: formData.username,
            password: formData.password
          })
        });

        const data = await response.json();
        if (!response.ok) {
          throw new Error(data.message || 'Invalid credentials');
        }

        if (data.token) {
          localStorage.setItem('jwt_token', data.token);
          setIsAuthenticated(true);
          setIsModalOpen(false);
          setFormData({ name: '', username: '', password: '' });
          navigate('/'); // Redirect to home after login
        } else {
          throw new Error('No token received');
        }
      }
    } catch (err) {
      setError(err.message || 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('jwt_token');
    setIsAuthenticated(false);
    navigate('/');
  };

  return (
    <nav className="navbar">
      <div className="nav-left">
        <Link to="/" className="nav-brand">
          Product Catalog
        </Link>
      </div>
      <div className="nav-buttons">
        {isAuthenticated && (
          <>
            <button className="add-product-btn" onClick={() => setShowAddProduct(true)}>
              Add Product
            </button>
            <Link to="/orders" className="orders-btn">
              My Orders
            </Link>
            <Link to="/cart" className="cart-button">
              <span role="img" aria-label="shopping cart">🛒</span>
              <span className="cart-badge">{cartItemCount}</span>
            </Link>
          </>
        )}
        
        {isAuthenticated ? (
          <button className="btn btn-signin" onClick={handleLogout}>
            Sign Out
          </button>
        ) : (
          <div className="auth-buttons">
            <button 
              className="btn btn-signin"
              onClick={() => {
                setIsSignIn(true);
                setIsModalOpen(true);
              }}
            >
              Sign In
            </button>
            <button 
              className="btn btn-signup"
              onClick={() => {
                setIsSignIn(false);
                setIsModalOpen(true);
              }}
            >
              Sign Up
            </button>
          </div>
        )}
      </div>

      {isModalOpen && (
        <div className="modal-overlay">
          <div className="modal">
            <button 
              className="close-btn" 
              onClick={() => {
                setIsModalOpen(false);
                setError('');
                setFormData({ name: '', username: '', password: '' });
              }}
            >
              ×
            </button>
            <h2>{isSignIn ? 'Sign In' : 'Sign Up'}</h2>
            
            {error && <div className="error-message">{error}</div>}
            
            <form onSubmit={handleSubmit} className="auth-form">
              {!isSignIn && (
                <input
                  type="text"
                  name="name"
                  placeholder="Name"
                  value={formData.name}
                  onChange={handleChange}
                  required
                />
              )}
              <input
                type="text"
                name="username"
                placeholder="Username"
                value={formData.username}
                onChange={handleChange}
                required
              />
              <input
                type="password"
                name="password"
                placeholder="Password"
                value={formData.password}
                onChange={handleChange}
                required
              />
              <button 
                type="submit" 
                className="submit-btn"
                disabled={loading}
              >
                {loading ? 'Processing...' : (isSignIn ? 'Sign In' : 'Sign Up')}
              </button>
            </form>
          </div>
        </div>
      )}
    </nav>
  );
};

export default NavBar;