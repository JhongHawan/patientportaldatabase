--**********************************************************************************************--
-- Title: Assigment08 - Milestone02
-- Author: Brian Jhong
-- Desc: This file is the script for the Patients Appointment Project.
--		 It creates the database including tables, views, and stored procedures. 
-- Change Log: When,Who,What
-- 2018-11-28,Brian Jhong,Created File
-- 2018-11-28,Brian Jhong Created Clinics, Patients, Doctors, and Appointments tables. 
-- 2018-11-28,Brian Jhong Created Clinics, Patients, Doctors, and Appointments table views. 
-- 2018-11-28,Brian Jhong Created reporting view. 
-- 2018-11-29,Brian Jhong Created Clinics, Patients, Doctors, and Appointments stored procedures.
-- 2018-11-29,Brian Jhong Created stored procedures testing code.
-- 2018-11-29,Brian Jhong Set permissions for tables, views, and stored procedures.
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_BrianJhong')
	 Begin 
	  Alter Database [Assignment08DB_BrianJhong] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_BrianJhong;
	 End
	Create Database Assignment08DB_BrianJhong;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_BrianJhong;

-- Create Tables & Add Constraints -- 

Create Table Clinics (
	ClinicID int not null primary key identity(1,1),
	ClinicName nvarchar(100) not null unique,
	ClinicPhoneNumber nvarchar(100) null check(ClinicPhoneNumber like '206-123-1234'), 
	ClinicAddress nvarchar(100) not null, 
	ClinicCity nvarchar(100) not null,  
	ClinicState nchar(2) not null,  
	ClinicZipCode nvarchar(10) not null check(ClinicZipCode like '[0-9][0-9][0-9][0-9][0-9]' or 
												ClinicZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
go

Create Table Patients (
	PatientID int not null primary key identity(1,1),
	PatientFirstName nvarchar(100) not null,
	PatientLastName nvarchar(100) not null,
	PatientPhoneNumber nvarchar(100) null check(PatientPhoneNumber like '206-123-1234'), 
	PatientAddress nvarchar(100) not null, 
	PatientCity nvarchar(100) not null,  
	PatientState nchar(2) not null,  
	PatientZipCode nvarchar(10) not null check(PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]' or 
												PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
go

Create Table Doctors (
	DoctorID int not null primary key identity(1,1),
	DoctorFirstName nvarchar(100) not null,
	DoctorLastName nvarchar(100) not null,
	DoctorPhoneNumber nvarchar(100) null check(DoctorPhoneNumber like '206-123-1234'), 
	DoctorAddress nvarchar(100) not null, 
	DoctorCity nvarchar(100) not null,  
	DoctorState nchar(2) not null,  
	DoctorZipCode nvarchar(10) not null check(DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]' or 
												DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
go

Create Table Appointments (
	AppointmentID int not null primary key identity(1,1),
	AppointmentDateTime datetime not null,
	AppointmentPatientID int not null foreign key references Patients(PatientID),
	AppointmentDoctorID int not null foreign key references Doctors(DoctorID),
	AppointmentClinicID int not null foreign key references Clinics(ClinicID)
);
go

-- Create Views -- 

-- CLINICS VIEW -- 

Create View vClinics As
	Select 
		ClinicID,
		ClinicName,
		ClinicPhoneNumber, 
		ClinicAddress, 
		ClinicCity,  
		ClinicState,  
		ClinicZipCode
	From Clinics;
go

-- PATIENTS VIEW --
 
Create View vPatients As
	Select 
		PatientID,
		PatientFirstName,
		PatientLastName,
		PatientPhoneNumber, 
		PatientAddress, 
		PatientCity,  
		PatientState,  
		PatientZipCode
	From Patients;
go

-- DOCTORS VIEW -- 

Create View vDoctors As
	Select 
		DoctorID,
		DoctorFirstName,
		DoctorLastName,
		DoctorPhoneNumber, 
		DoctorAddress, 
		DoctorCity,  
		DoctorState,  
		DoctorZipCode
	From Doctors;
go

-- APPOINTMENTS VIEW -- 

Create View vAppointments As
	Select 
		AppointmentID,
		AppointmentDateTime,
		AppointmentPatientID,
		AppointmentDoctorID,
		AppointmentClinicID
	From Appointments;
go

-- REPORTING VIEW -- 

Create View vAppointmentsByPatientsDoctorsAndClinics As
	Select 
		a.AppointmentID,
		AppointmentDate = Format(a.AppointmentDateTime, 'MM/dd/yyyy'), --Format as US MM/DD/YYYY from AppointmentDateTime
		AppointmentTime = Format(a.AppointmentDateTime, 'hh:mm'),  --Format as 24 hour HH:MM from AppointmentDateTime
		p.PatientID,
		PatientName = p.PatientFirstName + ' ' + p.PatientLastName,	   --First and Last Name
		p.PatientPhoneNumber,
		p.PatientAddress,
		p.PatientCity,
		p.PatientState,
		p.PatientZipCode,
		d.DoctorID,
		DoctorName = d.DoctorFirstName + ' ' + d.DoctorLastName,      --First and Last Name
		d.DoctorPhoneNumber,
		d.DoctorAddress,
		d.DoctorCity,
		d.DoctorState,
		d.DoctorZipCode,
		c.ClinicID,
		c.ClinicName,
		c.ClinicPhoneNumber,
		c.ClinicAddress,
		c.ClinicCity,
		c.ClinicState,
		c.ClinicZipCode
	From Appointments As a
	Inner Join Patients As p 
	On p.PatientID = a.AppointmentPatientID
	Inner Join Doctors As d
	On d.DoctorID = a.AppointmentDoctorID
	Inner Join Clinics as c 
	On c.ClinicID = a.AppointmentClinicID
go 

-- Add Stored Procedures --

-- INSERT PROCEDURES -- 
Create Procedure pInsClinics
(	@ClinicName nvarchar(100),
	@ClinicPhoneNumber nvarchar(100), 
	@ClinicAddress nvarchar(100), 
	@ClinicCity nvarchar(100),  
	@ClinicState nchar(2),  
	@ClinicZipCode nvarchar(10)
)
/* Author: Brian Jhong 
** Desc: Processes Insertion of data into the Clinics table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pInsClinics stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into 
		Clinics(
			ClinicName,
			ClinicPhoneNumber, 
			ClinicAddress, 
			ClinicCity,  
			ClinicState,  
			ClinicZipCode
		) 
	Values (
		@ClinicName,
		@ClinicPhoneNumber, 
		@ClinicAddress, 
		@ClinicCity,  
		@ClinicState,  
		@ClinicZipCode
	);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsPatients
(	@PatientFirstName nvarchar(100),
	@PatientLastName nvarchar(100),
	@PatientPhoneNumber nvarchar(100), 
	@PatientAddress nvarchar(100), 
	@PatientCity nvarchar(100),  
	@PatientState nchar(2),  
	@PatientZipCode nvarchar(10)
)
/* Author: Brian Jhong 
** Desc: Processes Insertion of data into the Patients table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pInsPatients stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into 
		Patients(
			PatientFirstName,
			PatientLastName,
			PatientPhoneNumber, 
			PatientAddress, 
			PatientCity,  
			PatientState,  
			PatientZipCode
		) 
	Values (
		@PatientFirstName,
		@PatientLastName,
		@PatientPhoneNumber, 
		@PatientAddress, 
		@PatientCity,  
		@PatientState,  
		@PatientZipCode
	);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsDoctors
(	@DoctorFirstName nvarchar(100),
	@DoctorLastName nvarchar(100),
	@DoctorPhoneNumber nvarchar(100), 
	@DoctorAddress nvarchar(100), 
	@DoctorCity nvarchar(100),  
	@DoctorState nchar(2),  
	@DoctorZipCode nvarchar(10)
)
/* Author: Brian Jhong 
** Desc: Processes Insertion of data into the Doctors table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pInsDoctors stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into 
		Doctors(
			DoctorFirstName,
			DoctorLastName,
			DoctorPhoneNumber, 
			DoctorAddress, 
			DoctorCity,  
			DoctorState,  
			DoctorZipCode
		) 
	Values (
		@DoctorFirstName,
		@DoctorLastName,
		@DoctorPhoneNumber, 
		@DoctorAddress, 
		@DoctorCity,  
		@DoctorState,  
		@DoctorZipCode
	);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsAppointments
(	@AppointmentDateTime datetime,
	@AppointmentPatientID int,
	@AppointmentDoctorID int,
	@AppointmentClinicID int
)
/* Author: Brian Jhong 
** Desc: Processes Insertion of data into the Appointments table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pInsAppointments stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into 
		Appointments(
			AppointmentDateTime,
			AppointmentPatientID,
			AppointmentDoctorID,
			AppointmentClinicID
		) 
	Values (
		@AppointmentDateTime,
		@AppointmentPatientID,
		@AppointmentDoctorID,
		@AppointmentClinicID
	);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- UPDATE PROCEDURES -- 

Create Procedure pUpdClinics
(	@ClinicID int,
	@ClinicName nvarchar(100),
	@ClinicPhoneNumber nvarchar(100), 
	@ClinicAddress nvarchar(100), 
	@ClinicCity nvarchar(100),  
	@ClinicState nchar(2),  
	@ClinicZipCode nvarchar(10)
)
/* Author: Brian Jhong 
** Desc: Processes Updating of data in the Clinics table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pUpdClinics stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Clinics
    Set ClinicName = @ClinicName,			
		ClinicPhoneNumber = @ClinicPhoneNumber, 
		ClinicAddress = @ClinicAddress, 
		ClinicCity = @ClinicCity,  
		ClinicState = @ClinicState,  
		ClinicZipCode = @ClinicZipCode
    Where ClinicID = @ClinicID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdPatients
(	@PatientID int, 
	@PatientFirstName nvarchar(100),
	@PatientLastName nvarchar(100),
	@PatientPhoneNumber nvarchar(100), 
	@PatientAddress nvarchar(100), 
	@PatientCity nvarchar(100),  
	@PatientState nchar(2),  
	@PatientZipCode nvarchar(10)
)
/* Author: Brian Jhong 
** Desc: Processes Updating of data in the Patients table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pUpdPatients stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Patients
    Set PatientFirstName = @PatientFirstName,
		PatientLastName = @PatientLastName,
		PatientPhoneNumber = @PatientPhoneNumber, 
		PatientAddress = @PatientAddress, 
		PatientCity = @PatientCity,  
		PatientState = @PatientState,  
		PatientZipCode = @PatientZipCode
	Where PatientID = @PatientID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdDoctors
(	@DoctorID int, 
	@DoctorFirstName nvarchar(100),
	@DoctorLastName nvarchar(100),
	@DoctorPhoneNumber nvarchar(100), 
	@DoctorAddress nvarchar(100), 
	@DoctorCity nvarchar(100),  
	@DoctorState nchar(2),  
	@DoctorZipCode nvarchar(10)
)
/* Author: Brian Jhong 
** Desc: Processes Updating of data in the Doctors table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pUpdDoctors stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Doctors
    Set DoctorFirstName = @DoctorFirstName,
		DoctorLastName = @DoctorLastName,
		DoctorPhoneNumber = @DoctorPhoneNumber, 
		DoctorAddress = @DoctorAddress, 
		DoctorCity = @DoctorCity,  
		DoctorState = @DoctorState,  
		DoctorZipCode = @DoctorZipCode
	Where DoctorID = @DoctorID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdAppointments
(	@AppointmentID int, 
	@AppointmentDateTime datetime,
	@AppointmentPatientID int,
	@AppointmentDoctorID int,
	@AppointmentClinicID int
)
/* Author: Brian Jhong 
** Desc: Processes Updating of data in the Appointments table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pUpdAppointments stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Appointments
    Set AppointmentDateTime = @AppointmentDateTime,
		AppointmentPatientID = @AppointmentPatientID,
		AppointmentDoctorID = @AppointmentDoctorID,
		AppointmentClinicID = @AppointmentClinicID
	Where AppointmentID = @AppointmentID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- DELETE PROCEDURES -- 

Create Procedure pDelClinics
(	@ClinicID int
)
/* Author: Brian Jhong 
** Desc: Processes Deletion of data in the Clinics table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pDelClinics stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete 
	 From Clinics 
	  Where ClinicID = @ClinicID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelPatients
(	@PatientID int
)
/* Author: Brian Jhong 
** Desc: Processes Deletion of data in the Patients table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pDelPatients stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete 
	 From Patients 
	  Where PatientID = @PatientID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelDoctors
(	@DoctorID int
)
/* Author: Brian Jhong 
** Desc: Processes Deletion of data in the Doctors table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pDelDoctors stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete 
	 From Doctors 
	  Where DoctorID = @DoctorID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelAppointments
(	@AppointmentID int
)
/* Author: Brian Jhong 
** Desc: Processes Deletion of data in the Appointments table. 
** Change Log: When,Who,What
** 2018-11-29,Brian Jhong,Created pDelAppointments stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete 
	 From Appointments 
	  Where AppointmentID = @AppointmentID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Testing Views -- 

Select * From vClinics;
go

Select * From vPatients;
go

Select * From vDoctors;
go

Select * From vAppointments; 
go

Select * From vAppointmentsByPatientsDoctorsAndClinics; 
go

-- Set Permissions --

----- DENY OBJECT PERMISSIONS START HERE -----
Deny Select, Insert, Update, Delete On Clinics To Public; 
Deny Select, Insert, Update, Delete On Patients To Public; 
Deny Select, Insert, Update, Delete On Doctors To Public; 
Deny Select, Insert, Update, Delete On Appointments To Public; 

----- PERMISSIONS FOR VIEWS START HERE -----
Grant Select On vClinics To Public;
Grant Select On vPatients To Public;
Grant Select On vDoctors To Public;
Grant Select On vAppointments To Public;

----- PERMISSIONS FOR CLINICS PROCEDURES START HERE -----
Grant Execute On pInsClinics To Public;
Grant Execute On pUpdClinics To Public;
Grant Execute On pDelClinics To Public;

----- PERMISSIONS FOR PATIENTS PROCEDURES START HERE -----
Grant Execute On pInsPatients To Public;
Grant Execute On pUpdPatients To Public;
Grant Execute On pDelPatients To Public;

----- PERMISSIONS FOR DOCTORS PROCEDURES START HERE -----
Grant Execute On pInsDoctors To Public;
Grant Execute On pUpdDoctors To Public;
Grant Execute On pDelDoctors To Public;

----- PERMISSIONS FOR COURSES PROCEDURES START HERE -----
Grant Execute On pInsAppointments To Public;
Grant Execute On pUpdAppointments To Public;
Grant Execute On pDelAppointments To Public;

-- Testing Sprocs -- 

----- INSERT PROCEDURES TEST CODE START HERE -----

Declare @Status int;
Exec @Status = pInsClinics
				@ClinicName = 'SunnyClinic',
				@ClinicPhoneNumber = '206-123-1234', 
				@ClinicAddress = 'Sunny St', 
				@ClinicCity = 'Seattle',  
				@ClinicState = 'WA',  
				@ClinicZipCode = '98001'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
go

Declare @Status int;
Exec @Status = pInsPatients 		
				@PatientFirstName = 'William',
				@PatientLastName = 'Bennett',
				@PatientPhoneNumber = '206-123-1234', 
				@PatientAddress = 'Red St', 
				@PatientCity = 'Seattle',  
				@PatientState = 'WA',  
				@PatientZipCode = '98002'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
go

Declare @Status int;
Exec @Status = pInsDoctors 
				@DoctorFirstName = 'Albert',
				@DoctorLastName = 'Wyatt',
				@DoctorPhoneNumber = '206-123-1234', 
				@DoctorAddress = 'Blue St', 
				@DoctorCity = 'Seattle',  
				@DoctorState = 'WA',  
				@DoctorZipCode = '98004'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
go	

Declare @Status int;
Exec @Status = pInsAppointments
				@AppointmentDateTime = '2018-11-30 06:26:34.500',
				@AppointmentPatientID = '1',
				@AppointmentDoctorID = '1',
				@AppointmentClinicID = '1'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
go	

----- SELECT AFTER INSERT -----

Select * From vClinics;
go

Select * From vPatients;
go

Select * From vDoctors;
go

Select * From vAppointments; 
go

Select * From vAppointmentsByPatientsDoctorsAndClinics; 
go

----- UPDATE PROCEDURES TEST CODE START HERE -----

Declare @Status int;
Exec @Status = pUpdClinics
				@ClinicID = @@IDENTITY, 
				@ClinicName = 'RainbowClinic',
				@ClinicPhoneNumber = '206-123-1234', 
				@ClinicAddress = 'Rainbow St', 
				@ClinicCity = 'Los Angeles',  
				@ClinicState = 'CA',  
				@ClinicZipCode = '40001'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foreign Key Violation'
  End as [Status]
go
				
Declare @Status int;
Exec @Status = pUpdPatients
				@PatientID = @@IDENTITY, 
				@PatientFirstName = 'John',
				@PatientLastName = 'Fergus',
				@PatientPhoneNumber = '206-123-1234', 
				@PatientAddress = 'Yellow St', 
				@PatientCity = 'New York City',  
				@PatientState = 'NY',  
				@PatientZipCode = '02390'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foreign Key Violation'
  End as [Status]
go
			
Declare @Status int;
Exec @Status = pUpdDoctors
				@DoctorID = @@IDENTITY,
				@DoctorFirstName = 'Edward',
				@DoctorLastName = 'Takumi',
				@DoctorPhoneNumber = '206-123-1234', 
				@DoctorAddress = 'Green St', 
				@DoctorCity = 'Miami',  
				@DoctorState = 'FL',  
				@DoctorZipCode = '09999'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foreign Key Violation'
  End as [Status]
go

Declare @Status int;
Exec @Status = pUpdAppointments
				@AppointmentID = @@IDENTITY,
				@AppointmentDateTime = '2018-12-01 09:00:00.000',
				@AppointmentPatientID = '1',
				@AppointmentDoctorID = '1',
				@AppointmentClinicID = '1'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foreign Key Violation'
  End as [Status]
go

----- SELECT AFTER UPDATE -----

Select * From vClinics;
go

Select * From vPatients;
go

Select * From vDoctors;
go

Select * From vAppointments; 
go

Select * From vAppointmentsByPatientsDoctorsAndClinics; 
go

----- DELETE PROCEDURES TEST CODE START HERE -----

Declare @Status int;
Exec @Status = pDelAppointments @AppointmentID = @@IDENTITY;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]
go

Declare @Status int;
Exec @Status = pDelClinics @ClinicID = @@IDENTITY;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]
go

Declare @Status int;
Exec @Status = pDelPatients @PatientID = @@IDENTITY;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]
go

Declare @Status int;
Exec @Status = pDelDoctors @DoctorID = @@IDENTITY;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]
go

----- SELECT AFTER DELETE -----

Select * From vClinics;
go

Select * From vPatients;
go

Select * From vDoctors;
go

Select * From vAppointments; 
go

Select * From vAppointmentsByPatientsDoctorsAndClinics; 
go

/**************************************************************************************************/