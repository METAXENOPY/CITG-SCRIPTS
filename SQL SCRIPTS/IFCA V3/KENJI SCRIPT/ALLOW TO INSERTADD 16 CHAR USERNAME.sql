
-- Change all column 'user_audit' to VARCHAR(35)
DECLARE @TableName NVARCHAR(MAX)
DECLARE @AlterQuery NVARCHAR(MAX)

DECLARE cursor_tables CURSOR FOR
SELECT
    TABLE_SCHEMA + '.' + TABLE_NAME AS 'Table'
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    COLUMN_NAME = 'audit_user';

OPEN cursor_tables

FETCH NEXT FROM cursor_tables INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @AlterQuery = 'ALTER TABLE ' + @TableName + ' ALTER COLUMN audit_user VARCHAR(35);'
    -- Replace 'VARCHAR(35)' with the desired data type and length for the column

    BEGIN TRY
        EXEC sp_executesql @AlterQuery
        PRINT 'Column altered successfully in table: ' + @TableName
    END TRY
    BEGIN CATCH
        PRINT 'Error while altering column in table: ' + @TableName
        PRINT ERROR_MESSAGE()
    END CATCH

    FETCH NEXT FROM cursor_tables INTO @TableName
END

CLOSE cursor_tables
DEALLOCATE cursor_tables
GO

ALTER TABLE mgr.security_users DROP CONSTRAINT pk_security_users
ALTER TABLE mgr.security_users ALTER COLUMN name VARCHAR(35) NOT NULL
ALTER TABLE mgr.security_users ADD CONSTRAINT pk_security_users PRIMARY KEY (name)
GO

ALTER TABLE mgr.security_groupings
ALTER COLUMN group_name VARCHAR(35) NOT NULL
ALTER TABLE mgr.security_groupings
ALTER COLUMN user_name VARCHAR(35) NOT NULL
GO

ALTER TABLE mgr.cfs_user_entity
ALTER COLUMN userid VARCHAR(35) NOT NULL
GO

ALTER TABLE mgr.cfs_user_mstr
ALTER COLUMN userid VARCHAR(35) NOT NULL
ALTER TABLE mgr.cfs_user_mstr
ALTER COLUMN passwd VARCHAR(35) NOT NULL
GO
