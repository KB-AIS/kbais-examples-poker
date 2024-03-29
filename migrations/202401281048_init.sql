BEGIN;

CREATE SCHEMA poker
    CREATE TABLE projects
    (
        id SERIAL PRIMARY KEY,
        started_at DATE NOT NULL,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        chatId INTEGER
    )
    CREATE TABLE sprints
    (
        id          SERIAL PRIMARY KEY,
        project_id  INTEGER REFERENCES projects (id),
        iteration   INTEGER NOT NULL,
        started_at  DATE    NOT NULL,
        finished_at DATE    NOT NULL
    )
    CREATE TABLE task
    (
        id          SERIAL PRIMARY KEY,
        sprint_id   INTEGER REFERENCES sprints (id),
        name        VARCHAR(255) NOT NULL,
        description TEXT
    )
    CREATE TABLE outbox_table
    (
        id INT PRIMARY KEY,
        textmessage VARCHAR(255)
    )
    CREATE TABLE members
    (
    userId     SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects (id)
    );
    



COMMIT;
