ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';
ALTER USER 'root'@'%' IDENTIFIED BY '1234';

CREATE USER 'data'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'data'@'%' IDENTIFIED BY '1234';

GRANT ALL PRIVILEGES ON *.* TO 'data'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'data'@'%';

FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS data_co_schema;
-- USE data_co_schema;
