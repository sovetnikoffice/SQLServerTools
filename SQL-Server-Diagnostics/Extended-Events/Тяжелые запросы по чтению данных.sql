-- Анализ тяжелых запросов по чтению данных

CREATE EVENT SESSION [HeavyQueryByReads] ON SERVER 
-- Класс событий RPC:Completed указывает, что удаленный вызов процедуры завершен.
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/rpc-completed-event-class?view=sql-server-2017
ADD EVENT sqlserver.rpc_completed(
    ACTION (
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.client_pid,
        sqlserver.database_id,
        sqlserver.nt_username,
        sqlserver.query_hash,
        sqlserver.query_plan_hash,
        sqlserver.server_principal_name,
        sqlserver.session_id,
        sqlserver.sql_text,
        sqlserver.transaction_id,
        sqlserver.username)
    WHERE ([logical_reads]>(50000))),
-- Класс событий SQL:BatchCompleted указывает на завершение выполнения пакета языка Transact-SQL .
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/sql-batchcompleted-event-class?view=sql-server-2017
ADD EVENT sqlserver.sql_batch_completed(
    ACTION (
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.client_pid,
        sqlserver.database_id,
        sqlserver.nt_username,
        sqlserver.query_hash,
        sqlserver.query_plan_hash,
        sqlserver.server_principal_name,
        sqlserver.session_id,
        sqlserver.sql_text,
        sqlserver.transaction_id,
        sqlserver.username)
    WHERE ([logical_reads]>(50000))),
-- Событие класса событий SQL:StmtCompleted указывает на то, что инструкция языка Transact-SQL завершена.
-- https://docs.microsoft.com/ru-ru/sql/relational-databases/event-classes/sql-stmtcompleted-event-class?view=sql-server-2017
ADD EVENT sqlserver.sql_statement_completed(
    ACTION (
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.client_pid,
        sqlserver.database_id,
        sqlserver.nt_username,
        sqlserver.query_hash,
        sqlserver.query_plan_hash,
        sqlserver.server_principal_name,
        sqlserver.session_id,
        sqlserver.sql_text,
        sqlserver.transaction_id,
        sqlserver.username)
    WHERE ([logical_reads]>(50000)))
ADD TARGET package0.event_file(SET 
    filename=N'D\Log\HeavyQueryByReads.xel',
    max_file_size=(10),
    max_rollover_files=(5),
    metadatafile=N'D\Log\HeavyQueryByReads.xem')
WITH (
    MAX_MEMORY=4096 KB,
    EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY=15 SECONDS,
    MAX_EVENT_SIZE=0 KB,
    MEMORY_PARTITION_MODE=NONE,
    TRACK_CAUSALITY=OFF,
    STARTUP_STATE=OFF)


