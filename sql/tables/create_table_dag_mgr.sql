CREATE TABLE `airflow`.`dag_mgr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dag_id` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `up_task_id` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `up_dag_id` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_ts` timestamp NULL DEFAULT NULL,
  `updated_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci