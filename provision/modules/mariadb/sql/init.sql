CREATE TABLE uuevents
(
   identifier varchar(255) PRIMARY KEY NOT NULL,
   issuedTime timestamp,
   producer varchar(255),
   producerReferenceId varchar(255),
   event_type varchar(255)
);
