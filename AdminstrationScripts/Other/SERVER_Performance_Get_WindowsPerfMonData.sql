/*********************************************************************************
Author:		Danny Howell

Date:		

SOURCE: 

WHAT THIS TELLS YOU
Provides the statistics gathered by the Windows 2008 Performance Monitor grouped.
The query results vary depending upon what is captured by the performance monitor definition. 
The metrics gathered vary according to the performance monitor objects selected.
The metric definitions are to numerous to outline here.  Please consult Windows Performance Monitoring for
the list of metrics, their counters and their definitions.
*********************************************************************************/
 
 

SELECT 
CDet1.MachineName,
CDet1.ObjectName,
CDet1.CounterName,
CONVERT(DATETIME, CONVERT(VARCHAR(16), CD1.CounterDateTime)) as [DateTime],
AVG(CD1.CounterValue) as Average,
MIN(CD1.CounterValue) as Minimum,
MAX(CD1.CounterValue) as Maximum
FROM CounterDetails AS CDet1
INNER JOIN CounterData AS CD1
ON CD1.CounterID = CDet1.CounterID
INNER JOIN DisplayToID AS DID1
ON DID1.GUID = CD1.GUID
GROUP BY CDet1.MachineName
,CDet1.ObjectName
,CDet1.CounterName,
CONVERT(DATETIME, CONVERT(VARCHAR(16), CD1.CounterDateTime)) 
  