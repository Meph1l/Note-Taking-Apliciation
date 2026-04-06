-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: crud_app
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employees`
--
USE crud_app;
DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `job` varchar(255) NOT NULL,
  `experience` varchar(255) NOT NULL,
  `salary` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Dante','Freelance','5',100.00),(2,'name from backend','job from backend','experience from backend',100.00),(3,'name from client','job from client','experience from client',100.00);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folder`
--

DROP TABLE IF EXISTS `folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE folder (
    folderId       INT          NOT NULL AUTO_INCREMENT,
    folderName     VARCHAR(255) NOT NULL,
    userId         INT          NOT NULL,
    parentFolderId INT          DEFAULT NULL,
    PRIMARY KEY (folderId),
    FOREIGN KEY (userId)         REFERENCES users(userid)   ON DELETE CASCADE,
    FOREIGN KEY (parentFolderId) REFERENCES folder(folderId) ON DELETE CASCADE
);
--
-- Dumping data for table `folder`
--

LOCK TABLES `folder` WRITE;
/*!40000 ALTER TABLE `folder` DISABLE KEYS */;
/*!40000 ALTER TABLE `folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folderfoldernotes`
--


--
-- Dumping data for table `folderfoldernotes`
--

LOCK TABLES `folderfoldernotes` WRITE;
/*!40000 ALTER TABLE `folderfoldernotes` DISABLE KEYS */;
/*!40000 ALTER TABLE `folderfoldernotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graph`
--

DROP TABLE IF EXISTS `graph`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graph` (
  `graphId` int NOT NULL AUTO_INCREMENT,
  `graphname` varchar(45) NOT NULL,
  `dateCreated` datetime NOT NULL,
  PRIMARY KEY (`graphId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graph`
--
ALTER TABLE graph
  ADD COLUMN userId INT NULL AFTER graphname,
  ADD COLUMN updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP AFTER dateCreated;

ALTER TABLE graph
  ADD CONSTRAINT fk_graph_user
  FOREIGN KEY (userId) REFERENCES users(userid)
  ON DELETE CASCADE;
LOCK TABLES `graph` WRITE;
/*!40000 ALTER TABLE `graph` DISABLE KEYS */;
/*!40000 ALTER TABLE `graph` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Save which tags were selected for the merge
drop table if exists `graph_tags`;
CREATE TABLE IF NOT EXISTS graph_tags (
  graphId INT NOT NULL,
  tagId INT NOT NULL,
  PRIMARY KEY (graphId, tagId),
  CONSTRAINT fk_graph_tags_graph
    FOREIGN KEY (graphId) REFERENCES graph(graphId)
    ON DELETE CASCADE,
  CONSTRAINT fk_graph_tags_tag
    FOREIGN KEY (tagId) REFERENCES tag(tagId)
    ON DELETE CASCADE
);
-- Save each note rectangle and its dragged position
DROP TABLE IF EXISTS `graph_nodes`;
CREATE TABLE IF NOT EXISTS graph_nodes (
  graphNodeId INT NOT NULL AUTO_INCREMENT,
  graphId INT NOT NULL,
  noteId INT NOT NULL,
  posX DECIMAL(10,2) NOT NULL DEFAULT 0,
  posY DECIMAL(10,2) NOT NULL DEFAULT 0,
  width DECIMAL(10,2) NOT NULL DEFAULT 220,
  height DECIMAL(10,2) NOT NULL DEFAULT 120,
  displayOrder INT NOT NULL DEFAULT 0,
  PRIMARY KEY (graphNodeId),
  UNIQUE KEY uq_graph_note_once (graphId, noteId),
  CONSTRAINT fk_graph_nodes_graph
    FOREIGN KEY (graphId) REFERENCES graph(graphId)
    ON DELETE CASCADE,
  CONSTRAINT fk_graph_nodes_note
    FOREIGN KEY (noteId) REFERENCES notes(noteId)
    ON DELETE CASCADE
);
-- Save the connection lines between notes 
DROP TABLE IF EXISTS `graph_edges`;
CREATE TABLE IF NOT EXISTS graph_edges (
  graphEdgeId INT NOT NULL AUTO_INCREMENT,
  graphId INT NOT NULL,
  sourceNodeId INT NOT NULL,
  targetNodeId INT NOT NULL,
  sharedTagId INT NULL,
  relationType VARCHAR(30) NOT NULL DEFAULT 'shared_tag',
  PRIMARY KEY (graphEdgeId),
  UNIQUE KEY uq_graph_edge_once (graphId, sourceNodeId, targetNodeId),
  CONSTRAINT fk_graph_edges_graph
    FOREIGN KEY (graphId) REFERENCES graph(graphId)
    ON DELETE CASCADE,
  CONSTRAINT fk_graph_edges_source
    FOREIGN KEY (sourceNodeId) REFERENCES graph_nodes(graphNodeId)
    ON DELETE CASCADE,
  CONSTRAINT fk_graph_edges_target
    FOREIGN KEY (targetNodeId) REFERENCES graph_nodes(graphNodeId)
    ON DELETE CASCADE,
  CONSTRAINT fk_graph_edges_tag
    FOREIGN KEY (sharedTagId) REFERENCES tag(tagId)
    ON DELETE SET NULL,
  CONSTRAINT chk_graph_edges_no_self
    CHECK (sourceNodeId <> targetNodeId)
);
-- Identify which notes are connected by shared tags.
DROP VIEW IF EXISTS `vw_note_tag_relationships`;
CREATE OR REPLACE VIEW vw_note_tag_relationships AS
SELECT
  n1.userId,
  LEAST(n1.noteId, n2.noteId) AS sourceNoteId,
  GREATEST(n1.noteId, n2.noteId) AS targetNoteId,
  GROUP_CONCAT(DISTINCT t.tagName ORDER BY t.tagName SEPARATOR ', ') AS sharedTags,
  COUNT(DISTINCT t.tagId) AS sharedTagCount
FROM note_tags nt1
JOIN note_tags nt2
  ON nt1.tagId = nt2.tagId
 AND nt1.noteId < nt2.noteId
JOIN notes n1
  ON n1.noteId = nt1.noteId
JOIN notes n2
  ON n2.noteId = nt2.noteId
 AND n1.userId = n2.userId
JOIN tag t
  ON t.tagId = nt1.tagId
 AND t.userId = n1.userId
GROUP BY
  n1.userId,
  LEAST(n1.noteId, n2.noteId),
  GREATEST(n1.noteId, n2.noteId);
DROP TABLE IF EXISTS `notehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notehistory` (
  `historyId` int NOT NULL AUTO_INCREMENT,
  `contentSnapshot` longtext NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`historyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notehistory`
--

LOCK TABLES `notehistory` WRITE;
/*!40000 ALTER TABLE `notehistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `notehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS notes (
    noteId       INT          NOT NULL AUTO_INCREMENT,
    title        VARCHAR(255) NOT NULL DEFAULT 'Untitled',
    content      TEXT,
    dateCreated  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifiedDate DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    historyId    INT          DEFAULT NULL,
    folderId     INT          DEFAULT NULL,   -- NEW: links note to a folder
    userId		INT           NOT NULL,
    PRIMARY KEY (noteId),
    FOREIGN KEY (folderId) REFERENCES folder(folderId) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `tagId` int NOT NULL AUTO_INCREMENT,
  `tagName` varchar(45) NOT NULL,
  `userId` int not null,
  UNIQUE key (tagname),
  PRIMARY KEY (`tagId`),
  Foreign key (userId) references users(userid) on delete cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP table if exists `note_tags`;
CREATE TABLE note_tags (
  noteId INT NOT NULL,
  tagId  INT NOT NULL,
  PRIMARY KEY (noteId, tagId),
  FOREIGN KEY (noteId) REFERENCES notes(noteId) ON DELETE CASCADE,
  FOREIGN KEY (tagId) REFERENCES tag(tagId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usernotesfoldersgraphs`
--


--
-- Dumping data for table `usernotesfoldersgraphs`
--


INSERT IGNORE INTO folder (folderId, folderName, userId, parentFolderId) VALUES
(1, 'Lecture Notes',  1, NULL),
(2, 'Assignments',    1, NULL),
(3, 'Personal',       1, NULL);

-- Sub-folder (Lecture Notes > Week 1)
INSERT IGNORE INTO folder (folderId, folderName, userId, parentFolderId) VALUES
(4, 'Week 1', 1, 1);

-- Sample notes assigned to folders
INSERT IGNORE INTO notes (noteId, title, content, folderId, userId) VALUES
(1, 'Systems Design Intro',   'Today we covered UML diagrams and use-case modeling.', 1,1),
(2, 'Assignment 1',           'Build a class diagram for the note-taking app.',       2,1),
(3, 'Meeting Notes',          'Discussed folder module implementation.',               3,1),
(4, 'Week 1 – Day 1',         'Introduction to the course.',                          4,2);

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userid` int NOT NULL AUTO_INCREMENT,
  `user` varchar(45) NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `loggedin` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Galen','galenchow@gmail.com','123456',0),(2,'John','John@gmail.com','1234567',0),(3,'Flat','Flat@gmail.com','1234567',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-02 22:55:12