CREATE SCHEMA IF NOT EXISTS warehouse;
CREATE SCHEMA IF NOT EXISTS snapshots;
DROP TABLE IF EXISTS warehouse.customers;
CREATE TABLE warehouse.customers (
    customer_id INT,
    zipcode VARCHAR(5),
    city VARCHAR(100),
    state_code VARCHAR(2),
    datetime_created VARCHAR(100),
    datetime_updated VARCHAR(100)
);
DROP TABLE IF EXISTS warehouse.orders;
CREATE TABLE warehouse.orders (
    order_id VARCHAR(32),
    cust_id INT,
    order_status VARCHAR(15),
    order_purchase_timestamp VARCHAR(100),
    order_approved_at VARCHAR(100),
    order_delivered_carrier_date VARCHAR(100),
    order_delivered_customer_date VARCHAR(100),
    order_estimated_delivery_date VARCHAR(100)
);
DROP TABLE IF EXISTS warehouse.state;
CREATE TABLE warehouse.state (
    state_identifier VARCHAR(10),
    state_code VARCHAR(5000),
    st_name VARCHAR(5000)
);
COPY warehouse.customers(customer_id, zipcode, city, state_code, datetime_created, datetime_updated)
FROM '/input_data/customer.csv' DELIMITER ',' CSV HEADER;
COPY warehouse.state(state_identifier, state_code, st_name)
FROM '/input_data/state.csv' DELIMITER ',' CSV HEADER;
COPY warehouse.orders(
    order_id,
    cust_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
FROM '/input_data/orders.csv' DELIMITER ',' CSV HEADER;
