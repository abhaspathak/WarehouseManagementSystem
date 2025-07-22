--CREATE OR REPLACE DIRECTORY ext_dirr AS 'C:\projects';
GRANT READ, WRITE ON DIRECTORY ext_dirr TO sys;

--create employee table
CREATE TABLE employee (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(100),
    Middle_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Manager_ID INT,
      manager_name varchar(100);    
    FOREIGN KEY (Manager_ID) REFERENCES employee(Employee_ID)
);
CREATE INDEX idx_manager_name ON employee(manager_Name);
CREATE INDEX idx_backorder_manager ON backorder(Manager_ID, Remaining_Quantity);

--create external table for employee
--CREATE TABLE external_employeee_2 (
--    Employee_ID INT,
--    First_Name VARCHAR2(100),
--    Middle_Name VARCHAR2(100),
--    Last_Name VARCHAR2(100),
--      
--    Manager_ID INT,
--    manager_name varchar(100)
--)
--ORGANIZATION EXTERNAL (
--    TYPE ORACLE_LOADER
--    DEFAULT DIRECTORY ext_dirr
--    ACCESS PARAMETERS (
--        RECORDS DELIMITED BY NEWLINE
--        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
--       
--    )
--    LOCATION ('employee.txt')
--)
--REJECT LIMIT UNLIMITED;
----
--select * from external_employeee_2;
----
--INSERT INTO employee (Employee_ID,First_Name ,Middle_Name,Last_Name ,Manager_ID )
--SELECT Employee_ID,First_Name ,Middle_Name,Last_Name ,Manager_ID 
--FROM external_employeee_2;
--select* from employee;
--------------------------------------------------------------------------------

CREATE TABLE warehouses (
    Warehouse_ID INT PRIMARY KEY,
    Warehouse_Name VARCHAR(100),
    Manager_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES employee(Employee_ID)
);
--select* from warehouses;


CREATE TABLE external_ware (
    warehouse_ID INT,
    warehouse_name varchar(50),
    manager_ID INT
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('ware.txt')
)
REJECT LIMIT UNLIMITED;
select*from external_ware;


INSERT INTO warehouses (warehouse_ID, warehouse_name, manager_ID)
SELECT warehouse_ID, warehouse_name, manager_ID
FROM external_ware;
----------------------------------------------------------------------------------------------------
CREATE TABLE bins (
    Bin_ID INT PRIMARY KEY,
    Capacity INT,
    Warehouse_ID INT,
    FOREIGN KEY (Warehouse_ID) REFERENCES warehouses(Warehouse_ID)
);
CREATE TABLE external_bin_1 (
    Bin_ID INT,
    Capacity INT,
    Warehouse_ID INT
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('bin.txt')
)
REJECT LIMIT UNLIMITED;
select* from external_bin;
INSERT INTO bins (Bin_ID, Capacity, Warehouse_ID)
SELECT Bin_ID, Capacity, Warehouse_ID
FROM external_bin_1;
--select* from bins;
---------------------------------------------------------------------------------------------
CREATE TABLE part (
    Part_ID INT PRIMARY KEY,
    Part_Name VARCHAR(100),
    Part_Number VARCHAR(50),
    Assembly_ID INT
);

CREATE TABLE external_part (
    Part_ID INT,
    Part_Name VARCHAR2(100),
    Part_Number VARCHAR2(50),
    Assembly_ID INT
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('part.txt')
)
REJECT LIMIT UNLIMITED;
select*from external_part;
INSERT INTO part (Part_ID, Part_Name, Part_Number, Assembly_ID)
SELECT Part_ID, Part_Name, Part_Number, Assembly_ID
FROM external_part;
--select* from part;
------------------------------------------------------------------------------
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

CREATE TABLE external_batch (
    Batch_Number INT,
    Batch_Size INT,
    Part_ID INT,
    Arrival_Date char(10),
    Bin_ID INT,
    Manager_ID INT
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('batch.txt')
)
REJECT LIMIT UNLIMITED;
drop table batch CASCADE constraints  ;
select* from external_batch;
INSERT INTO batch (Batch_Number, Batch_Size, Part_ID, Arrival_Date, Bin_ID, Manager_ID)
SELECT Batch_Number, Batch_Size, Part_ID, Arrival_Date, Bin_ID, Manager_ID
FROM external_batch;
--------------------------------------------------------------------------------
CREATE TABLE phone (
    Phone_ID INT PRIMARY KEY,
    Employee_ID INT,
    Phone_Number CHAR(6),
    FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID)
);

CREATE TABLE external_phone (
    Phone_ID INT,
    Employee_ID INT,
    Phone_Number CHAR(6)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('phone.txt')
)

REJECT LIMIT UNLIMITED;
select* from external_phone;
INSERT INTO phone (Phone_ID, Employee_ID, Phone_Number)
SELECT Phone_ID, Employee_ID, Phone_Number
FROM external_phone;
----select* from phone;
------------------------------------------------------------------------------------------
CREATE TABLE address (
    Address_ID INT PRIMARY KEY,
    Employee_ID INT,
    Street_Number CHAR(6),
    Street_Name VARCHAR(100),
    City_Name VARCHAR(100),
    Province_Abbr CHAR(2),
    FOREIGN KEY (address_ID) REFERENCES employee(Employee_ID)
);

CREATE TABLE external_address (
    Address_ID INT,
    Employee_ID INT,
    Street_Number CHAR(6),
    Street_Name VARCHAR(100),
    City_Name VARCHAR(100),
    Province_Abbr CHAR(2)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('address.txt')
)
REJECT LIMIT UNLIMITED;

select* from external_address;
INSERT INTO address (Address_ID, Employee_ID, Street_Number, Street_Name, City_Name, Province_Abbr)
SELECT Address_ID, Employee_ID, Street_Number, Street_Name, City_Name, Province_Abbr
FROM external_address;
----select* from address;

--------------------------------------------------------------------------------

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

INSERT INTO backorder (Backorder_ID, Part_ID, Quantity_Ordered, Remaining_Quantity, Manager_ID, Backorder_Date)
SELECT Backorder_ID, Part_ID, Quantity_Ordered, Remaining_Quantity, Manager_ID,Backorder_Date
FROM external_backorder;
--
select * from backorder;
select* from external_backorder;
CREATE TABLE external_backorder (
    Backorder_ID INT,
    Part_ID INT,
    Quantity_Ordered INT,
    Remaining_Quantity INT,
    Manager_ID INT,
    Backorder_Date CHAR(10) 
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('backorder.txt')
)
REJECT LIMIT UNLIMITED;
-------------------------------------------------------

CREATE TABLE shipment (
    Shipment_ID INT,
    Date_Out CHAR(10) ,
    Part_ID INT,
    Employee_ID INT
);

CREATE TABLE external_shipment (
    Shipment_ID INT,
    Date_Out CHAR(10) ,
    Part_ID INT,
    Employee_ID INT
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dirr
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('shipment.txt')
)
REJECT LIMIT UNLIMITED;

select * from external_shipment;
INSERT INTO shipment (Shipment_ID, Date_Out, Part_ID, Employee_ID)
SELECT Shipment_ID,Date_Out, Part_ID, Employee_ID
FROM external_shipment;
-------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
create or replace PROCEDURE GetWorkersUnderManager IS
BEGIN
    FOR worker IN (
        SELECT Employee_ID
        FROM employee 
        WHERE manager_Name = 'Tony7 Tony7'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || worker.Employee_ID);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END GetWorkersUnderManager;

BEGIN
    GetWorkersUnderManager;
END;

EXPLAIN PLAN FOR
    SELECT Employee_ID
        FROM employee 
        WHERE manager_Name = 'Tony7 Tony7'
        SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
        CREATE INDEX idx_manager_name ON employee(manager_Name);
-------------------------------------------------------------------------------------------------
--
CREATE OR REPLACE PROCEDURE ListBackordersByManager IS
BEGIN
    -- Loop through each unique Manager_ID
    FOR manager IN (
        SELECT DISTINCT Manager_ID
        FROM backorder
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Manager ID: ' || manager.Manager_ID);
        
        -- Loop through the backorders for the current Manager_ID
        FOR backorder IN (
            SELECT b.Backorder_ID, b.Part_ID, b.Quantity_Ordered, b.Remaining_Quantity, b.Backorder_Date
            FROM backorder b
            WHERE b.Manager_ID = manager.Manager_ID
            AND b.Remaining_Quantity > 0  -- Filter to show only current backorders
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('   Backorder ID: ' || backorder.Backorder_ID || 
                                 ', Part ID: ' || backorder.Part_ID || 
                                 ', Quantity Ordered: ' || backorder.Quantity_Ordered || 
                                 ', Remaining Quantity: ' || backorder.Remaining_Quantity || 
                                 ', Backorder Date: ' || backorder.Backorder_Date);
        END LOOP;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ListBackordersByManager;
----/
begin
ListBackordersByManager;
end;

EXPLAIN PLAN FOR 
SELECT Backorder_ID, Part_ID, Quantity_Ordered, Remaining_Quantity, Backorder_Date
FROM backorder
WHERE Manager_ID = :manager_id
AND Remaining_Quantity > 0;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
CREATE INDEX idx_backorder_manager ON backorder(Manager_ID, Remaining_Quantity);
--select user from dual
----------------------------------------------------------------------------------------------------------------------

DECLARE
    -- Declare a cursor for fetching backorder data
    CURSOR backorder_cursor IS
        SELECT Backorder_ID, Part_ID, Quantity_Ordered, Remaining_Quantity, Backorder_Date
        FROM backorder
        WHERE Remaining_Quantity > 500;  -- You can modify the condition as needed

    -- Declare variables to hold the values fetched by the cursor
    v_Backorder_ID INT;
    v_Part_ID INT;
    v_Quantity_Ordered INT;
    v_Remaining_Quantity INT;
    v_Backorder_Date CHAR(10);
BEGIN
    -- Open the cursor and loop through the rows
    OPEN backorder_cursor;

    LOOP
        FETCH backorder_cursor INTO v_Backorder_ID, v_Part_ID, v_Quantity_Ordered, v_Remaining_Quantity, v_Backorder_Date;
        EXIT WHEN backorder_cursor%NOTFOUND;  -- Exit the loop when no more rows are found

        -- Display the fetched data
        DBMS_OUTPUT.PUT_LINE('Backorder ID: ' || v_Backorder_ID || 
                             ', Part ID: ' || v_Part_ID || 
                             ', Quantity Ordered: ' || v_Quantity_Ordered || 
                             ', Remaining Quantity: ' || v_Remaining_Quantity || 
                             ', Backorder Date: ' || v_Backorder_Date);
    END LOOP;

    -- Close the cursor after processing
    CLOSE backorder_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);  -- Handle any exceptions
END;
explain plan for
SELECT Backorder_ID, Part_ID, Quantity_Ordered, Remaining_Quantity, Backorder_Date
        FROM backorder
        WHERE Remaining_Quantity >500;
   SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY); 
   CREATE INDEX idx_remaining_quantity ON backorder(Remaining_Quantity);
   CREATE INDEX idx_remaining_quantity_func ON backorder(CASE WHEN Remaining_Quantity > 500 THEN Remaining_Quantity END);
 SELECT * 
FROM USER_INDEXES 
WHERE INDEX_NAME = 'IDX_REMAINING_QUANTITY';



-----------------------------------------------------------------------------------------------------------------------------------
--
--
--
------/
CREATE OR REPLACE PROCEDURE InsertNewEmployee (
    p_Employee_ID INT,
    p_First_Name VARCHAR2,
    p_Middle_Name VARCHAR2,
    p_Last_Name VARCHAR2,
    p_Manager_ID INT,
    p_Manager_Name VARCHAR2
) IS
BEGIN
INSERT INTO employee (Employee_ID, First_Name, Middle_Name, Last_Name, Manager_ID,manager_name)
    VALUES (p_Employee_ID, p_First_Name, p_Middle_Name, p_Last_Name, p_Manager_ID,p_manager_name);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE ('New employee added with ID: ' || p_Employee_ID);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_Employee_ID || ' already exists.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertNewEmployee;
drop procedure InsertNewEmployee;
/

BEGIN
    InsertNewEmployee(100, 'John', 'A', 'Doe',50,'john');
END;
EXPLAIN PLAN FOR
INSERT INTO employee (Employee_ID, First_Name, Middle_Name, Last_Name, Manager_ID,manager_name)
    VALUES (&Employee_ID, '&First_Name', '&Middle_Name', '&Last_Name', &Manager_ID,'&manager_name');
     SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY); 
--------------------------------------------------------
CREATE OR REPLACE PROCEDURE GetBackordersByManager (
    p_Manager_ID INT
) AS
BEGIN
    FOR rec IN (SELECT * FROM backorder WHERE Manager_ID = p_Manager_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('Backorder ID: ' || rec.Backorder_ID || ', Part ID: ' || rec.Part_ID || ', Quantity Ordered: ' || rec.Quantity_Ordered);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No backorders found for Manager ID: ' || p_Manager_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END GetBackordersByManager;
/
begin
 GetBackordersByManager(1);
 end;
explain plan for
SELECT * FROM backorder WHERE Manager_ID = :Manager_ID;
   SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY); 
CREATE INDEX idx_backorder_part ON backorder(Part_ID);
 SELECT * 
FROM USER_INDEXES 
WHERE INDEX_NAME = 'idx_backorder_part';

--------------------------------------------------------------------------
--
CREATE OR REPLACE PROCEDURE ShowPartOrderDetails (
    p_Part_ID INT
) AS
    v_Total_Ordered INT;
    v_Remaining_Quantity INT;
BEGIN
    -- Initialize the variables
    v_Total_Ordered := 0;
    v_Remaining_Quantity := 0;

    -- Calculate total ordered and remaining quantity for the specified part
    SELECT SUM(Quantity_Ordered), SUM(Remaining_Quantity)
    INTO v_Total_Ordered, v_Remaining_Quantity
    FROM backorder
    WHERE Part_ID = p_Part_ID;

    -- Check if the part has any backorders
    IF v_Total_Ordered IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('No backorders found for Part ID: ' || p_Part_ID);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Part ID: ' || p_Part_ID || 
                             ', Total Ordered: ' || v_Total_Ordered || 
                             ', Remaining Quantity: ' || v_Remaining_Quantity);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No data found for Part ID: ' || p_Part_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ShowPartOrderDetails;
/
BEGIN
    ShowPartOrderDetails(1);  -- 
END;
--/
EXPLAIN PLAN FOR
SELECT SUM(Quantity_Ordered), SUM(Remaining_Quantity)
FROM backorder
WHERE Part_ID = :p_Part_ID;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
CREATE INDEX idx_backorder_part ON backorder(Part_ID);

--------------------------------------------------------------------------------------------------------------
--
--
--drop table user_credentials;
CREATE TABLE user_credentials (
    username VARCHAR2(50) PRIMARY KEY,
    password VARCHAR2(50)
--);
--INSERT INTO user_credentials (username, password) 
--VALUES ('admin', 'admin123');  -- Example user
--
--INSERT INTO user_credentials (username, password) 
--VALUES ('employee', 'emp123');  -- Example user

drop procedure authenticateuser;
CREATE OR REPLACE PROCEDURE AuthenticateUser (
    p_username IN VARCHAR2, 
    p_password IN VARCHAR2, 
    p_success OUT BOOLEAN
) AS
    v_count INT;
BEGIN
    -- Check if the provided username and password match any record in the table
    SELECT COUNT(*)
    INTO v_count
    FROM user_credentials
    WHERE username = p_username
    AND password = p_password;
    
    -- If a matching record is found, authentication is successful
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Authentication successful!');
        p_success := TRUE;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid username or password.');
        p_success := FALSE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        p_success := FALSE;
END AuthenticateUser;
-- Prompt the user for the username


-- Prompt the user for the username and password
ACCEPT username CHAR PROMPT 'Enter username: ';
ACCEPT password CHAR PROMPT 'Enter password: ';

DECLARE
    v_authenticated BOOLEAN;  -- Variable to hold authentication status
    v_username VARCHAR2(100); -- Variable to store username
    v_password VARCHAR2(100); -- Variable to store password
BEGIN
    -- Assign the input values to variables
    v_username := '&username';  -- Use the substitution variable for username
    v_password := '&password';  -- Use the substitution variable for password

    -- Call authentication procedure with user input
    AuthenticateUser(v_username, v_password, v_authenticated);

    -- If authentication is successful, proceed with calling other procedures
    IF v_authenticated THEN
        -- Call another procedure, e.g., GetBackordersByManager
        -- Pass a manager ID (for example, 1) to get backorders for that manager
        GetBackordersByManager(1);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Access denied. No further actions can be performed.');
    END IF;
END;
/
explain plan for
   SELECT COUNT(*)
    FROM user_credentials
    WHERE username = :username
    AND password = :password;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
