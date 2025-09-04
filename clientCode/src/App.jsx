import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import NavBar from './components/NavBar';
import ProductList from './components/ProductList';
import Cart from './components/Cart';
import AddProduct from './components/AddProduct';
import Orders from './components/Orders';
import Checkout from './components/Checkout';
import './App.css';

function App() {
  const [cartItems, setCartItems] = useState([]);
  const [showCart, setShowCart] = useState(false);
  const [showAddProduct, setShowAddProduct] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('jwt_token');
    setIsAuthenticated(!!token);
  }, []);

  const addToCart = (product, quantity) => {
    setCartItems(prevItems => {
      const existingItemIndex = prevItems.findIndex(item => item.id === product.id);
      
      if (existingItemIndex !== -1) {
        const newItems = [...prevItems];
        newItems[existingItemIndex] = {
          ...newItems[existingItemIndex],
          quantity: newItems[existingItemIndex].quantity + quantity
        };
        return newItems;
      }
      return [...prevItems, { ...product, quantity }];
    });
  };

  const updateCartQuantity = (productId, newQuantity) => {
    if (newQuantity < 1) return;
    setCartItems(prevItems =>
      prevItems.map(item =>
        item.id === productId
          ? { ...item, quantity: newQuantity }
          : item
      )
    );
  };

  const removeFromCart = (productId) => {
    setCartItems(prevItems => prevItems.filter(item => item.id !== productId));
  };

  const handleOrderComplete = () => {
    setCartItems([]);
  };

  const handleCloseAddProduct = () => {
    setShowAddProduct(false);
  };

  const handleCompleteCheckout = (setCartItems) => {
    setCartItems([]);
  };

  return (
    <Router>
      <div className="app">
        <NavBar 
          cartItemCount={cartItems.length} 
          setShowCart={setShowCart}
          setShowAddProduct={setShowAddProduct}
          isAuthenticated={isAuthenticated}
          setIsAuthenticated={setIsAuthenticated}
        />
        <main style={{ paddingTop: '80px' }}>
          <Routes>
            <Route path="/" element={<ProductList addToCart={addToCart} />} />
            <Route path="/cart" element={
              <Cart 
                cartItems={cartItems} 
                removeFromCart={removeFromCart}
                updateQuantity={updateCartQuantity}
              />
            } />
            <Route path="/orders" element={
              isAuthenticated ? <Orders /> : <Navigate to="/" />
            } />
            <Route path="/checkout" element={
              cartItems.length ? (
                <Checkout 
                  cartItems={cartItems} 
                  onComplete={() => handleCompleteCheckout(setCartItems)}
                />
              ) : (
                <Navigate to="/cart" />
              )
            } />
          </Routes>
          
          {showAddProduct && (
            <div className="modal-overlay">
              <AddProduct onClose={() => setShowAddProduct(false)} />
            </div>
          )}
        </main>
      </div>
    </Router>
  );
}

export default App;
