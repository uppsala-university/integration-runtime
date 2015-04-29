CREATE TABLE uuevents
(
   identifier char(100) PRIMARY KEY NOT NULL,
   issuedTime timestamp,
   producer char(20),
   producerReferenceId char(100)
);
