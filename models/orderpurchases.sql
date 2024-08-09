{{ config(materialized='table') }}

with customers as (
    select
        id as customer_id,
        first_name,
        last_name
    from PC_HEVODATA_DB.PUBLIC.HEVOTASK_RAW_CUSTOMERS
),

orders as (
    select
        id as order_id,
        user_id as customer_id,
        order_date
    from PC_HEVODATA_DB.PUBLIC.HEVOTASK_RAW_ORDERS
),
payments as (
    select
        id as payment_id,
        order_id,
        amount
    from PC_HEVODATA_DB.PUBLIC.HEVOTASK_RAW_PAYMENTS
)

SELECT C.customer_id,C.first_name,C.last_name,MIN(O.order_date)AS first_order, MAX(O.order_date) AS last_order, COUNT(O.order_id) AS number_of_orders, SUM(P.amount) AS customer_lifetime_value
FROM customers C
JOIN orders O ON C.customer_id=O.customer_id
JOIN payments P ON O.order_id=P.order_id
GROUP BY C.customer_id, C.first_name,C.last_name