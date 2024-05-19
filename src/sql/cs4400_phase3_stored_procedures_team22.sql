-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team __
-- Saim Bhimji (sbhimji3)
-- Desmond Dulaney (ddulaney3)
-- Seongyeon Park (spark913)
-- Sunwoo Park (spark868)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	-- place your solution here
    if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null
    or ip_rating is null or ip_credit is null then leave sp_main;
    
    elseif length(ip_uname) > 40 or length(ip_first_name) > 100 or length(ip_first_name) > 100 or length(ip_address) > 500 
    or ip_rating < 1 or ip_rating > 5 or ip_credit < 0 then leave sp_main;
    elseif ip_uname in (select uname from users) then leave sp_main;
    END IF;
    
    insert into users values(ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    insert into customers values (ip_uname, ip_rating, ip_credit);
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	-- place your solution here
    if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null
    or ip_taxID is null or ip_service is null or ip_salary is null or ip_licenseID is null or ip_experience is null then leave sp_main;
    
    elseif ip_uname in (select uname from users) then leave sp_main;
    elseif ip_taxID in (select taxID from employees) then leave sp_main;
    elseif ip_licenseID in (select licenseID from drone_pilots) then leave sp_main;
	end if;
    
    insert into users (uname, first_name, last_name, address, birthdate) values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
	insert into employees (uname, taxID, service, salary) values (ip_uname, ip_taxID, ip_service, ip_salary);
	insert into drone_pilots (uname, licenseID, experience) values (ip_uname, ip_licenseID, ip_experience);
  
end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	-- place your solution here
    if ip_barcode is null or ip_pname is null or ip_weight is null
    then leave sp_main;
    elseif ip_barcode in (select barcode from products) then leave sp_main;
    end if;
    insert into products values(ip_barcode, ip_pname, ip_weight);
end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
	-- place your solution here
    if ip_storeID is null or ip_droneTag is null or ip_capacity is null or ip_remaining_trips is null or ip_pilot is null 
    then leave sp_main;
    elseif ip_storeID not in (select storeID from stores) then leave sp_main;
    elseif ip_droneTag in (select droneTag from drones where storeID = ip_storeID) then leave sp_main;
    elseif ip_pilot not in (select uname from drone_pilots) then leave sp_main;
    elseif ip_pilot in (select pilot from drones) then leave sp_main;
    end if;
    insert into drones values(ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	-- place your solution here
    DECLARE current_credit integer;
    if ip_uname is null or ip_money is null or ip_money < 0 then leave sp_main;
    elseif ip_uname not in (select uname from customers) then leave sp_main;
    end if;
    select credit into current_credit from customers where uname = ip_uname;
    update customers set credit = current_credit + ip_money where uname = ip_uname;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
	-- place your solution here
    if ip_incoming_pilot is null or ip_outgoing_pilot is null then leave sp_main;
    
    elseif ip_incoming_pilot not in (select uname from drone_pilots) or 
    ip_outgoing_pilot not in (select uname from drone_pilots) then leave sp_main;

    elseif ip_incoming_pilot in (select pilot from drones) then leave sp_main;
    
    elseif ip_outgoing_pilot not in (select pilot from drones) then leave sp_main;
    end if;
    
    update drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	-- place your solution here
    if ip_drone_store is null or ip_drone_tag is null or ip_refueled_trips is null or ip_refueled_trips < 0
    then leave sp_main;
    end if;
    update drones set remaining_trips = remaining_trips + ip_refueled_trips where storeID = ip_drone_store and droneTag = ip_drone_tag;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
    -- all values are specified not null in the table
    if ip_orderID is null or ip_sold_on is null or ip_purchased_by is null or ip_carrier_store is null or ip_carrier_tag is null or ip_barcode is null
	or ip_price is null or ip_quantity is null then leave sp_main;
	
	-- orderID cannot be duplicate
	elseif ip_orderID in (select orderID from orders) then leave sp_main;
    -- purchased by should be a valid user, barcode should be valid
	elseif ip_purchased_by not in (select uname from customers) then leave sp_main;
	elseif ip_barcode not in (select barcode from products) then leave sp_main;
     -- CHECK that the drone is valid - check that store and dronetag exist and check that they correspond to the same row
	elseif ip_carrier_store not in (select storeID from drones) then leave sp_main;
    elseif ip_carrier_tag not in (select droneTag from drones) then leave sp_main;
    elseif ip_carrier_tag not in (select droneTag from drones where storeID = ip_carrier_store) then leave sp_main;
    -- check that customer has enough credit to by product
	elseif (select credit from customers where uname = ip_purchased_by) < ip_price * ip_quantity then leave sp_main;
    -- check price and quantity to be positive
	elseif ip_price < 0 then leave sp_main;
	elseif ip_quantity < 0 then leave sp_main;
    -- check that capacity < weight * quantity of the product
    -- since this is begin_order we only need to explore the order line that is in inputs
	elseif (select capacity from drones where droneTag = ip_carrier_tag and storeID = ip_carrier_store) < 
	(select weight from products where barcode = ip_barcode) * ip_quantity then leave sp_main;
	end if;

	-- insert statements
	insert into orders values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
	insert into order_lines values (ip_orderID, ip_barcode, ip_price, ip_quantity);
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
   -- place your solution here
   DECLARE current_weight integer;
   DECLARE new_product_weight integer;
   DECLARE total_weight integer;
   DECLARE prev_cost integer;
   DECLARE store varchar(40);
   Declare tag integer;
   DECLARE total_cost integer;
   DECLARE order_purchased_by varchar(40);
   
   -- check for null inputs
   if ip_orderID is null or ip_barcode is null or ip_price is null or ip_quantity is null then leave sp_main;
   
   -- check for valid orderID and prodcut barcode
   elseif ip_orderID not in (select orderID from orders) then leave sp_main;
   elseif ip_barcode not in (select barcode from products) then leave sp_main;
   
   -- check that product is not alr in order
   elseif ip_barcode in (select barcode from order_lines where orderID = ip_orderID) then leave sp_main;
   
   -- check price and quantity to be positive
	elseif ip_price < 0 then leave sp_main;
	elseif ip_quantity < 0 then leave sp_main;
    end if;
    
    -- check that customer has enough credit to buy the entire order
    select purchased_by into order_purchased_by from orders where orderID = ip_orderID;
    select sum(quantity * price) into prev_cost from order_lines where orderID = ip_orderID;
    set total_cost = (ip_price * ip_quantity) + prev_cost;
	if (select credit from customers where uname = order_purchased_by) < total_cost then leave sp_main;
    end if;
   
   -- check that the drone has enough lifting capacity 
   select carrier_store into store from orders where orderID = ip_orderID;
   select carrier_tag into tag from orders where orderID = ip_orderID;
   select sum(quantity * weight) into current_weight from order_lines natural join products natural join orders where carrier_store = store and carrier_tag = tag;
   select weight * ip_quantity into new_product_weight from products where barcode = ip_barcode;
   set new_product_weight = ip_quantity * (select weight from products where barcode = ip_barcode);
   
   set total_weight = current_weight + new_product_weight;
   if total_weight > (select capacity from drones where droneTag = tag and storeID = store) then leave sp_main;
   end if;
   
   -- insert statements
   insert into order_lines values (ip_orderID, ip_barcode, ip_price, ip_quantity);
   
   
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    DECLARE customer varchar(40);
    DECLARE store varchar(40);
    DECLARE total_cost integer;
	DECLARE current_cost integer;
    DECLARE current_revenue integer;
    DECLARE current_credit integer;
    declare tag integer;
    declare trips integer;
    declare pilot1 varchar(40);
    declare exper integer;
    DECLARE customer_rating integer;
    
     -- check validity of orderID
    if ip_orderID is null then leave sp_main;
	elseif ip_orderID not in (select orderID from orders) then leave sp_main;
    end if;
    
    -- check that there are enough remaining trips
    select carrier_tag into tag from orders where orderID = ip_orderID;
	select carrier_store into store from orders where orderID = ip_orderID;
    select remaining_trips into trips from drones where storeID = store and droneTag = tag;
    if trips < 1 then leave sp_main;
    end if;
    
    -- reduce customer credit
    select purchased_by into customer from orders where orderID = ip_orderID;
    select sum(price * quantity) into total_cost from order_lines where orderID = ip_orderID;
    select credit into current_credit from customers where uname = customer;
    if current_credit < total_cost then leave sp_main;
    end if;
    update customers set credit = current_credit - total_cost where uname = customer; 
    
    -- increase stores revenue
    select revenue into current_revenue from stores where storeID = store;
    update stores set revenue = current_revenue + total_cost where storeID = store;
    
    -- decrease trips by one 
    update drones set remaining_trips = trips - 1 where storeID = store and droneTag = tag;
    -- increase experience by 1
    select pilot into pilot1 from drones where storeID = store and droneTag = tag;
    select experience into exper from drone_pilots where uname = pilot1;
    update drone_pilots set experience = exper + 1 where uname = pilot1;
    
    -- increase customer rating by 1 if price > 25
	select rating into customer_rating from customers where uname = customer;
	if total_cost > 25 and customer_rating < 5 then update customers set rating = customer_rating + 1 where uname = customer;
	end if;
     -- remove all order lines from system
    delete from order_lines where orderID = ip_orderID;
    -- delete order instance
    delete from orders where orderID = ip_orderID;
    
    
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    
    -- check if orderID is null
    DECLARE customer varchar(40);
    DECLARE customer_rating integer;
    
    -- check validity of orderID
    if ip_orderID is null then leave sp_main;
    elseif ip_orderID not in (select orderID from orders) then leave sp_main;
    end if;
    
    -- get customer
    select purchased_by into customer from orders where orderID = ip_orderID;
    -- delete all instances of order_lines matching orderID
    delete from order_lines where orderID = ip_orderID;
    -- delete order instance
    delete from orders where orderID = ip_orderID;
    -- decrease rating
    select rating into customer_rating from customers where uname = customer;
    if customer_rating < 2 then leave sp_main;
    end if; 
    update customers set rating = customer_rating - 1 where uname = customer;
    
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution as
select 'users' as category, count(*) as total from users
union all
select 'customers' as category, count(*) as total from customers
union all
select 'employees' as category, count(*) as total from employees
union all
select 'customer_employer_overlap' as category, count(*) as total from customers c
    inner join employees e on c.uname = e.uname
union all
select 'drone_pilots' as category, count(*) as total from drone_pilots
union all
select 'store_workers' as category, count(*) as total from store_workers
union all
select 'other_employee_roles' as category, count(*) as total from employees e
where e.uname not in (select uname from store_workers) and e.uname not in (select uname from drone_pilots);



-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- replace this select query with your solution
select uname as customer_name, rating, credit as current_credit, coalesce(sum(price * quantity), 0) as credit_already_allocated
from customers left join orders as o1 on uname = purchased_by 
left join order_lines as o2  on o1.orderID = o2.orderID
group by uname;

-- display drone status and current activity
-- create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
--	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
-- select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7' from drones;

create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot, 
    total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
select 
    d.storeID as drone_serves_store,
    d.droneTag as drone_tag,
    d.pilot,
    d.capacity as total_weight_allowed,
    COALESCE(sum(ol.quantity * p.weight), 0) as current_weight,
    d.remaining_trips as deliveries_allowed,
    count(distinct o.orderID) as deliveries_in_progress
from 
    drones d
left join orders o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
left join order_lines ol on o.orderID = ol.orderID
left join products p on ol.barcode = p.barcode
group by 
    d.storeID, d.droneTag;

-- display product status and current activity including most popular products
create or replace view most_popular_products as
select 
    p.barcode,
    p.pname as product_name,
    p.weight,
    MIN(ol.price) as lowest_price, 
    MAX(ol.price) as highest_price, 
    MIN(ifnull(ol.quantity, 0)) as lowest_quantity,
    MAX(ifnull(ol.quantity, 0)) as highest_quantity,
    SUM(ifnull(ol.quantity, 0)) as total_quantity
from 
    products p
left join order_lines ol on p.barcode = ol.barcode
group by p.barcode;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
select uname, licenseID, storeID as drone_serves_store, droneTag, experience as successful_deliveries, 
(select COALESCE((select COUNT(orderID) from orders where carrier_store = storeID and carrier_tag = droneTag GROUP BY carrier_store, carrier_tag), 0)) as pending_deliveries
from drone_pilots left join drones on uname = pilot;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
select s_o.storeID as store_id, s_o.sname, s_o.manager, s_o.revenue as revenue, 
	SUM(ol.price * ol.quantity) as incoming_revenue, count(distinct s_o.orderID) as incoming_orders 
	from (select s.storeID, s.sname, s.manager, s.revenue, o.orderID 
	from stores as s join orders as o on s.storeID=o.carrier_store group by s.storeID, o.orderID) as s_o 
	natural join order_lines as ol group by store_id;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload, contents) as
select 
    o.orderID as orderID,
    sum(ol.price * ol.quantity) as cost,
    count(ol.barcode) as num_products,
    sum(p.weight * ol.quantity) as payload,
    group_concat(p.pname separator ', ') as contents
from 
    orders o
join order_lines ol on o.orderID = ol.orderID
join products p on ol.barcode = p.barcode
group by o.orderID;


-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
    if ip_uname is null then leave sp_main;
    elseif ip_uname in (SELECT purchased_by FROM orders) then leave sp_main;
    end if;
	delete from customers where uname = ip_uname;
    if ip_uname not in (select uname from employees) then delete from users where uname = ip_uname;
    end if;
end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
    if ip_uname is null
    then leave sp_main;
    end if;
    if ip_uname in (select pilot from drones) then leave sp_main; 
    end if;
    delete from drone_pilots where uname = ip_uname;
    if not exists (select * from customers where uname = ip_uname)
    then delete from users where uname = ip_uname;
    end if;
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	-- place your solution here
    if ip_barcode is null
    then leave sp_main;
    end if;
    if not exists (select 1 from order_lines where barcode = ip_barcode)
    then delete from products where barcode = ip_barcode;
    end if;
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	-- place your solution here
    if ip_storeID is null or ip_droneTag is null
    then leave sp_main;
    end if;
    if not exists (select carrier_tag from orders where carrier_tag = ip_droneTag and carrier_store = ip_storeID)
    then delete from drones where droneTag = ip_droneTag;
    end if;
end //
delimiter ;



