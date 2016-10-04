--CREATE EXTENSION postgis;
create user pi with password 'security++';
alter role pi with createdb;
create database swn owner pi;
\connect swn
CREATE TABLE devices(
       id     integer NOT NULL PRIMARY KEY,
       device_name  varchar(10) NOT NULL UNIQUE
);
grant all privileges on table devices to pi;
CREATE TABLE consumption(
       id   integer NOT NULL PRIMARY KEY,
       date date  NOT NULL,
       device_id integer references devices(id)
);
INSERT INTO devices
(id, device_name)
VALUES
(15 , 'express');
