CREATE TABLE `airflow`.`dag_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dag_id` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `is_paused` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100001 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci