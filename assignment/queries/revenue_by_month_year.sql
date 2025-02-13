-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

SELECT
  STRFTIME("%m", o.order_delivered_customer_date) AS month_no,
  CASE STRFTIME("%m", o.order_delivered_customer_date)
    WHEN "01" THEN "JAN"
    WHEN "02" THEN "FEB"
    WHEN "03" THEN "MAR"
    WHEN "04" THEN "APR"
    WHEN "05" THEN "MAY"
    WHEN "06" THEN "JUN"
    WHEN "07" THEN "JUL"
    WHEN "08" THEN "AUG"
    WHEN "09" THEN "SEP"
    WHEN "10" THEN "OCT"
    WHEN "11" THEN "NOV"
    WHEN "12" THEN "DEC"
  END AS month,
  SUM(CASE STRFTIME('%Y', o.order_delivered_customer_date) WHEN '2016' THEN op.payment_value ELSE 0.0 END) AS Year2016,
  SUM(CASE STRFTIME('%Y', o.order_delivered_customer_date) WHEN '2017' THEN op.payment_value ELSE 0.0 END) AS Year2017,
  SUM(CASE STRFTIME('%Y', o.order_delivered_customer_date) WHEN '2018' THEN op.payment_value ELSE 0.0 END) AS Year2018
FROM
  (
    SELECT
      oo.order_id,
      oo.order_delivered_customer_date
    FROM
      olist_orders oo
    WHERE
      oo.order_delivered_customer_date IS NOT NULL
      AND oo.order_purchase_timestamp IS NOT NULL
      AND oo.order_status = 'delivered'
  ) AS o
JOIN
  (
    SELECT
      olist_order_payments.order_id,
      MIN(olist_order_payments.payment_value) AS payment_value
    FROM
      olist_order_payments
    GROUP BY
      olist_order_payments.order_id
  ) AS op ON o.order_id = op.order_id
GROUP BY
  month_no, month
ORDER BY
  month_no;