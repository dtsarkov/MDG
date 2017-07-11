IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'HLSD')
   EXEC sys.sp_executesql N'CREATE SCHEMA [HLSD] AUTHORIZATION [dbo]'
GO
