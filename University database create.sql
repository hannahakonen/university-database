CREATE TABLE Students(
        ID TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        birthdate TEXT NOT NULL,
        program TEXT NOT NULL, 
        startYear INTEGER NOT NULL, 
        expStudyRight TEXT NOT NULL
);

CREATE TABLE Courses(
        code TEXT PRIMARY KEY NOT NULL, 
        name TEXT NOT NULL, 
        credits REAL 
);

CREATE TABLE CourseInstances(
        instanceID INTEGER PRIMARY KEY NOT NULL, 
        startDate TEXT NOT NULL, 
        endDate TEXT NOT NULL, 
        courseCode TEXT NOT NULL,
        FOREIGN KEY (courseCode) REFERENCES Courses(code)
            ON DELETE SET NULL 
            ON UPDATE CASCADE
);  

CREATE TABLE Buildings(
        name TEXT PRIMARY KEY NOT NULL, 
        address TEXT DEFAULT "?"
);

CREATE TABLE Rooms(
        buildingName TEXT, 
        name TEXT NOT NULL, 
        seats INTEGER NOT NULL, 
        examSeats INTEGER NOT NULL,
        PRIMARY KEY (buildingName, name)
        FOREIGN KEY (buildingName) REFERENCES Buildings(name)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
);

CREATE TABLE Reservations(
        ID INTEGER PRIMARY KEY NOT NULL, 
        date TEXT NOT NULL, 
        startTime TEXT NOT NULL, 
        endTime TEXT NOT NULL, 
        roomName TEXT, 
        buildingName TEXT,
        type TEXT NOT NULL,
        FOREIGN KEY (buildingName, roomName) REFERENCES Rooms(buildingName, name)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
);

CREATE TABLE Lectures(
        instanceID INTEGER,
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        reservationID INTEGER,
        PRIMARY KEY (instanceID, date)
        FOREIGN KEY (instanceID) REFERENCES CourseInstances(instanceID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
        FOREIGN KEY (reservationID) REFERENCES Reservations(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE  
); 

CREATE TABLE ExerciseGroups(
        instanceID INTEGER, 
        groupNo INTEGER NOT NULL, 
        noParticipants INTEGER DEFAULT 0  CHECK (noParticipants <= maxParticipants) NOT NULL, 
        maxParticipants INTEGER NOT NULL,
        PRIMARY KEY (instanceID, groupNo)
        FOREIGN KEY (instanceID) REFERENCES CourseInstances(instanceID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
);

CREATE TABLE ExerciseGroupMeetings(
        instanceID INTEGER, 
        groupNo INTEGER, 
        date TEXT NOT NULL, 
        startTime TEXT NOT NULL, 
        endTime TEXT NOT NULL, 
        reservationID INTEGER,
        PRIMARY KEY (instanceID, groupNo, date)
        FOREIGN KEY (instanceID, groupNo) REFERENCES ExerciseGroups(instanceID, groupNo)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
        FOREIGN KEY (reservationID) REFERENCES Reservations(ID) 
                ON DELETE SET NULL 
                ON UPDATE CASCADE
); 

CREATE TABLE Exams(
        courseCode TEXT, 
        date TEXT NOT NULL, 
        startTime TEXT NOT NULL, 
        endTime TEXT NOT NULL,
        PRIMARY KEY (courseCode, date)
        FOREIGN KEY (courseCode) REFERENCES Courses(code)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
); 

CREATE TABLE SelectedBy(
        groupNo INTEGER, 
        instanceID INTEGER, 
        studentID TEXT,
        PRIMARY KEY (groupNo, instanceID, studentID)
        FOREIGN KEY (groupNo, instanceID) REFERENCES ExerciseGroups(groupNo, instanceID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
        FOREIGN KEY (studentID) REFERENCES Students(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
); 

CREATE TABLE EnrolledBy(
        examDate TEXT, 
        courseCode TEXT, 
        studentID TEXT,
        PRIMARY KEY (examDate, courseCode, studentID)
        FOREIGN KEY (studentID) REFERENCES Students(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
        FOREIGN KEY (courseCode, examDate) REFERENCES Exams(courseCode, date)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
); 

CREATE TABLE HasExamReservation(
        courseCode TEXT, 
        date TEXT, 
        reservationID INTEGER,
        PRIMARY KEY (courseCode, date, reservationID)
        FOREIGN KEY (courseCode, date) REFERENCES Exams(courseCode, date)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
        FOREIGN KEY (reservationID) REFERENCES Reservations(ID) 
                ON DELETE SET NULL 
                ON UPDATE CASCADE
); 

CREATE TABLE Equipments(
        ID INTEGER PRIMARY KEY NOT NULL, 
        type TEXT NOT NULL, 
        model TEXT NOT NULL
); 

CREATE TABLE OwnedBy(
        equipmentID INTEGER PRIMARY KEY, 
        buildingName TEXT, 
        roomName TEXT,
        FOREIGN KEY (equipmentID) REFERENCES Equipments(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
        FOREIGN KEY (buildingName, roomName) REFERENCES Rooms(buildingName, name)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
);

CREATE TABLE Projectors(
        ID INTEGER PRIMARY KEY, 
        Description TEXT NOT NULL,
        FOREIGN KEY (ID) REFERENCES Equipments(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
);

CREATE TABLE Computers(
        ID INTEGER PRIMARY KEY, 
        user TEXT NOT NULL, 
        ram INTEGER NOT NULL, 
        speed REAL NOT NULL, 
        harddisk INTEGER NOT NULL,
        FOREIGN KEY (ID) REFERENCES Equipments(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE
);

CREATE TABLE Cameras(
        ID INTEGER PRIMARY KEY, 
        Description TEXT NOT NULL,
        FOREIGN KEY (ID) REFERENCES Equipments(ID)
                ON DELETE SET NULL 
                ON UPDATE CASCADE

);

CREATE VIEW ExamInstances AS
        SELECT R.buildingName, R.name, RES.date, RES.startTime, RES.endTime, COUNT(studentID)
        FROM Reservations AS RES, EnrolledBy AS E, Rooms AS R, HasExamReservation AS H
        WHERE RES.date=H.date AND H.date=E.examDate AND RES.roomName=R.name AND RES.buildingName=R.buildingName AND H.courseCode=E.courseCode AND RES.ID=H.reservationID
        GROUP BY R.Name, R.buildingName, RES.date, RES.startTime, RES.endTime;


CREATE VIEW GroupParticipantNo AS
        SELECT code, startDate, groupNo, COUNT(studentID)
        FROM ExerciseGroups AS E, SelectedBy AS S, Courses AS C, CourseInstances AS CI
        WHERE E.instanceID=S.instanceID AND S.instanceID=CI.instanceID AND C.code=CI.courseCode AND E.groupNo=S.groupNo
        GROUP BY code, startDate;

INSERT INTO Students
VALUES("112233", "Teemu Teekkari", "1985-11-17", "TIK", 2007, "2011-08-30");

INSERT INTO Students
VALUES("123456", "Tiina Teekkari", "2000-08-18", "TUTA", 2019, "2023-08-30");

INSERT INTO Students
VALUES("218311", "Kari Kemisti", "1995-05-06", "KEM", 2015, "2023-08-30");

INSERT INTO Students
VALUES("224411", "Maija Virtanen", "1999-03-17", "AUT", 2019, "2023-08-30");

INSERT INTO Students
VALUES("433511", "Maija Virtanen", "1997-01-03", "TUTA", 2016, "2024-08-30");

INSERT INTO Students
VALUES("512442", "Kalle Rantanen", "2000-08-19", "TIK", 2019, "2023-08-30");

INSERT INTO Students
VALUES("212434", "Pekka Lampinen", "1996-12-01", "BIZ", 2015, "2019-08-30");

INSERT INTO Students
VALUES("442255", "Teemu Teekkari", "1998-06-29", "TFM", 2018, "2026-08-30");

INSERT INTO Students
VALUES("565545", "Anne Korhonen", "2000-04-25", "AUT", 2019, "2023-08-30");

INSERT INTO Students
VALUES("441232", "Minna Kalaoja", "1995-11-04", "TIK", 2014, "2018-08-30");

INSERT INTO Students
VALUES("234155", "Mari Virtanen", "1997-10-12", "TFM", 2018, "2022-08-30");

INSERT INTO Students
VALUES("553311", "Ville Vallaton", "1993-09-28", "AUT", 2015, "2023-08-30");

INSERT INTO Students
VALUES("512434", "Pirjo Pirtea", "1997-02-06", "BIZ", 2018, "2022-08-30");

INSERT INTO Students
VALUES("987202", "Karri Lappinen", "1997-03-15", "TOK", 2019, "2027-08-30");

INSERT INTO Courses
VALUES("CS-A1150", "Databases", 5);

INSERT INTO Courses
VALUES("CS-A1120", "Programming 2", 5);

INSERT INTO Courses
VALUES("CSE-A1200", "Databases", 5);

INSERT INTO CourseInstances
VALUES(5347, "2019-09-01", "2019-12-16", "CSE-A1200");

INSERT INTO CourseInstances
VALUES(6679, "2020-09-01", "2020-12-16", "CSE-A1200");

INSERT INTO CourseInstances
VALUES(4567, "2018-09-01", "2018-12-16", "CSE-A1200");

INSERT INTO CourseInstances
VALUES(6398, "2020-09-01", "2020-10-26", "CS-A1150");

INSERT INTO CourseInstances
VALUES(5698, "2019-09-01", "2019-10-26", "CS-A1150");

INSERT INTO CourseInstances
VALUES(6267, "2020-10-28", "2020-12-16", "CS-A1120");

INSERT INTO Buildings
VALUES("Kandidaattikeskus", "Otakaari 1");

INSERT INTO Buildings
VALUES("TUAS-talo", "Maarintie 8");

INSERT INTO Rooms
VALUES("Kandidaattikeskus", "A-sali", 570, 95);

INSERT INTO Rooms
VALUES("Kandidaattikeskus", "B-sali", 320, 50);

INSERT INTO Rooms
VALUES("TUAS-talo", "AS1", 300, 50);

INSERT INTO Rooms
VALUES("TUAS-talo", "TU4", 15, 15);

INSERT INTO Rooms
VALUES("TUAS-talo", "AS5", 28, 28);

INSERT INTO Reservations
VALUES(65980, "2020-09-10", "12:15:00.0", "14:00:00.0", "AS5", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(65985, "2020-09-17", "12:15:00.0", "14:00:00.0", "AS5", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(65981, "2020-09-11", "12:15:00.0", "14:00:00.0", "AS5", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(55981, "2019-09-10", "12:15:00.0", "14:00:00.0", "AS5", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(45981, "2018-09-10", "12:15:00.0", "14:00:00.0", "AS5", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(67891, "2020-09-10", "12:15:00.0", "14:00:00.0", "TU4", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(55990, "2019-09-10", "12:15:00.0", "14:00:00.0", "TU4", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(65990, "2020-09-17", "12:15:00.0", "14:00:00.0", "TU4", "TUAS-talo", "Exercise group meeting");

INSERT INTO Reservations
VALUES(33333, "2019-09-10", "09:15:00.0", "11:00:00.0", "AS1", "TUAS-talo", "Exercise group meeting"); 

INSERT INTO Reservations
VALUES(65978, "2020-09-01", "12:15:00.0", "14:00:00.0", "A-sali", "Kandidaattikeskus", "Lecture");

INSERT INTO Reservations
VALUES(66778, "2020-09-01", "10:15:00.0", "12:00:00.0", "B-sali", "Kandidaattikeskus", "Lecture");

INSERT INTO Reservations
VALUES(66112, "2020-10-28", "12:15:00.0", "14:00:00.0", "B-sali", "Kandidaattikeskus", "Lecture"); 

INSERT INTO Reservations
VALUES(66677, "2020-10-26", "12:00:00.0", "14:15:00.0", "B-sali", "Kandidaattikeskus", "Exam");

INSERT INTO Reservations
VALUES(55443, "2019-10-26", "12:00:00.0", "14:15:00.0", "B-sali", "Kandidaattikeskus", "Exam");

INSERT INTO Reservations
VALUES(65432, "2020-12-16", "12:00:00.0", "16:15:00.0", "A-sali", "Kandidaattikeskus", "Exam");

INSERT INTO Reservations
VALUES(54321, "2019-12-16", "12:00:00.0", "16:15:00.0", "A-sali", "Kandidaattikeskus", "Exam");

INSERT INTO Reservations
VALUES(66998, "2020-12-16", "12:00:00.0", "16:15:00.0", "A-sali", "Kandidaattikeskus", "Exam");

INSERT INTO Reservations
VALUES(44444, "2018-12-16", "12:00:00.0", "16:15:00.0", "A-sali", "Kandidaattikeskus", "Exam");

INSERT INTO Lectures
VALUES(6679, "2020-09-01", "12:15:00.0", "14:00:00.0", 65978);

INSERT INTO Lectures
VALUES(6398, "2020-09-01", "12:15:00.0", "14:00:00.0", 66778);

INSERT INTO Lectures
VALUES(6267, "2020-10-28", "12:15:00.0", "14:00:00.0", 66112);

INSERT INTO ExerciseGroups
VALUES(6679, 1, 3, 28);

INSERT INTO ExerciseGroups
VALUES(6679, 2, 2, 28);

INSERT INTO ExerciseGroups
VALUES(5347, 1, 28, 28);

INSERT INTO ExerciseGroups
VALUES(4567, 1, 27, 30);

INSERT INTO ExerciseGroups
VALUES(6398, 1, 1, 15);

INSERT INTO ExerciseGroups
VALUES(5698, 1, 7, 15);

INSERT INTO ExerciseGroups
VALUES(6267, 1, 1, 15);

INSERT INTO ExerciseGroups
VALUES(6679, 10, 28, 28);

INSERT INTO ExerciseGroupMeetings
VALUES(6679, 1, "2020-09-10", "12:15:00.0", "14:00:00.0", 65980);

INSERT INTO ExerciseGroupMeetings
VALUES(6679, 1, "2020-09-17", "12:15:00.0", "14:00:00.0", 65985);

INSERT INTO ExerciseGroupMeetings
VALUES(6679, 2, "2020-09-11", "12:15:00.0", "14:00:00.0", 65981);

INSERT INTO ExerciseGroupMeetings
VALUES(5347, 1, "2019-09-10", "12:15:00.0", "14:00:00.0", 55981);

INSERT INTO ExerciseGroupMeetings
VALUES(4567, 1, "2018-09-10", "12:15:00.0", "14:00:00.0", 45981);

INSERT INTO ExerciseGroupMeetings
VALUES(6398, 1, "2020-09-10", "12:15:00.0", "14:00:00.0", 67891);

INSERT INTO ExerciseGroupMeetings
VALUES(5698, 1, "2019-09-10", "12:15:00.0", "14:00:00.0", 55990);

INSERT INTO ExerciseGroupMeetings
VALUES(6267, 1, "2020-09-17", "12:15:00.0", "14:00:00.0", 65990);

INSERT INTO Exams
VALUES("CS-A1150", "2020-10-26", "12:15:00.0", "14:00:00.0");

INSERT INTO Exams
VALUES("CS-A1150", "2019-10-26", "12:15:00.0", "14:00:00.0");

INSERT INTO Exams
VALUES("CS-A1120", "2020-12-16", "12:15:00.0", "16:00:00.0");

INSERT INTO Exams
VALUES("CSE-A1200", "2019-12-16", "12:15:00.0", "16:00:00.0");

INSERT INTO Exams
VALUES("CSE-A1200", "2020-12-16", "12:15:00.0", "16:00:00.0");

INSERT INTO Exams
VALUES("CSE-A1200", "2018-12-16", "12:15:00.0", "16:00:00.0");

INSERT INTO Exams
VALUES("CS-A1150", "2020-12-16", "12:15:00.0", "16:00:00.0");

INSERT INTO SelectedBy
VALUES(1, 6679, "987202");

INSERT INTO SelectedBy
VALUES(1, 6679, "512434");

INSERT INTO SelectedBy
VALUES(1, 6679, "234155");

INSERT INTO SelectedBy
VALUES(2, 6679, "553311");

INSERT INTO SelectedBy
VALUES(2, 6679, "565545");

INSERT INTO SelectedBy
VALUES(1, 5347, "442255");

INSERT INTO SelectedBy
VALUES(1, 4567, "212434");

INSERT INTO SelectedBy
VALUES(1, 6398, "512442");

INSERT INTO SelectedBy
VALUES(1, 5698, "433511");

INSERT INTO SelectedBy
VALUES(1, 6267, "224411");

INSERT INTO EnrolledBy
VALUES("2020-10-26", "CS-A1150", "123456");

INSERT INTO EnrolledBy
VALUES("2020-10-26", "CS-A1150", "224411");

INSERT INTO EnrolledBy
VALUES("2020-10-26", "CS-A1150", "433511");

INSERT INTO EnrolledBy
VALUES("2020-10-26", "CS-A1150", "512442");

INSERT INTO EnrolledBy
VALUES("2020-10-26", "CS-A1150", "442255");

INSERT INTO EnrolledBy
VALUES("2020-10-26", "CS-A1150", "565545");

INSERT INTO EnrolledBy
VALUES("2019-10-26", "CS-A1150", "218311");

INSERT INTO EnrolledBy
VALUES("2019-10-26", "CS-A1150", "565545");

INSERT INTO EnrolledBy
VALUES("2019-10-26", "CS-A1150", "234155");

INSERT INTO EnrolledBy
VALUES("2019-10-26", "CS-A1150", "553311");

INSERT INTO EnrolledBy
VALUES("2019-10-26", "CS-A1150", "512434");

INSERT INTO EnrolledBy
VALUES("2019-10-26", "CS-A1150", "987202");

INSERT INTO EnrolledBy
VALUES("2020-12-16", "CS-A1120", "224411");

INSERT INTO EnrolledBy
VALUES("2020-12-16", "CS-A1120", "123456");

INSERT INTO EnrolledBy
VALUES("2020-12-16", "CS-A1120", "433511");

INSERT INTO EnrolledBy
VALUES("2020-12-16", "CS-A1120", "442255");

INSERT INTO EnrolledBy
VALUES("2020-12-16", "CSE-A1200", "512442");

INSERT INTO EnrolledBy
VALUES("2020-12-16", "CSE-A1200", "565545"); 

INSERT INTO EnrolledBy
VALUES("2019-12-16", "CSE-A1200", "433511");

INSERT INTO EnrolledBy
VALUES("2018-12-16", "CSE-A1200", "212434");

INSERT INTO HasExamReservation
VALUES("CS-A1150", "2020-10-26", 66677);

INSERT INTO HasExamReservation
VALUES("CS-A1150", "2019-10-26", 55443);

INSERT INTO HasExamReservation
VALUES("CS-A1120", "2020-12-16", 65432);

INSERT INTO HasExamReservation
VALUES("CSE-A1200", "2019-12-16", 54321);

INSERT INTO HasExamReservation
VALUES("CSE-A1200", "2020-12-16", 66998);

INSERT INTO HasExamReservation
VALUES("CSE-A1200", "2018-12-16", 44444);

INSERT INTO Equipments
VALUES(1, "computer", "1001");

INSERT INTO Equipments
VALUES(2, "computer", "1002");

INSERT INTO Equipments
VALUES(3, "computer", "1001");

INSERT INTO Equipments
VALUES(4, "computer", "1002");

INSERT INTO Equipments
VALUES(5, "computer", "1002");

INSERT INTO Equipments
VALUES(6, "computer", "1001");

INSERT INTO Equipments
VALUES(7, "computer", "1002");

INSERT INTO Equipments
VALUES(8, "computer", "1002");

INSERT INTO Equipments
VALUES(9, "computer", "1002");

INSERT INTO Equipments
VALUES(10, "computer", "1002");

INSERT INTO Equipments
VALUES(11, "computer", "1002");

INSERT INTO Equipments
VALUES(12, "computer", "1002");

INSERT INTO Equipments
VALUES(13, "computer", "1002");

INSERT INTO Equipments
VALUES(14, "computer", "1002");

INSERT INTO Equipments
VALUES(15, "computer", "1002");

INSERT INTO Equipments
VALUES(16, "computer", "1002");

INSERT INTO Equipments
VALUES(17, "camera", "543");

INSERT INTO Equipments
VALUES(18, "camera", "789");

INSERT INTO Equipments
VALUES(19, "camera", "543");

INSERT INTO Equipments
VALUES(20, "projector", "33");

INSERT INTO Equipments
VALUES(21, "projector", "33");

INSERT INTO Equipments
VALUES(22, "projector", "33");

INSERT INTO Equipments
VALUES(23, "projector", "99");

INSERT INTO Equipments
VALUES(24, "projector", "99");

INSERT INTO Equipments
VALUES(25, "projector", "99");

INSERT INTO Equipments
VALUES(26, "laserpointer", "plop");

INSERT INTO Equipments
VALUES(27, "laserpointer", "plip");

INSERT INTO Equipments
VALUES(28, "laserpointer", "plop");

INSERT INTO Equipments
VALUES(29, "laserpointer", "plip");

INSERT INTO Equipments
VALUES(30, "laserpointer", "plip");

INSERT INTO OwnedBy
VALUES(1, "Kandidaattikeskus", "A-sali");

INSERT INTO OwnedBy
VALUES(2, "Kandidaattikeskus", "A-sali");

INSERT INTO OwnedBy
VALUES(3, "Kandidaattikeskus", "B-sali");

INSERT INTO OwnedBy
VALUES(4, "TUAS-talo", "AS1");

INSERT INTO OwnedBy
VALUES(5, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(6, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(7, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(8, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(9, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(10, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(11, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(12, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(13, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(14, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(15, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(16, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(17, "Kandidaattikeskus", "A-sali");

INSERT INTO OwnedBy
VALUES(18, "Kandidaattikeskus", "B-sali");

INSERT INTO OwnedBy
VALUES(19, "TUAS-talo", "AS1");

INSERT INTO OwnedBy
VALUES(20, "Kandidaattikeskus", "A-sali");

INSERT INTO OwnedBy
VALUES(21, "Kandidaattikeskus", "A-sali");

INSERT INTO OwnedBy
VALUES(22, "Kandidaattikeskus", "B-sali");

INSERT INTO OwnedBy
VALUES(23, "TUAS-talo", "AS1");

INSERT INTO OwnedBy
VALUES(24, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(25, "TUAS-talo", "AS5");

INSERT INTO OwnedBy
VALUES(26, "Kandidaattikeskus", "A-sali");

INSERT INTO OwnedBy
VALUES(27, "Kandidaattikeskus", "B-sali");

INSERT INTO OwnedBy
VALUES(28, "TUAS-talo", "AS1");

INSERT INTO OwnedBy
VALUES(29, "TUAS-talo", "TU4");

INSERT INTO OwnedBy
VALUES(30, "TUAS-talo", "AS5");

INSERT INTO Projectors
VALUES(20, "projector1");

INSERT INTO Projectors
VALUES(21, "projector1");

INSERT INTO Projectors
VALUES(22, "projector1");

INSERT INTO Projectors
VALUES(23, "projector2");

INSERT INTO Projectors
VALUES(24, "projector2");

INSERT INTO Projectors
VALUES(25, "projector2");

INSERT INTO Computers
VALUES(1, "teacher", 8192, 2.7, 1000);

INSERT INTO Computers
VALUES(2, "teacher", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(3, "teacher", 8192, 2.7, 1000);

INSERT INTO Computers
VALUES(4, "teacher", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(5, "teacher", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(6, "teacher", 8192, 2.7, 1000);

INSERT INTO Computers
VALUES(7, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(8, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(9, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(10, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(11, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(12, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(13, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(14, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(15, "student", 4096, 2.7, 500);

INSERT INTO Computers
VALUES(16, "student", 4096, 2.7, 500);

INSERT INTO Cameras
VALUES(17, "cam1");

INSERT INTO Cameras
VALUES(18, "cam2");

INSERT INTO Cameras
VALUES(19, "cam1");

CREATE INDEX StudentStartYear ON Students(startYear);

CREATE INDEX ReservationDate ON Reservations(date);

CREATE INDEX CourseStart ON CourseInstances(startDate);

CREATE INDEX CourseEnd ON CourseInstances(endDate);

CREATE INDEX ExamDate ON Exams(date);

CREATE INDEX EnrolledByDate ON EnrolledBy(examDate);

CREATE VIEW ExamInstances AS
SELECT R.buildingName, R.name, RES.date, RES.startTime, RES.endTime, COUNT(studentID)
FROM Reservations AS RES, EnrolledBy AS E, Rooms AS R, HasExamReservation AS H
WHERE RES.date=H.date AND H.date=E.examDate AND RES.roomName=R.name AND RES.buildingName=R.buildingName AND H.courseCode=E.courseCode AND RES.ID=H.reservationID
GROUP BY R.Name, R.buildingName, RES.date, RES.startTime, RES.endTime;

CREATE VIEW GroupParticipantNo AS
SELECT code, startDate, groupNo, COUNT(studentID)
FROM ExerciseGroups AS E, SelectedBy AS S, Courses AS C, CourseInstances AS CI
WHERE E.instanceID=S.instanceID AND S.instanceID=CI.instanceID AND C.code=CI.courseCode AND E.groupNo=S.groupNo
GROUP BY code, startDate;