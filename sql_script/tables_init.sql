USE data_co_schema;

CREATE TABLE customer (
    customer_id INT NOT NULL PRIMARY KEY,
    fname VARCHAR(45) NOT NULL ,
    lname VARCHAR(45) ,
    email VARCHAR(45) NOT NULL ,
    passwd VARCHAR(45) NOT NULL ,
    segment VARCHAR(45) NOT NULL ,
    UNIQUE INDEX customer_id_UNIQUE (customer_id ASC)
);

CREATE TABLE customer_geo (
    customer_id INT NOT NULL PRIMARY KEY,
    customer_city VARCHAR(45) NOT NULL ,
    customer_country VARCHAR(45) NOT NULL ,
    customer_state VARCHAR(45) NOT NULL ,
    customer_street VARCHAR(45) NOT NULL ,
    customer_zipcode VARCHAR(45) ,
    UNIQUE INDEX customer_id_UNIQUE (customer_id ASC),
    CONSTRAINT customer_id_fk FOREIGN KEY (customer_id) REFERENCES data_co_schema.customer (customer_id) ON DELETE NO ACTION ON UPDATE CASCADE
);


CREATE TABLE product_category (
    category_id INT NOT NULL PRIMARY KEY,
    category_name VARCHAR(45) NOT NULL,
    UNIQUE INDEX category_id_UNIQUE (category_id ASC)
);

CREATE TABLE product (
    product_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45) NOT NULL ,
    category_id INT NOT NULL ,
    image VARCHAR(254) NOT NULL ,
    product_price FLOAT NOT NULL ,
    product_status INT NOT NULL,
    UNIQUE INDEX product_id_UNIQUE (product_id ASC),
    CONSTRAINT category_id_fk FOREIGN KEY (category_id) REFERENCES data_co_schema.product_category (category_id) ON DELETE NO ACTION ON UPDATE CASCADE
);


CREATE TABLE department (
    department_id INT NOT NULL PRIMARY KEY,
    department_name VARCHAR(45) NOT NULL ,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(10,8) NOT NULL,
    market VARCHAR(45) NOT NULL ,
    UNIQUE INDEX department_id_UNIQUE (department_id ASC)
);

CREATE TABLE orders (
    order_id INT NOT NULL PRIMARY KEY ,
    customer_id INT NOT NULL ,
    order_date DATETIME NOT NULL ,
    type VARCHAR(45) NOT NULL ,
    delivery_status VARCHAR(45) NOT NULL ,
    late_delivery_risk INT NOT NULL ,
    order_profit_per_order FLOAT NOT NULL ,
    benefit_per_order FLOAT NOT NULL ,
    department_id INT NOT NULL ,
    UNIQUE INDEX order_id_UNIQUE (order_id ASC),
    CONSTRAINT department_id_fk FOREIGN KEY (department_id) REFERENCES data_co_schema.department (department_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT customer_id_orders_fk FOREIGN KEY (customer_id) REFERENCES data_co_schema.customer (customer_id) ON DELETE NO ACTION ON UPDATE CASCADE
);


CREATE TABLE orders_geo (
    order_id INT NOT NULL PRIMARY KEY ,
    city VARCHAR(45) NOT NULL ,
    region VARCHAR(45) NOT NULL ,
    state VARCHAR(45) NOT NULL ,
    status VARCHAR(45) NOT NULL ,
    UNIQUE INDEX order_id_UNIQUE (order_id ASC),
    CONSTRAINT order_id_fk FOREIGN KEY (order_id) REFERENCES data_co_schema.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE order_item (
    order_item_id INT NOT NULL PRIMARY KEY,
    order_id INT NOT NULL ,
    product_id INT NOT NULL ,
    discount REAL NOT NULL ,
    discount_rate REAL(4,4) NOT NULL ,
    item_price REAL NOT NULL ,
    profit_ratio REAL NOT NULL ,
    quantity REAL NOT NULL ,
    sales REAL NOT NULL ,
    order_item_total FLOAT NOT NULL ,
    UNIQUE INDEX order_item_id_UNIQUE (order_item_id ASC),
    CONSTRAINT order_id_order_item_fk FOREIGN KEY (order_id) REFERENCES data_co_schema.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT product_id_order_item_fk FOREIGN KEY (product_id) REFERENCES data_co_schema.product (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE shipping (
    order_id INT NOT NULL PRIMARY KEY,
    days_for_shipping_real INT NOT NULL ,
    days_for_shipping_scheduled INT NOT NULL ,
    shipping_date DATETIME NOT NULL ,
    mode VARCHAR(45) NOT NULL ,
    UNIQUE INDEX order_id_shipping_UNIQUE (order_id ASC),
    CONSTRAINT order_id_shipping__fk FOREIGN KEY (order_id) REFERENCES data_co_schema.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE
);



