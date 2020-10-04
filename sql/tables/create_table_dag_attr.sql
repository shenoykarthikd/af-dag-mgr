CREATE TABLE `airflow`.`dag_attr` (
  `dag_id` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `unpaused_ts` timestamp NULL DEFAULT NULL,
  `paused_ts` timestamp NULL DEFAULT NULL,
  `is_active` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,  
  `created_ts` timestamp NULL DEFAULT NULL,
  `updated_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`dag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci