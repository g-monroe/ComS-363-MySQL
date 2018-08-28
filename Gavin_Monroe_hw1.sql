/*Batch file by Gavin Monroe
--Known Problems 1175 Access denied. Every command tested and passed.*/

/*I forgot to copy the commands 1-12 so if they are different I just copied DDL commands*/

/*--Item1:*/
create table Person (Name char (20),ID char (9) not null,Address char (30),DOB date,Primary key (ID))

/*--Item2:*/
CREATE TABLE `Instructor` (
  `InstructorID` char(9) NOT NULL,
  `Rank` char(12) DEFAULT NULL,
  `Salary` int(11) DEFAULT NULL,
  PRIMARY KEY (`InstructorID`)
);

/*--Item3:*/
CREATE TABLE `Student` (
  `StudentID` char(9) NOT NULL,
  `Classification` char(10) DEFAULT NULL,
  `GPA` double DEFAULT NULL,
  `MentorID` char(9) DEFAULT NULL,
  `CreditHours` int(11) DEFAULT NULL,
  PRIMARY KEY (`StudentID`),
  KEY `MentorID` (`MentorID`),
  CONSTRAINT `Student_ibfk_1` FOREIGN KEY (`MentorID`) REFERENCES `Instructor` (`InstructorID`)
);

/*--Item4:*/
CREATE TABLE `Course` (
  `CourseCode` char(6) NOT NULL,
  `CourseName` char(50) DEFAULT NULL,
  `PreReq` char(6) DEFAULT NULL
);

/*--Item5:*/
CREATE TABLE `Offering` (
  `CourseCode` char(6) NOT NULL,
  `SectionNo` int(11) NOT NULL,
  `InstructorID` char(9) DEFAULT NULL,
  PRIMARY KEY (`CourseCode`,`SectionNo`),
  KEY `InstructorID` (`InstructorID`),
  CONSTRAINT `Offering_ibfk_1` FOREIGN KEY (`InstructorID`) REFERENCES `Instructor` (`InstructorID`)
);

/*--Item6:*/
create table Enrollment (CourseCode char(6) NOT NULL, SectionNo int NOT NULL, StudentID char(9) NOT NULL references Student, Grade char(4) NOT NULL, primary key (CourseCode, StudentID), foreign key (CourseCode, SectionNo) references Offering(CourseCode, SectionNo));

/*--Item7:*/
load xml local infile 'C:/MyFolder/Person.xml' 
into table Person 
rows identified by '<Person>';

/*--Item8:*/
load xml local infile 'C:/MyFolder/Enrollment.xml' 
into table Enrollment
rows identified by '<Enrollment>';

/*--Item9:*/
load xml local infile 'C:/MyFolder/Offering.xml' 
into table Offering
rows identified by '<Offering>';

/*--Item10:*/
load xml local infile 'C:/MyFolder/Instructor.xml' 
into table Instructor
rows identified by '<Instructor>';

/*--Item11:*/
load xml local infile 'C:/MyFolder/Course.xml' 
into table Course
rows identified by '<Course>';

/*--Item12:*/
load xml local infile 'C:/MyFolder/Student.xml' 
into table Student
rows identified by '<Student>';

/*--Item13:*/
SELECT s.StudentID, s.MentorID
FROM Student s
WHERE s.Classification="junior" OR s.Classification="senior"
AND s.GPA > 3.8;






 


/*--Item14:*/
SELECT DISTINCT o.CourseCode, o.SectionNo
FROM Offering o, Student s
WHERE s.Classification="sophomore"
AND s.MentorID = o.InstructorID;

/*--Item15:*/
SELECT i.Salary, p.Name
FROM Instructor i, Student s, Person p
WHERE s.Classification="freshmen"
AND p.ID = i.InstructorID
AND s.MentorID = i.InstructorID;

/*--Item16:*/
SELECT sum(i.Salary)
FROM Instructor i, Offering o
WHERE 0 = (i.InstructorID != o.InstructorID);

/*--Item17:*/
SELECT p.DOB
FROM Student s, Person p
WHERE Year(p.DOB) = 1976;

/*--Item18:*/
SELECT p.Name, i.Rank
FROM  Person p, Instructor i
INNER JOIN Offering as o
ON o.InstructorID != i.InstructorID
INNER JOIN Student as s
ON s.MentorID != i.InstructorID
GROUP BY p.Name;

/*--Item19:*/
SELECT max(p.DOB), p.Name, p.ID
FROM Person p, Student s
WHERE s.StudentID = p.ID;

/*--Item20:*/
SELECT p.Name, p.ID, p.DOB
FROM  Instructor i
INNER JOIN Person as p
ON p.ID != i.InstructorID
INNER JOIN Student as s
ON s.MentorID != i.InstructorID
GROUP BY p.Name;


/*--Item21:*/
SELECT p.Name, count(*) totalCount
FROM  Instructor i
INNER JOIN Person as p
ON p.ID = i.InstructorID
INNER JOIN Student as s
ON s.MentorID = i.InstructorID
GROUP BY p.Name;


/*--Item22:*/
SELECT s.Classification, avg(s.GPA), Count(*)
FROM Student s
GROUP BY s.Classification;

/*--Item23:*/
SELECT COUNT(e.studentid) AS lowest_nonzero_count 
FROM Enrollment e
GROUP BY e.CourseCode
order by 1
limit 1


/*--Item24:*/
SELECT s.StudentID, o.InstructorID
FROM  Offering o
INNER JOIN Student as s
ON s.MentorID = o.InstructorID
GROUP BY s.StudentID;

/*--Item25:*/
SELECT s.StudentID, p.Name, s.CreditHours
FROM  Person p, Student s
WHERE p.ID = s.StudentID 
AND s.Classification="freshman"
AND Year(p.DOB) >= 1976;

/*--Item26:*/
INSERT INTO Student (StudentID, Classification, GPA, MentorID, CreditHours)
VALUES (480293439, "junior", 3.48, 201586985, 75);
INSERT INTO Person (Name, ID, Address, DOB)
VALUES ("Briggs Jason", 480293439, "215 North Hyland Avenue", '1975-01-15');INSERT INTO Enrollment (CourseCode, SectionNo, StudentID, Grade)
VALUES ("CS311", 2, 480293439, "A");
INSERT INTO Enrollment (CourseCode, SectionNo, StudentID, Grade)
VALUES ("CS330", 1, 480293439, "A-");

/*--Item27:*/
DELETE e
FROM Enrollment e, Student s
WHERE e.StudentID = s.StudentID AND s.GPA < 0.5;
DELETE s
FROM Student s
WHERE s.GPA < 0.5;


/*--Item28:*/
UPDATE Instructor
SET Salary = Salary * 1.1
Where InstructorID In (Select p.ID
From Person p
Where p.Name = "Ricky Ponting") AND 5 <= (Select COUNT(*)
From Enrollment e
WHERE e.CourseCode = (Select o.CourseCode
From Offering o
Where o.InstructorID = (Select p.ID
From Person p
Where p.Name = "Ricky Ponting") AND e.Grade = "A" LIMIT 1))

/*--Item29:*/
INSERT INTO Person (Name, ID, Address, DOB)
VALUES ("Trevor Horns", 000957303, "23 Canberra Street", '1964-11-23');

/*--Item30:*/
DELETE FROM Student WHERE StudentID IN (SELECT p.ID FROM Person p WHERE p.Name = "Jan Austin");
DELETE FROM Enrollment WHERE StudentID IN (SELECT p.ID FROM Person p WHERE p.Name = "Jan Austin");