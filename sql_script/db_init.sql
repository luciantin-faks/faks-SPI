ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';
ALTER USER 'root'@'%' IDENTIFIED BY '1234';

CREATE USER 'data'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'data'@'%' IDENTIFIED BY '1234';

GRANT ALL PRIVILEGES ON *.* TO 'data'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'data'@'%';

FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS data_co_schema;
USE data_co_schema;

CREATE TABLE customer_geo (
    id INT NOT NULL ,
    city VARCHAR NOT NULL ,
    country VARCHAR NOT NULL ,
    state VARCHAR NOT NULL ,
    street VARCHAR NOT NULL ,
    zipcode VARCHAR NOT NULL ,
);

CREATE TABLE customer (
    id INT NOT NULL ,
    fname VARCHAR NOT NULL ,
    lname VARCHAR NOT NULL ,
    email VARCHAR NOT NULL ,
    passwd VARCHAR NOT NULL ,
    segment VARCHAR NOT NULL ,
);

CREATE TABLE product (
    id INT NOT NULL ,
    name VARCHAR NOT NULL ,
    category_id INT NOT NULL ,
    image VARCHAR NOT NULL ,
    price VARCHAR NOT NULL ,
    status INT NOT NULL ,
);

