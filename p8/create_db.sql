
--DONE
drop table if exists greenhouse_rows;
create table greenhouse_rows (
row_id varchar,
greenhouse_location varchar,
primary key (row_id)
);

--DONE
drop table if exists plants_active;
create table plants_active (
plant_id varchar,
row_id varchar,
crop_variety varchar,
date_planted date,
primary key (plant_id),
foreign key (row_id) references greenhouse_rows(row_id)
);

--DONE
drop table if exists robots;
create table robots (
robot_id int,
robot_class varchar,
robot_name varchar,
date_commissioned date,
primary key (robot_id),
unique (robot_id)
);

--DONE
drop table if exists robot_jobs;
create table robot_jobs (
job_type varchar,
robot_class varchar,
foreign key (robot_class) references robots(robot_class),
primary key(job_type)
);

--DONE
drop table if exists trusses_status;
create table trusses_status (
truss_id int,
plant_id varchar,
colour int,
last_observation timestamp,
harvested timestamp,
harvest_job int,
x_coordinate float,
z_coordinate float,
weight_estimate float,
primary key (truss_id),
foreign key (plant_id) references plants_active(plant_id),
foreign key (harvest_job) references robot_job_log(job_id)
);

--DONE
drop table if exists robot_job_log;
create table robot_job_log (
job_id int,
start_time timestamp,
end_time timestamp,
job_type varchar,
foreign key (job_type) references robot_jobs(job_type),
primary key (job_id)
);

--DONE
drop table if exists leaf;
create table leaf (
leaf_id int,
plant_id varchar,
deleaf_job int,
pest_count int,
x_coordinate float,
z_coordinate float,
foreign key (deleaf_job) references robot_job_log(job_id),
foreign key (plant_id) references plants_active (plant_id),
primary key (leaf_id)
);

--DONE
drop table if exists sensor_info;
create table sensor_info (
sensor_id int,
sensor_location varchar,
row int,
foreign key (row) references greenhouse_rows(row_id),
primary key (sensor_id) 
);

--DONE
drop table if exists sensor_logs;
create table sensor_logs (
log_id int,
sensor_id int,
humidity_p float,
brightness_lux float,
temperature_c float,
log_timestamp timestamp,
foreign key (sensor_id) references sensor_info(sensor_id),
primary key (log_id) 
);

--DONE
drop table if exists maintenance_protocols;
create table maintenance_protocols (
protocol_id int,
protocol_name varchar,
recurrence_hours int,
primary key (protocol_id)
); 


--DONE
drop table if exists maintenance_schedule;
create table maintenance_schedule (
maintenance_job_id int,
robot int,
technician_id int,
scheduled_date date,
foreign key (robot) references robots(robot_id),
foreign key (technician_id) references technicians(technician_id),
primary key (maintenance_job_id)
);

--DONE
drop table if exists technicians;
create table technicians (
technician_id int,
first_last_name varchar,
hired_date date,
primary key (technician_id)
);

drop table if exists robot_log_audit;
create table robot_log_audit (
    robot_id int not null,
    entry_date varchar
);


