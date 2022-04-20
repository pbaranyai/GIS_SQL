USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'GIS Orphan removal', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'Removes orphan locks prior to SDE compress on Monday mornings after midnight.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CRAWFORD\arcadmin', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'GIS Orphan removal', @server_name = N'CCPHANTOM\ARCGIS'
GO
Delete from sde.SDE_table_locks
where sde_id not in (select sde_id from sde.SDE_process_information)

Delete from sde.SDE_layer_locks
where sde_id not in (select sde_id from sde.SDE_process_information)

Delete from sde.SDE_object_locks
where sde_id not in (select sde_id from sde.SDE_process_information)

Delete from sde.SDE_state_locks
where sde_id not in (select sde_id from sde.SDE_process_information)
