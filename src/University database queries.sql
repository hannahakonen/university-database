INSERT INTO Courses
VALUES("MUO-E8005", "Sustainable Product and Service Design", 4);

INSERT INTO CourseInstances
VALUES((SELECT MAX(instanceID) FROM CourseInstances)+1, "2021-01-08", "2021-03-16", "MUO-E8005");

SELECT MAX(ID)
FROM Students;

INSERT INTO Students
VALUES("987203", "Pilli Piipari", "2000-10-20", "TIK", 2020, "2024-08-30");

INSERT INTO Buildings
VALUES("Väre", "Otaniementie 14");

INSERT INTO Rooms
VALUES("Väre", "A123", 76, 13);

SELECT buildingName, name
FROM Rooms
WHERE seats>=50 AND seats<=100
     EXCEPT
SELECT buildingName, roomName 
FROM Reservations
WHERE date="2021-01-08" AND ((startTime<="12:15:00.0" AND endTime>="12:15:00.0") OR (startTime<="14:00:00.0" AND endTime>="14:00:00.0"));

SELECT MAX(ID) 
FROM Reservations;

INSERT INTO Reservations
VALUES(67892, "2021-01-08", "12:15:00.0", "14:00:00.0", "A123", "Väre", "Lecture");

INSERT INTO Lectures
VALUES(6680, "2021-01-08", "12:15:00.0", "14:00:00.0", 67892);

SELECT MAX(groupNo)
FROM ExerciseGroups
WHERE instanceID=6680;

INSERT INTO ExerciseGroups
VALUES(6680, 1, 3, 15);

SELECT buildingName, name
FROM Rooms
WHERE seats>=50 AND seats<=100
     EXCEPT
SELECT buildingName, roomName 
FROM Reservations
WHERE date="2021-01-10" AND ((startTime<="12:15:00.0" AND endTime>="12:15:00.0") OR (startTime<="14:00:00.0" AND endTime>="14:00:00.0"));

SELECT MAX(ID) 
FROM Reservations;

INSERT INTO Reservations
VALUES(67893, "2021-01-10", "12:15:00.0", "14:00:00.0", "A123", "Väre", "Exercise group meeting");

INSERT INTO ExerciseGroupMeetings
VALUES(6680, 1, "2021-01-10", "12:15:00.0", "14:00:00.0", 67893);

UPDATE ExerciseGroups
SET noParticipants=(SELECT noParticipants FROM ExerciseGroups WHERE groupNo=1 AND instanceID=6680)+1
WHERE groupNo=1 AND instanceID=6680;

INSERT INTO SelectedBy
VALUES(1, 6680, "987203");

INSERT INTO Exams
VALUES("MUO-E8005", "2020-12-16", "12:15:00.0", "16:00:00.0");

SELECT buildingName, name
FROM Rooms
WHERE examseats>=25
        EXCEPT
SELECT buildingName, roomName 
FROM Reservations
WHERE date="2020-12-16" AND ((startTime<="12:00:00.0" AND endTime>="12:00:00.0") OR (startTime<="16:15:00.0" AND endTime>="16:15:00.0"))
        UNION
SELECT R.buildingName, R.name
FROM Reservations AS RES, EnrolledBy AS E, Rooms AS R, HasExamReservation AS H
WHERE RES.date="2020-12-16" AND RES.date=H.date AND H.date=E.examDate AND RES.roomName=R.name AND RES.buildingName=R.buildingName AND H.courseCode=E.courseCode AND startTime="12:00:00.0" AND endTime<="16:15:00.0" AND RES.ID=H.reservationID
GROUP BY R.Name, R.buildingName
HAVING COUNT(studentID)<=examSeats-25;
 
INSERT INTO Reservations
VALUES(22222, "2020-12-16", "12:00:00.0", "16:15:00.0", "A-sali", "Kandidaattikeskus", "Exam");

INSERT INTO HasExamReservation
VALUES("MUO-E8005", "2020-12-16", 22222);

INSERT INTO EnrolledBy
VALUES("2020-12-16", "MUO-E8005", "987203");

SELECT code, name, groupNo
FROM Courses AS C, ExerciseGroupMeetings AS E, Reservations AS R, CourseInstances AS CI
WHERE reservationID=ID AND roomName="AS5" AND buildingName="TUAS-talo" AND R.date="2019-09-10" AND E.startTime<="13:00:00.0" AND E.endTime>="13:00:00.0" AND E.instanceID=CI.instanceID AND C.code=CI.courseCode;

SELECT code, name
FROM Courses
WHERE code IN
    (SELECT courseCode
     FROM CourseInstances
     WHERE startDate > "2020-08-01" AND endDate < "2020-12-31");

SELECT DISTINCT name, date
FROM Courses AS C, Exams AS E
WHERE C.code="CS-A1120" AND E.courseCode="CS-A1120" AND date>="2020-08-30" AND date<="2020-12-31";

SELECT startDate, endDate
FROM Courses AS C, CourseInstances AS CI
WHERE C.code=CI.courseCode AND name="Databases" AND C.code="CSE-A1200";

SELECT date, L.startTime, L.endTime
FROM Lectures AS L, CourseInstances AS CI
WHERE CI.startDate="2020-09-01" AND CI.endDate="2020-12-16" AND CI.instanceID=L.instanceID AND courseCode="CSE-A1200";

SELECT groupNo
FROM ExerciseGroups AS E, CourseInstances AS CI
WHERE CI.startDate="2020-09-01" AND CI.endDate="2020-12-16" AND CI.instanceID=E.instanceID AND courseCode="CSE-A1200";

SELECT groupNo
FROM ExerciseGroups AS E, CourseInstances AS CI
WHERE CI.startDate="2020-09-01" AND CI.endDate="2020-12-16" AND CI.instanceID=E.instanceID AND courseCode="CSE-A1200" AND noParticipants<maxParticipants;

SELECT R.date, R.startTime, R.endTime, R.buildingName, R.roomName
FROM ExerciseGroupMeetings AS E, CourseInstances AS CI, Reservations AS R
WHERE CI.startDate="2020-09-01" AND CI.endDate="2020-12-16" AND CI.instanceID=E.instanceID AND courseCode="CSE-A1200" AND groupNo=1 AND E.reservationID=R.ID;

SELECT buildingName, name
FROM Rooms
WHERE seats>50
     EXCEPT
SELECT buildingName, roomName 
FROM Reservations
WHERE date="2020-09-01" AND ((startTime<="12:15:00.0" AND endTime>="12:15:00.0") OR (startTime<="14:00:00.0" AND endTime>="14:00:00.0"));

SELECT DISTINCT type
FROM Reservations
WHERE roomName="A-sali" AND buildingName="Kandidaattikeskus" AND date="2020-12-16" AND ((startTime<="12:15:00.0" AND endTime>="12:15:00.0") OR (startTime<="16:00:00.0" AND endTime>="16:00:00.0"));

SELECT studentID, name
FROM SelectedBy, Students
WHERE instanceID=6679 AND studentID=ID;

SELECT studentID, name
FROM SelectedBy, Students
WHERE instanceID=6679 AND groupNo=1 AND studentID=ID;

SELECT studentID, name
FROM EnrolledBy, Students
WHERE studentID=ID AND courseCode="CSE-A1200"AND examDate="2020-12-16";

SELECT groupNo
FROM CourseInstances AS C, ExerciseGroups AS E
WHERE C.instanceID=E.instanceID AND startDate>"2020-08-01" AND endDate<"2020-12-31" AND courseCode="CS-A1120" AND noParticipants<maxParticipants;

SELECT ID, type
FROM Equipments
WHERE ID IN
    (SELECT equipmentID
     FROM OwnedBy
     WHERE roomName="A-sali"
     );


