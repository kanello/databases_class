--break down the amount of crop that is harvetable against the environmental variables that we measure
select 
    e.week, 
    e.row, 
    e.humidity, 
    e.temp, 
    e.br, 
    sum(c.total_weight), 
    count(case 
        when c.colour >= 4 then "harvestable"
        when c.colour < 4 then "not harvestable"
    end) as harvestability_count,
    case 
        when c.colour >= 4 then "harvestable"
        when c.colour < 4 then "not harvestable"
    end as harvestability
from weekly_env_data e inner join unharvested_crop c on e.row=c.row_id 
group by e.week, e.row, e.humidity, e.temp, e.br
order by e.week desc; 

-------
-------
--modification of last week's query -- show us how many workers are busy with upcoming jobs
with no_jobs as (select 
        * 
    from technicians t left outer join maintenance_schedule m on t.technician_id=m.technician_id)
select 
    case
            when maintenance_job_id is not NULL then "busy"
    end as work_status,
    count(case
            when maintenance_job_id is not NULL then "busy"
    end) as count_id
from no_jobs;

-------
-------

create temp table leafs_variety as
select 
    *,
    deleaf_job as job_id
from pests_crop_variety join plants_active using(plant_id);

---count the number of pests on each plant, for every scan of the robot
with join_leafs as (
    select 
        l.crop_variety,
        l.leaf_id,
        l.pest_count,
        l.plant_id,
        r.start_time,
        r.end_time 
    from leafs_variety l join robot_job_log r using(job_id)
) select 
    plant_id,
    crop_variety,
    sum(pest_count) as pest_count,
    end_time 
from join_leafs
group by plant_id, crop_variety, end_time
order by 3 desc;

-------
-------
--estimate weight of crop harvested -- modification of last week's query
select 
    g.row_id, 
    sum(s.weight_estimate) as weight_estimate,
    p.crop_variety
from greenhouse_rows g 
    inner join plants_active p on g.row_id=p.row_id 
    inner join trusses_status s on p.plant_id=s.plant_id 
group by 1, 3;

------
------
--find which of the workers is assigned to more than one maintenance job per week
with temp as (select * from maintenance_schedule join technicians using (technician_id))
select 
    count(maintenance_job_id) as jobs, 
    first_last_name,  
    strftime('%W', scheduled_date) as week
from temp
group by first_last_name, week
having jobs >1;


-------
-------
--average weight of crop harvested from each row by week
with temp as (
    select * 
    from trusses_status ts 
    inner join plants_active pa on ts.plant_id=pa.plant_id 
    inner join greenhouse_rows g on pa.row_id=g.row_id
    )
select 
    strftime('%Y', harvested) as Yr, 
    strftime('%W', harvested) as WeekNumber, 
    sum(weight_estimate), 
    crop_variety,
    row_id 
from  temp group by WeekNumber, Yr, row_id order by 1 asc;