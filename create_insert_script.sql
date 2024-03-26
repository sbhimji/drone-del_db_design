-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 19, 2024 @ 12:00am EST

-- Team 22
-- Sunwoo Park (spark868)
-- Desmond Dulaney (ddulaney3)
-- Saim Bhimji (sbhimji3)
-- Seongyeon Park (spark913)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
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

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */


CREATE TABLE User (
    uname VARCHAR(40) NOT NULL PRIMARY KEY,
    fname CHAR(100) NOT NULL,
    lname CHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    birthdate DATE NULL
);

CREATE TABLE Product (
    barcode VARCHAR(40) NOT NULL PRIMARY KEY,
    pname VARCHAR(255) NOT NULL,
    weight DECIMAL(10, 2) NOT NULL 
);

CREATE TABLE Employee (
    uname VARCHAR(40) NOT NULL,
    taxID CHAR(11) NOT NULL UNIQUE,
    service INT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (uname),
    FOREIGN KEY (uname) REFERENCES User(uname)
);

CREATE TABLE Store_worker (
    employeeID VARCHAR(40) NOT NULL PRIMARY KEY,
    FOREIGN KEY (employeeID) REFERENCES Employee(uname)
);

CREATE TABLE Drone_pilot (
    employeeID VARCHAR(40) NOT NULL PRIMARY KEY,
    licenseID VARCHAR(40) NOT NULL UNIQUE,
    experience INT NOT NULL,
    FOREIGN KEY (employeeID) REFERENCES Employee(uname)
);

CREATE TABLE Store (
    storeID CHAR(3) NOT NULL PRIMARY KEY,
    sname VARCHAR(100) NOT NULL,
    revenue DECIMAL(15, 2) NOT NULL,
    managerID VARCHAR(40) NOT NULL,
    FOREIGN KEY (managerID) REFERENCES Store_worker(employeeID)
);

CREATE TABLE Drone (
    droneTag VARCHAR(40) NOT NULL PRIMARY KEY,
    storeID CHAR(3) NOT NULL,
    rem_trips INT NOT NULL,
    capacity DECIMAL(10, 2) NOT NULL,
    employeeID VARCHAR(40) NOT NULL UNIQUE,
    FOREIGN KEY (storeID) REFERENCES Store(storeID),
    FOREIGN KEY (employeeID) REFERENCES Drone_pilot(employeeID)
);

CREATE TABLE Customer (
    customerID VARCHAR(40) NOT NULL PRIMARY KEY,
    rating DECIMAL(3, 2) NULL,
    credit DECIMAL(10, 2) NULL,
    FOREIGN KEY (customerID) REFERENCES User(uname)
);

CREATE TABLE Orders (
    orderID VARCHAR(40) NOT NULL PRIMARY KEY,
    sold_on DATE NOT NULL,
    droneID VARCHAR(40) NOT NULL,
    customerID VARCHAR(40) NOT NULL,
    FOREIGN KEY (droneID) REFERENCES Drone(droneTag),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Contain (
    barcode VARCHAR(40) NOT NULL,
    orderID VARCHAR(40) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (barcode, orderID),
    FOREIGN KEY (barcode) REFERENCES Product(barcode),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE Employ (
    employeeID VARCHAR(40) NOT NULL,
    storeID CHAR(3) NOT NULL,
    PRIMARY KEY (employeeID, storeID),
    FOREIGN KEY (employeeID) REFERENCES Store_worker(employeeID),
    FOREIGN KEY (storeID) REFERENCES Store(storeID)
);

INSERT INTO User (uname, fname, lname, address, birthdate) VALUES
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19');

INSERT INTO Customer (customerID, rating, credit) VALUES
('awilson5', 2, 100),
('jstone5', 4, 40),
('lrodriguez5', 4, 60),
('sprince6', 5, 30);

INSERT INTO Employee (uname, taxID, service, salary) VALUES
('awilson5', '111-11-1111', 9, 46000),
('csoares8', '888-88-8888', 26, 57000),
('echarles19', '777-77-7777', 3, 27000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000);

INSERT INTO Store_worker (employeeID) VALUES
('echarles19'),
('eross10'),
('hstark16');

INSERT INTO Drone_pilot (employeeID, licenseID, experience) VALUES
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10);

INSERT INTO Store (storeID, sname, revenue, managerID) VALUES
('pub', 'Publix', 200000, 'hstark16'),
('krg', 'Kroger', 300000, 'echarles19');

INSERT INTO Drone (droneTag, storeID, rem_trips, capacity, employeeID) VALUES
('Publix\'s drone #1', 'pub', 3, 10, 'awilson5'),
('Publix\'s drone #2', 'pub', 2, 20, 'tmccall5'),
('Kroger\'s drone #1', 'krg', 4, 15, 'lrodriguez5');

INSERT INTO Orders (orderID, sold_on, droneID, customerID) VALUES
('pub_303', '2021-05-23', 'Publix\'s drone #1', 'sprince6'),
('krg_217', '2021-05-23', 'Kroger\'s drone #1', 'jstone5'),
('pub_306', '2021-05-22', 'Publix\'s drone #2', 'awilson5'),
('pub_305', '2021-05-22', 'Publix\'s drone #2', 'sprince6');

INSERT INTO Product (barcode, weight, pname) VALUES
('ss_2D4E6L', 3, 'shrimp salad'),
('ap_9T25E36L', 4, 'antipasto platter'),
('pr_3C6A9R', 6, 'pot roast'),
('hs_5E7L23M', 3, 'hoagie sandwich'),
('clc_4T9U25X', 5, 'chocolate lava cake');

INSERT INTO Contain (barcode, orderID, price, quantity) VALUES
('ap_9T25E36L', 'pub_303', 4, 1),
('pr_3C6A9R', 'pub_303', 20, 1),
('pr_3C6A9R', 'krg_217', 15, 2),
('hs_5E7L23M', 'pub_306', 3, 2),
('ap_9T25E36L', 'pub_306', 10, 1),
('clc_4T9U25X', 'pub_305', 3, 2);




