# af-dag-mgr

Airflow DAG manager is a database solution for managing and triggering upstream and downstream DAGs based on 
inter-dependencies among DAGs and file arrivals from other external systems

1) SQL Scripts need to be installed on an existing Airflow metadata database
2) Custom DAG can be created to run sp at an interval of every 1 minute
3) Another custom DAG to monitor files can be created to log file arrival into file_event table 
4) Reporting can be done on the new SQL tables via any standard Data Visualization tool