# loading the lalamove database where it consists two tables (vanorder and vaninterest)
use lalamove;

SELECT * FROM vanorder;

SELECT * FROM vaninterest;

# Question a)
# SQL code for both (group by day and hour) and (group by hour) cases

# Group by Day and Hour
SELECT DAY(order_datetime) AS Days, HOUR(order_datetime) AS Hours, COUNT(*) AS Counts
FROM vanorder
GROUP BY Days, Hours
ORDER BY Days, Hours;

# Group by Hour
SELECT HOUR(order_datetime) AS Hours, COUNT(*) AS Counts
FROM vanorder
GROUP BY Hours
ORDER BY Hours;

# Question b)
SELECT Count_group, SUM(Q) * 100 / (SELECT SUM(total_price) FROM vanorder WHERE order_status = 2) AS Percentage
FROM
	(SELECT SUM(total_price) AS Q, (CASE WHEN COUNT(requestor_client_id) = 1 THEN '1' ELSE '>1' END) AS Count_group
	FROM vanorder
	WHERE order_status = 2
	GROUP BY requestor_client_id) AS table1
GROUP BY Count_group;

# Question c)
# Sorted Client_id by ascending order at last for better reading

SELECT requestor_client_id as Client_id, SUM(total_price) AS Total_money_spent, COUNT(*) AS Total_order_completed
FROM vanorder
WHERE order_status = 2 
GROUP BY Client_id
ORDER BY Total_money_spent DESC, Total_order_completed DESC, Client_id ASC;

# Question d)
# Inner join if idvanOrder, servicer_auth and order_subset are matched from both vanorder and vaninterest tables
# There is one case (idvanOrder: 299) that even the order_status is 3 (cancelled), an associated servier_auth (21) is in vanorder table
# So I put a filter where order_status is completed (2)
# Then I left join the unique driver id from vaninterest table with the table I just created
# Sorted Driver_id by ascending order at last for better reading

SELECT servicer_auth as Driver_id, (IFNULL(SUM(total_price), 0)) as Total_income, 
	(IF(IFNULL(SUM(total_price), 0)=0, 0, COUNT(servicer_auth))) as Total_order_completed
FROM
	(SELECT unique_driver.servicer_auth, total_price 
	FROM
		(SELECT servicer_auth FROM vaninterest GROUP BY servicer_auth) AS unique_driver
	LEFT JOIN
		(SELECT vaninterest.idvanOrder, vaninterest.servicer_auth, vanorder.total_price 
		FROM vaninterest 
		INNER JOIN vanorder ON (vaninterest.idvanOrder = vanorder.idvanOrder) 
						AND (vaninterest.servicer_auth = vanorder.servicer_auth)
						AND (vaninterest.order_subset_assigned = vanorder.order_subset)
		WHERE vanorder.order_status = 2) as completed
	ON (unique_driver.servicer_auth = completed.servicer_auth)) as joint
GROUP BY Driver_id
ORDER BY Total_income DESC, Total_order_completed DESC, Driver_id ASC;

# Question e) using script from question d
SELECT Driver_id
FROM 
	(SELECT servicer_auth as Driver_id, (IFNULL(SUM(total_price), 0)) as Total_income, 
		(IF(IFNULL(SUM(total_price), 0)=0, 0, COUNT(servicer_auth))) as Total_order_completed
	FROM
		(SELECT unique_driver.servicer_auth, total_price 
		FROM
			(SELECT servicer_auth FROM vaninterest GROUP BY servicer_auth) AS unique_driver
		LEFT JOIN
			(SELECT vaninterest.idvanOrder, vaninterest.servicer_auth, vanorder.total_price 
			FROM vaninterest 
			INNER JOIN vanorder ON (vaninterest.idvanOrder = vanorder.idvanOrder) 
							AND (vaninterest.servicer_auth = vanorder.servicer_auth)
							AND (vaninterest.order_subset_assigned = vanorder.order_subset)
			WHERE vanorder.order_status = 2) as completed
		ON (unique_driver.servicer_auth = completed.servicer_auth)) as joint
	GROUP BY Driver_id
	ORDER BY Total_income DESC, Total_order_completed DESC, Driver_id ASC) AS table2 
WHERE Total_order_completed = 0;
