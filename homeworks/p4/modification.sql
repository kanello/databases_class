--delete based on condition
delete from sensor_logs where log_timestamp > "2021-10-00 00:00";

--delete trusses whose z_coordnate is 0, i.e. they are on the floor. Maybe a mistake in Computer Vision :)
delete from trusses_status where z_coordinate = 0;

--delete robots whose class starts with BIO; we're no longer doing any such jobs
delete from robots where robot_class like 'BIO%';

--update based on condition
-- change the recurence_hours to 450 in the protocols that currently have it listed as 450
update maintenance_protocols set recurrence_hours=450 where recurrence_hours = 500;

--change any plant that was of the 'brioso' crop type to 'tatami'
update plants_active set crop_variety = 'tatami' where crop_variety = 'brioso';

--change the estimated weights to be double of what they used to be
update trusses_status set weight_estimate = weight_estimate*2;

--change the temperature data to be +5 the existing one. the sensor had an issue
update sensor_logs set temperature_c = temperature_c+5;

--insert some data
-- we decided to get some biocontrol robots again. insert the date, class, id and date commissioned
insert into robots (robot_id, robot_class, robot_name, date_commissioned) values (31, 'BIOCONTROL', 'BI-31', '2022-02-10');

insert into robots (robot_id, robot_class, robot_name, date_commissioned) values (35, 'SECURITY', 'SE-35', '2022-02-10');

insert into robots (robot_class) select first_last_name from technicians;

insert into sensor_logs (temperature_c) select weight_estimate from trusses_status limit 1;