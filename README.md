# SHEIN-DATABASE

## Overview
Welcome to the SHEIN Database System, a comprehensive solution for managing and optimizing the backend operations of an online retail platform.

## Files
1-**System Requirements**:
Review the requirements_document.txt to know more about the requirements of our system.

2-**Database Schema**:
Review the SheinSchema.jpg or SHEIN_ERD.png to get an overview of the tables, relationships, and entities included in the system.

3-**Queries and Operations**:
Execute common queries and operations with examples provided in the Queries.sql.
You can also run queries as stored procedures in our project by referring to DML_SPs.sql.

## Data Details

The dataset is structured with multiple tables, focusing mainly on orders information. The key tables include:

- **Products**: Information about SHEIN products like their names, color, price, and categories they belong, etc...
- **Orders**: Daily transaction data, like their order_id, Payment_type, Shipping_address, Date, and status.
- **order_product**: Details about order and product and quantity of products.
- **Category**: Details about the categories' names and the parent class they belong
- **Review**: Details about reviews like the product, the customer, rate, and comments.
- **Customer**:  Details about the customer like name, e-mail, phone, address, age, and credit card, etc...

## Key Features:

- **Customer Management:** Efficiently store and manage customer information, including personal details, order history, and contact information.

- **Order Processing:** Seamlessly handle order creation, status tracking, and payment processing, ensuring a smooth transaction flow.

- **Products:** Keep track of product details, including descriptions, categories, pricing, and stock levels.

- **Sales Analysis:** Utilize built-in queries to analyze sales data, identify popular products, and gain insights into customer preferences.

## Installation:

Follow the steps below to set up the SHEIN Database System in your local environment:
1-Open SQL Server Management Studio (SSMS).
2-Connect to your SQL Server instance.
3-Right-click on "Databases" in Object Explorer.
Choose "Restore Database..."
4-Select "Device" and choose the Shein_data.bak file from the cloned repository.
But firstly use this code to clone our repo
```bash
# Clone the repository
git clone https://github.com/farah1612/SHEIN-DATABASE
