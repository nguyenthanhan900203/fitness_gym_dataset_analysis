/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'GymFitnessDataset' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gym
	
WARNING:
    Running this script will drop the entire 'GymFitnessDataset' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'GymFitnessDataset')
BEGIN
    ALTER DATABASE GymFitnessDataset SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GymFitnessDataset;
END;
GO

-- Create the 'GymFitnessDataset' database
CREATE DATABASE GymFitnessDataset;
GO

USE GymFitnessDataset;
GO

-- Create Schema

CREATE SCHEMA gym;
GO

CREATE TABLE gym.fitness_dataset (
    age INT NULL,
    membership_type NVARCHAR(50) NOT NULL,
    visit_per_week INT NULL,
    days_per_week NVARCHAR(50) NOT NULL,
    attend_group_lesson BIT NOT NULL,
    avg_time_check_in TIME(0) NULL,
    avg_time_check_out TIME(0) NULL,
    duration_in_gym_minutes INT NULL,
    has_drink_subscription BIT NOT NULL,
    personal_training BIT NOT NULL,
    uses_sauna BIT NOT NULL,
    self_identified_gender NVARCHAR(50) NOT NULL,
    subscription_price FLOAT NULL,
    subscription_model NVARCHAR(50) NOT NULL,
    adjusted_price FLOAT NOT NULL,
    discount_type NVARCHAR(50) NOT NULL,
    final_price FLOAT NOT NULL,
    access_hours NVARCHAR(50) NOT NULL,
    home_gym_location NVARCHAR(50) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    join_date DATE NOT NULL,
    personal_training_hours INT NULL,
    multi_location_access BIT NOT NULL,
    last_visit_date DATE NOT NULL
);
GO

TRUNCATE TABLE gym.fitness_dataset;
GO

BULK INSERT gym.fitness_dataset
FROM '"C:\Users\Ng.C Thanh Nhan\Downloads\Data Gym Membership\Fitness_Membership_Analytics_Dataset.csv"'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
