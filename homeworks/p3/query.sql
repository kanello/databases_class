-- select all columns from the maintenance protocols table, ordering them by recurrence in descending order
select * from maintenance_protocols order by recurrence_hours desc;

-- select trusses, weight estimate of each truss for all trusses whose colour is equal to 4
select truss_id, weight_estimate from trusses_status where colour = 4;

-- show the id, x/z coordingates and plant id of all truses
select t.truss_id, t.x_coordinate, t.z_coordinate, t.plant_id,  from trusses_status t 