CREATE TABLE Requirements (
    requirement_id SERIAL PRIMARY KEY,
    requirement_name VARCHAR(255)
);

CREATE TABLE Classes (
    class_id SERIAL PRIMARY KEY,
    grade INT,
    class_name VARCHAR(10)
);

CREATE TABLE Schools (
    school_id SERIAL PRIMARY KEY,
    school_name VARCHAR(255)
);

CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(255)
);

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    class_id INT,
    school_id INT,
    is_admin BOOLEAN,
    email VARCHAR(255),
    password_hash TEXT,
    created_at DATE,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    FOREIGN KEY (school_id) REFERENCES Schools(school_id)
);

CREATE TABLE StudyGroups (
    study_group_id SERIAL PRIMARY KEY,
    course_id INT,
    school_id INT,
    study_group_name VARCHAR(255),
    "description" VARCHAR(255),
    user_id INT,
    is_active BOOLEAN,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (school_id) REFERENCES Schools(school_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Enrolments (
    enrolment_id SERIAL PRIMARY KEY,
    user_id INT,
    study_group_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id)
);

CREATE TABLE "Access" (
    access_id SERIAL PRIMARY KEY,
    user_id INT,
    study_group_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id)
);

CREATE TABLE Tasks (
    task_id SERIAL PRIMARY KEY,
    task_name VARCHAR(255),
    task_description VARCHAR(255),
    expected_code TEXT,
    expected_output TEXT,
    code_template TEXT,
    difficulty VARCHAR(255),
    "level" VARCHAR(50),
    "type" VARCHAR(50),
    course_id INT,
    user_id INT,
    public_access BOOLEAN,
    image_url TEXT,
    is_active BOOLEAN,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE TaskRequirements (
    task_requirement_id SERIAL PRIMARY KEY,
    task_id INT,
    requirement_id INT,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (requirement_id) REFERENCES Requirements(requirement_id)
);

CREATE TABLE HelpRequests (
    help_request_id SERIAL PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    submitted_code TEXT,
    submitted_output TEXT,
    expected_code TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    gpt_feedback TEXT,
    requirement_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (requirement_id) REFERENCES Requirements(requirement_id)
);

CREATE TYPE recommended_type AS ENUM ('obligatory', 'exercise');

CREATE TABLE Recommended (
    recommended_id SERIAL PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    study_group_id INT NOT NULL,
    type recommended_type NOT NULL,
    deadline TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id)
);

CREATE TABLE RecommendedStudents (
    recommended_student_id SERIAL PRIMARY KEY,
    recommended_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (recommended_id) REFERENCES Recommended(recommended_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    UNIQUE (recommended_id, user_id)
);

CREATE TABLE Submissions (
    submission_id SERIAL PRIMARY KEY,
    task_id INT,
    user_id INT,
    submitted_code TEXT,
    generated_output VARCHAR(255),
    gpt_feedback TEXT,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Favorites (
    favorite_id SERIAL PRIMARY KEY,
    task_id INT,
    user_id INT,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Settings (
    settings_id SERIAL PRIMARY KEY,
    user_id INT,
    editor_theme_dark BOOLEAN,
    theme_dark BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Announcements (
    announcement_id SERIAL PRIMARY KEY,
    study_group_id INT,
    user_id INT,
    title VARCHAR(100),
    content TEXT,
    date_published DATE,
    FOREIGN KEY (study_group_id) REFERENCES StudyGroups(study_group_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE SubmissionHistories (
    submission_history_id SERIAL PRIMARY KEY,
    task_id INT,
    user_id INT,
    submitted_code TEXT,
    created_at DATE,
    passed BOOLEAN,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TYPE task_status AS ENUM ('not_started', 'in_progress', 'completed');

CREATE TABLE TaskStatuses (
    task_status_id SERIAL PRIMARY KEY,
    user_id INT,
    task_id INT,
    last_updated DATE,
    "status" task_status,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id)
);
