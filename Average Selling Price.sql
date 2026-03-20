select
 p.product_id,
 round(
    ifnull(sum(p.price * u.units)/ sum(u.units),0),
  2)
  as average_price
FROM Prices p 
LEFT JOIN UnitsSold u
on p.product_id = u.product_id 
and u.purchase_date between p.start_date and p.end_date
group by product_id;
