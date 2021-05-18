SELECT order_id, MAX(date_from) as date_from FROM data_co_schema_dim.Dim_Location GROUP BY order_id ORDER BY order_id;

SELECT A.order_id, A.location_tk, A.date_from FROM
    data_co_schema_dim.Dim_Location as A
    LEFT JOIN
    (SELECT order_id, MAX(date_from) as date_from FROM data_co_schema_dim.Dim_Location GROUP BY order_id ORDER BY order_id) as B
    ON A.order_id = B.order_id
    WHERE A.date_from = B.date_from
    ORDER BY A.order_id;

SELECT A.order_id, A.time_tk, A.date_from FROM
    data_co_schema_dim.Dim_Time as A
    LEFT JOIN
    (SELECT order_id, MAX(date_from) as date_from FROM data_co_schema_dim.Dim_Time GROUP BY order_id ORDER BY order_id) as B
    ON A.order_id = B.order_id
    WHERE A.date_from = B.date_from
    ORDER BY A.order_id;

SELECT A.order_id, A.shipping_tk, A.date_from FROM
    data_co_schema_dim.Dim_Shipping as A
    LEFT JOIN
    (SELECT order_id, MAX(date_from) as date_from FROM data_co_schema_dim.Dim_Shipping GROUP BY order_id ORDER BY order_id) as B
    ON A.order_id = B.order_id
    WHERE A.date_from = B.date_from
    ORDER BY A.order_id;

SELECT A.product_id, A.product_tk, A.date_from FROM
    data_co_schema_dim.Dim_Product as A
    LEFT JOIN
    (SELECT product_id, MAX(date_from) as date_from FROM data_co_schema_dim.Dim_Product GROUP BY product_id ORDER BY product_id) as B
    ON A.product_id = B.product_id
    WHERE A.date_from = B.date_from
    ORDER BY A.product_id;


SELECT A.order_id, order_profit_per_order, SUM(B.item_price * B.quantity) as order_item_total
    FROM orders as A INNER JOIN order_item as B
    ON A.order_id = B.order_id
    GROUP BY A.order_id, B.;


SELECT order_id, location_tk, date_from FROM data_co_schema_dim.Dim_Location ORDER BY order_id;

INSERT INTO data_co_schema_dim.Dim_Location (location_tk, order_id, department_name, market, order_city, order_region, order_state, customer_country, customer_city, customer_segment, version, date_from) VALUES
    (81000, 2, 'asd', 'asd', 'asd', 'asd', 'asd', 'asd', 'asd', 'asd', 8, STR_TO_DATE('06-01-2023', '%m-%d-%Y'));


INSERT INTO data_co_schema_dim.Dim_Location (location_tk, order_id, department_name, market, order_city, order_region, order_state, customer_country, customer_city, customer_segment, version, date_from) VALUES
    (72000, 4, 'asd', 'asd', 'asd', 'asd', 'asd', 'asd', 'asd', 'asd', 5, STR_TO_DATE('06-01-2021', '%m-%d-%Y'));

SELECT order_item_id, order_id, product_id, profit_ratio, quantity, discount FROM order_item;


SELECT A.item_pk, A.item_tk, A.date_from FROM
    data_co_schema_dim.Fact_Item as A
    LEFT JOIN
    (SELECT item_pk, MAX(date_from) as date_from FROM data_co_schema_dim.Fact_Item GROUP BY item_pk ORDER BY item_pk) as B
    ON A.item_pk = B.item_pk
    WHERE A.date_from = B.date_from
    ORDER BY A.item_pk;

SELECT A.order_pk, A.order_tk, A.date_from FROM
    data_co_schema_dim.Fact_Order as A
    LEFT JOIN
    (SELECT order_pk, MAX(date_from) as date_from FROM data_co_schema_dim.Fact_Order GROUP BY order_pk ORDER BY order_pk) as B
    ON A.order_pk = B.order_pk
    WHERE A.date_from = B.date_from
    ORDER BY A.order_pk;


SELECT A.order_id, B.order_item_id FROM data_co_schema.orders AS A JOIN order_item AS B ON A.order_id = B.order_id