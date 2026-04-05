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

LOCK TABLES `graph` WRITE;
/*!40000 ALTER TABLE `graph` DISABLE KEYS */;
/*!40000 ALTER TABLE `graph` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notehistory`
--

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