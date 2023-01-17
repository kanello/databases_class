--add row_id column to sensor_logs
alter table sensor_logs add column row_id int;


--dropping a column from sensor_logs
alter table sensor_logs drop column humidity_p;