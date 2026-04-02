-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: lost_found_db
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `claims`
--

DROP TABLE IF EXISTS `claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `claims` (
  `claim_id` int NOT NULL AUTO_INCREMENT,
  `lost_id` int DEFAULT NULL,
  `found_id` int DEFAULT NULL,
  `claimant_id` int DEFAULT NULL,
  `claim_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `verification_note` text,
  PRIMARY KEY (`claim_id`),
  KEY `lost_id` (`lost_id`),
  KEY `found_id` (`found_id`),
  KEY `claimant_id` (`claimant_id`),
  CONSTRAINT `claims_ibfk_1` FOREIGN KEY (`lost_id`) REFERENCES `lost_items` (`lost_id`),
  CONSTRAINT `claims_ibfk_2` FOREIGN KEY (`found_id`) REFERENCES `found_items` (`found_id`),
  CONSTRAINT `claims_ibfk_3` FOREIGN KEY (`claimant_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claims`
--

LOCK TABLES `claims` WRITE;
/*!40000 ALTER TABLE `claims` DISABLE KEYS */;
INSERT INTO `claims` VALUES (1,1,1,1,'approved','Matched wallet details'),(2,2,2,2,'approved','Phone verified successfully'),(3,3,3,3,'pending','Awaiting admin verification'),(4,4,4,4,'approved','Bag identified correctly'),(5,5,5,5,'rejected','Incorrect claim details'),(6,6,6,6,'approved','Watch matched'),(7,7,7,7,'pending','Verification in progress'),(8,8,8,8,'approved','Bottle confirmed'),(9,9,9,9,'approved','Notebook matched'),(10,10,10,10,'rejected','Mismatch in description'),(11,11,11,11,'approved','Glasses verified'),(12,12,12,12,'pending','Under review'),(13,13,13,13,'approved','Calculator matched'),(14,14,14,14,'approved','USB verified'),(15,15,15,15,'approved','Jacket confirmed');
/*!40000 ALTER TABLE `claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `found_items`
--

DROP TABLE IF EXISTS `found_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `found_items` (
  `found_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `item_name` varchar(100) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `location_found` varchar(100) DEFAULT NULL,
  `date_found` date DEFAULT NULL,
  `status` enum('found','claimed') DEFAULT 'found',
  PRIMARY KEY (`found_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `found_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `found_items`
--

LOCK TABLES `found_items` WRITE;
/*!40000 ALTER TABLE `found_items` DISABLE KEYS */;
INSERT INTO `found_items` VALUES (1,16,'Wallet','Accessories','Black leather wallet','Library','2026-03-11','found'),(2,17,'Phone','Electronics','Samsung phone with cracked screen','Cafeteria','2026-03-12','found'),(3,18,'ID Card','Documents','College ID card','Auditorium','2026-03-13','found'),(4,19,'Backpack','Bags','Blue Nike backpack','Bus Stop','2026-03-14','found'),(5,20,'Keys','Accessories','Keys with red keychain','Parking Lot','2026-03-15','found'),(6,21,'Watch','Accessories','Silver wrist watch','Gym','2026-03-16','found'),(7,22,'Laptop','Electronics','HP laptop in sleeve','Library','2026-03-17','found'),(8,23,'Water Bottle','Personal','Steel bottle','Classroom','2026-03-18','found'),(9,24,'Notebook','Stationery','Math notebook','Lab','2026-03-19','found'),(10,25,'Earphones','Electronics','White earphones','Cafeteria','2026-03-20','found'),(11,26,'Glasses','Accessories','Black frame specs','Library','2026-03-21','found'),(12,27,'Umbrella','Personal','Black umbrella','Entrance Gate','2026-03-22','found'),(13,28,'Calculator','Electronics','Casio calculator','Classroom','2026-03-23','found'),(14,29,'Pen Drive','Electronics','16GB USB','Lab','2026-03-24','found'),(15,30,'Jacket','Clothing','Grey hoodie','Playground','2026-03-25','found'),(16,17,'cap','Accessories','blue,adidas ','library','2026-03-04','claimed'),(17,17,'pouch','Accessories','red,blue stripes','library','2026-04-05','claimed'),(18,17,'cap','Accessories','red','library','2026-04-04','claimed'),(19,17,'scale','Accessories','metal','rooms','2026-04-03','claimed');
/*!40000 ALTER TABLE `found_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lost_items`
--

DROP TABLE IF EXISTS `lost_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lost_items` (
  `lost_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `item_name` varchar(100) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `location` varchar(100) DEFAULT NULL,
  `date_lost` date DEFAULT NULL,
  `status` enum('lost','claimed') DEFAULT 'lost',
  PRIMARY KEY (`lost_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `lost_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lost_items`
--

LOCK TABLES `lost_items` WRITE;
/*!40000 ALTER TABLE `lost_items` DISABLE KEYS */;
INSERT INTO `lost_items` VALUES (1,1,'Wallet','Accessories','Black leather wallet','Library','2026-03-10','lost'),(2,2,'Phone','Electronics','Samsung phone with cracked screen','Cafeteria','2026-03-11','lost'),(3,3,'ID Card','Documents','College ID card','Auditorium','2026-03-12','lost'),(4,4,'Backpack','Bags','Blue Nike backpack','Bus Stop','2026-03-13','lost'),(5,5,'Keys','Accessories','Set of house keys with red keychain','Parking Lot','2026-03-14','lost'),(6,6,'Watch','Accessories','Silver wrist watch','Gym','2026-03-15','lost'),(7,7,'Laptop','Electronics','HP laptop in black sleeve','Library','2026-03-16','lost'),(8,8,'Water Bottle','Personal','Steel bottle with stickers','Classroom','2026-03-17','lost'),(9,9,'Notebook','Stationery','Math notes notebook','Lab','2026-03-18','lost'),(10,10,'Earphones','Electronics','White wired earphones','Cafeteria','2026-03-19','lost'),(11,11,'Glasses','Accessories','Black frame specs','Library','2026-03-20','lost'),(12,12,'Umbrella','Personal','Foldable black umbrella','Entrance Gate','2026-03-21','lost'),(13,13,'Calculator','Electronics','Casio scientific calculator','Classroom','2026-03-22','lost'),(14,14,'Pen Drive','Electronics','16GB USB drive','Lab','2026-03-23','lost'),(15,15,'Jacket','Clothing','Grey hoodie','Playground','2026-03-24','lost'),(16,17,'gel pen','Accessories','blue color,red striped','stairs','2026-03-03','lost'),(17,17,'pouch','Accessories','blue,red striped','library','2026-04-04','lost'),(18,17,'cap','Accessories','red','stairs','2026-04-10','lost'),(19,17,'calculator','Accessories','casio ','canteen','2026-04-02','lost'),(20,17,'pencil','Accessories','camlin,red.yellow stripes','library','2026-04-02','lost'),(21,17,'ring','Accessories','diamond','canteen','2026-03-31','lost'),(22,17,'cap','Accessories','white','stairs','2026-04-02','lost'),(23,17,'eraser','Accessories','apsara','room','2026-04-03','lost'),(24,17,'scale','Accessories','metal','room','2026-03-31','lost'),(25,17,'Laptop','Accessories','Dell,black,i3','library','2026-04-02','lost');
/*!40000 ALTER TABLE `lost_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Aarav Sharma','aarav1@gmail.com','pass301','user'),(2,'Diya Patel','diya1@gmail.com','pass302','user'),(3,'Rohan Verma','rohan1@gmail.com','pass303','user'),(4,'Sneha Iyer','sneha1@gmail.com','pass304','user'),(5,'Karan Mehta','karan1@gmail.com','pass305','user'),(6,'Ananya Reddy','ananya1@gmail.com','pass306','user'),(7,'Vikram Singh','vikram1@gmail.com','pass307','user'),(8,'Pooja Nair','pooja1@gmail.com','pass308','user'),(9,'Aditya Gupta','aditya1@gmail.com','pass309','user'),(10,'Meera Joshi','meera1@gmail.com','pass310','user'),(11,'Rahul Das','rahul1@gmail.com','pass311','user'),(12,'Neha Kapoor','neha1@gmail.com','pass312','user'),(13,'Arjun Pillai','arjun1@gmail.com','pass313','user'),(14,'Kavya Menon','kavya1@gmail.com','pass314','user'),(15,'Siddharth Jain','sid1@gmail.com','pass315','user'),(16,'Ishita Bose','ishita1@gmail.com','pass316','user'),(17,'Manish Yadav','manish1@gmail.com','pass317','user'),(18,'Ritika Sharma','ritika1@gmail.com','pass318','user'),(19,'Deepak Kumar','deepak1@gmail.com','pass319','user'),(20,'Shreya Banerjee','shreya1@gmail.com','pass320','user'),(21,'Nikhil Rao','nikhil1@gmail.com','pass321','user'),(22,'Tanvi Kulkarni','tanvi1@gmail.com','pass322','user'),(23,'Harsh Agarwal','harsh1@gmail.com','pass323','user'),(24,'Priya Choudhary','priya1@gmail.com','pass324','user'),(25,'Varun Malhotra','varun1@gmail.com','pass325','user'),(26,'Aditi Mishra','aditi1@gmail.com','pass326','user'),(27,'Yash Thakur','yash1@gmail.com','pass327','user'),(28,'Simran Kaur','simran1@gmail.com','pass328','user'),(29,'Ravi Teja','ravi1@gmail.com','pass329','user'),(30,'Divya Shetty','divya1@gmail.com','pass330','admin');
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

-- Dump completed on 2026-04-02 13:29:10
