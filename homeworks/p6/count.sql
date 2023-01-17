select 
    (select count(*) from greenhouse_rows) as greenhouse_rows,
    (select count(*) from plants_active) as plants_active,
    (select count(*) from sensor_logs) as sensor_logs,
    (select count(*) from robots) as robots,
    (select count(*) from robot_jobs) as robot_jobs,
    (select count(*) from trusses_status) as trusses_status,
    (select count(*) from robot_job_log) as robot_job_log,
    (select count(*) from leaf) as leaf,
    (select count(*) from sensor_info) as sensor_info,
    (select count(*) from maintenance_protocols) as maintenance_protocols,
    (select count(*) from maintenance_schedule) as maintenance_schedule,
    (select count(*) from technicians) as technicians

from greenhouse_rows limit 1;


