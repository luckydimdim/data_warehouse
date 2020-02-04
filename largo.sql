-- MariaDB dump 10.17  Distrib 10.4.6-MariaDB, for osx10.14 (x86_64)
--
-- Host: localhost    Database: largo
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
  `order_id` int(11) NOT NULL DEFAULT 0,
  `order_number` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `order_positions` varchar(255) NOT NULL,
  `period_id` int(11) NOT NULL DEFAULT 0,
  `partner_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `user_name_and_surname` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_phone` varchar(255) NOT NULL,
  `user_generation` int(11) NOT NULL DEFAULT 0,
  `user_package_name` varchar(255) NOT NULL,
  `activation` tinyint(1) NOT NULL DEFAULT 0,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `points` decimal(12,4) DEFAULT 0.0000,
  `money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `status` varchar(255) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `utm_source` varchar(255) NOT NULL DEFAULT '',
  `utm_medium` varchar(255) NOT NULL DEFAULT '',
  `utm_campaign` varchar(255) NOT NULL DEFAULT '',
  `utm_term` varchar(255) NOT NULL DEFAULT '',
  `utm_content` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_cmb_accruals_period_id_order_id_partner_id_user_id_status_pk` (`period_id`,`order_id`,`partner_id`,`user_id`,`status`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_datetime_index` (`partner_id`,`period_id`,`created`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_activation_index` (`partner_id`,`period_id`,`activation`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_base_price_index` (`partner_id`,`period_id`,`base_price`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_money_index` (`partner_id`,`period_id`,`money`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_order_id_index` (`partner_id`,`period_id`,`order_id`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_order_number_index` (`partner_id`,`period_id`,`order_number`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_order_pos_index` (`partner_id`,`period_id`,`order_positions`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_points_index` (`partner_id`,`period_id`,`points`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_price_index` (`partner_id`,`period_id`,`price`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_user_email_index` (`partner_id`,`period_id`,`user_email`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_user_gen_index` (`partner_id`,`period_id`,`user_generation`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_user_id_index` (`partner_id`,`period_id`,`user_id`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_user_name_index` (`partner_id`,`period_id`,`user_name_and_surname`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_user_package_index` (`partner_id`,`period_id`,`user_package_name`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_user_phone_index` (`partner_id`,`period_id`,`user_phone`),
  KEY `iva_summary_cmb_accruals_period_id_order_id_index` (`period_id`,`order_id`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_utm_campaign_index` (`partner_id`,`period_id`,`utm_campaign`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_utm_content_index` (`partner_id`,`period_id`,`utm_content`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_utm_medium_index` (`partner_id`,`period_id`,`utm_medium`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_utm_source_index` (`partner_id`,`period_id`,`utm_source`),
  KEY `iva_summary_cmb_accruals_partner_id_period_id_utm_term_index` (`partner_id`,`period_id`,`utm_term`),
  KEY `iva_cmb_accruals_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6182309 DEFAULT CHARSET=utf8;
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
  UNIQUE KEY `iva_cmb_orders_order_id_pk` (`order_id`),
  KEY `iva_cmb_orders_status_user_id_price_index` (`status`,`user_id`,`price`)
) ENGINE=InnoDB AUTO_INCREMENT=962530 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_accruals`
--

DROP TABLE IF EXISTS `iva_mp_accruals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_accruals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) NOT NULL DEFAULT 0,
  `order_positions` varchar(255) NOT NULL,
  `order_price` decimal(9,2) NOT NULL DEFAULT 0.00,
  `user_name_and_surname` varchar(255) NOT NULL,
  `partner_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `user_email` varchar(255) NOT NULL,
  `user_phone` varchar(255) NOT NULL,
  `user_package_name` varchar(255) NOT NULL,
  `user_generation` int(11) NOT NULL DEFAULT 0,
  `user_activation` tinyint(1) NOT NULL DEFAULT 0,
  `kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ko` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_datetime_index` (`partner_id`,`period_id`,`created`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_activation_index` (`partner_id`,`period_id`,`user_activation`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_bo_index` (`partner_id`,`period_id`,`bo`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_bs_index` (`partner_id`,`period_id`,`bs`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_gb_index` (`partner_id`,`period_id`,`gb`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_go_index` (`partner_id`,`period_id`,`go`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_ko_index` (`partner_id`,`period_id`,`ko`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_kp_index` (`partner_id`,`period_id`,`kp`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_lb_index` (`partner_id`,`period_id`,`lb`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_money_index` (`partner_id`,`period_id`,`money`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_o1l_index` (`partner_id`,`period_id`,`o1l`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_order_id_index` (`partner_id`,`period_id`,`order_id`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_order_pos_index` (`partner_id`,`period_id`,`order_positions`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_order_price_index` (`partner_id`,`period_id`,`order_price`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_points_index` (`partner_id`,`period_id`,`points`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_sb_index` (`partner_id`,`period_id`,`sb`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_user_email_index` (`partner_id`,`period_id`,`user_email`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_user_gen_index` (`partner_id`,`period_id`,`user_generation`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_user_n_and_s_index` (`partner_id`,`period_id`,`user_name_and_surname`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_user_pack_index` (`partner_id`,`period_id`,`user_package_name`),
  KEY `iva_summary_mp_accruals_partner_id_period_id_user_phone_index` (`partner_id`,`period_id`,`user_phone`),
  KEY `iva_mp_accruals_user_id_index` (`user_id`),
  KEY `iva_mp_accruals_period_id_index` (`period_id`)
) ENGINE=InnoDB AUTO_INCREMENT=665528 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_customer_roots`
--

DROP TABLE IF EXISTS `iva_mp_customer_roots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_customer_roots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period_id` int(11) NOT NULL DEFAULT 0,
  `depth` int(11) NOT NULL DEFAULT 0,
  `is_leaf` tinyint(1) NOT NULL DEFAULT 0,
  `child_is_new` tinyint(1) NOT NULL DEFAULT 0,
  `parent_is_new` tinyint(1) NOT NULL DEFAULT 0,
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `parent_email` varchar(255) NOT NULL,
  `parent_name_and_surname` varchar(255) NOT NULL,
  `parent_package_name` varchar(255) NOT NULL,
  `parent_kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `parent_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_id` int(11) NOT NULL DEFAULT 0,
  `child_email` varchar(255) NOT NULL,
  `child_name_and_surname` varchar(255) NOT NULL,
  `child_package_name` varchar(255) NOT NULL,
  `child_kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_sb` decimal(12,4) NOT NULL,
  `child_bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `child_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `is_box` tinyint(1) NOT NULL DEFAULT 0,
  `box_order_id` int(11) NOT NULL DEFAULT 0,
  `box_order_name` varchar(255) NOT NULL DEFAULT '',
  `box_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_mp_customer_roots_perid_pid_cid_boid_pk` (`period_id`,`parent_id`,`child_id`,`box_order_id`),
  KEY `iva_summary_bonus_tree_child_id_depth_index_2` (`parent_id`,`period_id`),
  KEY `iva_summary_bonus_tree_period_id_child_id_index` (`period_id`,`child_id`),
  KEY `iva_mp_customer_roots_child_id_index` (`child_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41968805 DEFAULT CHARSET=utf8;
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
  `order_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `period_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_package_id` int(11) DEFAULT NULL,
  `user_has_business` int(11) NOT NULL DEFAULT 0,
  `price` decimal(9,2) NOT NULL DEFAULT 0.00,
  `is_test` int(11) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'new',
  `accruals_status` varchar(255) NOT NULL DEFAULT 'n',
  `order_package_id` int(11) DEFAULT NULL,
  `order_package_name` varchar(255) DEFAULT NULL,
  `order_subscription_in_month` int(11) DEFAULT NULL,
  `package_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `subscription_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sequence` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_total_orders_id_uindex` (`id`),
  UNIQUE KEY `iva_total_orders_order_id_pk` (`order_id`),
  KEY `iva_total_orders_user_id_index` (`user_id`),
  KEY `iva_total_orders_id_user_id_datetime_index` (`id`,`user_id`,`created`),
  KEY `iva_total_orders_id_user_id_period_id_index` (`id`,`user_id`,`period_id`),
  KEY `iva_total_orders_period_id_index` (`period_id`),
  KEY `iva_mp_orders_status_user_id_price_index` (`status`,`user_id`,`price`)
) ENGINE=InnoDB AUTO_INCREMENT=98583 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_mp_position_packages`
--

DROP TABLE IF EXISTS `iva_mp_position_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_mp_position_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total_position_id` int(11) NOT NULL,
  `for_package_id` int(11) DEFAULT NULL,
  `package_id` int(11) DEFAULT NULL,
  `subscription_duration_in_month` int(11) DEFAULT NULL,
  `package_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `subsription_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_total_positions_packages_id_uindex` (`id`),
  KEY `iva_total_positions_packages_total_position_id_index` (`total_position_id`),
  KEY `iva_total_positions_packages_position_and_prices` (`total_position_id`,`package_price`,`subsription_price`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_package_commissions`
--

DROP TABLE IF EXISTS `iva_package_commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_package_commissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) NOT NULL DEFAULT 0,
  `package_name` varchar(255) NOT NULL DEFAULT 'Silver',
  `value` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_package_discounts`
--

DROP TABLE IF EXISTS `iva_package_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_package_discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) NOT NULL DEFAULT 0,
  `package_name` varchar(255) NOT NULL DEFAULT 'Silver',
  `value` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_packages`
--

DROP TABLE IF EXISTS `iva_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_packages` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `alias` varchar(255) NOT NULL,
  `ratio` decimal(9,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_periods`
--

DROP TABLE IF EXISTS `iva_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_periods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start` datetime NOT NULL,
  `finish` datetime NOT NULL,
  `name` varchar(255) NOT NULL,
  `withdrawal_start` datetime DEFAULT NULL,
  `is_closed` tinyint(1) NOT NULL DEFAULT 0,
  `is_current` tinyint(1) NOT NULL DEFAULT 0,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `iva_bonus_periods_start_is_closed_index` (`start`,`is_closed`),
  KEY `iva_bonus_periods_is_current_index` (`is_current`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_profits`
--

DROP TABLE IF EXISTS `iva_profits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_profits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `period_id` int(11) NOT NULL DEFAULT 0,
  `period_name` varchar(255) DEFAULT NULL,
  `activation` tinyint(1) NOT NULL DEFAULT 0,
  `go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `osv` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ko` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `k` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `qualification_name` varchar(255) NOT NULL DEFAULT '',
  `kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ks` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `extra_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `extra_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `extra_name` varchar(255) NOT NULL DEFAULT 'Дополнительное вознаграждение',
  `total_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `available_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_user_accruals_period_id_user_id_pk` (`period_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=535010 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_qualifications`
--

DROP TABLE IF EXISTS `iva_qualifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_qualifications` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `percent` decimal(12,4) NOT NULL,
  `lower_bound` decimal(12,4) NOT NULL,
  `upper_bound` decimal(12,4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_user_branches`
--

DROP TABLE IF EXISTS `iva_user_branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_user_branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `child_id` int(11) NOT NULL DEFAULT 0,
  `depth` int(11) NOT NULL DEFAULT 0,
  `is_leaf` tinyint(1) NOT NULL DEFAULT 0,
  `partner_id` int(11) NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `package_id` int(11) NOT NULL DEFAULT 0,
  `package_name` varchar(255) NOT NULL,
  `has_business` tinyint(1) NOT NULL DEFAULT 0,
  `subscription_expire` datetime DEFAULT NULL,
  `is_subscription_expired` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) NOT NULL,
  `name_and_surname` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `birthdate` datetime DEFAULT NULL,
  `activation` tinyint(1) NOT NULL DEFAULT 0,
  `go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `osv` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `generation` int(11) NOT NULL DEFAULT 0,
  `k` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `qualification_name` varchar(255) NOT NULL,
  `kp` decimal(9,2) NOT NULL DEFAULT 0.00,
  `ks` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ko` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `team_size` int(11) NOT NULL DEFAULT 0,
  `is_trash` tinyint(1) NOT NULL DEFAULT 0,
  `total_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `is_password_expired` tinyint(1) NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_user_branches_is_trash_parent_id_child_id_pk` (`is_trash`,`parent_id`,`child_id`),
  KEY `iva_summary_parents_children_is_trash_child_id_index` (`is_trash`,`child_id`),
  KEY `iva_summary_parents_children_is_trash_cmb_money_index` (`is_trash`,`cmb_money`),
  KEY `iva_summary_parents_children_is_trash_email_index` (`is_trash`,`email`),
  KEY `iva_summary_parents_children_is_trash_mp_money_index` (`is_trash`,`mp_money`),
  KEY `iva_summary_parents_children_is_trash_parent_id_activation_index` (`is_trash`,`parent_id`,`activation`),
  KEY `iva_summary_parents_children_is_trash_parent_id_bs_index` (`is_trash`,`parent_id`,`bs`),
  KEY `iva_summary_parents_children_is_trash_parent_id_child_id_index` (`is_trash`,`parent_id`,`child_id`),
  KEY `iva_summary_parents_children_is_trash_parent_id_cmb_money_index` (`is_trash`,`parent_id`,`cmb_money`),
  KEY `iva_summary_parents_children_is_trash_parent_id_cmb_points_index` (`is_trash`,`parent_id`,`cmb_points`),
  KEY `iva_summary_parents_children_is_trash_parent_id_email_index` (`is_trash`,`parent_id`,`email`),
  KEY `iva_summary_parents_children_is_trash_parent_id_gb_index` (`is_trash`,`parent_id`,`gb`),
  KEY `iva_summary_parents_children_is_trash_parent_id_gen_index` (`is_trash`,`parent_id`,`generation`),
  KEY `iva_summary_parents_children_is_trash_parent_id_go_index` (`is_trash`,`parent_id`,`go`),
  KEY `iva_summary_parents_children_is_trash_parent_id_index` (`is_trash`,`parent_id`),
  KEY `iva_summary_parents_children_is_trash_parent_id_ko_index` (`is_trash`,`parent_id`,`ko`),
  KEY `iva_summary_parents_children_is_trash_parent_id_kp_index` (`is_trash`,`parent_id`,`kp`),
  KEY `iva_summary_parents_children_is_trash_parent_id_lb_index` (`is_trash`,`parent_id`,`lb`),
  KEY `iva_summary_parents_children_is_trash_parent_id_mp_money_index` (`is_trash`,`parent_id`,`mp_money`),
  KEY `iva_summary_parents_children_is_trash_parent_id_mp_points_index` (`is_trash`,`parent_id`,`mp_points`),
  KEY `iva_summary_parents_children_is_trash_parent_id_name_index` (`is_trash`,`parent_id`,`name_and_surname`),
  KEY `iva_summary_parents_children_is_trash_parent_id_o1l_index` (`is_trash`,`parent_id`,`o1l`),
  KEY `iva_summary_parents_children_is_trash_parent_id_osv_index` (`is_trash`,`parent_id`,`osv`),
  KEY `iva_summary_parents_children_is_trash_parent_id_phone_index` (`is_trash`,`parent_id`,`phone`),
  KEY `iva_summary_parents_children_is_trash_parent_id_q_name_index` (`is_trash`,`parent_id`,`qualification_name`),
  KEY `iva_summary_parents_children_is_trash_parent_id_sb_index` (`is_trash`,`parent_id`,`sb`),
  KEY `iva_summary_parents_children_is_trash_parent_id_total_m_index` (`is_trash`,`parent_id`,`total_money`),
  KEY `iva_summary_parents_children_is_trash_parent_id_total_p_index` (`is_trash`,`parent_id`,`total_points`),
  KEY `iva_summary_parents_children_ist_p_total_money_index` (`is_trash`,`parent_id`,`total_money`),
  KEY `iva_user_branches_is_trash_child_id_index` (`is_trash`,`child_id`),
  KEY `iva_user_branches_child_id_index` (`child_id`),
  KEY `iva_user_branches_parent_id_index` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5508233 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_user_groups`
--

DROP TABLE IF EXISTS `iva_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_user_group` (`group_id`,`user_id`),
  KEY `ix_user_group_group` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_user_packages`
--

DROP TABLE IF EXISTS `iva_user_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_user_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `old_package_id` int(11) NOT NULL,
  `old_package_name` varchar(255) NOT NULL,
  `old_package_expires` datetime DEFAULT NULL,
  `new_package_id` int(11) NOT NULL,
  `new_package_name` varchar(255) NOT NULL,
  `new_package_expires` datetime DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `period_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_package_history_id_uindex` (`id`),
  UNIQUE KEY `iva_user_packages_order_id_new_package_id_pk` (`order_id`,`new_package_id`),
  KEY `iva_package_history_user_id_index` (`user_id`),
  KEY `iva_package_history_old_package_id_old_package_name_index` (`old_package_id`,`old_package_name`),
  KEY `iva_package_history_new_package_id_new_package_name_index` (`new_package_id`,`new_package_name`),
  KEY `iva_package_history_datetime_index` (`created`),
  KEY `iva_package_history_new_package_name_user_id_datetime_index` (`new_package_name`,`user_id`,`created`),
  KEY `iva_package_history_user_id_datetime_index` (`user_id`,`created`)
) ENGINE=InnoDB AUTO_INCREMENT=88027 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_user_requisites`
--

DROP TABLE IF EXISTS `iva_user_requisites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_user_requisites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `face_type` varchar(255) DEFAULT NULL,
  `card_bik` varchar(255) DEFAULT NULL,
  `card_number` varchar(255) DEFAULT NULL,
  `card_account` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `bank_bik` varchar(255) DEFAULT NULL,
  `inn` varchar(255) DEFAULT NULL,
  `rs` varchar(255) DEFAULT NULL,
  `available_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_user_requisites_user_id_pk` (`user_id`),
  KEY `iva_user_requisites_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3261694 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_user_roots`
--

DROP TABLE IF EXISTS `iva_user_roots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_user_roots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_id` int(11) NOT NULL DEFAULT 0,
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `depth` int(11) NOT NULL DEFAULT 0,
  `is_leaf` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_user_roots_parent_id_child_id_pk` (`parent_id`,`child_id`),
  KEY `iva_users_tree_parent_id_child_id_index` (`parent_id`,`child_id`),
  KEY `iva_users_tree_child_id_is_leaf_index` (`child_id`,`is_leaf`),
  KEY `iva_users_tree_parent_id_index` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9150891 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_user_transfers`
--

DROP TABLE IF EXISTS `iva_user_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_user_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL,
  `old_parent_id` int(11) DEFAULT NULL,
  `new_parent_id` int(11) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `comment` varchar(255) DEFAULT '',
  `source` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `iva_transfer_history_id_uindex` (`id`),
  KEY `iva_transfer_history_user_id_index` (`user_id`),
  KEY `iva_transfer_history_datetime_index` (`created`),
  KEY `iva_transfer_history_parent_old_index` (`old_parent_id`),
  KEY `iva_transfer_history_parent_new_index` (`new_parent_id`),
  KEY `iva_transfer_history_manager_id_index` (`manager_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1115401 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_users`
--

DROP TABLE IF EXISTS `iva_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_users` (
  `id` int(11) NOT NULL,
  `login` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `name_and_surname` varchar(255) DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `email_extra` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `phone_extra` varchar(255) DEFAULT NULL,
  `birthdate` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `source` varchar(255) NOT NULL DEFAULT 'IVA',
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `package_id` int(11) NOT NULL DEFAULT 1697716,
  `package_name` varchar(255) NOT NULL DEFAULT 'Silver',
  `package_expires` datetime DEFAULT NULL,
  `is_package_expired` tinyint(1) NOT NULL DEFAULT 1,
  `is_trash` tinyint(1) NOT NULL DEFAULT 0,
  `confirmation_code` varchar(255) DEFAULT NULL,
  `sequre_token` varchar(255) DEFAULT NULL,
  `sequre_token_expires` datetime DEFAULT NULL,
  `has_business` tinyint(1) NOT NULL DEFAULT 0,
  `is_password_expired` tinyint(1) NOT NULL DEFAULT 0,
  `show_all_teams` tinyint(1) NOT NULL DEFAULT 0,
  `permanent_activation` tinyint(1) NOT NULL DEFAULT 0,
  `permanent_activation_till` datetime DEFAULT NULL,
  `email_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `activation` tinyint(1) DEFAULT 0,
  `go` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `o1l` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `osv` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bo` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ko` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `k` int(11) NOT NULL DEFAULT 0,
  `qualification_name` varchar(255) NOT NULL DEFAULT '',
  `kp` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `ks` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `lb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `kb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `bs` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `gb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sb` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `mp_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `cmb_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_points` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_money` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `team_size` int(11) NOT NULL DEFAULT 0,
  `available_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `is_special` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `iva_users_id_uindex` (`id`),
  UNIQUE KEY `iva_users_login_pk` (`login`),
  UNIQUE KEY `iva_users_parent_id_id_pk` (`parent_id`,`id`),
  KEY `b_user_ACTIVE_ID_index` (`is_trash`,`id`),
  KEY `b_user_ACTIVE_LOGIN_index` (`is_trash`,`login`),
  KEY `iva_users_permanent_activation_permanent_activation_till_index` (`permanent_activation`,`permanent_activation_till`),
  KEY `iva_users_activation_index` (`activation`),
  KEY `iva_users_available_amount_index` (`available_amount`),
  KEY `iva_users_cmb_index` (`cmb`),
  KEY `iva_users_total_money_index` (`total_money`),
  KEY `iva_users_package_name_is_package_expired_is_special_index` (`package_name`,`is_package_expired`,`is_special`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iva_withdrawals`
--

DROP TABLE IF EXISTS `iva_withdrawals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva_withdrawals` (
  `id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL DEFAULT 0,
  `login` varchar(255) DEFAULT NULL,
  `name_and_surname` varchar(255) DEFAULT NULL,
  `card_number` varchar(255) DEFAULT NULL,
  `card_account` varchar(255) DEFAULT NULL,
  `rs` varchar(255) DEFAULT NULL,
  `inn` varchar(255) DEFAULT NULL,
  `card_bik` varchar(255) DEFAULT NULL,
  `bank_bik` varchar(255) DEFAULT NULL,
  `original_name` varchar(255) DEFAULT NULL,
  `face_type` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `comission` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `vat` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `available_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `amount_after_vat` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `period_id` int(11) NOT NULL DEFAULT 0,
  UNIQUE KEY `iva_summary_withdrawals_id_pk` (`id`),
  KEY `iva_summary_withdrawals_id_index` (`id`),
  KEY `iva_summary_withdrawals_amount_after_vat_index` (`amount_after_vat`),
  KEY `iva_summary_withdrawals_amount_index` (`amount`),
  KEY `iva_summary_withdrawals_available_amount_index` (`available_amount`),
  KEY `iva_summary_withdrawals_bank_bik_index` (`bank_bik`),
  KEY `iva_summary_withdrawals_card_account_index` (`card_account`),
  KEY `iva_summary_withdrawals_card_bik_index` (`card_bik`),
  KEY `iva_summary_withdrawals_card_number_index` (`card_number`),
  KEY `iva_summary_withdrawals_comission_index` (`comission`),
  KEY `iva_summary_withdrawals_comment_index` (`comment`),
  KEY `iva_summary_withdrawals_datetime_index` (`created`),
  KEY `iva_summary_withdrawals_face_type_index` (`face_type`),
  KEY `iva_summary_withdrawals_inn_index` (`inn`),
  KEY `iva_summary_withdrawals_login_index` (`login`),
  KEY `iva_summary_withdrawals_name_and_surname_index` (`name_and_surname`),
  KEY `iva_summary_withdrawals_original_name_index` (`original_name`),
  KEY `iva_summary_withdrawals_period_id_user_id_index` (`period_id`,`user_id`),
  KEY `iva_summary_withdrawals_rs_index` (`rs`),
  KEY `iva_summary_withdrawals_status_index` (`status`),
  KEY `iva_summary_withdrawals_user_id_index` (`user_id`),
  KEY `iva_summary_withdrawals_vat_index` (`vat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-04 11:45:11
