/*******************************************************************************
[SCRIPT NAME]: StatsOnly_NEW
[DESCRIPTION]: Executes the checking of Index Statistics
[USAGE NOTES]: Run all at once
   * This script will not return results for tables that have no rows
   * If no results are returned and no errors are reported, the databases Index Statistics are not considered stale and/or meet the expected sample rate
Column Definitions:
   * [TableName] - The name of the database table related to the Statistic
   * [Index] - The Index that the Statistic belongs to
   * [Advisory] - The reason why the Statistic was returned
   * [Rows] - The number of rows that were in the table during the last Statistics update
   * [#RowsSampled] - The number of rows that were sampled during the last Statistics update
   * [#Modifications] - The number of modifications that have occurred since the last Statistics update
   * [LastSample%] - The % of rows sampled during the last Statistics update
[PARAMETER INFO]:
   @StatsSample - The target desired sample rate (percentage) for the Index Statistics (number of rows vs. rows sampled)
   * Default value: 100
   @ModPercent - The percentage of modifications made since the last Statistics update (INSERT, UPDATE, DELETE)
   * Statisics are considered stale when the modifications meet or exceed the provided percentage
   * Default value: 20
*******************************************************************************/
 Use PC_PROD
 go
/* DO NOT EDIT ABOVE THIS LINE */
 
DECLARE @StatsSample INT = 100
DECLARE @ModPercent INT = 5
 
/* DO NOT EDIT BELOW THIS LINE */
 
BEGIN
 
WITH statsCTE AS (
SELECT
[so].[name] [TableName],
[s].[name] [Index],
[sp].[last_updated],
[sp].[rows],
[sp].[rows_sampled],
[sp].[modification_counter],
(CAST ([sp].[rows_sampled] AS DECIMAL(20,2)) / CAST ([sp].[rows] AS DECIMAL(20,2)) *100.00) [SamplePercentage],
CASE
WHEN [sp].[modification_counter] > 0 AND [sp].[rows] <= [sp].[modification_counter] THEN 1
WHEN [sp].[modification_counter] > 0 AND [sp].[rows] > [sp].[modification_counter] AND CAST ([sp].[modification_counter] AS DECIMAL)/CAST([sp].[rows] AS DECIMAL) * 100 >= @ModPercent THEN 2
ELSE 0
END AS [ModStats]
FROM [sys].[stats] s
CROSS APPLY [sys].[dm_db_stats_properties]([s].[object_id],[s].[stats_id]) sp
JOIN [sys].[objects] AS [so] ON
[s].object_id=[so].object_id
JOIN [sys].[schemas] as [sc] on
[so].schema_id=[sc].schema_id
JOIN [sys].indexes [i] ON
[s].name = [i].name
WHERE [sc].name= 'dbo'
AND [s].auto_created <> 1
AND [sp].rows IS NOT NULL
AND [i].is_disabled <> 1
)
SELECT
statsCTE.[TableName],
statsCTE.[Index],
statsCTE.[Last_updated],
CASE
WHEN statsCTE.SamplePercentage < @StatsSample THEN 'Insufficient Statistics Sampling rate (' + CONVERT(varchar(5), (100 * statsCTE.[rows_sampled] ) / statsCTE.[rows]) + '%)'
WHEN statsCTE.ModStats <> 0 THEN 'Stale Statistics due to modifications exceeding ' + CONVERT(varchar(3),(@ModPercent)) + '%'
END AS [Advisory],
statsCTE.[rows] [Rows],
statsCTE.[rows_sampled] [#RowsSampled],
statsCTE.[modification_counter] [#Modifications],
CONVERT(varchar(5), (100 * statsCTE.[rows_sampled] ) / statsCTE.[rows]) [LastSample%],
statsCTE.last_updated
FROM statsCTE
--WHERE ModStats <> 0 
--OR [SamplePercentage] < @StatsSample
ORDER BY [TableName], [Index]

END
