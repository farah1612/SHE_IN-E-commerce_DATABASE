use Shein_data

--- Insertion into Customer table ------
create  proc InsertCust
	@id int ,
	@fname varchar(50) = NULL,
	@lname varchar(50) = NULL,
	@DOB date = NULL,
	@gender varchar(1) = NULL,
	@mail varchar(100) = NULL,
	@phone varchar(50) = NULL,
	@credit_card varchar(50) =  NULL,
	@street varchar(50) =  NULL,
	@city varchar(50) =  NULL,
	@country varchar(50) =  NULL,
	@pass varchar(50) =  NULL
	AS
	Begin
		insert into Customer
		values(@id,@fname,@lname,@DOB,@gender,@mail,@phone,@credit_card,@street,@city,
		@country,@pass)
	End

--- Insertion into Categoy table ------
create  proc InsertCat
	@cat_id int ,
	@cat_name varchar(100) = NULL,
	@class_name varchar(100) = NULL
	AS
	Begin
		insert into Category
		values(@cat_id,@cat_name,@class_name)
	End

--- Insertion into Review table ------
create  proc InsertRev
	@prod_id int ,
	@cust_id int,
	@rate int  = NULL,
	@comment varchar(1000) = NULL,
	@date datetime = NULL
	AS
	Begin
		insert into review
		values(@prod_id,@cust_id,@rate,@comment,@date)
	End

--- Deletion from  Customer table ------
create proc DelCust 
	@id int
as
Begin
	 delete from Customer
	 where cust_id = @id
End

--- Deletion from  Category table ------
create proc DelCat 
	@cat_id int
as
Begin
	 delete from Category
	 where category_id = @cat_id
End

--- Deletion from  Category table ------
create proc DelRev
	@prod_id int, 
	@cust_id int
as
Begin
	 delete from review
	 where  product_id = @prod_id and customer_id = @cust_id
End


--- Update  Customer Email ------
create proc updateEmail
       @c_id int,
	   @e_mail varchar(100) 
As
begin
	 update Customer
	 set E_mail = @e_mail
	 where cust_id = @c_id
end
--- Update  Customer phone ------
create proc updatePhone
       @c_id int,
	   @phone varchar(50) 
As
begin
	 update Customer
	 set phone = @phone
	 where cust_id = @c_id
end
--- Update  Customer credit_care ------
create proc updateCard
       @c_id int,
	   @credit varchar(100) 
As
begin
	 update Customer
	 set credit_card = @credit
	 where cust_id = @c_id
end
--- Update  Customer pass ------
create proc updatePass
       @c_id int,
	   @Pass varchar(50) 
As
begin
	 update Customer
	 set pass = @Pass
	 where cust_id = @c_id
end

--- Update  Review rate ------
create  proc updateRate
       @c_id int,
	   @Prod_id int,
	   @rate int
As
begin
	 update Review
	 set rate = @rate
	 where customer_id = @c_id and product_id = @Prod_id
end
--- Update  Review comment ------
create proc updateComment
       @c_id int,
	   @Prod_id int,
	   @comment  varchar(1000)
As
begin
	 update Review
	 set comment = @comment
	 where customer_id = @c_id and product_id = @Prod_id
end

-- Insertion Procedure for Order
CREATE PROCEDURE InsertOrder
	@orderId INT,
    @customerId INT,
    @orderDate DATETIME,
    @orderstatus NVARCHAR(25),
    @shippingAddress NVARCHAR(255),
    @shippingdate DATETIME,
    @shippingmethod NVARCHAR(25),
    @estimatedDate DATETIME,
    @payType NVARCHAR(25),
    @payId INT
AS
BEGIN
    INSERT INTO Orders (order_id, order_date,order_Status, shipping_address,shipping_date,shipping_method, estimated_date,payment_id, payment_type,cust_ID)
    VALUES (@orderId, @orderDate, @orderstatus,@shippingAddress, @shippingdate,@shippingmethod,@estimatedDate, @payType, @payId, @customerId)
END

-- Insertion Procedure for Product
CREATE PROCEDURE InsertProduct
	@productID INT,
    @productName NVARCHAR(255),
    @categoryID INT,
    @inStock INT,
    @price DECIMAL(10, 2),
    @size NVARCHAR(10),
    @color NVARCHAR(50),
    @discountVal INT
AS
BEGIN
    INSERT INTO Products ([product_id],[product_name],[category_id],[in_stock],[price],[size],[color],[discount_value])
    VALUES (@productID , @productName ,@categoryID ,@inStock, @price, @size, @color, @discountVal)
END

-- Insertion Procedure for order _product
CREATE PROCEDURE InsertOrderProd
    @orderId INT,
	@productID INT,
	@quantity INT
AS
BEGIN
    INSERT INTO order_product ([order_id],[product_id],[order_quantity])
    VALUES (@orderId, @productID , @quantity)
END

-- Update Procedure for Orders
CREATE PROCEDURE UpdateOrder
    @orderId INT,
    @newStatus NVARCHAR(50)
AS
BEGIN
    UPDATE Orders
    SET Order_Status = @newStatus
    WHERE Order_id = @orderId
END

-- Update Procedure for Products

--price
CREATE PROCEDURE UpdateProductPrice
    @productId INT,
    @newPrice DECIMAL(10, 2)
AS
BEGIN
    UPDATE Products
    SET Price = @newPrice
    WHERE product_id = @productId
END

--instock
CREATE PROCEDURE UpdateProductAvailability
    @productId INT,
    @available INT
AS
BEGIN
    UPDATE Products
    SET [in_stock] = @available
    WHERE product_id = @productId
END

--discount
CREATE PROCEDURE UpdateProductDiscount
    @productId INT,
    @newdiscount INT
AS
BEGIN
    UPDATE Products
    SET [discount_value] = @newdiscount
    WHERE product_id = @productId
END

-- Update Procedure for order_product
CREATE PROCEDURE UpdateOrderProduct
    @orderId INT,
    @productId INT,
    @newQuantity INT
AS
BEGIN
    UPDATE order_product
    SET order_quantity= @newQuantity
    WHERE Order_ID = @orderId AND Product_ID = @productId;
END

-- Deletion Procedure for Orders
CREATE PROCEDURE DeleteOrder
    @orderId INT
AS
BEGIN
    DELETE FROM Orders
    WHERE Order_id = @orderId;
END;

-- Deletion Procedure for Products
CREATE PROCEDURE DeleteProduct
    @productId INT
AS
BEGIN
    DELETE FROM Products
    WHERE product_id = @productId;
END

-- Deletion Procedure for order_product
CREATE PROCEDURE DeleteOrderProduct
    @orderId INT,
    @productId INT
AS
BEGIN
    DELETE FROM order_product
    WHERE Order_ID = @orderId AND Product_ID = @productId;
END
