CREATE TABLE User (
    UserID int NOT NULL,
    Firstname varchar(255),
    Lastname varchar(255),
    ClassID int,
	isAdmin boolean,
    PRIMARY KEY (UserID),
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
	UserID int,
	CourseID int,
	PRIMARY KEY (EnrolmentID),
	FOREIGN KEY (UserID) REFERENCES User(UserID),
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
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
	UserID int,
	RequirementID int,
	PRIMARY KEY (TaskID),
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
	FOREIGN KEY (UserID) REFERENCES User(UserID),
	FOREIGN KEY (RequirementID) REFERENCES Requirement(RequirementID)
);	

CREATE TABLE Recommended (
    RecommendedID int NOT NULL,
	UserID int,
	TaskID int,
	PRIMARY KEY (RecommendedID),
	FOREIGN KEY (UserID) REFERENCES User(UserID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
);

CREATE TABLE Error (
    ErrorID int NOT NULL,
	TaskID int,
	UserID int,
	Submittedcode varchar(1000),
	"Output" varchar(255),
	Feedback varchar(255),
	PRIMARY KEY (ErrorID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID),
	FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE Configuration (
    ConfigurationID int NOT NULL,
	UserID int,
	Darkmode boolean,
	Autosave boolean,
	PRIMARY KEY (ConfigurationID),
	FOREIGN KEY (UserID) REFERENCES User(UserID)
);

