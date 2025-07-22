--create database wsm;
use wsm;
CREATE TABLE employee (
    Employee_ID INT PRIMARY KEY,
   First_Name VARCHAR(100),
  Middle_Name VARCHAR(100),
  Last_Name VARCHAR(100),
   Manager_ID INT,
    manager_name varchar(100)  
	FOREIGN KEY (Manager_ID) REFERENCES employee(Employee_ID)
	);
	select* from employee;


	BULK INSERT employee
FROM 'C:\projects\employee.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
-------------------------------------------------------------------------------------------------------------

CREATE TABLE warehouses (
    Warehouse_ID INT PRIMARY KEY,
    Warehouse_Name VARCHAR(100),
    Manager_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES employee(Employee_ID)
);

	BULK INSERT warehouses
FROM 'C:\projects\ware.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
--------------------------------------------------------------------------------------------------------
CREATE TABLE bins (
    Bin_ID INT PRIMARY KEY,
    Capacity INT,
    Warehouse_ID INT,
    FOREIGN KEY (Warehouse_ID) REFERENCES warehouses(Warehouse_ID)
);
	BULK INSERT bins
FROM 'C:\projects\bin.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
-----------------------------------------------------------------------------------------
CREATE TABLE part (
    Part_ID INT PRIMARY KEY,
    Part_Name VARCHAR(100),
    Part_Number VARCHAR(50),
    Assembly_ID INT
);
BULK INSERT part
FROM 'C:\projects\part.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
-----------------------------------------------------------------
CREATE TABLE batch (
    Batch_Number INT PRIMARY KEY,
    Batch_Size INT,
    Part_ID INT,
    Arrival_Date char(10),
    Bin_ID INT,
    Manager_ID INT,
    FOREIGN KEY (Part_ID) REFERENCES part(Part_ID),
    FOREIGN KEY (Bin_ID) REFERENCES bins(Bin_ID),
    FOREIGN KEY (Manager_ID) REFERENCES employee(Employee_ID)
);
BULK INSERT batch
FROM 'C:\projects\batch.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);

-----------------------------------------------------------------------------------------------------
CREATE TABLE phone (
    Phone_ID INT PRIMARY KEY,
    Employee_ID INT,
    Phone_Number CHAR(6),
    FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID)
);

BULK INSERT phone
FROM 'C:\projects\phone.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
---------------------------------------------------------------------------------------------------
CREATE TABLE address (
    Address_ID INT PRIMARY KEY,
    Employee_ID INT,
    Street_Number CHAR(6),
    Street_Name VARCHAR(100),
    City_Name VARCHAR(100),
    Province_Abbr CHAR(2),
    FOREIGN KEY (address_ID) REFERENCES employee(Employee_ID)
);


BULK INSERT address
FROM 'C:\projects\address.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);

-------------------------------------------------------------------------------------
CREATE TABLE backorder (
    Backorder_ID INT PRIMARY KEY,
    Part_ID INT,
    Quantity_Ordered INT,
    Remaining_Quantity INT,
    Manager_ID INT,
    Backorder_Date char(10),
    FOREIGN KEY (Part_ID) REFERENCES part(Part_ID),
    FOREIGN KEY (Manager_ID) REFERENCES employee(Employee_ID)
);
BULK INSERT address
FROM 'C:\projects\address.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
------------------------------------------------------------------------------------------------
CREATE TABLE shipment (
    Shipment_ID INT,
    Date_Out CHAR(10) ,
    Part_ID INT,
    Employee_ID INT
);

BULK INSERT shipment
FROM 'C:\projects\shipment.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Adjust delimiter based on your file format
    ROWTERMINATOR = '\n',    -- Adjust based on line breaks in your file
    FIRSTROW =  2          -- Skip header row if applicable
);
-------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE GetWorkersUnderManager  
AS  
BEGIN  
    BEGIN TRY  
        -- Declare a cursor to loop through employees under a specific manager  
        DECLARE @EmployeeID INT  

        DECLARE worker_cursor CURSOR FOR  
        SELECT Employee_ID  
        FROM employee  
        WHERE manager_Name = 'Tony7 Tony7'  

        OPEN worker_cursor  

        FETCH NEXT FROM worker_cursor INTO @EmployeeID  

        WHILE @@FETCH_STATUS = 0  
        BEGIN  
            PRINT 'Employee ID: ' + CAST(@EmployeeID AS VARCHAR)  
            FETCH NEXT FROM worker_cursor INTO @EmployeeID  
        END  

        CLOSE worker_cursor  
        DEALLOCATE worker_cursor  
    END TRY  
    BEGIN CATCH  
        PRINT 'Error: ' + ERROR_MESSAGE()  
    END CATCH  
END  
GO  

-- Execute the stored procedure  
EXEC GetWorkersUnderManager  

-------------------------------------------------------------------------------------------
