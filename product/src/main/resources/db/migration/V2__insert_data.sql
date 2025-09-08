INSERT INTO category (id, name, description, image_url) VALUES
    (nextval('category_seq'), 'Electronics', 'Devices and gadgets', 'https://unsplash.com/s/photos/mobile-phone'),
    (nextval('category_seq'), 'Books', 'Printed and digital books', 'https://www.freepik.com/free-photos-vectors/science-fiction-book'),
    (nextval('category_seq'), 'Clothing', 'Men and women clothing', 'https://unsplash.com/s/photos/t-shirt'),
    (nextval('category_seq'), 'Groceries', 'Daily essential grocery items', 'https://www.freepik.com/free-photos-vectors/groceries'),
    (nextval('category_seq'), 'Furniture', 'Home and office furniture', 'https://www.freepik.com/free-photos-vectors/dining-table');

INSERT INTO product (id, name, description, available_quantity, price, category_id, image_url) VALUES
    (nextval('product_seq'), 'Smartphone', 'Android smartphone with 6GB RAM', 100, 299.99, 1, 'https://m.media-amazon.com/images/I/61135j8fPJL._SL1500_.jpg'),
    (nextval('product_seq'), 'Laptop', '15-inch laptop with SSD storage', 50, 799.99, 1, 'https://m.media-amazon.com/images/I/51XpiWaeMQL._SX300_SY300_QL70_FMwebp_.jpg'),
    (nextval('product_seq'), 'Science Fiction Book', 'Paperback novel by famous author', 200, 15.99, 51, 'https://m.media-amazon.com/images/I/51nbRQdrkML._SX342_SY445_ControlCacheEqualizer_.jpg'),
    (nextval('product_seq'), 'T-Shirt', 'Cotton round-neck T-shirt', 300, 9.49, 101, 'https://m.media-amazon.com/images/I/61mWuLGz5xL._AC_UL480_FMwebp_QL65_.jpg'),
    (nextval('product_seq'), 'Dining Table', '6-seater wooden dining table', 10, 399.00, 201, 'https://m.media-amazon.com/images/I/81nQBN0OF8L._AC_UL480_FMwebp_QL65_.jpg'),
    (nextval('product_seq'), 'Organic Rice', '5kg pack of organic rice', 150, 24.99, 151, 'https://m.media-amazon.com/images/I/71c62J5botL._AC_UL480_FMwebp_QL65_.jpg'),
    (nextval('product_seq'), 'Bluetooth Speaker', 'Portable wireless speaker', 75, 49.99, 1, 'https://m.media-amazon.com/images/I/71wAXhzCmnS._AC_UY327_FMwebp_QL65_.jpg'),
    (nextval('product_seq'), 'Notebook', 'A5-size ruled notebook', 500, 2.99, 51, 'https://m.media-amazon.com/images/I/61NUA0O7WTL._AC_UL480_FMwebp_QL65_.jpg'),
    (nextval('product_seq'), 'Jeans', 'Slim fit stretchable jeans', 120, 29.99, 101, 'https://m.media-amazon.com/images/I/71vSy-vxjvL._AC_UL480_FMwebp_QL65_.jpg'),
    (nextval('product_seq'), 'Office Chair', 'Ergonomic mesh chair', 40, 129.95, 201, 'https://m.media-amazon.com/images/I/61+SWH1qODL._AC_UL480_FMwebp_QL65_.jpg');