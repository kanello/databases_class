
-- shows us how many trusses are on every plant and which row that plant is in
-- select the sum of trusses as trusses_count, the row_id, plant_id from the common elements in trusses_status and plants_active joined on plant_id. Group all by row_id and plant_id
select count(ts.truss_id) as trusses_count, pa.row_id,  ts.plant_id from trusses_status ts inner join plants_active pa on ts.plant_id = pa.plant_id group by pa.row_id,ts.plant_id;
-- the above looks wrong

-- how many trusses and how much weight do we harvest per day
select count(ts.truss_id) as truss_count, sum(ts.weight_estimate) as weight, DATE(ts.harvested), pa.crop_variety, pa.row_id from trusses_status ts inner join plants_active pa on ts.plant_id=pa.plant_id group by ts.harvested, pa.crop_variety, DATE(ts.harvested);

-- how long each jobs takes on average
-- used JULIANDAY to calculate the difference b/w the end and start time timestamps
select avg(ROUND((JULIANDAY(end_time) - JULIANDAY(start_time)) * 86400/60, 2)) AS duration, job_type from robot_job_log group by job_type;