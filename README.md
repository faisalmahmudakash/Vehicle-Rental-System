# 🚗 Vehicle Rental System — Database Design & SQL Queries

A relational database solution for managing users, vehicles, and bookings in a vehicle rental business. This project demonstrates ERD design, table relationships, primary/foreign keys, and SQL querying techniques.

## 📁 Repository Structure

```
vehicle-rental-system/
├── README.md        # Project documentation 
├── queries.sql      # All SQL queries with solutions  
```
## 🗄️ Database Schema

### `users`
Stores registered users of the platform.

| Column    | Type         | Constraints               |
|-----------|--------------|---------------------------|
| user_id   | SERIAL       | PRIMARY KEY               |
| user_name | VARCHAR(100) | NOT NULL                  |
| email     | VARCHAR(150) | NOT NULL, UNIQUE          |
| password  | VARCHAR(255) | NOT NULL                  |
| phone     | VARCHAR(20)  |                           |
| role      | VARCHAR(10)  | CHECK: admin \| customer  |

---

### `vehicles`
Stores all vehicles available for rental.

| Column               | Type           | Constraints                               |
|----------------------|----------------|-------------------------------------------|
| vehicle_id           | SERIAL         | PRIMARY KEY                               |
| vehicle_name         | VARCHAR(100)   | NOT NULL                                  |
| vehicle_type         | VARCHAR(20)    | CHECK: car \| bike \| truck               |    
| model                | VARCHAR(100)   |                                           |
| registration_number  | VARCHAR(50)    | NOT NULL, UNIQUE                          |
| rental_price         | NUMERIC(10,2)  | NOT NULL                                  |
| availability_status  | VARCHAR(20)    | CHECK: available \| rented \| maintenance |

---

### `bookings`
Links users to vehicles for a rental period.

| Column         | Type          | Constraints                                            |
|----------------|---------------|--------------------------------------------------------|
| booking_id     | SERIAL        | PRIMARY KEY                                            |
| user_id        | INT           | FOREIGN KEY → users(user_id)                           |
| vehicle_id     | INT           | FOREIGN KEY → vehicles(vehicle_id)                     |
| start_date     | DATE          | NOT NULL                                               |
| end_date       | DATE          | NOT NULL                                               |
| booking_status | VARCHAR(20)   | CHECK: pending \| confirmed \| completed \| cancelled  |
| total_cost     | NUMERIC(10,2) |                                                        |

---
## 🔗 Entity Relationships

users       ──< bookings >── vehicles
(1)              (many)         (1)
```

```
| Relationship | Description |
|---|---|
| **One-to-Many** | One `user` can have many `bookings` |
| **Many-to-One** | Many `bookings` belong to one `vehicle` |
| **Logical One-to-One** | Each booking links exactly one user to one vehicle |
---

## 🔍 SQL Queries Explained

```
```
### Query 1 — JOIN
**Goal:** Retrieve all bookings with the customer's name and vehicle name.
select 
    booking_id, 
    user_name as customer_name, 
    vehicle_name, 
    start_date, 
    end_date, 
    booking_status as status 
  from bookings
  inner join users on bookings.user_id = users.user_id
  inner join vehicles on bookings.vehicle_id = vehicles.vehicle_id;
```

**Concept:** `INNER JOIN` combines rows from `bookings`, `users`, and `vehicles` where the foreign keys match. Only bookings that have a matching user and vehicle are returned.

**Expected Output:**

| booking_id | customer_name | vehicle_name   | start_date | end_date   | status    |
|------------|---------------|----------------|------------|------------|-----------|
| 1          | Rahim Uddin   | Toyota Corolla | 2026-03-01 | 2026-03-03 | confirmed |
| 2          | Karim Hasan   | Yamaha R15     | 2026-03-02 | 2026-03-04 | completed |

---

### Query 2 — NOT EXISTS
**Goal:** Find all vehicles that have never been booked.

```sql
select 
    vehicle_id, 
    vehicle_name as name, 
    vehicle_type as type, 
    model, 
    registration_number, 
    rental_price, 
    availability_status as booking_status
  from vehicles v 
  where not exists(select * from bookings b where b.vehicle_id = v.vehicle_id);
```

**Concept:** `NOT EXISTS` uses a correlated subquery. For every row in `vehicles`, it checks whether any row exists in `bookings` with the same `vehicle_id`. If no match is found, the vehicle is included in the results — meaning it has never been booked.

**Expected Output:**

| vehicle_id  | name            | type  | model      | registration_number | rental_price   | booking_status |
|-------------|-----------------|-------|------------|---------------------|----------------|----------------|
| 14          | Kawsaki Ninja   | bike  | 2022       | DHA-2006            | 3000.00        | available      |

---

### Query 3 — WHERE
**Goal:** Retrieve all available vehicles of type `car`.

```sql
select 
    vehicle_id, 
    vehicle_name as name, 
    vehicle_type as type, 
    model, 
    registration_number,
    rental_price, 
    availability_status as booking_status
  from vehicles 
  where availability_status = 'available' and vehicle_type = 'car';
```

**Concept:** `WHERE` filters rows based on conditions. Here, two conditions are combined with `AND` — the vehicle must be of type `car` and have an `available` status. Both conditions must be true for a row to be returned.

**Expected Output:**

| vehicle_id | name           | type | model         | registration_number | rental_price   | booking_status |
|------------|----------------|------|---------------|---------------------|----------------|----------------|
| 1          | Toyota Corolla | car  | 2020          | DHA-1001            | 5000.00        | available      |
| 2          | Hyundai Civic  | car  | 2019          | DHA-1002            | 5200.00        | available      |

---

### Query 4 — GROUP BY and HAVING
**Goal:** Find vehicles with more than 2 bookings.

```sql
select 
    v.vehicle_name, 
    count(b.booking_id) as total_bookings
  from vehicles v
  inner join bookings b on v.vehicle_id = b.vehicle_id
  group by v.vehicle_id, v.vehicle_name
  having count(b.booking_id) > 2;
```

**Concept:** `GROUP BY` groups all booking rows by vehicle. `COUNT()` aggregates the number of bookings per vehicle. `HAVING` then filters those groups — unlike `WHERE` (which filters rows), `HAVING` filters aggregated groups. Only vehicles with more than 2 bookings appear in the output.

**Expected Output:**

| vehicle_name   | total_bookings |
|----------------|----------------|
| Nissan Sunny   | 4              |


---

## ▶️ How to Run

1. Create a PostgreSQL database:
   ```sql
   CREATE DATABASE vehicle_rental;
   ```
2. Connect and run the schema (create tables first using the schema above).
3. Insert sample data.
4. Run the queries from `queries.sql`.

---

## 🔗 Submission Links

| Item | Link |
|---|---|
| 📊 ERD Diagram | [Lucidchart ERD](https://lucid.app/lucidchart/e2601577-20b0-4fde-b8b3-43079250aa51/edit?viewport_loc=17%2C-73%2C2175%2C1041%2C0_0&invitationId=inv_9c49a74b-dccc-4ae2-9098-50953a266826)  |
| 💻 GitHub Repository | [GitHub Repo](https://github.com/faisalmahmudakash/Vehicle-Rental-System.git)|
| 🎥 Viva Video | [Google Drive](#) |

---

## 👤 Author

**Faisal Mahmud**  
