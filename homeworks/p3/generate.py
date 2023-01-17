ffrom turtle import clear

from numpy import var
from scipy import rand
from faker import Faker
from random import randint, uniform
from datetime import datetime
import csv

fake = Faker()

def maintenance_protocols():
    r = randint(2,12)
    c = randint(2,12)
    hours = [50, 75, 100, 125, 150, 175, 200, 300, 500]

    for i in range(25):
        r = randint(2,12)
        c = randint(0,8)
        i=(i*r)+c
        print("""INSERT INTO maintenance_protocols (protocol_id, protocol_name, recurrence_hours) VALUES ({}, '{}', {});""".format(i, fake.name(), hours[c]))

def robot_job_log():
    """
    Contains the information from a job after the job has been done
    """


    for i in range(20):
        
        #random id generation
        r = randint(10,22)
        c = randint(0,8)
        i=((i*r)+c)//3
        d = fake.date_between(datetime(2021,1,1))
        #start time
        h = randint(0, 23)
        m = randint(0,59)
        #end time
        he = (h+1)%24
        me = (m + randint(1,50))%59

        jobs = ['Deleafing', 'Harvesting','Pruning','Lowering', 'Spraying']
        a = randint(0,4)


        print("""INSERT INTO robot_job_log (job_id, start_time, end_time, job_type) VALUES ({}, '{} {}:{}:00', '{} {}:{}:00', '{}');""".format(i, d, h, m, d, he, me, jobs[a] ))

def robots():
    """
    names and classes of all robots
    """
    
    classes = ['HARVEST', 'BIOCONTROL', 'PLANT MAINTENANCE']

    for i in range(30):

        c = i //10

        print("""INSERT INTO robots_t (robot_id, robot_class, robot_name, date_commissioned) VALUES ({}, '{}', '{}-{}', '{}');""".format(i+1, classes[c], classes[c][:2], (i+1), fake.date_between(datetime(2019,1,1), datetime(2023,12,31))))

def robot_jobs():
    """
    Jobs possible by robots

    create table robot_jobs (
    job_type varchar,
    robot_class varchar,
    primary key(job_type),
    foreign key (robot_class) references robots(robot_class)
    );
    """
    
    classes = ['HARVEST', 'BIOCONTROL', 'PLANT MAINTENANCE']

    for i in range(5):

        print("""INSERT INTO robot_jobs (job_type, robot_class) VALUES ('', '');""")

def greenhouse_rows():
    """
    create table greenhouse_rows (
    row_id varchar,
    greenhouse_location varchar,
    primary key (row_number)
    );

    """

    blocks = ["A", "B", "C", "D", "E", "F"]
    side = ["L", "R"]

    for i in range(600):

        c = i //100

        print("""INSERT INTO greenhouse_rows (row_number, greenhouse_location) VALUES ('{}-{}', '{}');""".format(i+1, side[i%2], blocks[c]))

def plants_active():
    """
    create table plants_active (
    plant_id varchar,
    row_id varchar,
    foreign key (row_id) references greenhouse_rows(row_id),
    crop_variety varchar,
    date_planted date,
    primary key (plant_id)
    );
    """

    #to get the row numbers correctly
    side = ["L", "R"]
    variety = ["piccolo", "sunstream", "brioso"]

    with open ('plants_active.csv', 'w', newline='') as file:
        data_add = csv.writer(file, delimiter=',', quotechar='|')
        # data_add.writerow()
    
        for i in range(10000):

            c = randint(1,130)
            v = randint(0,2)
            data = "{}-{}".format(variety[v][:2],i+101), "{}-{}".format(c, side[i%2]), variety[v], fake.date_between(datetime(2021,1,1), datetime(2022,1,1))
            data_add.writerow(data)
            print("""INSERT INTO plants_active (plant_id, row_id, crop_variety, date_planted) VALUES ('{}-{}','{}-{}', '{}', '{}');""".format(variety[v][:2], i+1, c, side[i%2], variety[v], fake.date_between(datetime(2021,1,1), datetime(2022,1,1))))

def trusses_status():
    """
    create table trusses_status (
    truss_id int,
    plant_id varchar,
    foreign key (plant_id) references plants_active(plant_id),
    colour int,
    last_observation timestamp,
    harvested timestamp,
    harvest_job int,
    foreign key (harvest_job) references robot_job_log(job_id),
    x_coordinate float,
    y_coordinate float,
    weight_estimate float,
    primary key (truss_id)
    """

    

    weights = [250, 200, 220, 210, 230, 225, 210, 205, 235]
    job_ids = [19,78]
    plant_ids = ['su-9481','su-9484','su-9489','su-9491','su-9492','su-9496','su-9497','su-950','su-9501','su-9505','su-9507','su-951','su-9513','su-9514','su-9515','su-952','su-9529','su-9530','su-9537','su-9543','su-9547','su-9551','su-9558','su-956','su-9562','su-9563','su-957','su-9570','su-9572','su-9577','su-9581','su-9583','su-9588','su-9592','su-9594','su-9595','su-9599','su-960','su-9603','su-9609','su-961','su-9610','su-9613','su-9614','su-9615','su-9616','su-9618','su-9621','su-9628','su-963','su-9637','su-9641','su-9648','su-9649','su-9653','su-9657','su-9662','su-9664','su-9666','su-9669','su-9670','su-9672','su-9676','su-9678','su-9680','su-9681','su-9682']


    with open('trusses_status.csv', 'w', newline='') as file:
        data_add = csv.writer(file, delimiter=',', quotechar='|')

    #10 plants per row 5 per row side (normally it's twice that amount but scared about making too much data)
        for i in range(61, 30060):
            colour = randint(1,5)
            w = randint(0,4)
            c = (i //6)+1
            data = i+1, plant_ids[i%66], colour, '{} 00:0{}'.format(fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10), '{} 00:0{}'.format(fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10), job_ids[i%2], round(uniform(1, 100), 2), round(uniform(1,1.6), 2), weights[w] 
            data_add.writerow(data)
                                                                                                                                                                    #(truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, y_coordinate, weight_estimate) 
            # print("""INSERT INTO trusses_status (truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, z_coordinate, weight_estimate) VALUES ({},'{}-{}', '{}', '{} 00:0{}', '{} 00:0{}', {}, {}, {}, {});""".format(i+1, variety[:2], i//4, colour, fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10, fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10, i, round(uniform(1, 100), 2), round(uniform(1,1.6), 2), weights[w] ))

        for i in range(30061,60065):
            colour = randint(1,5)
            w = randint(0,8)
            data = i, plant_ids[i%66], colour, '{} 00:0{}'.format(fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10), 'NULL', 'NULL', round(uniform(1, 100), 2), round(uniform(1,1.6), 2), weights[w] 
            data_add.writerow(data)
                                                                                                                                                                    #(truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, y_coordinate, weight_estimate) 
            # print("""INSERT INTO trusses_status (truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, z_coordinate, weight_estimate) VALUES ({},'su-{}', '{}', '{} 00:0{}', NULL, NULL, {}, {}, {});""".format(i+31, i//4, colour, fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10, round(uniform(1, 100), 2), round(uniform(1,1.6), 2), weights[w] ))


def leaf():
    """
    create table leaf (
    leaf_id int,
    plant_id varchar,
    deleaf_job int,
    foreign key (plant_id) references plants_active (plant_id),
    pest_count int,
    x_coord float,
    y_coord float,
    foreign key (deleaf_job) references robot_job_log(job_id),
    primary key (leaf_id)
    );
    """

    plant_ids = ['su-9481','su-9484','su-9489','su-9491','su-9492','su-9496','su-9497','su-950','su-9501','su-9505','su-9507','su-951','su-9513','su-9514','su-9515','su-952','su-9529','su-9530','su-9537','su-9543','su-9547','su-9551','su-9558','su-956','su-9562','su-9563','su-957','su-9570','su-9572','su-9577','su-9581','su-9583','su-9588','su-9592','su-9594','su-9595','su-9599','su-960','su-9603','su-9609','su-961','su-9610','su-9613','su-9614','su-9615','su-9616','su-9618','su-9621','su-9628','su-963','su-9637','su-9641','su-9648','su-9649','su-9653','su-9657','su-9662','su-9664','su-9666','su-9669','su-9670','su-9672','su-9676','su-9678','su-9680','su-9681','su-9682']
    job_ids = [74, 75, 141]
    
    with open('leaf.csv', 'w', newline='') as file:
        data_add = csv.writer(file, delimiter=',', quotechar='|')
       

        for i in range(10000):
            
            a = randint(0,66)
            b = randint(0,2)
            
            
            data = i+31, plant_ids[a], job_ids[b], randint(3,30), round(uniform(1, 100), 2), round(uniform(1,1.6), 2)
            data_add.writerow(data)
            
            # print("""INSERT INTO leaf (leaf_id, plant_id, deleaf_job, pest_count, x_coordinate, y_coordinate) VALUES ({},'{}', {}, {}, '{}', '{}');""".format(i+1, plant_ids[a], job_ids[b], randint(3,30), round(uniform(1, 100), 2), round(uniform(1,1.6), 2) ))
        print('success')

def sensor_info():
    """
    create table sensor_info (
    sensor_id int,
    sensor_location varchar,
    row int,
    foreign key (row) references greenhouse_rows(row_id),
    primary key (sensor_id) 
    );

    """

    rows = ['1-L', '1-R', '2-L', '2-R', '3-L', '3-R', '4-L', '4-R', '5-L', '5-R', '6-L', '6-R', '7-L', '7-R']

    for i in range(20):

        x = randint(0,50)
        y = randint(0,13)

        


        print("""INSERT INTO sensor_info (sensor_id, sensor_location, row) VALUES ({}, {}, '{}');""".format(i, x, rows[y]))

def sensor_logs():
    """
    create table sensor_logs (
    log_id int,
    sensor_id int,
    foreign key (sensor_id) references sensor_info(sensor_id),
    humidity_p float,
    brightness_lux float,
    temperature_c float,
    log_timestamp timestamp,
    primary key (log_id) 
    );

    """

    with open('sensor_logs.csv', 'w', newline='') as file:
            data_add = csv.writer(file, delimiter=',', quotechar='|')
            
            
            for i in range(10000):

                x = randint(1,20)

                data = i+21, x, randint(70,86), randint(1000,3000),randint(29,38), '{} 00:0{}'.format(fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10)
                data_add.writerow(data)


                print("""INSERT INTO sensor_logs (log_id, sensor_id, humidity_p, brightness_lux, temperature_c, log_timestamp) VALUES ({}, {}, '{}', '{}', '{}','{} 00:0{}');""".format(i, x, randint(70,86), randint(1000,3000),randint(29,38), fake.date_between(datetime(2021,1,1),  datetime(2022,1,1)), i%10))

def maintenance_schedule():
    """
    create table maintenance_schedule (
    maintenance_job_id int,
    robot int,
    technician_id int,
    foreign key (robot) references robots(robot_id),
    scheduled_date date,
    foreign key (technician_id) references technicians(technician_id),
    primary key (maintenance_job_id)
    );

    """
    robots = ['HA-9', 'HA-10', 'BI-11', 'BI-12', 'BI-13', 'BI-14','PL-22', 'PL-23','PL-24']
    ids = [1,11,21,31,41,51,61,71,81]


    for i in range(20):

        x = randint(0,8)
        y = randint(0,13)


        print("""INSERT INTO maintenance_schedule (maintenance_job_id, robot, technician_id, scheduled_date) VALUES ({}, '{}', {}, '{}');""".format(i, robots[x], ids[x], fake.date_between(datetime(2021,1,1),  datetime(2022,1,1))))



if __name__ == "__main__":

    trusses_status()

    

    


