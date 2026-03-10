CREATE DATABASE vehicle_rental;

CREATE TABLE users(
  user_id SERIAL PRIMARY KEY,
  user_role VARCHAR(10) CHECK (user_role IN ('Admin', 'Customer')),
  user_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  user_password VARCHAR(100) NOT NULL,
  phone_number VARCHAR(15)
);

CREATE TABLE vehicles(
  vehicle_id SERIAL PRIMARY KEY,
  vehicle_name VARCHAR(100) NOT NULL,
  vehicle_type VARCHAR(20) CHECK (vehicle_type IN('car','bike','truck')),
  model VARCHAR(100),
  registration_number VARCHAR(50) NOT NULL UNIQUE,
  rental_price DECIMAL(10, 2) NOT NULL,
  availability_status VARCHAR(20) CHECK (availability_status IN('available', 'rented', 'maintenance'))
);

CREATE TABLE bookings(
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  vehicle_id INT REFERENCES vehicles(vehicle_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  booking_status VARCHAR(20) CHECK (booking_status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  total_cost DECIMAL(10, 2)
);




INSERT INTO users (user_role, user_name, email, user_password, phone_number) VALUES
('Admin','Faisal Mahmud','faisal@gmail.com','pass123','01710000001'),
('Customer','Rahim Uddin','rahim@gmail.com','pass123','01710000002'),
('Customer','Karim Hasan','karim@gmail.com','pass123','01710000003'),
('Customer','Ayesha Akter','ayesha@gmail.com','pass123','01710000004'),
('Customer','Nusrat Jahan','nusrat@gmail.com','pass123','01710000005'),
('Customer','Tanvir Ahmed','tanvir@gmail.com','pass123','01710000006'),
('Customer','Sadia Islam','sadia@gmail.com','pass123','01710000007'),
('Customer','Hasan Ali','hasan@gmail.com','pass123','01710000008'),
('Customer','Mehedi Hasan','mehedi@gmail.com','pass123','01710000009'),
('Customer','Tania Sultana','tania@gmail.com','pass123','01710000010'),
('Customer','Arif Khan','arif@gmail.com','pass123','01710000011'),
('Customer','Rafi Ahmed','rafi@gmail.com','pass123','01710000012'),
('Customer','Mim Akter','mim@gmail.com','pass123','01710000013'),
('Customer','Sabbir Hossain','sabbir@gmail.com','pass123','01710000014'),
('Customer','Jannat Islam','jannat@gmail.com','pass123','01710000015');


INSERT INTO vehicles (vehicle_name, vehicle_type, model, registration_number, rental_price, availability_status) VALUES
('Toyota Corolla','car','2020','DHA-1001',5000,'available'),
('Honda Civic','car','2019','DHA-1002',5200,'available'),
('Suzuki Swift','car','2018','DHA-1003',4000,'rented'),
('Yamaha R15','bike','2022','DHA-2001',1500,'available'),
('Honda CBR','bike','2021','DHA-2002',1600,'available'),
('Bajaj Pulsar','bike','2020','DHA-2003',1200,'maintenance'),
('Hero Splendor','bike','2019','DHA-2004',1000,'available'),
('Toyota Hiace','truck','2018','DHA-3001',7000,'available'),
('Isuzu Truck','truck','2017','DHA-3002',7500,'rented'),
('Tata Truck','truck','2016','DHA-3003',7200,'available'),
('Nissan Sunny','car','2021','DHA-1004',4800,'available'),
('Hyundai Elantra','car','2022','DHA-1005',5500,'available'),
('TVS Apache','bike','2023','DHA-2005',1700,'available'),
('Kawasaki Ninja','bike','2022','DHA-2006',3000,'available'),
('Ford Ranger','truck','2021','DHA-3004',8000,'available');


INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, booking_status, total_cost) VALUES
(2,1,'2026-03-01','2026-03-03','confirmed',10000),
(3,4,'2026-03-02','2026-03-04','completed',3000),
(4,2,'2026-03-05','2026-03-06','pending',5200),
(5,3,'2026-03-06','2026-03-08','confirmed',8000),
(6,5,'2026-03-07','2026-03-09','completed',3200),
(7,6,'2026-03-08','2026-03-10','cancelled',0),
(8,7,'2026-03-09','2026-03-10','confirmed',1000),
(9,8,'2026-03-10','2026-03-12','pending',14000),
(10,9,'2026-03-11','2026-03-13','completed',15000),
(11,10,'2026-03-12','2026-03-14','confirmed',14400),
(12,11,'2026-03-13','2026-03-15','pending',9600),
(13,12,'2026-03-14','2026-03-16','confirmed',11000),
(14,13,'2026-03-15','2026-03-17','completed',3400),
(15,11,'2026-03-16','2026-03-18','confirmed',6000),
(15,11,'2026-03-16','2026-03-19','confirmed',6000),
(15,11,'2026-03-16','2026-03-20','confirmed',6000),
(2,15,'2026-03-17','2026-03-19','pending',16000);
  

--q1
select booking_id, user_name as customer_name, vehicle_name, start_date, end_date, booking_status as status 
  from bookings
    inner join users on bookings.user_id = users.user_id
    inner join vehicles on bookings.vehicle_id = vehicles.vehicle_id;

--q2
select vehicle_id, vehicle_name as name, vehicle_type as type, model, registration_number, rental_price, availability_status as booking_status
  from vehicles v 
  where not exists(select * from bookings b where b.vehicle_id = v.vehicle_id);


--q3
select vehicle_id, vehicle_name as name, vehicle_type as type, model, registration_number, rental_price, availability_status as booking_status
  from vehicles 
    where availability_status = 'available' and vehicle_type = 'car';


--q4
select v.vehicle_name, count(b.booking_id) as total_bookings
  from vehicles v
  inner join bookings b on v.vehicle_id = b.vehicle_id
  group by v.vehicle_id, v.vehicle_name
  having count(b.booking_id) > 2;






