INSERT INTO category (id, name, description) VALUES
                                                 (nextval('category_seq'), 'Electronics', 'Devices and gadgets'),
                                                 (nextval('category_seq'), 'Books', 'Printed and digital books'),
                                                 (nextval('category_seq'), 'Clothing', 'Men and women clothing'),
                                                 (nextval('category_seq'), 'Groceries', 'Daily essential grocery items'),
                                                 (nextval('category_seq'), 'Furniture', 'Home and office furniture');
INSERT INTO product (id, name, description, available_quantity, price, category_id) VALUES
                                                                                        (nextval('product_seq'), 'Smartphone', 'Android smartphone with 6GB RAM', 100, 299.99, 1),
                                                                                        (nextval('product_seq'), 'Laptop', '15-inch laptop with SSD storage', 50, 799.99, 1),
                                                                                        (nextval('product_seq'), 'Science Fiction Book', 'Paperback novel by famous author', 200, 15.99, 51),
                                                                                        (nextval('product_seq'), 'T-Shirt', 'Cotton round-neck T-shirt', 300, 9.49, 101),
                                                                                        (nextval('product_seq'), 'Dining Table', '6-seater wooden dining table', 10, 399.00, 201),
                                                                                        (nextval('product_seq'), 'Organic Rice', '5kg pack of organic rice', 150, 24.99, 151),
                                                                                        (nextval('product_seq'), 'Bluetooth Speaker', 'Portable wireless speaker', 75, 49.99, 1),
                                                                                        (nextval('product_seq'), 'Notebook', 'A5-size ruled notebook', 500, 2.99, 51),
                                                                                        (nextval('product_seq'), 'Jeans', 'Slim fit stretchable jeans', 120, 29.99, 101),
                                                                                        (nextval('product_seq'), 'Office Chair', 'Ergonomic mesh chair', 40, 129.95, 201);
