USE data_co_schema_dim;

CREATE TABLE Dim_Location (
    location_tk BIGINT UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY,
    order_id INT NOT NULL DEFAULT -1,
    department_name VARCHAR(45) NOT NULL DEFAULT '-1' ,
    market VARCHAR(45) NOT NULL DEFAULT '-1' ,
    order_city VARCHAR(45) NOT NULL DEFAULT '-1' ,
    order_region VARCHAR(45) NOT NULL DEFAULT '-1' ,
    order_state VARCHAR(45) NOT NULL DEFAULT '-1' ,
    customer_country VARCHAR(45) NOT NULL DEFAULT '-1' ,
    customer_city VARCHAR(45) NOT NULL DEFAULT '-1' ,
    customer_segment VARCHAR(45) NOT NULL DEFAULT '-1' ,
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    version INT NOT NULL DEFAULT 0,
    UNIQUE INDEX location_tk_UNIQUE (location_tk ASC)
);

CREATE TABLE Dim_Shipping (
    shipping_tk BIGINT UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY,
    order_id INT NOT NULL DEFAULT -1,
    shipping_mode VARCHAR(45) NOT NULL DEFAULT '-1' ,
    days_for_shipping_real INT NOT NULL DEFAULT 0 ,
    days_for_shipping_scheduled INT NOT NULL DEFAULT 0 ,
    late_delivery_risk INT NOT NULL DEFAULT 0 ,
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    version INT NOT NULL DEFAULT 0,
    UNIQUE INDEX shipping_tk_UNIQUE (shipping_tk ASC)
);

CREATE TABLE Dim_Time (
    time_tk BIGINT UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY,
    order_id INT NOT NULL DEFAULT -1,
    order_date DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    shipping_date DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    version INT NOT NULL DEFAULT 0,
    UNIQUE INDEX time_tk_UNIQUE (time_tk ASC)
);



CREATE TABLE Dim_Product (
    product_tk BIGINT UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY ,
    product_id INT NOT NULL DEFAULT -1,
    category_name VARCHAR(45) NOT NULL  DEFAULT 'none',
    product_price FLOAT NOT NULL  DEFAULT -1,
    product_name VARCHAR(45) NOT NULL DEFAULT 'none',
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    active BOOLEAN NOT NULL DEFAULT 1,
    version INT NOT NULL DEFAULT 0,
    UNIQUE INDEX product_tk_UNIQUE (product_tk ASC)
);

CREATE TABLE Fact_Order (
    order_pk INT NOT NULL  DEFAULT 0,
    order_tk BIGINT UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY,
    time_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    shipping_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    location_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    order_item_total  FLOAT NOT NULL DEFAULT 0 ,
    order_profit_per_order FLOAT NOT NULL DEFAULT 0 ,
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    version INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_time_tk_Fact_Order FOREIGN KEY (time_tk) REFERENCES data_co_schema_dim.Dim_Time (time_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_shipping_tk_Fact_Order FOREIGN KEY (shipping_tk) REFERENCES data_co_schema_dim.Dim_Shipping (shipping_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_location_tk_Fact_Order FOREIGN KEY (location_tk) REFERENCES data_co_schema_dim.Dim_Location (location_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    UNIQUE INDEX order_pk_UNIQUE (order_pk ASC)
);

CREATE TABLE Fact_Item (
    item_pk INT NOT NULL DEFAULT 0,
    item_tk BIGINT UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY,
    time_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    product_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    discount REAL NOT NULL DEFAULT 0 ,
    profit_ratio REAL NOT NULL DEFAULT 0 ,
    quantity REAL NOT NULL DEFAULT 0 ,
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    version INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_time_tk_Fact_Item FOREIGN KEY (time_tk) REFERENCES data_co_schema_dim.Dim_Time (time_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_product_tk_Fact_Item FOREIGN KEY (product_tk) REFERENCES data_co_schema_dim.Dim_Product (product_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    UNIQUE INDEX item_pk_UNIQUE (item_tk ASC)
);

CREATE TABLE Ref_Order_Items (
    ref_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    order_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    item_tk BIGINT UNSIGNED NOT NULL DEFAULT 0,
    date_from DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    date_to DATETIME NOT NULL DEFAULT(CURRENT_DATE),
    version INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_Ref_Order_Item PRIMARY KEY (ref_tk),
    CONSTRAINT FK_order_pk_Ref_Order_Item FOREIGN KEY (order_tk) REFERENCES data_co_schema_dim.Fact_Order (order_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_item_pk_Ref_Order_Item FOREIGN KEY (item_tk) REFERENCES data_co_schema_dim.Fact_Item (item_tk) ON DELETE NO ACTION ON UPDATE CASCADE
);
