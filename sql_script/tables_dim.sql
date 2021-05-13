USE data_co_schema_dim;

CREATE TABLE Dim_Location (
    location_tk BIGINT UNSIGNED NOT NULL,
    department_name VARCHAR(45) NOT NULL ,
    market VARCHAR(45) NOT NULL ,
    order_city VARCHAR(45) NOT NULL , 
    order_region VARCHAR(45) NOT NULL , 
    order_state VARCHAR(45) NOT NULL ,  
    customer_country VARCHAR(45) NOT NULL ,
    customer_city VARCHAR(45) NOT NULL ,  
    customer_segment VARCHAR(45) NOT NULL ,  
    UNIQUE INDEX location_tk_UNIQUE (location_tk ASC)
);

CREATE TABLE Dim_Shipping (
    shipping_tk BIGINT UNSIGNED NOT NULL,
    shipping_mode VARCHAR(45) NOT NULL , 
    days_for_shipping_real INT NOT NULL ,  
    days_for_shipping_scheduled INT NOT NULL , 
    late_delivery_risk INT NOT NULL ,  
    UNIQUE INDEX shipping_tk_UNIQUE (shipping_tk ASC)
);

CREATE TABLE Dim_Time (
    time_tk BIGINT UNSIGNED NOT NULL,
    order_date DATETIME NOT NULL ,
    shipping_date DATETIME NOT NULL ,
    UNIQUE INDEX time_tk_UNIQUE (time_tk ASC)
);


CREATE TABLE Dim_Product_Category (
    product_category_tk BIGINT UNSIGNED NOT NULL,
    category_name VARCHAR(45) NOT NULL,
    product_price FLOAT NOT NULL , 
    product_name VARCHAR(45) NOT NULL ,
    UNIQUE INDEX product_category_tk_UNIQUE (product_category_tk ASC)
);

CREATE TABLE Fact_Orders (
    order_pk BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    time_tk BIGINT UNSIGNED NOT NULL,
    shipping_tk BIGINT UNSIGNED NOT NULL,
    location_tk BIGINT UNSIGNED NOT NULL,
    order_item_total  FLOAT NOT NULL ,
    order_profit_per_order FLOAT NOT NULL ,
    CONSTRAINT FK_time_tk_Fact_Orders FOREIGN KEY (time_tk) REFERENCES data_co_schema_dim.Dim_Time (time_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_shipping_tk_Fact_Orders FOREIGN KEY (shipping_tk) REFERENCES data_co_schema_dim.Dim_Shipping (shipping_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_location_tk_Fact_Orders FOREIGN KEY (location_tk) REFERENCES data_co_schema_dim.Dim_Location (location_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    UNIQUE INDEX order_pk_UNIQUE (order_pk ASC)
);

CREATE TABLE Fact_Item (
    item_pk BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    time_tk BIGINT UNSIGNED NOT NULL,
    product_category_tk BIGINT UNSIGNED NOT NULL,
    discount REAL NOT NULL , 
    profit_ratio REAL NOT NULL , 
    quantity REAL NOT NULL ,  
    CONSTRAINT FK_time_tk_Fact_Item FOREIGN KEY (time_tk) REFERENCES data_co_schema_dim.Dim_Time (time_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_product_category_tk_Fact_Item FOREIGN KEY (product_category_tk) REFERENCES data_co_schema_dim.Dim_Product_Category (product_category_tk) ON DELETE NO ACTION ON UPDATE CASCADE,
    UNIQUE INDEX item_pk_UNIQUE (item_pk ASC)
);

CREATE TABLE Ref_Order_Items (
    order_pk BIGINT UNSIGNED NOT NULL,
    item_pk BIGINT UNSIGNED NOT NULL,
    CONSTRAINT PK_Ref_Order_Item PRIMARY KEY (order_pk,item_pk),
    CONSTRAINT FK_order_pk_Ref_Order_Item FOREIGN KEY (order_pk) REFERENCES data_co_schema_dim.Fact_Orders (order_pk) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_item_pk_Ref_Order_Item FOREIGN KEY (item_pk) REFERENCES data_co_schema_dim.Fact_Item (item_pk) ON DELETE NO ACTION ON UPDATE CASCADE
);