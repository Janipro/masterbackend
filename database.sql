CREATE TABLE Requirements (
    requirement_id SERIAL int NOT NULL,
	requirement_name varchar(255),
	PRIMARY KEY (requirement_id)
);

CREATE TABLE Classes (
    class_id SERIAL int NOT NULL,
    grade int,
	class_name varchar(10),
    PRIMARY KEY (class_id)
);

CREATE TABLE Schools (
	school_id SERIAL int NOT NULL,
	school_name varchar(255),
	PRIMARY KEY (school_id)
);

CREATE TABLE Courses (
    course_id SERIAL int NOT NULL,
    course_name varchar(255),
    PRIMARY KEY (course_id)
);

CREATE TABLE Users (
    user_id SERIAL int NOT NULL,
    firstname varchar(255),
    lastname varchar(255),
    class_id int,
	school_id int,
	is_admin boolean,
	email varchar(255),
	password_hash text,
	created_at Date,
    PRIMARY KEY (user_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
	FOREIGN KEY (school_id) REFERENCES Schools(school_id)
);

CREATE TABLE StudyGroups (
	study_group_id SERIAL int NOT NULL,
	course_id int,
	school_id int,
	study_group_name varchar(255),
	"description" varchar(255),
	user_id int,
	is_active boolean,
	PRIMARY KEY (study_group_id),
	FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	FOREIGN KEY (school_id) REFERENCES Schools(school_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Enrolments (
    enrolment_id SERIAL int NOT NULL,
	user_id int,
	study_group_id int,
	PRIMARY KEY (enrolment_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id)
);

CREATE TABLE "Access" (
	access_id SERIAL int NOT NULL,
	user_id int,
	study_group_id int,
	PRIMARY KEY (access_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id)
);

CREATE TABLE Tasks (
    task_id SERIAL int NOT NULL,
	task_name varchar(255),
	task_description varchar(255),
	expected_code text,
	expected_output text,
	code_template text,
	difficulty varchar(255),
	"level" varchar(50),
	"type" varchar(50),
	course_id int,
	user_id int,
	public_access boolean,
	image_url text,
	is_active boolean,
	PRIMARY KEY (task_id),
	FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);	

CREATE TABLE TaskRequirements (
	task_requirement_id SERIAL int NOT NULL,
	task_id int,
	requirement_id int,
	PRIMARY KEY (task_requirement_id),
	FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
	FOREIGN KEY (requirement_id) REFERENCES Requirements(requirement_id)
);

CREATE TABLE HelpRequests (
	help_request_id SERIAL,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    submitted_code TEXT,
    submitted_output TEXT,
    expected_code TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    gpt_feedback TEXT,
	requirement_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	help_request_id PRIMARY KEY,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (requirement_id) REFERENCES Requirements(requirement_id)
)

CREATE TYPE recommended_type AS ENUM('obligatory', 'exercise');

CREATE TABLE Recommended (
	recommended_id SERIAL INT NOT NULL,
    task_id INT NOT NULL,
	user_id INT NOT NULL,
    study_group_id INT NOT NULL,
    type recommended_type NOT NULL,
    deadline TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
	PRIMARY KEY (recommended_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id)
);

CREATE TABLE RecommendedStudents (
    recomennded_student_id SERIAL NOT NULL,
    recommended_id INT NOT NULL,
    user_id INT NOT NULL,
	recomennded_student_id PRIMARY KEY,
    FOREIGN KEY (recommended_id) REFERENCES Recommended(recommended_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    UNIQUE (recommended_id, user_id)
);

CREATE TABLE Submissions (
    submission_id SERIAL int NOT NULL,
	task_id int,
	user_id int,
	submitted_code text,
	generated_output varchar(255),
	gpt_feedback text,
	PRIMARY KEY (submission_id),
	FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Favorites (
	favorite_id SERIAL int NOT NULL,
	task_id int,
	user_id int,
	PRIMARY KEY (favorite_id),
	FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Settings (
    settings_id SERIAL int NOT NULL,
	user_id int,
	editor_theme_dark boolean,
	theme_dark boolean,
	PRIMARY KEY (settings_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Announcements (
	announcement_id SERIAL int NOT NULL,
	study_group_id int,
	user_id int,
	title varchar(100),
	content text,
	date_published Date,
	PRIMARY KEY (announcement_id),
	FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE SubmissionHistories (
	submission_history_id SERIAL int NOT NULL,
	task_id int,
	user_id int,
	submitted_code text,
	created_at Date,
	passed boolean,
	PRIMARY KEY (submission_history_id),
	FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TYPE task_status AS ENUM('not_started', 'in_progress', 'completed');
CREATE TABLE TaskStatuses (
	task_status_id SERIAL int NOT NULL,
	user_id int,
	task_id int,
	last_updated Date,
	"status" task_status,
	PRIMARY KEY (task_status_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (task_id) REFERENCES Tasks(task_id)
);

