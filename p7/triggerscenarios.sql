--t_truss_weights
--activate
INSERT INTO trusses_status (truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, z_coordinate, weight_estimate) VALUES (1003334240,'pi-1', '3', '2021-03-06 00:07', '2021-02-21 00:07', 7, 6.48, 1.02, 450);


--don't activate
INSERT INTO trusses_status (truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, z_coordinate, weight_estimate) VALUES (103344503,'pi-1', '3', '2021-03-06 00:07', '2021-02-21 00:07', 7, 6.48, 1.02, 250);

--t_robot_id
--activate
INSERT INTO robots (robot_id, robot_class, robot_name, date_commissioned) VALUES (NULL, 'HARVEST', 'HA-2', '2020-04-14');

--don't activate
INSERT INTO robots (robot_id, robot_class, robot_name, date_commissioned) VALUES (10008838000, 'HARVEST', 'HA-2', '2020-04-14');

--t_robots_commissioned
--activate
INSERT INTO robots (robot_id, robot_class, robot_name, date_commissioned) VALUES (10030003, 'HARVEST', 'HA-2', '2020-04-14');

--don't activate
update robots set  robot_name = robot_class||'-'||robot_id;