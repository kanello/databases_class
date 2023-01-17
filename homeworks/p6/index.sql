--.time on -> measure the time to run the queries before and after adding the index
-- for the mapping query, we can create an index which directly assigns bins. This means that instead of computing if 
-- tuple values are b/w this and that, we can directly call the bin value



-- we can create indexing on dates to week values, which could speed up a lot of things and avoid us having to make computations
create index date on robot_job_log(end_time asc) where mod(strftime('%W', end_time), 10)=0;

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




--to get an even larger dataset, I've cross joined two tables, one with 10K and the other 60K tuples (no actual value in doing, expect to see speedup with index)
select count(*) from trusses_status ts cross join leaf where ts.weight_estimate='250';

create index trusses_status_weight on trusses_status(weight_estimate);

--w/out index => Run Time: real 1.096 user 1.091513 sys 0.004679
--w index => Run Time: real 1.065 user 1.056609 sys 0.002849

--it doesn't look like we are getting faster :(
