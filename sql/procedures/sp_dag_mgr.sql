CREATE PROCEDURE `airflow`.`sp_dag_mgr`()
BEGIN
	
	DROP TABLE IF EXISTS PAUSE_DAG;
	DROP TABLE IF EXISTS DAG_TEMP;
	DROP TABLE IF EXISTS DAG_UP_TEMP;


	CREATE TEMPORARY TABLE PAUSE_DAG
	SELECT DISTINCT
		da.dag_id
	FROM
		dag_attr da
		INNER JOIN dag_run dr
			on dr.dag_id = da.dag_id
		INNER JOIN dag d
			on dr.dag_id = d.dag_id
	WHERE
		d.is_paused = 0
		and da.is_active != 'N'
		and da.unpaused_ts is not null                            
		and da.unpaused_ts < dr.end_date
		and dr.state != 'running'    
		and not exists (
			select 
				1
			from
				dag_run dr1
			where
				dr1.dag_id = da.dag_id
				and dr1.state = 'running'
		);	
	
	UPDATE
		dag d
		INNER JOIN PAUSE_DAG p
			on p.dag_id = d.dag_id       
	SET
		d.is_paused = 1
	WHERE
		d.is_paused = 0;   	
	
	UPDATE
		dag_attr da
		INNER JOIN PAUSE_DAG p
			on p.dag_id = da.dag_id 
	SET
		da.paused_ts = CURRENT_TIMESTAMP,
		da.updated_ts = CURRENT_TIMESTAMP; 

	INSERT INTO dag_log
	SELECT
		0,
		dag_id,
		1,
		CURRENT_TIMESTAMP
	FROM
		PAUSE_DAG
	
	CREATE TEMPORARY TABLE DAG_TEMP
	SELECT DISTINCT  
		dag_id,
		FW_IND
	FROM 
		(
			SELECT 
				dag_id , 
				1 as FW_IND
			FROM 
			(
				SELECT
					dm.dag_id as dag_id , 
					min(case when fi.file_id is not null then 1 else 0 end) as file_arrival
				FROM 
					dag_mgr dm
					LEFT JOIN 
					(
						SELECT DISTINCT
							file_id 
					   FROM 
							file_master fm 
							INNER JOIN file_event fe 
								on fe.file_path = fm.file_path
					    WHERE 
							fm.is_active != 'N'
							fe.status='Pending'
					) fi 
						on dm.up_dag_id = fi.file_id
				WHERE
					dm.is_active != 'N' 
					AND dm.up_task_id IS NULL
				GROUP BY
					dm.dag_id
			) X
			WHERE
				file_arrival = 1
		UNION
		SELECT 
			dd2.dag_id as dag_id, 
			0 as FW_IND
		FROM 
			dag_mgr dd2
			INNER JOIN dag_attr da
				on dd2.dag_id = da.dag_id
			INNER JOIN dag d
				on dd2.dag_id = d.dag_id                                        
		WHERE
			dd2.is_active != 'N' 
			and da.is_active != 'N'
			AND d.is_paused = 1
			AND dd2.up_task_id IS NOT NULL 
			AND not exists 
			(
				SELECT 
					1 
				FROM 
					dag_mgr dd3
				WHERE
					dd3.is_active != 'N' 
					AND dd3.up_task_id IS NULL
					AND dd3.dag_id = dd2.dag_id
			)
			AND not exists 
			(
				SELECT
						1
				FROM
						task_instance ti
				WHERE 
						da.dag_id = ti.dag_id 
						and CURRENT_DATE <= cast(ti.end_date as date)
						and ti.state = 'success' 
			)
		) DAG_TEMP;


	CREATE TEMPORARY TABLE DAG_UP_TEMP
	SELECT DISTINCT
		dag_id
	FROM
	(
		SELECT
			dt.dag_id,
			min(case 
					when dm.up_task_id is not null 
						and run_date.up_dag_id is null 
						then 0 
					when dm.up_task_id is not null 
						and run_date.up_dag_id is not null 
						then 1 
					when fw_ind = 1 
						then 1 
					else 0 
				end) as completion_ind
		FROM
			DAG_TEMP dt
			INNER JOIN dag_mgr dm 
				on dt.dag_id = dm.dag_id
			INNER JOIN dag_attr child_da   
				on dt.dag_id = child_da.dag_id 
					and child_da.is_active != 'N'
			INNER JOIN dag_attr parent_da 
				on dm.up_dag_id = parent_da.dag_id	
					and parent_da.is_active != 'N'
			LEFT JOIN 
			(
				SELECT
					dm2.up_dag_id,
					dm2.up_task_id,
					max(ti.end_date) as end_date
				FROM
					task_instance ti
					INNER JOIN dag_mgr dm2 
						on dm2.up_dag_id  = ti.dag_id
						and dm2.up_task_id = ti.task_id 
					INNER JOIN dag_attr da 
						on dm2.up_dag_id = da.dag_id
				WHERE
					dm2.is_active != 'N'
					and da.is_active != 'N'
					and ti.state = 'success'
				group by
						1,
						2 
			) run_date 
				on child_da.paused_ts <= run_date.end_date
					and dm.up_dag_id = run_date.up_dag_id
					and dm.up_task_id = run_date.up_task_id
		WHERE
			dm.is_active != 'N'
		group by
			1
	) X
	WHERE 
		completion_ind = 1;

	
	UPDATE
		dag d
		INNER JOIN DAG_UP_TEMP u
			on d.dag_id = u.dag_id 
	SET
		d.is_paused = 0
	WHERE
		d.is_paused = 1;
			
	UPDATE
		dag_attr da
		INNER JOIN DAG_UP_TEMP u
			on da.dag_id = u.dag_id
	SET
		da.unpause_ts = CURRENT_TIMESTAMP,
		da.update_ts = CURRENT_TIMESTAMP;

	INSERT INTO dag_log
	SELECT
		0,
		dag_id,
		0,
		CURRENT_TIMESTAMP
	FROM
		DAG_UP_TEMP
		
	UPDATE
		file_event fe
		INNER JOIN file_master fm 
			on fe.file_path = fm.file_path
		inner join dag_mgr dm
			on fm.file_id = dm.up_dag_id
		inner join DAG_UP_TEMP u
			on dm.dag_id = u.dag_id 
	SET 
		fe.status = 'Completed',
		fe.updated_ts = CURRENT_TIMESTAMP
	where 
		dm.is_active != 'N'
		and fm.is_active != 'N'
		and fe.status = 'Pending';
	
	DROP TABLE IF EXISTS PAUSE_DAG;
	DROP TABLE IF EXISTS DAG_TEMP;
	DROP TABLE IF EXISTS DAG_UP_TEMP;

END