-- FoodFlash Database Setup
-- Drop existing tables if they exist
DROP TABLE IF EXISTS ORDER_ITEMS CASCADE;

DROP TABLE IF EXISTS ORDERS CASCADE;

DROP TABLE IF EXISTS INVENTORY CASCADE;

DROP TABLE IF EXISTS MENU_ITEMS CASCADE;

DROP TABLE IF EXISTS RESTAURANTS CASCADE;

DROP TABLE IF EXISTS USERS CASCADE;

-- Users table
CREATE TABLE USERS (
    ID SERIAL PRIMARY KEY,
    EMAIL VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD_HASH VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PHONE VARCHAR(20),
    ADDRESS TEXT,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Restaurants table
CREATE TABLE RESTAURANTS (
    ID SERIAL PRIMARY KEY,
    NAME VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    ADDRESS TEXT NOT NULL,
    PHONE VARCHAR(20),
    RATING DECIMAL(2, 1) DEFAULT 0,
    DELIVERY_TIME INT DEFAULT 30,
    IS_ACTIVE BOOLEAN DEFAULT TRUE,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Menu items table
CREATE TABLE MENU_ITEMS (
    ID SERIAL PRIMARY KEY,
    RESTAURANT_ID INT REFERENCES RESTAURANTS(ID) ON DELETE CASCADE,
    NAME VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    PRICE DECIMAL(10, 2) NOT NULL,
    CATEGORY VARCHAR(100),
    IS_AVAILABLE BOOLEAN DEFAULT TRUE,
    IMAGE_URL VARCHAR(500),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory table
CREATE TABLE INVENTORY (
    ID SERIAL PRIMARY KEY,
    RESTAURANT_ID INT REFERENCES RESTAURANTS(ID) ON DELETE CASCADE,
    ITEM_ID INT REFERENCES MENU_ITEMS(ID) ON DELETE CASCADE,
    QUANTITY INT NOT NULL DEFAULT 0,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(RESTAURANT_ID, ITEM_ID)
);

-- Orders table
CREATE TABLE ORDERS (
    ID SERIAL PRIMARY KEY,
    USER_ID INT REFERENCES USERS(ID) ON DELETE SET NULL,
    RESTAURANT_ID INT REFERENCES RESTAURANTS(ID) ON DELETE SET NULL,
    TOTAL DECIMAL(10, 2) NOT NULL,
    STATUS VARCHAR(50) DEFAULT 'pending',
    PAYMENT_ID VARCHAR(255),
    ITEMS JSONB NOT NULL,
    DELIVERY_ADDRESS TEXT,
    SPECIAL_INSTRUCTIONS TEXT,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IDX_ORDERS_USER_ID ON ORDERS(USER_ID);

CREATE INDEX IDX_ORDERS_RESTAURANT_ID ON ORDERS(RESTAURANT_ID);

CREATE INDEX IDX_ORDERS_STATUS ON ORDERS(STATUS);

CREATE INDEX IDX_ORDERS_CREATED_AT ON ORDERS(CREATED_AT);

CREATE INDEX IDX_MENU_ITEMS_RESTAURANT_ID ON MENU_ITEMS(RESTAURANT_ID);

CREATE INDEX IDX_INVENTORY_RESTAURANT_ITEM ON INVENTORY(RESTAURANT_ID,
ITEM_ID);

-- Sample data for testing
INSERT INTO USERS (
    EMAIL,
    PASSWORD_HASH,
    NAME,
    PHONE,
    ADDRESS
) VALUES (
    'john@example.com',
    '$2b$10$example_hash',
    'John Doe',
    '+1234567890',
    '123 Main St, City, State'
),
(
    'jane@example.com',
    '$2b$10$example_hash',
    'Jane Smith',
    '+1234567891',
    '456 Oak Ave, City, State'
),
(
    'bob@example.com',
    '$2b$10$example_hash',
    'Bob Johnson',
    '+1234567892',
    '789 Pine St, City, State'
);

INSERT INTO RESTAURANTS (
    NAME,
    DESCRIPTION,
    ADDRESS,
    PHONE,
    RATING
) VALUES (
    'Pizza Palace',
    'Best pizza in town',
    '100 Pizza St, City, State',
    '+1111111111',
    4.5
),
(
    'Burger Barn',
    'Gourmet burgers and fries',
    '200 Burger Ave, City,
State',
    '+2222222222',
    4.2
),
(
    'Taco Fiesta',
    'Authentic Mexican cuisine',
    '300 Taco Blvd, City,
State',
    '+3333333333',
    4.8
);

INSERT INTO MENU_ITEMS (
    RESTAURANT_ID,
    NAME,
    DESCRIPTION,
    PRICE,
    CATEGORY
) VALUES (
    1,
    'Margherita Pizza',
    'Classic tomato, mozzarella, and basil',
    18.99,
    'Pizza'
),
(
    1,
    'Pepperoni Pizza',
    'Tomato sauce, mozzarella, and pepperoni',
    21.99,
    'Pizza'
),
(
    2,
    'Classic Burger',
    'Beef patty with lettuce, tomato, and onion',
    15.99,
    'Burgers'
),
(
    2,
    'Bacon Cheeseburger',
    'Beef patty with bacon and cheese',
    18.99,
    'Burgers'
),
(
    3,
    'Chicken Tacos',
    'Three tacos with grilled chicken',
    12.99,
    'Tacos'
),
(
    3,
    'Beef Burritos',
    'Large burrito with seasoned beef',
    14.99,
    'Burritos'
);

-- Stock inicial (INTENCIONALMENTE BAJO para crear problemas)
INSERT INTO INVENTORY (
    RESTAURANT_ID,
    ITEM_ID,
    QUANTITY
) VALUES (
    1,
    1,
    50
), -- Pizza Margherita
(
    1,
    2,
    45
), -- Pepperoni Pizza
(
    2,
    3,
    30
), -- Classic Burger
(
    2,
    4,
    25
), -- Bacon Cheeseburger
(
    3,
    5,
    40
), -- Chicken Tacos
(
    3,
    6,
    35
);

-- Beef Burritos
-- Crear algunos pedidos de prueba
INSERT INTO ORDERS (
    USER_ID,
    RESTAURANT_ID,
    TOTAL,
    STATUS,
    ITEMS
) VALUES (
    1,
    1,
    18.99,
    'delivered',
    '[{"id": 1, "name": "Margherita Pizza",
"quantity": 1, "price": 18.99}]'
),
(
    2,
    2,
    15.99,
    'preparing',
    '[{"id": 3, "name": "Classic Burger",
"quantity": 1, "price": 15.99}]'
),
(
    3,
    3,
    12.99,
    'confirmed',
    '[{"id": 5, "name": "Chicken Tacos",
"quantity": 1, "price": 12.99}]'
);

COMMIT;