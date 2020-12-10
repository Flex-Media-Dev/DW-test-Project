USE [master]
GO

CREATE DATABASE [Testdb]
GO

CREATE LOGIN [Testuser] WITH PASSWORD=N'Testpassword', DEFAULT_DATABASE=[Testdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [Testdb]
GO
CREATE USER [Testuser] FOR LOGIN [Testuser] WITH DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE [db_datareader] ADD MEMBER [Testuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [Testuser]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [Testuser]
GO
