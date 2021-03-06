USE [master]
GO
/****** Object:  Database [LTP_Project]    Script Date: 12/23/2018 11:43:36 AM ******/
CREATE DATABASE [LTP_Project]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LTP_Project', FILENAME = N'E:\projects\LTP\LTP\data\LTP_Project.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LTP_Project_log', FILENAME = N'E:\projects\LTP\LTP\data\LTP_Project_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [LTP_Project] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LTP_Project].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LTP_Project] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LTP_Project] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LTP_Project] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LTP_Project] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LTP_Project] SET ARITHABORT OFF 
GO
ALTER DATABASE [LTP_Project] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LTP_Project] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LTP_Project] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LTP_Project] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LTP_Project] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LTP_Project] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LTP_Project] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LTP_Project] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LTP_Project] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LTP_Project] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LTP_Project] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LTP_Project] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LTP_Project] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LTP_Project] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LTP_Project] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LTP_Project] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LTP_Project] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LTP_Project] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [LTP_Project] SET  MULTI_USER 
GO
ALTER DATABASE [LTP_Project] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LTP_Project] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LTP_Project] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LTP_Project] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LTP_Project] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LTP_Project] SET QUERY_STORE = OFF
GO
USE [LTP_Project]
GO
/****** Object:  User [admin]    Script Date: 12/23/2018 11:43:36 AM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
/****** Object:  Table [dbo].[person]    Script Date: 12/23/2018 11:43:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person](
	[person_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[state_id] [int] NULL,
	[gender] [char](1) NULL,
	[dob] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[states]    Script Date: 12/23/2018 11:43:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[states](
	[state_id] [int] IDENTITY(1,1) NOT NULL,
	[state_code] [char](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[state_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[person]  WITH CHECK ADD FOREIGN KEY([state_id])
REFERENCES [dbo].[states] ([state_id])
GO
/****** Object:  StoredProcedure [dbo].[uspPersonSearch]    Script Date: 12/23/2018 11:43:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspPersonSearch]
	@searchTerm varchar(100) = null
AS
	IF (@searchTerm IS NULL OR @searchTerm = '')
		SELECT person_id as Id,
		first_name as FirstName,
		last_name as LastName,
		state_id as StateId,
		gender as Gender,
		dob as DOB
		FROM [dbo].[person]
		ORDER BY last_name
	ELSE
		SELECT person_id as Id,
		first_name as FirstName,
		last_name as LastName,
		state_id as StateId,
		gender as Gender,
		dob as DOB
		FROM [dbo].[person]
		WHERE first_name + ' ' + last_name LIKE '%' + @searchTerm + '%'
		ORDER BY last_name
GO
/****** Object:  StoredProcedure [dbo].[uspPersonUpsert]    Script Date: 12/23/2018 11:43:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspPersonUpsert] 
	@personId int = null,
	@firstName varchar(50) = null,
	@lastName varchar(50) = null,
	@stateId int = null,
	@gender char(1) = null,
	@dob datetime = null
AS
BEGIN
	IF (@personId IS NOT NULL) AND EXISTS (SELECT * FROM [dbo].[person] WHERE person_id = @personId)
		UPDATE [dbo].[person] 
		SET 
			first_name = @firstName, 
			last_name = @lastName, 
			state_id = @stateId, 
			gender = @gender, 
			dob = @dob 
		WHERE person_id = @personId
	ELSE
		INSERT INTO [dbo].[person](first_name, last_name, state_id, gender, dob)
		VALUES(@firstName, @lastName, @stateId, @gender, @dob)
END


GO
/****** Object:  StoredProcedure [dbo].[uspStatesList]    Script Date: 12/23/2018 11:43:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspStatesList]
AS
	SELECT state_id AS Id,
	state_code as Code
	FROM [dbo].[states] 
	ORDER BY state_code
GO
USE [master]
GO
ALTER DATABASE [LTP_Project] SET  READ_WRITE 
GO
