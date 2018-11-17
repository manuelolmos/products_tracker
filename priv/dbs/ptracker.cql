DROP KEYSPACE IF EXISTS ptracker;

CREATE KEYSPACE ptracker WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : '3'} AND durable_writes = true;

CREATE TABLE ptracker.products (
   name text PRIMARY KEY,
   prize int,
   date text,
   seller text
);
