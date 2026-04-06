-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: crud_app
-- ------------------------------------------------------
-- Server version	8.0.45

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
CREATE TABLE `folder` (
  `folderId` int NOT NULL AUTO_INCREMENT,
  `folderName` varchar(255) NOT NULL,
  `userId` int NOT NULL,
  `parentFolderId` int DEFAULT NULL,
  PRIMARY KEY (`folderId`),
  KEY `userId` (`userId`),
  KEY `parentFolderId` (`parentFolderId`),
  CONSTRAINT `folder_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `folder_ibfk_2` FOREIGN KEY (`parentFolderId`) REFERENCES `folder` (`folderId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder`
--

LOCK TABLES `folder` WRITE;
/*!40000 ALTER TABLE `folder` DISABLE KEYS */;
INSERT INTO `folder` VALUES (1,'Lecture Notes',1,NULL),(2,'Assignments',1,NULL),(3,'Personal',1,NULL),(4,'Week 1',1,1);
/*!40000 ALTER TABLE `folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folderfoldernotes`
--

DROP TABLE IF EXISTS `folderfoldernotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `folderfoldernotes` (
  `folderid` int NOT NULL,
  `folderid2` int NOT NULL,
  `noteid` int NOT NULL,
  PRIMARY KEY (`folderid`,`folderid2`,`noteid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `userId` int DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`graphId`),
  KEY `fk_graph_user` (`userId`),
  CONSTRAINT `fk_graph_user` FOREIGN KEY (`userId`) REFERENCES `users` (`userid`) ON DELETE CASCADE
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
-- Table structure for table `graph_edges`
--

DROP TABLE IF EXISTS `graph_edges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graph_edges` (
  `graphEdgeId` int NOT NULL AUTO_INCREMENT,
  `graphId` int NOT NULL,
  `sourceNodeId` int NOT NULL,
  `targetNodeId` int NOT NULL,
  `sharedTagId` int DEFAULT NULL,
  `relationType` varchar(30) NOT NULL DEFAULT 'shared_tag',
  PRIMARY KEY (`graphEdgeId`),
  UNIQUE KEY `uq_graph_edge_once` (`graphId`,`sourceNodeId`,`targetNodeId`),
  KEY `fk_graph_edges_source` (`sourceNodeId`),
  KEY `fk_graph_edges_target` (`targetNodeId`),
  KEY `fk_graph_edges_tag` (`sharedTagId`),
  CONSTRAINT `fk_graph_edges_graph` FOREIGN KEY (`graphId`) REFERENCES `graph` (`graphId`) ON DELETE CASCADE,
  CONSTRAINT `fk_graph_edges_source` FOREIGN KEY (`sourceNodeId`) REFERENCES `graph_nodes` (`graphNodeId`) ON DELETE CASCADE,
  CONSTRAINT `fk_graph_edges_tag` FOREIGN KEY (`sharedTagId`) REFERENCES `tag` (`tagId`) ON DELETE SET NULL,
  CONSTRAINT `fk_graph_edges_target` FOREIGN KEY (`targetNodeId`) REFERENCES `graph_nodes` (`graphNodeId`) ON DELETE CASCADE,
  CONSTRAINT `chk_graph_edges_no_self` CHECK ((`sourceNodeId` <> `targetNodeId`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graph_edges`
--

LOCK TABLES `graph_edges` WRITE;
/*!40000 ALTER TABLE `graph_edges` DISABLE KEYS */;
/*!40000 ALTER TABLE `graph_edges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graph_nodes`
--

DROP TABLE IF EXISTS `graph_nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graph_nodes` (
  `graphNodeId` int NOT NULL AUTO_INCREMENT,
  `graphId` int NOT NULL,
  `noteId` int NOT NULL,
  `posX` decimal(10,2) NOT NULL DEFAULT '0.00',
  `posY` decimal(10,2) NOT NULL DEFAULT '0.00',
  `width` decimal(10,2) NOT NULL DEFAULT '220.00',
  `height` decimal(10,2) NOT NULL DEFAULT '120.00',
  `displayOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`graphNodeId`),
  UNIQUE KEY `uq_graph_note_once` (`graphId`,`noteId`),
  KEY `fk_graph_nodes_note` (`noteId`),
  CONSTRAINT `fk_graph_nodes_graph` FOREIGN KEY (`graphId`) REFERENCES `graph` (`graphId`) ON DELETE CASCADE,
  CONSTRAINT `fk_graph_nodes_note` FOREIGN KEY (`noteId`) REFERENCES `notes` (`noteId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graph_nodes`
--

LOCK TABLES `graph_nodes` WRITE;
/*!40000 ALTER TABLE `graph_nodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `graph_nodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graph_tags`
--

DROP TABLE IF EXISTS `graph_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graph_tags` (
  `graphId` int NOT NULL,
  `tagId` int NOT NULL,
  PRIMARY KEY (`graphId`,`tagId`),
  KEY `fk_graph_tags_tag` (`tagId`),
  CONSTRAINT `fk_graph_tags_graph` FOREIGN KEY (`graphId`) REFERENCES `graph` (`graphId`) ON DELETE CASCADE,
  CONSTRAINT `fk_graph_tags_tag` FOREIGN KEY (`tagId`) REFERENCES `tag` (`tagId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graph_tags`
--

LOCK TABLES `graph_tags` WRITE;
/*!40000 ALTER TABLE `graph_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `graph_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `note_tags`
--

DROP TABLE IF EXISTS `note_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `note_tags` (
  `noteId` int NOT NULL,
  `tagId` int NOT NULL,
  PRIMARY KEY (`noteId`,`tagId`),
  KEY `tagId` (`tagId`),
  CONSTRAINT `note_tags_ibfk_1` FOREIGN KEY (`noteId`) REFERENCES `notes` (`noteId`) ON DELETE CASCADE,
  CONSTRAINT `note_tags_ibfk_2` FOREIGN KEY (`tagId`) REFERENCES `tag` (`tagId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `note_tags`
--

LOCK TABLES `note_tags` WRITE;
/*!40000 ALTER TABLE `note_tags` DISABLE KEYS */;
INSERT INTO `note_tags` VALUES (5,1),(6,1),(7,1),(8,2),(9,2),(8,3),(9,3),(10,3),(8,4),(10,4);
/*!40000 ALTER TABLE `note_tags` ENABLE KEYS */;
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
CREATE TABLE `notes` (
  `noteId` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT 'Untitled',
  `content` text,
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifiedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `historyId` int DEFAULT NULL,
  `folderId` int DEFAULT NULL,
  `userId` int NOT NULL,
  PRIMARY KEY (`noteId`),
  KEY `folderId` (`folderId`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`folderId`) REFERENCES `folder` (`folderId`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` VALUES (1,'Systems Design Intro','Today we covered UML diagrams and use-case modeling.','2026-04-06 01:54:10','2026-04-06 01:54:10',NULL,1,1),(2,'Assignment 1','Build a class diagram for the note-taking app.','2026-04-06 01:54:10','2026-04-06 01:54:10',NULL,2,1),(3,'Meeting Notes','Discussed folder module implementation.','2026-04-06 01:54:10','2026-04-06 01:54:10',NULL,3,1),(4,'Week 1 – Day 1','Introduction to the course.','2026-04-06 01:54:10','2026-04-06 01:54:10',NULL,4,2),(5,'untitleds','','2026-04-05 21:56:58',NULL,NULL,NULL,4),(6,'untitledsssss','','2026-04-05 21:57:04',NULL,NULL,NULL,4),(7,'Nice','','2026-04-05 21:59:44',NULL,NULL,NULL,4),(8,'Brachioradialis','ss','2026-04-05 22:46:45',NULL,NULL,NULL,4),(9,'Flexor Carpi Ulnaris Longus','','2026-04-05 22:53:49',NULL,NULL,NULL,4),(10,'Biceps Brachii','','2026-04-05 22:54:42',NULL,NULL,NULL,4);
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
  `userId` int NOT NULL,
  PRIMARY KEY (`tagId`),
  UNIQUE KEY `tagName` (`tagName`),
  KEY `userId` (`userId`),
  CONSTRAINT `tag_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'one',4),(2,'Forearm',4),(3,'Arm',4),(4,'Upper Arm',4);
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usernotesfoldersgraphs`
--

DROP TABLE IF EXISTS `usernotesfoldersgraphs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usernotesfoldersgraphs` (
  `userId` int NOT NULL,
  `noteId` int NOT NULL,
  `folderId` int NOT NULL,
  `graphId` int NOT NULL,
  PRIMARY KEY (`userId`,`noteId`,`folderId`,`graphId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usernotesfoldersgraphs`
--

LOCK TABLES `usernotesfoldersgraphs` WRITE;
/*!40000 ALTER TABLE `usernotesfoldersgraphs` DISABLE KEYS */;
INSERT INTO `usernotesfoldersgraphs` VALUES (1,1,1,1),(1,2,1,1),(1,3,1,1);
/*!40000 ALTER TABLE `usernotesfoldersgraphs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userid` int NOT NULL AUTO_INCREMENT,
  `user` varchar(45) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `loggedin` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Galen','galenchow@gmail.com','123456',0),(2,'John','John@gmail.com','1234567',0),(3,'Flat','Flat@gmail.com','1234567',0),(4,'Jane','jane@gmail.com','po',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_note_tag_relationships`
--

DROP TABLE IF EXISTS `vw_note_tag_relationships`;
/*!50001 DROP VIEW IF EXISTS `vw_note_tag_relationships`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_note_tag_relationships` AS SELECT 
 1 AS `userId`,
 1 AS `sourceNoteId`,
 1 AS `targetNoteId`,
 1 AS `sharedTags`,
 1 AS `sharedTagCount`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_note_tag_relationships`
--

/*!50001 DROP VIEW IF EXISTS `vw_note_tag_relationships`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_note_tag_relationships` AS select `n1`.`userId` AS `userId`,least(`n1`.`noteId`,`n2`.`noteId`) AS `sourceNoteId`,greatest(`n1`.`noteId`,`n2`.`noteId`) AS `targetNoteId`,group_concat(distinct `t`.`tagName` order by `t`.`tagName` ASC separator ', ') AS `sharedTags`,count(distinct `t`.`tagId`) AS `sharedTagCount` from ((((`note_tags` `nt1` join `note_tags` `nt2` on(((`nt1`.`tagId` = `nt2`.`tagId`) and (`nt1`.`noteId` < `nt2`.`noteId`)))) join `notes` `n1` on((`n1`.`noteId` = `nt1`.`noteId`))) join `notes` `n2` on(((`n2`.`noteId` = `nt2`.`noteId`) and (`n1`.`userId` = `n2`.`userId`)))) join `tag` `t` on(((`t`.`tagId` = `nt1`.`tagId`) and (`t`.`userId` = `n1`.`userId`)))) group by `n1`.`userId`,least(`n1`.`noteId`,`n2`.`noteId`),greatest(`n1`.`noteId`,`n2`.`noteId`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-06 16:52:42
