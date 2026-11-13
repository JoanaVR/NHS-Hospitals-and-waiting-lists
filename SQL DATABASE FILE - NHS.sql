--Part 1 USE OKD to create database and tables

Create Database If not exists nhs_wait_times;
Use nhs_wait_times;

Create Table COUNTRY(
    COUNTRYID int Primary Key Auto_Increment,
    COUNTRYNAME varchar(100) Not Null
);

Create Table COUNTY(
    COUNTYID int Primary Key Auto_Increment,
    COUNTYNAME varchar(100) Not Null,
    COUNTRYID int,
    Foreign Key (COUNTRYID) References COUNTRY(COUNTRYID)
);

Create Table DISTRICT(
    DISTRICTID int Primary Key Auto_Increment,
    DISTRICTNAME varchar(100) Not Null,
    COUNTYID int,
    POPULATIONRECORDID int,

    Foreign Key (COUNTYID) References COUNTY(COUNTYID)
);

Create Table PERSON(
    PERSONID int Primary Key Auto_Increment,
    NHSNUMBER varchar(12) Unique,
    SECUREID varchar(50) Unique,
    FIRSTNAME varchar(100) Not Null,
    LASTNAME varchar(100) Not Null,
    ADDRESSLINE1 varchar(200) Not Null,
    ADDRESSLINE2 varchar(200),
    CITY varchar(100) Not Null,
    POSTCODE varchar(20) Not Null,
    COUNTRYID INT Not Null,
    DOB date Not Null,
    SEX char(1) Not Null,

    Foreign Key (COUNTRYID) References COUNTRY(COUNTRYID)
);

Create Table ROLE_TABLE(
    ROLEID int Primary Key Auto_Increment,
    ROLENAME varchar(100) Not Null,
    PERMISSIONS varchar(255) Not Null
);

Create Table PROCEDURE_TABLE(
    PROCEDUREID int Primary Key Auto_Increment,
    PROCEDURENAME varchar(100) Not Null,
    DESCRIPTION_TEXT text Not Null,
    CATERGORY varchar(100) Not Null,
    SCHEDULED DateTime Not null
);

Create Table PROVIDER_TABLE(
    PROVIDERID int Primary Key Auto_Increment,
    DISTRICTID int not Null,
    PROVIDERNAME varchar(200) Not Null,
    ADDRESSLINE1 varchar(200) Not Null,
    ADDRESSLINE2 varchar(200),
    CITY varchar(100) Not Null,
    POSTCODE varchar(20) Not Null,
    COUNTRY varchar(100) Not Null,
    PHONENUMBER varchar(15) Not Null,
    EMAIL varchar(100) Not Null, 
    ClinicType varchar(100) Not Null,

    Foreign Key (DISTRICTID) References DISTRICT(DISTRICTID)
);

Create Table DEPARTMENT(
    DEPTID int Primary Key Auto_Increment,
    DEPTNAME varchar(100) Not Null,
    PROVIDERID int Not Null,

    Foreign Key (PROVIDERID) References PROVIDER_TABLE(PROVIDERID)
);

Create Table PATIENT(
    PATIENTID int Primary Key Auto_Increment,
    PERSONID int Not Null,
    PROVIDERID int Not Null,
    FOREIGN KEY (PERSONID) REFERENCES PERSON(PERSONID),
    Foreign key (PROVIDERID) References PROVIDER_TABLE(PROVIDERID)
);

Create Table STAFF(
    STAFFID int Primary Key Auto_increment, 
    ROLEID int Not Null,
    PERSONID int not null,
    PROVIDERId int not null,

    Foreign key(PERSONID) References PERSON(PERSONID),
    Foreign Key (ROLEID) References ROLE_TABLE(ROLEID),
    Foreign Key (PROVIDERID) References PROVIDER_TABLE(PROVIDERID)
);

Create Table USER_TABLE(
    USERID int Primary Key Auto_increment,
    PERSONID Int not null,
    USERNAME varchar(100) Not Null,
    PASSWORDHASH varchar(255) Not Null,
    ROLEID int not null, 
    PROVIDERID int not null,

    Foreign key (PERSONID) References PERSON(PERSONID),
    Foreign Key(ROLEID) References ROLE_TABLE(ROLEID),
    Foreign Key(PROVIDERID) References PROVIDER_TABLE(PROVIDERID)
);

Create Table APPOINTMENT(
    APPTID int Primary Key Auto_Increment,
    PATIENTID int Not Null,
    STAFFID int not null, 
    PROVIDERID int not null, 
    APPTDATE DATETIME Not null, 
    APPTSTATUS varchar(50) not null, 
    BOOKEDBYUSERID int not null,

    Foreign Key (PATIENTID) References PATIENT(PATIENTID),
    Foreign Key (STAFFID) References STAFF(STAFFID),
    Foreign Key (PROVIDERID) References PROVIDER_TABLE(PROVIDERID),
    Foreign Key (BOOKEDBYUSERID) References USER_TABLE(USERID)
);


Create Table ADMISSIONS(
    ADMISSIONID int not null Primary Key Auto_increment,
    PATIENTID int not null, 
    PROVIDERID int not null,
    DEPTID int not null, 
    ADMISSIONDATE DateTime not null,
    DISCHARGEDATE DATETIME,
    ADMISSIONTYPE varchar(100) not null,

    Foreign Key (PATIENTID) references PATIENT(PATIENTID),
    Foreign Key (PROVIDERID) references PROVIDER_TABLE(PROVIDERID),
    Foreign key(DEPTID) references DEPARTMENT(DEPTID)
);

Create Table REFERRALS(
    REFERRALID int Primary key Auto_Increment,
    PATIENTID int not null,
    FROMID int not null,
    TOID int not null, 
    REFERRALDATE DateTime not null, 
    REFERRALPRIORITY varchar(100) not null,
    REASON text not null,

    Foreign Key(PATIENTID) references PATIENT(PATIENTID),
    Foreign Key(FROMID) references PROVIDER_TABLE(PROVIDERID),
    FOREIGN KEY(TOID) references PROVIDER_TABLE(PROVIDERID)
);

Create Table WAITINGLIST(
    WAITINGLISTID int Primary Key Auto_increment, 
    PATIENTID int not null, 
    PROCEDUREID int not null, 
    PROVIDERID int not null, 
    DEPTID int not null,
    REFERRALID int not null, 
    ADDEDDATE DateTime not null,
    WLPRIORITY varchar(50) not null,

    Foreign Key (PATIENTID) references PATIENT(PATIENTID),
    Foreign Key (PROVIDERID) references PROVIDER_TABLE(PROVIDERID),
    Foreign Key (REFERRALID) references REFERRALS(REFERRALID),
    Foreign Key (DEPTID) references DEPARTMENT(DEPTID),
    Foreign Key (PROCEDUREID) references PROCEDURE_TABLE(PROCEDUREID)
);

Create Table FIRSTMINISTER(
    FIRSTMINISTERID int primary key auto_increment,
    PERSONID int not null,
    COUNTRYID int not null,
    
    Foreign Key (PERSONID) references PERSON(PERSONID),
    Foreign Key (COUNTRYID) references COUNTRY(COUNTRYID)
);

Create Table MINISTERSTATEMENT(
    STATEMENTID int Primary Key auto_increment,
    FIRSTMINISTERID int not null,
    STATEMENTDATE DateTime not null,
    CONTENT TEXT Not null,

    Foreign Key (FIRSTMINISTERID) References FIRSTMINISTER(FIRSTMINISTERID)
);

CREATE TABLE CONTACT(
    CONTACTID int Primary Key auto_increment,
    PERSONID int not null,
    CTYPE VARCHAR(50) not null,
    CONTACTDETAILS VARCHAR(255) not null,

    Foreign Key (PERSONID) References PERSON(PERSONID)
);

CREATE TABLE POPULATIONRECORD(
    POPULATIONRECORDID int Primary Key auto_increment,
    DISTRICTID int not null,
    YEARRECORDED date not null,
    COUNT int not null,
    AGEGROUP VARCHAR(50) not null,
    EMPLOYMENTSTATUS VARCHAR(50) not null,

    Foreign Key (DISTRICTID) References DISTRICT(DISTRICTID)
);


Insert into COUNTRY(COUNTRYID, COUNTRYNAME) VALUES
(1, 'England'),
(2, 'Wales'),
(3, 'Scotland'),
(4, 'Ireland'),
(5, 'Northern Ireland'),
(6, 'America'),
(7, 'Spain'),
(8, 'Bangladesh'),
(9, 'Bulgaria'),
(10, 'Kosovo');

Insert into COUNTY(COUNTRYID, COUNTYNAME) VALUES
(1, 'London'),
(1, 'Manchester'),
(1, 'West Midlands'),
(2, 'Cardiff'),
(3, 'Edinburgh'),
(6,'NYC'),
(4,'Belfast'),
(8,'Dhaka'),
(1, 'Leeds'),
(1,'NewCastle');

Insert into DISTRICT(COUNTYID, DISTRICTNAME) VALUES
(1, 'Westminister'),
(2, 'Camden'),
(3, 'Greenwich'),
(4, 'Leeds North'),
(5, 'East Birmingham'),
(6,'Belfast east'),
(7,'Swansea east'),
(8,'Bristol Central'),
(9, 'Glasgow East'),
(10,'NewCastle upon Tyne');

Insert into PERSON(NHSNUMBER, SECUREID, FIRSTNAME, LASTNAME, ADDRESSLINE1, ADDRESSLINE2, CITY, POSTCODE, COUNTRYID, DOB, SEX) VALUES
('1234567891', 'S001', 'Alice', 'Jones', '10 Downing st', NULL, 'London', 'SW1A1AA', 1, '2006-05-25', 'F'),
('1234567892', 'S002', 'Amy', 'Smith', '11 Downing st', NULL, 'London', 'SW1A1AB', 1, '2007-05-23', 'M'),
('1234567893', 'S003', 'Joanna', 'Smith', '12 Downing st', NULL, 'London', 'SW1A1AC', 1, '2008-05-23', 'M'),
('1234567894', 'S004', 'Genta', 'Smith', '13 Downing st', NULL, 'manchester', 'SW1A1AD', 1, '2009-05-23', 'F'),
('1234567895', 'S005', 'Fariha', 'Smith', '14 Downing st', NULL, 'Leeds', 'SW1A1AE',1, '2010-05-23', 'M'),
('1234567896','S006', 'Zaynab', 'Smith', '15 Downing st', NULL, 'Leeds', 'SW1A1F', 1, '2017-05-23', 'F'),
('1234567897', 'S007', 'Ishaan', 'Smith', '16 Downing st', NULL, 'manchester', 'SW1A1AG', 1, '2018-05-23', 'M'),
('1234567898','S008', 'Assia', 'Smith', '17 Downing st', NULL, 'Leceister', 'SW1A1AH', 1, '2027-05-23', 'M'),
('1234567899', 'S009', 'Tahira', 'Smith', '18 Downing st', NULL, 'Leceister', 'SW1A1AI', 1, '237-05-23', 'F'),
('1234567890', 'S010', 'Aneesa', 'Smith', '19 Downing st', NULL, 'Leceister', 'SW1A1J', 1, '2067-05-23', 'M');

Insert Into ROLE_TABLE(ROLENAME, PERMISSIONS) VALUES
('ADMIN', 'ALL'),
('DR', 'READ, WRITE, UPDATE'),
('NURSE', 'READ, WRITE'),
('RECEPTIONIST', 'READ, WRITE'),
('PATIENT', 'READ'),
('ADMIN', 'ALL'),
('Radiologist', 'Read, write'),
('Surgeon', 'Update'),
('Surgeon2', 'Update, read, write'),
('Surgeon3', 'Update, read');

Insert into PROCEDURE_TABLE(PROCEDUREID, PROCEDURENAME, DESCRIPTION_TEXT, CATERGORY, SCHEDULED) VALUES
(1, 'Chemo', 'Cancer Treatment', 'Oncology', '2006-12-02 10:00:00'),
(2, 'Chemo', 'X-Ray', 'Vaccination', '2006-12-03 10:00:00'),
(3, 'neurology', 'EEG', 'Brain activity scan', '2025-12-03 12:00:00'),
(4, 'Gallbladder', 'EEG', 'Brain activity scan', '2024-12-03 13:00:00'),
(5, 'Biopsy', 'scan', 'emergency', '2023-12-04 14:00:00'),
(6, 'Surgery', 'EEG', 'neurology', '2022-12-05 15:00:00'),
(7, 'Knee surgery', 'EEG', 'Brain activity scan', '2021-12-06 16:00:00'),
(8, 'Vaccination', 'scan', 'replacement', '2020-12-07 17:00:00'),
(9, 'Vaccination', 'flu', 'Brain activity scan', '2019-12-08 18:00:00'),
(10, 'Vaccination', 'scan', 'emergency', '2018-12-09 19:00:00');

Insert into PROVIDER_TABLE(PROVIDERID, DISTRICTID, PROVIDERNAME, ADDRESSLINE1, ADDRESSLINE2, CITY, POSTCODE, COUNTRY, PHONENUMBER, EMAIL, ClinicType) VALUES
(1, 1, 'Central Hospital', '1 Main St', NULL, 'London', 'SW1A 1AA', 'UK', '+441234567890', 'central@nhs.uk', 'Hospital'),
(2, 2, 'Westside Clinic', '20 West Rd', NULL, 'Manchester', 'M1 2AB', 'UK', '+441122334455', 'westside@nhs.uk', 'Clinic'),
(3, 3, 'South Medical Centre', '5 South St', NULL, 'Bristol', 'BS1 4ST', 'UK', '+441112223334', 'southmed@nhs.uk', 'Clinic'),
(4, 4, 'North Hospital', '12 North Ave', NULL, 'Leeds', 'LS1 1AB', 'UK', '+441113334455', 'north@nhs.uk', 'Hospital'),
(5, 5, 'Eastside Clinic', '8 East St', NULL, 'Birmingham', 'B1 2XY', 'UK', '+441115556677', 'eastside@nhs.uk', 'Clinic'),
(6, 6, 'City Hospital', '30 Market St', NULL, 'Cardiff', 'CF10 1AA', 'UK', '+441116667788', 'city@nhs.uk', 'Hospital'),
(7, 7, 'Green Clinic', '25 Green Rd', NULL, 'Glasgow', 'G1 3ZX', 'UK', '+441117778899', 'green@nhs.uk', 'Clinic'),
(8, 8, 'Royal Hospital', '18 King St', NULL, 'Liverpool', 'L1 8JQ', 'UK', '+441118889900', 'royal@nhs.uk', 'Hospital'),
(9, 9, 'Central Clinic', '40 Queen Rd', NULL, 'Leicester', 'LE1 4AB', 'UK', '+441119990011', 'centralclinic@nhs.uk', 'Clinic'),
(10, 10, 'Northside Hospital', '15 Park St', NULL, 'Leeds', 'LS2 2CD', 'UK', '+441110011223', 'northside@nhs.uk', 'Hospital');

Insert into DEPARTMENT(DEPTID, DEPTNAME, PROVIDERID) VALUES
(1, 'Cardiology', 1),
(2, 'Neurology', 2),
(3, 'Oncology', 3),
(4, 'Pediatrics', 4),
(5, 'Orthopedics', 5),
(6, 'Emergency', 6),
(7, 'Radiology', 7),
(8, 'Surgery', 8),
(9, 'Dermatology', 9),
(10, 'Gynecology', 10);

Insert into PATIENT(PATIENTID, PERSONID, PROVIDERID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

Insert into STAFF( ROLEID, PERSONID, PROVIDERID) VALUES
(2, 1, 1),
(3, 2, 2),
(4, 3, 3),
(2, 4, 4),
(3, 5, 5),
(4, 6, 6),
(2, 7, 7),
(3, 8, 8),
(4, 9, 9),
(2, 10, 10);

Insert into USER_TABLE(USERID, PERSONID, USERNAME, PASSWORDHASH, ROLEID, PROVIDERID) VALUES
(1, 1, 'alicej', 'hash1', 5, 1),
(2, 2, 'amys', 'hash2', 5, 2),
(3, 3, 'joannas', 'hash3', 5, 3),
(4, 4, 'gentas', 'hash4', 5, 4),
(5, 5, 'farihahs', 'hash5', 5, 5),
(6, 6, 'zaynabs', 'hash6', 5, 6),
(7, 7, 'ishaanS', 'hash7', 5, 7),
(8, 8, 'assias', 'hash8', 5, 8),
(9, 9, 'tahiras', 'hash9', 5, 9),
(10, 10, 'aneesas', 'hash10', 5, 10);

Insert into ADMISSIONS(ADMISSIONID, PATIENTID, PROVIDERID, DEPTID, ADMISSIONDATE, DISCHARGEDATE, ADMISSIONTYPE) VALUES
(1, 1, 1, 1, '2023-01-15 10:00:00', '2023-01-20 14:00:00', 'Emergency'),
(2, 2, 2, 2, '2023-02-10 09:30:00', '2023-02-15 11:00:00', 'Elective'),
(3, 3, 3, 3, '2023-03-05 08:45:00', '2023-03-10 13:30:00', 'Emergency'),
(4, 4, 4, 4, '2023-04-12 12:15:00', '2023-04-18 16:45:00', 'Elective'),
(5, 5, 5, 5, '2023-05-20 14:00:00', '2023-05-25 10:30:00', 'Emergency'),
(6, 6, 6, 6, '2023-06-18 11:30:00', '2023-06-22 15:15:00', 'Elective'),
(7, 7, 7, 7, '2023-07-22 13:45:00', '2023-07-27 09:00:00', 'Emergency'),
(8, 8, 8, 8, '2023-08-30 10:15:00', '2023-09-04 14:30:00', 'Elective'),
(9, 9, 9, 9, '2023-09-14 09:00:00', '2023-09-19 12:45:00', 'Emergency'),
(10, 10, 10, 10, '2023-10-01 15:30:00', '2023-10-06 11:15:00', 'Elective');

INSERT INTO REFERRALS (REFERRALID, PATIENTID, FROMID, TOID, REFERRALDATE, REFERRALPRIORITY, REASON) VALUES
(1, 1, 1, 1, '2015-10-02', 'High', 'Consultation'),
(2, 2, 2, 2, '2015-11-02', 'Low', 'Follow-up'),
(3, 3, 3, 3, '2015-09-04', 'High', 'Routine check'),
(4, 4, 4, 4, '2015-10-24', 'Medium', 'Follow-up'),
(5, 5, 5, 5, '2015-12-30', 'High', 'Consultation'),
(6, 6, 6, 6, '2015-10-08', 'Low', 'Consultation'),
(7, 7, 7, 7, '2015-11-15', 'Medium', 'Consultation'),
(8, 8, 8, 8, '2015-10-13', 'High', 'Follow-up'),
(9, 9, 9, 9, '2015-08-03', 'High', 'Routine check'),
(10, 10, 10, 10, '2015-10-01', 'High', 'Consultation');

Insert into WAITINGLIST (WAITINGLISTID, PATIENTID, PROCEDUREID, PROVIDERID, DEPTID, REFERRALID, ADDEDDATE, WLPRIORITY) VALUES
(1,1,1,1,1,1,'2010-01-10 11:00:00', 'HIGH'),
(2,2,2,2,2,2,'2011-02-10 12:00:00', 'MEDIUM'),
(3,3,3,3,3,3,'2012-10-10 13:00:00', 'LOW'),
(4,4,4,4,4,4,'2013-03-10 14:00:00', 'HIGH'),
(5,5,5,5,5,5,'2014-04-10 15:00:00', 'MEDIUM'),
(6,6,6,6,6,6,'2015-05-10 16:00:00', 'LOW'),
(7,7,7,7,7,7,'2016-06-10 17:00:00', 'HIGH'),
(8,8,8,8,8,8,'2017-07-10 18:00:00', 'MEDIUM'),
(9,9,9,9,9,9,'2018-08-10 19:00:00', 'LOW'),
(10,10,10,10,10,10,'2019-09-10 20:00:00', 'HIGH');

Insert into FIRSTMINISTER(FIRSTMINISTERID, PERSONID, COUNTRYID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 1),
(7, 7, 2),
(8, 8, 3),
(9, 9, 4),
(10,10, 5);

Insert into MINISTERSTATEMENT(STATEMENTID, FIRSTMINISTERID, STATEMENTDATE, CONTENT) VALUES
(1,1, '2023-01-10 10:00:00', 'Healthcare improvements underway.'),
(2,2, '2024-01-10 11:00:00', 'More funds'),
(3,3, '2025-01-10 11:00:00', 'New policies'),
(4,4, '2020-01-10 11:00:00', 'More vaccines'),
(5,5, '2019-01-10 11:00:00', 'Old people care'),
(6,6, '2018-01-10 11:00:00', 'Pre natal care'),
(7,7, '2017-01-10 11:00:00', 'Mental health support'),
(8,8, '2016-01-10 11:00:00', 'Screening progress'),
(9,9, '2015-01-10 11:00:00', 'Policy update'),
(10,10, '2014-01-10 11:00:00', 'More funds allocated');

Insert into CONTACT(CONTACTID, PERSONID, CTYPE, CONTACTDETAILS) VALUES
(1,1,'Email', 'fariha@email.com'),
(2,2,'phone', '+1234556788'),
(3,3,'Email', 'genta@email.com'),
(4,4,'phone', '+123455678664'),
(5,5,'Email', 'joanna@email.com'),
(6,6,'Phone', '+123455672344'),
(7,7,'Email', 'zaynab@email.com'),
(8,8,'phone', '+1234556784262'),
(9,9,'Phone', '+1234556345566'),
(10,10,'Phone', '+123455234479');

Insert into POPULATIONRECORD(POPULATIONRECORDID, DISTRICTID, YEARRECORDED, COUNT, AGEGROUP, EMPLOYMENTSTATUS) VALUES
(1,1, '2020-01-01', 50000, '0-18', 'Employed'),
(2,2, '2025-01-03', 66888, '19-35', 'Unemployed'),
(3,3, '2026-01-04', 7698, '36-50', 'Employed'),
(4,4, '2027-01-05', 68779, '51-65', 'Retired'),
(5,5, '2028-01-06', 68645, '66+', 'Retired'),
(6,6, '2067-01-07', 356576, '0-18', 'Employed'),
(7,7, '2098-01-08', 656766, '19-35', 'Unemployed'),
(8,8, '2023-01-09', 35467, '36-50', 'Employed'),
(9,9, '2012-01-10', 7987787, '51-65', 'Retired'),
(10,10, '2019-01-11', 345677, '66+', 'Retired');


--Part 2: Basic queries. 
--using dates, joins or functions
--Example: customers who booked a room whose price is greater than 200. [2 MARKS]

-- 1) Shows all staff memebers with their provider and role name
SELECT s.STAFFID, per.FIRSTNAME AS StaffName, per.LASTNAME AS StaffSurname, pr.PROVIDERNAME, r.ROLENAME FROM STAFF s 
JOIN PERSON per ON s.PERSONID = per.PERSONID 
JOIN PROVIDER_TABLE pr ON s.PROVIDERID = pr.PROVIDERID 
JOIN ROLE_TABLE r ON s.ROLEID = r.ROLEID;

-- 2) List of patients admitted after April 1st, 2023
SELECT pr.PROVIDERNAME, per.FIRSTNAME, per.LASTNAME, a.ADMISSIONDATE, a.DISCHARGEDATE FROM ADMISSIONS a 
JOIN PATIENT pa ON a.PATIENTID = pa.PATIENTID 
JOIN PERSON per ON pa.PERSONID = per.PERSONID 
JOIN PROVIDER_TABLE pr ON a.PROVIDERID = pr.PROVIDERID 
WHERE a.ADMISSIONDATE > '2023-04-01';

--Part 3: Medium queries. 
--Write 3 medium queries using group-by and complex joins 
--(self-joins, outer joins). 
--Example: customers who booked a comfort room and a luxury room,
--all rooms with the customers who booked them including the rooms no customer has booked. [3 MARKS]

-- 1) Count how many patients each provider is resposible for
SELECT pr.PROVIDERNAME, COUNT(pa.PATIENTID) AS totalPatients FROM PROVIDER_TABLE pr 
LEFT JOIN PATIENT pa ON pr.PROVIDERID = pa.PROVIDERID 
GROUP BY pr.PROVIDERID;

--2) Total population per district  (grouped by district name)
SELECT d.DISTRICTNAME, SUM(pr.COUNT) AS TOTAL_POPULATION FROM DISTRICT d 
JOIN POPULATIONRECORD pr ON d.DISTRICTID = pr.DISTRICTID 
GROUP BY d.DISTRICTNAME;

-- 3) Average number of admissions per department
SELECT dept.DEPTNAME, COUNT(a.ADMISSIONID) / COUNT(a. DEPTID) AS AVG_ADMISSIONS FROM DEPARTMENT dept 
JOIN ADMISSIONS a ON dept.DEPTID = a.DEPTID 
GROUP BY dept.DEPTNAME;


-- Part 4: Advanced queries. 
--Write 3 
-- advanced queries (nested queries, set-based conditions or aggregations)
--Example: show customers who booked more rooms than the average customer 
--(i.e. the average number of rooms), all customers who booked mostly luxury rooms 
--(e.g. more than 90% of the bookings were for luxury rooms). [6 MARKS]

-- 1) Finds all patients with High Waiting list priority with the referral reason
SELECT p.PATIENTID, pe.FIRSTNAME, pe.LASTNAME, w.WLPRIORITY, r.REASON AS ReferralReason FROM PATIENT p 
JOIN PERSON pe ON p.PERSONID = pe.PERSONID 
JOIN WAITINGLIST w ON p.PATIENTID = w.PATIENTID 
JOIN REFERRALS r ON w.REFERRALID = r.REFERRALID 
WHERE w.PATIENTID IN (
    SELECT w.PATIENTID FROM WAITINGLIST WHERE WLPRIORITY = 'HIGH'
);
-- 2) Count the number of patients per country
SELECT c.COUNTRYNAME, 
(
    SELECT COUNT(*) FROM PATIENT p 
    JOIN PERSON pe ON p.PERSONID = pe.PERSONID
    WHERE pe.COUNTRYID = c.COUNTRYID
) AS totalPatients
FROM COUNTRY c 
ORDER BY totalPatients DESC;

-- 3) Counts how many EEGS procedures are scheduled per provider with the patients 
SELECT pe.FIRSTNAME, pe.LASTNAME, pr.PROCEDURENAME, pt.PROVIDERNAME, COUNT(pr.PROCEDUREID) AS EEG_COUNT FROM PERSON pe
JOIN PATIENT p ON pe.PERSONID = p.PERSONID
JOIN WAITINGLIST w ON p.PATIENTID = w.PATIENTID 
JOIN PROCEDURE_TABLE pr ON w.PROCEDUREID = pr.PROCEDUREID 
JOIN PROVIDER_TABLE pt ON w.PROVIDERID = pt.PROVIDERID 
WHERE pr.DESCRIPTION_TEXT LIKE '%EEG%' 
GROUP BY pe.PERSONID, pe.FIRSTNAME, pe.LASTNAME, pr.PROCEDURENAME, pt.PROVIDERNAME
ORDER BY EEG_COUNT DESC;