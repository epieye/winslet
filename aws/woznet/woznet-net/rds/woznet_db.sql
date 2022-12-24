CREATE DATABASE wozdb;
\c wozdb
CREATE TABLE lambda (
    id          char(36) CONSTRAINT firstkey PRIMARY KEY,
    created     date,
    request     varchar(40) NOT NULL,
    type        varchar(10) NOT NULL,
    status      varchar(20) NOT NULL
);
