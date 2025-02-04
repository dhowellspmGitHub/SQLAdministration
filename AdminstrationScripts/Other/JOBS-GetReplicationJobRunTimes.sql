 
WITH SQLJobRunHistory (publisher_server, subscriber_server, publisher_db, publication, subscriber_db, agent_type,jobname,[enabled],category_id,category_class,category_name,step_id,run_status,run_date,run_time,run_duration)
AS
(SELECT
da1.PublisherServer,
da1.SubscriberServer,
da1.publisher_db,
da1.publication,
da1.subscriber_db,
da1.AgentType,
sj1.name,
sj1.[enabled],
sc1.category_id,
sc1.category_class,
sc1.name,
sjh1.step_id,
sjh1.run_status,
CAST(sjh1.run_date AS VARCHAR(8))
,RIGHT('000' + CAST(sjh1.run_time AS VARCHAR(6)),6) 
,RIGHT('000000' + CAST(sjh1.run_duration AS VARCHAR(6)),6) 
FROM msdb.dbo.sysjobs AS sj1
INNER JOIN msdb.dbo.syscategories AS sc1
ON sj1.category_id = sc1.category_id
INNER JOIN msdb.dbo.sysjobhistory AS sjh1
ON sj1.job_id = sjh1.job_id
LEFT OUTER JOIN 
	(
	SELECT 
		psrvr1.name as PublisherServer,
		ssrvr1.name as SubscriberServer,
		da0.job_id,
		da0.publisher_db,
		da0.publication,
		da0.subscriber_db AS subscriber_db,
		'Distribution Agent' AS AgentType
		FROM distribution.dbo.MSdistribution_agents AS da0
		INNER JOIN master.sys.servers AS ssrvr1 
		on da0.subscriber_id = ssrvr1.server_id
		INNER JOIN master.sys.servers AS psrvr1 
		on da0.publisher_id = psrvr1.server_id
		UNION
		SELECT 
		psrvr1.name,
		'NA',
		ssa1.job_id,
		ssa1.publisher_db,
		ssa1.publication,
		'NA' AS subscriber_db,
		'Snapshot Agent' AS AgentType
		FROM distribution.dbo.MSsnapshot_agents AS ssa1
		INNER JOIN master.sys.servers AS psrvr1 
		on ssa1.publisher_id = psrvr1.server_id
		) AS da1

ON sj1.job_id = da1.job_id
WHERE step_id = 0)

SELECT 
publisher_server, 
subscriber_server, 
agent_type,
publisher_db, 
publication, 
subscriber_db,
jobname,
[enabled],
category_id,
category_class,
category_name,
step_id,
run_status,
CAST(run_date AS DATE) AS run_date,
CAST(STUFF(STUFF(run_time,5,0,':'),3,0,':') AS TIME) as run_time,
CAST(STUFF(STUFF(run_duration,5,0,':'),3,0,':') AS TIME) as run_duration
 FROM SQLJobRunHistory 
WHERE category_id IN (10,15)
ORDER BY category_name, publication, subscriber_db, run_date DESC , CAST(STUFF(STUFF(run_time,5,0,':'),3,0,':') AS TIME) desc,  jobname

/* When running against SQL 2005 server substitute the following lines for the date & time values as the DATE & TIME 
data types are not available
convert(nvarchar(15),CAST(run_date AS DATEtime),110) AS run_date,
convert(nvarchar(15),CAST(STUFF(STUFF(run_time,5,0,':'),3,0,':') AS dateTIME),114) as run_time,
convert(nvarchar(15),cast(STUFF(STUFF(run_duration,5,0,':'),3,0,':') AS dateTIME),108) as run_duration
FROM SQLJobRunHistory 
WHERE category_id IN (10,15)
ORDER BY category_name, publication, subscriber_db, run_date DESC , CAST(STUFF(STUFF(run_time,5,0,':'),3,0,':') AS dateTIME) desc,  jobname
*/

