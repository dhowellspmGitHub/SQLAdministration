/* Live query progress in SQL 2014 */
SELECT session_id,node_id,physical_operator_name, SUM(row_count) row_count, SUM(estimate_row_count) AS estimate_row_count, 
    CAST(SUM(row_count)*100 AS float)/NULLIF(SUM(estimate_row_count),0) AS percent_complete,
    SUM(elapsed_time_ms) AS elapsed_time_ms,
    SUM(cpu_time_ms) AS cpu_time_ms,
    SUM(logical_read_count) AS logical_read_count,
    SUM(physical_read_count) AS physical_read_count,
    SUM(write_page_count) AS spill_page_count,
    SUM(segment_read_count) AS segment_read_count,
    SUM(segment_skip_count) AS segment_skip_count,
    COUNT(*) AS num_threads
FROM sys.dm_exec_query_profiles 
WHERE session_id <> @@spid
GROUP BY session_id,node_id,physical_operator_name
ORDER BY session_id,node_id;