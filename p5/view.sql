--to manage the greenhouse, we want to have an overview of environmental data on a weekly basis
--the view helps us deal with the timestamp datatype and aggregations in a straightforward, easy way
create view weekly_env_data as
select 
    strftime('%W',sl.log_timestamp) as week,
    si.row, 
    avg(sl.humidity_p) as humidity, 
    avg(sl.temperature_c) as temp, 
    avg(sl.brightness_lux) as br 
from sensor_info si inner join sensor_logs sl on si.sensor_id=sl.sensor_id 
group by week, row;

--for future yield prediction it is good for us to know how many trusses in each color bucket each row has
--view simplifies the query for us as it involves aggregation and joining tables
--additionally, we would likely use this data to model future crop availability so it'll help us with building a pipeline for analysis
create view unharvested_crop as
select 
    g.row_id, 
    p.colour,
    count(p.truss_id) as trusses, 
    sum(p.weight_estimate) as total_weight
from trusses_status p inner join plants_active g on p.plant_id=g.plant_id 
where p.harvest_job is not NULL
group by g.row_id, p.colour
order by 2 desc;

--this view is also to simplify querying and will aid us in later analysis of data in relation to pest numbers per variety and their distribution in the crop
create view pests_crop_variety as
select 
    l.leaf_id, 
    l.plant_id,
    l.pest_count, 
    l.x_coordinate, 
    l.z_coordinate, 
    p.row_id, 
    p.crop_variety,
    l.deleaf_job 
from leaf l inner join plants_active p on l.plant_id=p.plant_id;
