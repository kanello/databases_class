--maintains data integrity by not allowing an accidental large value to be added to the trusses_status table
drop trigger if exists t_truss_weights;
create trigger t_truss_weights
    before insert on trusses_status
begin 
    select 
        case 
            when NEW.weight_estimate > 400 then
            raise (abort, 'This is too heavy for a truss! Please check again. If you actually have a monster truss, please contact your DB admin for help with this')
        end;
end;

--checking that any new robot added to the robots table contains a robot_id, as robot_id is pk
drop trigger if exists t_robot_id;
create trigger t_robot_id
    before insert on robots
begin 
    select 
        case
            when new.robot_id is NULL  then
            raise(abort, 'You must enter an integer value for robot_id (also cannot be null)')
        end;
end;


--update the robots_commissioned table with the new robot_id and the date it was added
drop trigger if exists t_robots_commissioned;
create trigger t_robots_commissioned
    after insert on robots
begin 
    insert into robot_log_audit values (new.robot_id, datetime('now'));
end;