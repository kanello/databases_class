--count the number of trusses and total weight in kgs harvested. Also tell us when the first and last harvest was completed
--filter only harvests happening in the second half of the year
select  
    pa.crop_variety,
    count(ts.truss_id) as trusses_harvested,
    sum(ts.weight_estimate)/1000 as kgs_harvested,
    max(strftime('%W', r.end_time)) as final_harvest
from plants_active pa 
inner join trusses_status ts on pa.plant_id=ts.plant_id
inner join robot_job_log r on ts.harvest_job=r.job_id
where strftime('%W', r.end_time) > 26
group by pa.crop_variety


---count the number of pests on a plant grouping by week
-- rank which plants have the most pests in each week period
with temp as (
    select 
        p.row_id-substr(p.row_id, -2) as row_both_sides,
        count(p.plant_id) as plants,
        sum(l.pest_count) as pests,
        strftime('%W', r.end_time) as week_no
    from leaf l 
    join plants_active p using(plant_id)
    inner join robot_job_log r on l.deleaf_job=r.job_id
    group by p.row_id, week_no
    having week_no >0
    order by 1 asc) 
select 
    row_both_sides,
    sum(plants) as plants,
    sum(pests) as pests,
    rank() over(partition by week_no order by pests desc) as rank_by_pests,
    week_no
from temp
group by row_both_sides, week_no;


-- we want to find the height distribution in buckets so we can configure the deleafing robots
with distr as (
    select 
        count(p.plant_id) as plants,
         as week_no
    from leaf l 
    join plants_active p using(plant_id)
    inner join robot_job_log r on l.deleaf_job=r.job_id
    where strftime('%W', r.end_time) > 26
    group by p.row_id, week_no
    having week_no >0
    order by 1 asc) 
select 
    row_both_sides,
    sum(plants) as plants,
    sum(pests) as pests,
    rank() over(partition by week_no order by pests desc) as rank_by_pests,
    week_no
from temp
group by row_both_sides, week_no;


--do a visual mapping of temperatures
--sensor_logs, greenhouse_rows, sensor_info
--create bins of meters
with sensor as (
    select 
        *,
        cast(si.sensor_location as int) as sensor_loc
    from sensor_logs sl join sensor_info si using(sensor_id)
    inner join greenhouse_rows g on si.row=g.row_id)
select 
    row_id - substr(row_id, -2) as row_id,
    round(avg(case when sensor_loc <11 then temperature_c end), 2) as '1-10',
    round(avg(case when sensor_loc > 10 and sensor_loc <21 then temperature_c end),2) as '11-20',
    round(avg(case when sensor_loc > 20 and sensor_loc <31 then temperature_c end),2) as '21-30',
    round(avg(case when sensor_loc > 30 and sensor_loc <41 then temperature_c end),2)as '31-40',
    round(avg(case when sensor_loc > 40 then temperature_c end),2) as '41-50'
from sensor
group by row_id;



