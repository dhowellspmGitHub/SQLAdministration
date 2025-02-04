
/*********************************************************************************
name:		database_stored_procedures_vw_sel__stored_procedures

author:		danny howell

date:		

description:		list all stored procedure parameters, data types and defaults

*********************************************************************************/

SELECT 
	so.name
	,p.name AS 'sp_parameter'
	,CASE tp.name				
	WHEN 'int' THEN tp.name			
	WHEN 'nvarchar' THEN tp.name +'(' +  			
		CASE p.max_length		
		WHEN -1 THEN 'max'	
		ELSE CAST(p.max_length AS NVARCHAR(5)) END	
		+ ')'			
	WHEN 'varchar' THEN tp.name +'(' +  			
		CASE p.max_length		
		WHEN -1 THEN 'max'	
		ELSE CAST(p.max_length AS NVARCHAR(5)) END	
		+ ')'			
	WHEN 'decimal' THEN tp.name +'(' +  CAST(p.precision AS NVARCHAR(5)) + ',' + CAST(p.scale AS NVARCHAR(5)) +')'			
	ELSE tp.name END AS 'sp_parameter datatype'		
	,p.parameter_id AS 'parameterid'
	,CASE p.has_default_value
		WHEN 1 THEN 'yes'
		ELSE 'no' END AS 'hasdefaultvalue'
	,ISNULL(p.default_value,'') AS 'defaultvalue'
	,CASE p.is_output 
		WHEN 0 THEN 'input'	
		ELSE 'output' END AS 'direction'
FROM sys.parameters p
INNER JOIN sys.objects so ON
p.object_id = so.object_id
INNER JOIN sys.types tp ON
p.system_type_id = tp.system_type_id


 