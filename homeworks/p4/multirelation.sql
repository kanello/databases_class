-- at least two 

--join three tables to get weight of crop per row
select g.row_id, sum(s.weight_estimate) from greenhouse_rows g inner join plants_active p on g.row_id=p.row_id inner join trusses_status s on p.plant_id=s.plant_id group by 1;

--find the id of the greenhouse rows which have to plants active in them
select g.row_id from greenhouse_rows g left join plants_active p on g.row_id=p.row_id where p.plant_id is null;

--average number of pests in any greenhouse row
--join the two tables in the subquery and then perform aggregation in the main query
select avg(pest_count), row_id from (select * from leaf l inner join plants_active p on l.plant_id=p.plant_id) group by row_id;

--count the number of technicians who do not have any work to do. find all those who have no job in the subquery and perform count in main query
select count(technician_id) as idle from (select * from technicians t left join maintenance_schedule m on t.technician_id=m.technician_id where m.maintenance_job_id is NULL) as no_jobs;

--average weight of crop harvested from each row by week
select strftime('%Y', harvested) as Yr, strftime('%W', harvested) as WeekNumber, sum(weight_estimate), row_id from (select * from trusses_status ts inner join plants_active pa on ts.plant_id=pa.plant_id inner join greenhouse_rows g on pa.row_id=g.row_id) as data group by WeekNumber, Yr, row_id order by 1 asc;