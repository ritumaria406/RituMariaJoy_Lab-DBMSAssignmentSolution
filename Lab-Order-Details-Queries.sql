/* ---3)	Display the number of the customer group by their 
genders who have placed any order of amount greater than or equal to Rs.3000.  ----- */

use `order-directory`;
select count(c.CUS_NAME) as count,C.CUS_GENDER as Gender from customer as C
inner join 
`order` as O on O.cus_id=C.cus_id
where O.ORD_AMOUNT > 3000
group by C.CUS_GENDER;


/*---4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
.--- */

select O.ORD_ID,O.ORD_AMOUNT,O.ORD_DATE,O.CUS_ID,P.PRO_ID,P.Pro_name from `order` O
inner join product P on P.PRO_ID = O.prod_id and O.CUS_ID=2
inner join product_details PD on PD.PRO_ID=P.PRO_ID;


/* ----5)	Display the Supplier details who can supply more than one product. --- */


select S.SUPP_ID,S.SUPP_NAME,S.SUPP_CITY,S.SUPP_PHONE from supplier S
inner join product_details PD on PD.SUPP_ID = S.SUPP_ID
group by PD.SUPP_ID
having count(PD.SUPP_ID) > 1;


/*----- 6)	Find the category of the product whose order amount is minimum. ---*/

select C.CAT_ID,C.CAT_NAME from category C 
inner join  product P  on P.CAT_ID=C.CAT_id
inner join product_details PD on PD.pro_id = p.pro_id
inner join 
(Select prod_id, min(ord_amount) from `order` ) O on O.prod_id=PD.prod_id

/* ----- 7)	Display the Id and Name of the Product ordered after “2021-10-05”. ----- */

Select P.pro_id,p.pro_name from  
 product P 
inner join product_details PD on PD.pro_id = p.pro_id
inner join
(select prod_id from `order` where ord_date > '2021-10-05') O on O.PROD_ID=PD.Prod_id;

/* ---- 8)	Display customer name and gender whose names start or end with character 'A'. -----*/

select cus_name,cus_gender from customer
where cus_name like 'A%' or cus_name like'%A';

/* -----9)	Create a stored procedure to display the Rating for a Supplier if
 any along with the Verdict on that rating if any like if rating >4 then 
“Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.  ---*/


DELIMITER //

CREATE procedure get_supplier_rating()
BEGIN
select R.SUPP_ID,s.SUPP_NAME,R.rat_ratstars ,
case 
	when r.rat_ratstars > 4 then 'Genuine Supplier'
	when  r.rat_ratstars < 4 and r.rat_ratstars >2 then 'Average Supplier'
	else 'Supplier should not be considered'  
end as Verdict
from
rating R inner join supplier S on R.SUPP_ID=S.SUPP_ID ;
END //

DELIMITER ;
CALL get_supplier_rating();

