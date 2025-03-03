CREATE TABLE User (
    user_id int NOT NULL,
    firstname varchar(255),
    lastname varchar(255),
    class_id int,
	school_id int,
	is_admin boolean,
	email varchar(255),
	password_hash text,
	created_at Date,
    PRIMARY KEY (user_id),
    FOREIGN KEY (class_id) REFERENCES "Class"(class_id)
	FOREIGN KEY (school_id) REFERENCES School(school_id)
);

CREATE TABLE "Class" (
    class_id int NOT NULL,
    grade int,
	class_name varchar(10),
    PRIMARY KEY (class_id)
);

CREATE TABLE School (
	school_id int NOT NULL,
	school_name varchar(255),
	PRIMARY KEY (school_id)
);

CREATE TABLE Course (
    course_id int NOT NULL,
    course_name varchar(255),
    PRIMARY KEY (course_id)
);

CREATE TABLE StudyGroup (
	study_group_id int NOT NULL,
	course_id int,
	school_id int,
	study_group_name varchar(255),
	"description" varchar(255),
	user_id int,
	is_active boolean,
	PRIMARY KEY (study_group_id),
	FOREIGN KEY (course_id) REFERENCES Course(course_id),
	FOREIGN KEY (school_id) REFERENCES School(school_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Enrolment (
    enrolment_id int NOT NULL,
	user_id int,
	study_group_id int,
	PRIMARY KEY (enrolment_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id),
	FOREIGN KEY (study_group_id) REFERENCES StudyGroup(study_group_id)
);

CREATE TABLE Access (
	access_id int NOT NULL,
	user_id int,
	study_group_id int,
	PRIMARY KEY (access_id),
	FOREIGN KEY (user_id) REFERENCES user(user_id),
	FOREIGN KEY (study_group_id) REFERENCES StudyGroup(study_group_id)
)

CREATE TABLE Requirement (
    requrement_id int NOT NULL,
	requrement_name varchar(255),
	PRIMARY KEY (requrement_id)
);

CREATE TABLE Task (
    task_id int NOT NULL,
	task_name varchar(255),
	task_description varchar(255),
	expected_code text,
	expected_output text,
	difficulty varchar(255),
	ImageURL varchar(255),
	course_id int,
	user_id int,
	public_access boolean,
	image_url text,
	PRIMARY KEY (task_id),
	FOREIGN KEY (course_id) REFERENCES Course(Courcourse_idseID),
	FOREIGN KEY (user_id) REFERENCES User(user_id),
);	

CREATE TABLE TaskRequirement (
	task_requirement_id int NOT NULL,
	task_id int,
	requirement_id int,
	PRIMARY KEY (task_requirement_id),
	FOREIGN KEY (task_id) REFERENCES Task(task_id),
	FOREIGN KEY (requirement_id) REFERENCES Requirement(requirement_id)
);

CREATE TABLE Recommended (
    recommended_id int NOT NULL,
	UserID int,
	task_id int,
	PRIMARY KEY (RecommendedID),
	FOREIGN KEY (UserID) REFERENCES User(UserID),
	FOREIGN KEY (TaskID) REFERENCES Task(TaskID)
);

CREATE TABLE Submission (
    submission_id int NOT NULL,
	task_id int,
	user_id int,
	submitted_code text,
	generated_output varchar(255),
	gpt_feedback text,
	PRIMARY KEY (submission_id),
	FOREIGN KEY (task_id) REFERENCES Task(task_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Favorite (
	favorite_id int NOT NULL,
	task_id int,
	user_id int,
	PRIMARY KEY (favorite_id),
	FOREIGN KEY (task_id) REFERENCES Task(task_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Settings (
    settings_id int NOT NULL,
	user_id int,
	editor_theme_dark boolean,
	theme_dark boolean,
	PRIMARY KEY (settings_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Announcement (
	announcement_id int NOT NULL,
	study_group_id int,
	user_id int,
	title varchar(100),
	content text,
	date_published Date,
	PRIMARY KEY (announcement_id),
	FOREIGN KEY (study_group_id) REFERENCES StudyGroup(study_group_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE SubmissionHistory (
	submission_history_id int NOT NULL,
	task_id int,
	user_id int,
	submitted_code text,
	created_at Date,
	passed boolean,
	PRIMARY KEY (submission_history_id),
	FOREIGN KEY (task_id) REFERENCES Task(task_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TYPE task_status AS ENUM('not_started', 'in_progress', 'completed');
CREATE TABLE TaskStatus (
	task_status_id int NOT NULL,
	user_id int,
	task_id int,
	last_updated Date,
	"status" task_status,
	PRIMARY KEY (task_status_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id),
	FOREIGN KEY (task_id) REFERENCES Task(task_id)
);

