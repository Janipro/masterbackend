CREATE TABLE Student (
    StudentID int NOT NULL,
    Firstname varchar(255),
    Lastname varchar(255),
    ClassID int,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (ClassID) REFERENCES "Class"(ClassID)
);

CREATE TABLE "Class" (
    ClassID int NOT NULL,
    Name varchar(255),
    PRIMARY KEY (ClassID),
);

CREATE TABLE Course (
    CourseID int NOT NULL,
    Name varchar(255),
    PRIMARY KEY (CourseID),
);

CREATE TABLE Enrolment (
    EnrolmentID int NOT NULL,
	StudentID int,
	CourseID int,
	PRIMARY KEY (EnrolmentID),
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE Teacher (
    TeacherID int NOT NULL,
    Firstname varchar(255),
    Lastname varchar(255),
	ClassID int,
	PRIMARY KEY (TeacherID),
	FOREIGN KEY (ClassID) REFERENCES "Class"(ClassID)
);

CREATE TABLE Requirement (
    RequirementID int NOT NULL,
	Name varchar(255),
	PRIMARY KEY (RequirementID)
);

CREATE TABLE Task (
    TaskID int NOT NULL,
	Name varchar(255),
	Description varchar(255),
	Difficulty varchar(255),
	ImageURL varchar(255),
	CourseID int,
	TeacherID int,
	RequirementID int,
	PRIMARY KEY (TaskID),
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
	FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID),
	FOREIGN KEY (RequirementID) REFERENCES Requirement(RequirementID)
);	

CREATE TABLE Recommended (
    RecommendedID int NOT NULL,
	StudentID int,
	TaskID int,
	PRIMARY KEY (RecommendedID),
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
);

CREATE TABLE Error (
    ErrorID int NOT NULL,
	TaskID int,
	StudentID int,
	Submittedcode varchar(1000),
	"Output" varchar(255),
	Feedback varchar(255),
	PRIMARY KEY (ErrorID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID),
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

CREATE TABLE Configuration (
    ConfigurationID int NOT NULL,
	StudentID int,
	Settings varchar(1000),
	PRIMARY KEY (ConfigurationID),
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

