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

CREATE INDEX StudentStartYear ON Students(startYear);

CREATE INDEX ReservationDate ON Reservations(date);

CREATE INDEX CourseStart ON CourseInstances(startDate);

CREATE INDEX CourseEnd ON CourseInstances(endDate);

CREATE INDEX ExamDate ON Exams(date);

CREATE INDEX EnrolledByDate ON EnrolledBy(examDate);