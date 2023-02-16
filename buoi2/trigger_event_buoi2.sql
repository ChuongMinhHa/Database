-- event 1: them mot chau luc vao l ngay sau    
CREATE EVENT insert_regions
ON SCHEDULE AT CURRENT_TIMESTAMP + interval 1 day
DO
	INSERT INTO regions (regions.name)
    VALUES('Ustralia');
    
-- event 2: sau 6 tháng sẽ tăng lương cho nhân viên lên 1000
CREATE EVENT update_employees
ON SCHEDULE AT CURRENT_TIMESTAMP + interval 6 month
DO
	update employees set salary=salary+1000;

-- trigger 1: kiểm tra lương trong khoảng từ 1000 -> 20000 khi thêm một công việc mới
DELIMITER $$
CREATE
TRIGGER `BEFORE_JOB_INSERT`
BEFORE insert ON jobs
FOR EACH ROW
BEGIN
	IF (NEW.min_salary < 1000 OR NEW.max_salary > 20000 ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must in [1000,20000]';
	END IF;
END$$


-- trigger 2: 
DELIMITER $$
CREATE
TRIGGER `INSERT_REGIONS_NAME`
BEFORE insert ON regions
FOR EACH ROW
BEGIN
	IF (exists(select * from regions where region_name=new.region_name)) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Region name is exist';
	END IF;
END$$