-- 3. Display the number of the customers, grouped by their genders, who have placed any order of amount greater than or equal to Rs. 3000.
select customer.cus_gender, count(customer.cus_gender) as count
from customer inner join `order` on customer.cus_id = `order`.cus_id
where `order`.ord_amount >= 3000
group by customer.cus_gender;

-- 4. Display all the order along with product name ordered by a customer having Customer_Id=2;
select `order`.*, product.pro_name
from `order`, product_details, product
where `order`.cus_id = 2 and `order`.prod_id = product_details.prod_id and product_details.prod_id = product.pro_id;

-- 5. Display the Supplier details who can supply more than one product.
select supplier.*
from supplier
	where supplier.supp_id in (
		select product_details.supp_id
        from product_details
        group by product_details.supp_id
        having count(product_details.supp_id) > 1
	);

-- 6. Find the category of the product whose order amount is minimum.

-- Interpreting the question to mean product where total order amount is minimum (makes more sense)
select category.*, sum(`order`.ord_amount) as sum_ord_amount
from `order`, product_details, product, category
    where `order`.prod_id = product_details.prod_id and product.pro_id = product_details.pro_id and category.cat_id = product.cat_id
group by category.cat_id
order by sum_ord_amount limit 1;

-- Interpreting the question to mean product where order amount is minimum
select category.*, `order`.ord_amount
from
	`order`
    inner join product_details on `order`.prod_id = product_details.prod_id
    inner join product on product.pro_id = product_details.pro_id
    inner join category on category.cat_id = product.cat_id
order by `order`.ord_amount limit 1;

-- 7. Display the Id and Name of the Product ordered after "2021-10-05".
select product.pro_id, product.pro_name, `order`.ord_date
from
	`order`
    inner join product_details on product_details.prod_id = `order`.prod_id
    inner join product on product.pro_id = product_details.pro_id
    where `order`.ord_date > "2021-10-05";

-- 8. Print the top 3 supplier name and id and rating on the basis of their rating along with the customer name who has given the rating.	
select supplier.supp_id, supplier.supp_name, customer.cus_name, rating.rat_ratstars
from
	rating
    inner join supplier on rating.supp_id = supplier.supp_id
    inner join customer on rating.cus_id = customer.cus_id
    order by rating.rat_ratstars desc limit 3;

-- 9. Display customer name and gender whose names start or end with character 'A'.
select customer.cus_name, customer.cus_gender
from customer
where customer.cus_name like 'A%' or customer.cus_name like '%A';

-- 10. Display the total order amount of the male customers.
select sum(`order`.ord_amount) as Amount
from `order` inner join customer on `order`.cus_id = customer.cus_id
where customer.cus_gender = 'M';

-- 11. Display all the Customers left outer join with  the orders.
select *
from customer left outer join `order` on customer.cus_id = `order`.cus_id; 

-- 12. Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like 
-- 	   if rating > 4 then "Genuine Supplier" 
--     if rating > 2 "Average Supplier" 
--     else "Supplier should not be considered".
call categorize_supplier();