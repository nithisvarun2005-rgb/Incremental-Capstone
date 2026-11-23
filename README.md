# FoodExpress - Food Delivery Management System

# Project Overview
FoodExpress is a food delivery marketplace for Urban Bite
Technologies. It supports the core data required to manage customers,
restaurants, menu items, delivery riders, customer orders, and the items
included in each order.

This project uses Microsoft SQL Server (T-SQL).
# Objectives
- Store customer and restaurant information.
- Maintain restaurant menu items and prices.
- Track delivery riders and their availability status.
- Record orders placed by customers.
- Store the menu items and quantities included in each order.
- Enforce relationships and basic business rules using primary keys,
  foreign keys, default constraints, and check constraints.

# Database Tables
  Table                               Purpose
  Customer  -                        Stores customer details.

  Restaurant  -                      Stores restaurant details and
                                    hourly capacity.

  Rider    -                         Stores delivery rider details and
                                      status.

  MenuItem  -                        Stores menu items belonging to
                                                        restaurants.

  [Order]    -                       Stores customer orders, restaurant,
                                      assigned rider, status, and total
                                    amount.

OrderItem   -                      Stores the individual menu items
                                    and quantities in each order.

# Relationships
- One restaurant can have many menu items.
- One customer can place many orders.
- One restaurant can receive many orders.
- One rider can be assigned to many orders.
- One order can contain many order items.
- One menu item can appear in many order items.
Foreign keys enforce these relationships and help prevent references to
records that do not exist.

| Relationship | Cardinality |
|--------|--------|
| Customer → Order | One-to-Many |
| Restaurant → MenuItem | One-to-Many |
| Restaurant → Order | One-to-Many |
| Rider → Order | One-to-Many |
| Order → OrderItem | One-to-Many |
| MenuItem → OrderItem | One-to-Many |


# Main Constraints
- Primary key columns uniquely identify records.
- Primary keys use SQL Server IDENTITY(1,1) to generate IDs
  automatically.
- MenuItem.Price must be greater than or equal to zero.
- OrderItem.Quantity must be greater than zero.
- Rider.Status defaults to Offline.
- [Order].Status defaults to Placed.
- [Order] is enclosed in square brackets because ORDER is a SQL
  keyword.
Sample Data
The sample-data script is designed to insert:

  Table            Number of rows
  Customer                   10
Restaurant                 10
Rider                      10
MenuItem                   20
[Order]                   100
OrderItem                 200
Total               350

The data must be inserted in dependency order so that referenced parent
records exist before child records are inserted.
Requirements
- Microsoft SQL Server (SQL Server 2019 or later recommended)
- SQL Server Management Studio (SSMS) or another SQL Server query
  editor
- Permission to create tables and insert records in the selected
  database

# Project Status
This README documents the FoodExpress SQL Server database schema and
sample-data setup. 
