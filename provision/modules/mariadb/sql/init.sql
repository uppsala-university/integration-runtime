CREATE TABLE uuevents
(
  identifier varchar(255) PRIMARY KEY NOT NULL,
  issuedTime timestamp,
  producer varchar(255),
  producerReferenceId varchar(255),
  event_type varchar(255)
);

CREATE TABLE CAMEL_MESSAGEPROCESSED (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  processorName VARCHAR(255),
  messageId VARCHAR(100),
  createdAt TIMESTAMP,
  UNIQUE KEY `ix_key` (`processorName`, `messageId`)
);
