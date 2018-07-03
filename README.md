<# Van Order Matching

There are two sample tables in this small test, one table called "vanorder" and one table called "vaninterest".

Logic of the sample system: A record is created in van-order when user places an order. Each order starts at order_subset A, and each order can be accepted by multiple drivers. There will be a new record in the vaninterest table when a driver accepts an order. After accepting order, the driver has the option to reject an order, which will go back to the pool and allow other drivers to match this order again.

1) vanorder
- Contains the final status of the orders information
- idvanOrder: The order ID, which is the primary key 
- order_status: The final status of the order.
  -- 2: 'Completed'
  -- 3: 'Cancelled'
  -- 5: 'Expired'
- order_subset: The final order subset of the order
- requestor_client_id: The user account ID
- servicer_auth: The driver ID
- total_price: The price of the order
- order_datetime: The order time of the order
- txCreate: The record creation time, which is the order placed time by the user

2) vaninterest
- Contains the order information for each subset 
- idvanInterest: The primary key of this table 
- idvanOrder: The order ID associated to this record
- order_subset_assigned: The order subset that is associated to this record
- servicer_auth: The driver ID for this subset
- txCreate: The record creation time, which is the time that this driver accepted the order

<br>
We are using MySQL for the tables. If you have a MySQL database available, you can run the SQL file, p1_data.sql, to create two tables in the database. The two files, vaninterest.csv and vanorder.csv, contain the same data.

Now we are write a few SQL statement to understand more about our data, users, and drivers. Unless specified otherwise, use all data available in the sample tables. Please use one SQL statement for finding each of the following:

- a) For hours with orders, how many orders are there each hour based on order time?

- b) What is the percentage of money spent for each of the following group of clients?
	- Clients who completed 1 order
	- Clients who completed more than 1 order
	
- c) List of unique Client ID who completed at least one order, also show each client's total money spent, and the total order(s) completed. Order the list by total money spent (descending), then by total order(s) completed (descending)

- d) List of all drivers who took order(s) (regardless of whether they eventually complete the order), also show each driver's total income and total order(s) completed. Order the list by total income (descending), then by total order(s) completed

- e) List of driver ID who took orders, but never complete an order?
