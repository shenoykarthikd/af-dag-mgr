INSERT INTO dag_mgr
SELECT 0, 'DAG_3', 'DAG_1', 'DAG_1_Done', 'Y', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 'DAG_3', 'DAG_2', 'DAG_2_Done', 'Y', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 'DAG_3', NULL, '103', 'Y', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 'DAG_1', NULL, '101', 'Y', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 'DAG_2', NULL, '102', 'Y', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 'DAG_4', 'DAG_3', 'DAG_3_Done', 'Y', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP