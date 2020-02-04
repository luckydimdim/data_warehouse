-- MariaDB dump 10.17  Distrib 10.4.6-MariaDB, for osx10.14 (x86_64)
--
-- Host: localhost    Database: libra
-- ------------------------------------------------------
-- Server version	10.4.6-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `iva_cmb_accruals`
--

DROP TABLE IF EXISTS `iva_cmb_accruals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_cmb_accruals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `points` decimal(12,4) DEFAULT 0.0000,
  `money` decimal(12,4) DEFAULT 0.0000,
  `period_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_bonus_courses_month_result_id_uindex` (`id`),
  UNIQUE KEY `iva_bonus_courses_month_result_period_id_user_id_pk` (`period_id`,`user_id`),
  KEY `iva_bonus_courses_month_result_datetime_index` (`created`),
  KEY `iva_bonus_courses_month_result_user_id_index` (`user_id`),
  KEY `iva_bonus_courses_month_result_period_id_index` (`period_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20917257 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_cmb_excepted_positions`
--

DROP TABLE IF EXISTS `iva_cmb_excepted_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_cmb_excepted_positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `iva_bonus_courses_exceptions_name_index` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_cmb_extra_accruals`
--

DROP TABLE IF EXISTS `iva_cmb_extra_accruals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_cmb_extra_accruals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `type` varchar(255) NOT NULL,
  `value` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `status` varchar(255) NOT NULL DEFAULT 'new',
  `period_id` int(11) NOT NULL DEFAULT 0,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_cmb_extra_accruals_order_id_type_pk` (`order_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=16788 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_cmb_orders`
--

DROP TABLE IF EXISTS `iva_cmb_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_cmb_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `order_number` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT 'completed',
  `period_id` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL DEFAULT 0,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `partial_payment_status` varchar(255) NOT NULL DEFAULT 'no',
  `utm_source` varchar(255) NOT NULL DEFAULT '',
  `utm_medium` varchar(255) NOT NULL DEFAULT '',
  `utm_campaign` varchar(255) NOT NULL DEFAULT '',
  `utm_term` varchar(255) NOT NULL DEFAULT '',
  `utm_content` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_cmb_orders_order_id_pk` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001613 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_cmb_transactions`
--

DROP TABLE IF EXISTS `iva_cmb_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_cmb_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `source_user_id` int(11) NOT NULL,
  `source_package_name` varchar(255) NOT NULL,
  `target_user_id` int(11) NOT NULL,
  `target_package_name` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `comment` varchar(255) DEFAULT NULL,
  `period_id` int(11) NOT NULL DEFAULT 0,
  `modified` datetime DEFAULT NULL,
  `is_leaf` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL DEFAULT 'new',
  PRIMARY KEY (`id`),
  KEY `iva_bonus_courses_source_user_id_index` (`source_user_id`),
  KEY `iva_bonus_courses_target_user_id_index` (`target_user_id`),
  KEY `iva_bonus_courses_datetime_index` (`created`),
  KEY `iva_bonus_courses_source_user_id_datetime_order_id_index` (`source_user_id`,`created`,`order_id`),
  KEY `iva_bonus_courses_stud` (`source_user_id`,`target_user_id`,`order_id`,`created`),
  KEY `iva_bonus_courses_order_id_index` (`order_id`),
  KEY `iva_bonus_courses_period_id_index` (`period_id`),
  KEY `iva_bonus_courses_source_user_id_period_id_order_id_index` (`source_user_id`,`period_id`,`order_id`),
  KEY `iva_bonus_courses_source_user_id_tuid_oid_pid_index` (`source_user_id`,`target_user_id`,`order_id`,`period_id`),
  KEY `iva_bonus_courses_source_uid_pid_oid_index` (`source_user_id`,`period_id`,`order_id`),
  KEY `iva_bonus_courses_order_id_is_leaf_index` (`order_id`,`is_leaf`),
  KEY `iva_cmb_transactions_period_id_target_user_id_index` (`period_id`,`target_user_id`),
  KEY `iva_cmb_transactions_period_id_order_id_status_index` (`period_id`,`order_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4892250 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_extra_profits`
--

DROP TABLE IF EXISTS `iva_extra_profits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_extra_profits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) NOT NULL DEFAULT 0,
  `comment` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_extra_profits_period_id_user_id_pk` (`period_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_accruals`
--

DROP TABLE IF EXISTS `iva_mp_accruals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_accruals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `package_name` varchar(255) NOT NULL DEFAULT '',
  `activation` tinyint(1) NOT NULL DEFAULT 0,
  `go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `osv` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ks` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ko` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `k` int(11) NOT NULL DEFAULT 0,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_bonus_month_result_period_id_user_id_pk` (`period_id`,`user_id`),
  KEY `iva_bonus_month_result_activation_user_id_index` (`activation`,`user_id`),
  KEY `iva_bonus_month_result_period_id_user_id_kp_index` (`period_id`,`user_id`,`kp`)
) ENGINE=InnoDB AUTO_INCREMENT=176218 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_order_accruals`
--

DROP TABLE IF EXISTS `iva_mp_order_accruals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_order_accruals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) DEFAULT NULL,
  `package_name` varchar(255) NOT NULL DEFAULT '',
  `activation` tinyint(1) DEFAULT 0,
  `go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `osv` decimal(12,4) DEFAULT 0.0000,
  `bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ks` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ko` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb` decimal(12,4) DEFAULT 0.0000,
  `k` int(11) NOT NULL DEFAULT 0,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_qualification_history_id_uindex` (`id`),
  UNIQUE KEY `iva_mp_order_accruals_order_id_user_id_pk` (`order_id`,`user_id`),
  KEY `iva_qualification_history_datetime_index` (`created`),
  KEY `iva_qualification_history_user_id_index` (`user_id`),
  KEY `iva_qualification_history_kp_index` (`kp`),
  KEY `iva_qualification_history_order_id_index` (`order_id`),
  KEY `iva_bonus_history_period_id_index` (`period_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28149694 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_order_positions`
--

DROP TABLE IF EXISTS `iva_mp_order_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_order_positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `total_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT '',
  `quantity` int(11) NOT NULL DEFAULT 0,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `currency` varchar(3) DEFAULT NULL,
  `period_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_total_order_positions_id_uindex` (`id`),
  KEY `iva_total_order_positions_order_id_index` (`order_id`),
  KEY `iva_total_order_positions_total_id_index` (`total_id`),
  KEY `iva_total_order_positions_order_id_amount_index` (`order_id`,`amount`)
) ENGINE=InnoDB AUTO_INCREMENT=297079 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_orders`
--

DROP TABLE IF EXISTS `iva_mp_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total_id` int(11) DEFAULT NULL,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_package_id` int(11) DEFAULT NULL,
  `user_has_business` int(11) NOT NULL DEFAULT 0,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `is_test` int(11) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'new',
  `accruals_status` varchar(255) NOT NULL DEFAULT 'n',
  `sequence` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_total_orders_order_id_pk` (`order_id`),
  KEY `iva_total_orders_user_id_index` (`user_id`),
  KEY `iva_total_orders_id_user_id_datetime_index` (`id`,`user_id`,`created`),
  KEY `iva_total_orders_id_user_id_period_id_index` (`id`,`user_id`,`period_id`),
  KEY `iva_total_orders_period_id_index` (`period_id`,`status`,`order_id`,`accruals_status`)
) ENGINE=InnoDB AUTO_INCREMENT=81075 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_transactions`
--

DROP TABLE IF EXISTS `iva_mp_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL DEFAULT 'user',
  `order_id` int(11) NOT NULL,
  `source` varchar(255) DEFAULT NULL,
  `source_user_id` int(11) NOT NULL,
  `source_package_name` varchar(255) DEFAULT '',
  `target_user_id` int(11) DEFAULT NULL,
  `target_package_name` varchar(255) DEFAULT '',
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) DEFAULT NULL,
  `go_package` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `go_subscribe` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l_package` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l_subscribe` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `status` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`order_id`,`id`),
  UNIQUE KEY `iva_bonus_id_uindex` (`id`),
  KEY `iva_bonus_datetime_index` (`created`),
  KEY `iva_bonus_datetime_target_user_id_index` (`created`,`target_user_id`),
  KEY `iva_bonus_o1l_package_datetime_target_user_id_index` (`o1l_package`,`created`,`target_user_id`),
  KEY `iva_bonus_order_id_target_user_id_source_user_id_index` (`order_id`,`target_user_id`,`source_user_id`),
  KEY `iva_bonus_period_id_o1l_package_index` (`period_id`,`o1l_package`),
  KEY `iva_bonus_period_id_order_id_source_user_id_index` (`period_id`,`order_id`,`source_user_id`),
  KEY `iva_bonus_period_id_order_id_target_user_id_index` (`period_id`,`order_id`,`target_user_id`),
  KEY `iva_bonus_period_id_order_id_type_index` (`period_id`,`order_id`,`type`),
  KEY `iva_bonus_period_id_source_user_id_target_user_id_index` (`period_id`,`source_user_id`,`target_user_id`),
  KEY `iva_bonus_period_id_type_source_user_id_index` (`period_id`,`type`,`source_user_id`),
  KEY `iva_bonus_period_id_type_target_user_id_index` (`period_id`,`type`,`target_user_id`),
  KEY `iva_bonus_source_index` (`source`),
  KEY `iva_bonus_source_user_id_datetime_order_id_index` (`source_user_id`,`created`,`order_id`),
  KEY `iva_bonus_source_user_id_index` (`source_user_id`),
  KEY `iva_bonus_source_user_id_target_user_id_datetime_index` (`source_user_id`,`target_user_id`,`created`),
  KEY `iva_bonus_target_user_id_index` (`target_user_id`),
  KEY `iva_bonus_target_user_id_type_datetime_order_id_index` (`target_user_id`,`type`,`created`,`order_id`),
  KEY `iva_bonus_type_index` (`type`),
  KEY `iva_bonus_period_id_status_target_user_id_sequence_index` (`period_id`,`status`,`target_user_id`,`sequence`)
) ENGINE=InnoDB AUTO_INCREMENT=607230 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_user_branches`
--

DROP TABLE IF EXISTS `iva_mp_user_branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_user_branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `parent_go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_ignored` tinyint(1) NOT NULL DEFAULT 0,
  `parent_kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_id` int(11) NOT NULL DEFAULT 0,
  `child_go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_ignored` tinyint(1) NOT NULL DEFAULT 0,
  `child_kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_package_name` varchar(255) NOT NULL DEFAULT '',
  `depth` int(11) NOT NULL DEFAULT 0,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `order_created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) NOT NULL DEFAULT 0,
  `is_box` tinyint(1) NOT NULL DEFAULT 0,
  `is_new` tinyint(1) NOT NULL DEFAULT 0,
  `box_order_id` int(11) NOT NULL DEFAULT 0,
  `points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `is_first_line` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `iva_bonus_roots_order_id_child_id_index` (`order_id`,`child_id`),
  KEY `iva_bonus_roots_order_id_parent_id_is_new_index` (`order_id`,`parent_id`,`is_new`),
  KEY `iva_mp_customer_branches_period_id_index` (`period_id`),
  KEY `iva_mp_user_branches_oid_pid_cid_d_pkp_ckp_index` (`order_id`,`depth`,`parent_id`,`child_id`,`parent_kp`,`child_kp`)
) ENGINE=InnoDB AUTO_INCREMENT=197370091 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_user_roots`
--

DROP TABLE IF EXISTS `iva_mp_user_roots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_user_roots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `child_id` int(11) NOT NULL DEFAULT 0,
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `depth` int(11) NOT NULL DEFAULT 0,
  `is_leaf` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_mp_customer_roots_order_id_parent_id_child_id_pk` (`order_id`,`parent_id`,`child_id`),
  KEY `iva_bonus_tree_order_id_child_id_depth_is_leaf_index` (`order_id`,`child_id`,`depth`,`is_leaf`),
  KEY `iva_bonus_tree_order_id_child_id_is_leaf_index` (`order_id`,`child_id`,`is_leaf`),
  KEY `iva_bonus_tree_order_id_parent_id_child_id_is_leaf_index` (`order_id`,`parent_id`,`child_id`,`is_leaf`),
  KEY `iva_bonus_tree_order_id_parent_id_is_leaf_index` (`order_id`,`parent_id`,`is_leaf`),
  KEY `iva_mp_customer_roots_period_id_order_id_child_id_depth_index` (`period_id`,`order_id`,`child_id`,`depth`),
  KEY `iva_mp_customer_roots_period_id_order_id_is_leaf_index` (`period_id`,`order_id`,`is_leaf`)
) ENGINE=InnoDB AUTO_INCREMENT=81552870 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_temp`
--

DROP TABLE IF EXISTS `iva_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL DEFAULT '',
  `amount` decimal(12,4) DEFAULT 0.0000,
  `user_id` int(11) DEFAULT NULL,
  `iva_order_id` int(11) DEFAULT NULL,
  `iva_amount` decimal(12,4) DEFAULT NULL,
  `iva_email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91902 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_users`
--

DROP TABLE IF EXISTS `iva_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `modified` datetime DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `email_extra` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) DEFAULT NULL,
  `phone_extra` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `partner_id` int(11) NOT NULL DEFAULT 0,
  `partner_email` varchar(255) NOT NULL DEFAULT '',
  `external_discount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `has_purchases` tinyint(1) NOT NULL DEFAULT 0,
  `package_id` int(11) NOT NULL DEFAULT 1697716,
  `package_name` varchar(255) NOT NULL DEFAULT 'Silver',
  `package_expires` datetime DEFAULT NULL,
  `birthdate` datetime DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `is_password_expired` tinyint(1) NOT NULL DEFAULT 0,
  `password` varchar(255) DEFAULT NULL,
  `face_type` varchar(255) DEFAULT NULL,
  `card_bik` varchar(255) DEFAULT NULL,
  `card_number` varchar(255) DEFAULT NULL,
  `card_account` varchar(255) DEFAULT NULL,
  `user_full_name` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `bank_bik` varchar(255) DEFAULT NULL,
  `inn` varchar(255) DEFAULT NULL,
  `rs` varchar(255) DEFAULT NULL,
  `external_package_id` int(11) NOT NULL DEFAULT 1697716,
  `external_package_name` varchar(255) NOT NULL DEFAULT 'Silver',
  `external_partner_id` int(11) NOT NULL DEFAULT 0,
  `external_partner_email` varchar(255) NOT NULL DEFAULT '',
  `other` int(11) DEFAULT NULL,
  `is_special` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_users_user_id_pk` (`user_id`),
  UNIQUE KEY `iva_users_email_pk` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=809167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_withdrawals`
--

DROP TABLE IF EXISTS `iva_withdrawals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_withdrawals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT current_timestamp(),
  `modified` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(12,4) DEFAULT 0.0000,
  `comission` decimal(12,4) DEFAULT 0.0000,
  `vat` decimal(12,4) DEFAULT 0.0000,
  `available_amount` decimal(12,4) DEFAULT 0.0000,
  `amount_after_vat` decimal(12,4) DEFAULT 0.0000,
  `destination` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_accountant_requests_id_uindex` (`id`),
  KEY `iva_accountant_requests_user_id_status_index` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=750 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `table2`
--

DROP TABLE IF EXISTS `table2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table2` (
  `id` int(11) NOT NULL DEFAULT 0,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `email` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-04 11:45:23
