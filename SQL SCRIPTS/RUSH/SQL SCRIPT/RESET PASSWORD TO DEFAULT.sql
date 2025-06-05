USE RUSH
GO

--Step I : Check if user exist
SELECT * from tbl_Profile where 
PRO_Name1 like '%TUNGALA%' -- Lastname
GO

--Step II : Get the loginname(username) of the user | and backup the old password | get the USD_PRO_ID
SELECT * from tbl_UserDetail WHERE 
USD_LoginName like '%TUNGALA%' -- Lastname
GO

--STEP III : Execute the Hash Generator using the format [username]Default@123
exec sp_cr_HashCodeGenerator 'TungalaKarlaMaeDefault@123'
select * from tbl_UserDetail where USD_LoginName like '%TUNGALA%' --Insert the Lastname


--STEP IV : Reset the password, copy the hashed code then set it as the password
UPDATE tbl_UserDetail
SET		
		USD_Password = '90D008EACE93D9963832E5F7F823D554', --Insert the HASHED CODE from Step III here
		USD_Force_PW_Change = '1'	--This will force the user to change there password from default to desire password
WHERE	USD_PRO_ID = '34755' --Insert the USD_PRO_ID from Step II

--STEP V : Go to Object Explorer > 192.168.5.11\... > Security > Logins > Find the user's name
--STEP VI : Change the user's password to RUSHDefault@123