CREATE TABLE `airflow`.`file_master` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT,
  `file_path` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,  
  `created_ts` timestamp NULL DEFAULT NULL,
  `updated_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci