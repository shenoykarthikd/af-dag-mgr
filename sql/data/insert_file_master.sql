INSERT INTO file_master
SELECT 0, 's3://bucket1/path1/file1.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 's3://bucket1/path1/file1.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 's3://bucket2/path2/file2.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 's3://bucket2/path2/file1.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 's3://bucket1/path1/file3.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 's3://bucket1/path1/file2.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
UNION ALL SELECT 0, 's3://bucket3/path3/file1.txt', 'Pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP