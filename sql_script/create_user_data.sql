CREATE USER 'data'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'data'@'%' IDENTIFIED BY '1234';

GRANT ALL PRIVILEGES ON *.* TO 'data'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'data'@'%';

FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS data_co_schema;
CREATE DATABASE IF NOT EXISTS data_co_schema_dim;
-- USE data_co_schema;

-- # DROP SCHEMA data_co_schema;