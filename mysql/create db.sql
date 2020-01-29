CREATE DATABASE tz;

CREATE TABLE tz.дом

	(

		id_дома INT NOT NULL AUTO_INCREMENT, 
		название VARCHAR(10) NOT NULL, 
		
		PRIMARY KEY (id_дома)
	) 
 
 ENGINE=INNODB DEFAULT CHARSET = cp1251;

CREATE TABLE tz.этаж
	(
	
		id_дома INT NOT NULL, 
		id_этажа INT NOT NULL AUTO_INCREMENT, 
		номер_этажа VARCHAR(25) NOT NULL, 
		
		PRIMARY KEY (id_этажа),
		
		FOREIGN KEY (id_дома) REFERENCES дом(id_дома)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
	)
	
 ENGINE=INNODB DEFAULT CHARSET = cp1251;


CREATE TABLE tz.лестница

	(
		id_лестницы INT NOT NULL AUTO_INCREMENT, 
		id_дома INT NOT NULL, 
		PRIMARY KEY (id_лестницы),
		
		FOREIGN KEY (id_дома) REFERENCES дом(id_дома)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
	)
	
 ENGINE=INNODB DEFAULT CHARSET = cp1251;


CREATE TABLE tz.этаж_лестница
	(
		id_этажа INT NOT NULL, 
		id_лестницы INT NOT NULL,
		
		FOREIGN KEY (id_этажа) REFERENCES этаж(id_этажа)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
			
		FOREIGN KEY (id_лестницы) REFERENCES лестница(id_лестницы)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
		
	)
	
 ENGINE=INNODB DEFAULT CHARSET = cp1251;





-- ------------Заполнение таблиц------------

DELIMITER //

CREATE PROCEDURE tz.pr_cur_simple (a TINYINT, first_floor_id INT, second_floor_id INT, first_stairs_id INT, second_stairs_id INT)
BEGIN

	DECLARE i_fl, i_stairs INT DEFAULT 1;

IF (a = 1) -- если необходима вставка обычных лестниц. в tz.`этаж_лестница` интервал длинною несколько этажей
THEN
	
	
	WHILE i_stairs <= (second_stairs_id - first_stairs_id) + 1 DO

	 	    
	    INSERT INTO tz.`этаж_лестница` (`id_этажа`,`id_лестницы`) VALUES (first_floor_id + i_fl - 1, first_stairs_id + i_stairs - 1);
	    INSERT INTO tz.`этаж_лестница` (`id_этажа`,`id_лестницы`) VALUES (first_floor_id + i_fl, first_stairs_id  + i_stairs - 1);	    
	    
	    SET i_fl = i_fl + 1;
		SET i_stairs = i_stairs + 1;
	  
	  
	END WHILE;

/*
ELSE  -- если необходима вставка пожарных лестниц. в tz.`этаж_лестница` интервал длинною несколько этажей

	
	
*/
END IF;

END//



CREATE PROCEDURE tz.cur_simple()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE tt1, tt2, tt3, tt4 INT DEFAULT 1;

	DECLARE cur1 CURSOR FOR
	(SELECT
	  MIN(t2.`id_этажа`) AS mn,
	  MAX(t2.`id_этажа`) AS mx,
	  MIN(t3.`id_лестницы`) AS mns,
	  MAX(t3.`id_лестницы`) AS mxs
	FROM
	  tz.`дом` AS t1,
	  tz.`этаж` AS t2,
	  tz.`лестница` AS t3
	WHERE t1.`id_дома` = t2.`id_дома`
	  AND t3.`id_дома` = t2.`id_дома`

	LIMIT 0, 10000);

   DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN cur1;

  REPEAT
    FETCH cur1 INTO tt1, tt2, tt3, tt4;
    
    IF NOT done 
	
		THEN
		
			CALL tz.`pr_cur_simple`(1, tt1, tt2, tt3, tt4);

		END IF;

		UNTIL done
		
  END REPEAT;

  CLOSE cur1;

END //



CREATE PROCEDURE tz.ins_proc() 

BEGIN 

	-- ----Дом----

	DECLARE i, j, p, t, d, maxd, a, b, c, temp1 INT DEFAULT 1;
	SET j = (SELECT GREATEST(10, FLOOR(101*RAND())));
		
	WHILE i <= j DO
		INSERT INTO tz.дом (название) VALUES (CONCAT('Дом ', i));
						
		SET i = i+1;
	END WHILE;
	
	
	-- ----Этаж----
	
	
	SET maxd = (SELECT COUNT(*) FROM tz.дом); -- количество домов
	SET d = 1;
	
	
	WHILE d<=maxd DO 
	
		SET t = (SELECT GREATEST(5, FLOOR(31*RAND()))); -- число этажей в конкретном доме
		SET p = 1;
			
		WHILE p<=t DO
			
			INSERT INTO 
				
				tz.этаж(id_дома, номер_этажа) 
				
				VALUES 
					(
						d, 
						

						(
							SELECT  (
								SELECT CASE p 
									WHEN 1 THEN 'первый этаж'
									WHEN 2 THEN 'второй этаж'
									WHEN 3 THEN 'третий этаж'
									WHEN 4 THEN 'четвертый этаж'
									WHEN 5 THEN 'пятый этаж'
									WHEN 6 THEN 'шестой этаж'
									WHEN 7 THEN 'седьмой этаж'
									WHEN 8 THEN 'восьмой этаж'
									WHEN 9 THEN 'девятый этаж'
									WHEN 10 THEN 'десятый этаж'
									WHEN 11 THEN 'одиннадцатый  этаж'
									WHEN 12 THEN 'двенадцатый этаж'
									WHEN 13 THEN 'тринадцатый этаж'
									WHEN 14 THEN 'четырнадцатый этаж'
									WHEN 15 THEN 'пятнадцатый этаж'
									WHEN 16 THEN 'шестнадцатый этаж'
									WHEN 17 THEN 'семнадцатый этаж'
									WHEN 18 THEN 'восемнадцатый этаж'
									WHEN 19 THEN 'девятнадцатый этаж'
									WHEN 20 THEN 'двадцатый этаж'
									WHEN 21 THEN 'двадцать первый этаж'
									WHEN 22 THEN 'двадцать второй этаж'
									WHEN 23 THEN 'двадцать третий этаж'
									WHEN 24 THEN 'двадцать четвертый этаж'
									WHEN 25 THEN 'двадцать пятый этаж'
									WHEN 26 THEN 'двадцать шестой этаж'
									WHEN 27 THEN 'двадцать седьмой этаж'
									WHEN 28 THEN 'двадцать восьмой этаж'
									WHEN 29 THEN 'двадцать девятый этаж'
									WHEN 30 THEN 'тридцатый этаж'
								END
							
								) AS 'этаж'
						)
					);
				
			SET p = p+1;
		
		END WHILE;
		
	
		SET d = d+1;
	END WHILE;
	

	-- ----Лестница----

	/*
	без противоречия условию задачи принимаю следующие утверждения:
	1. обычные лестницы есть в каждом доме (не встречал отсутствие лестниц в здании)
	2. пожарные лестницы есть не во всех зданиях
	3. пожарные лестницы могут быть в здании в виде пролетов (не 1 лестница на все здание, а несколько). Максимальное их количество - 3.
	4. длина пожарных лестниц может быть любой, но длиннее, чем обычный лестничный пролет - минимум 2 этажа (с 1-ого по 3-й). 
	*/



-- Генерация обычных лестниц

-- кол-во обычных лестниц = кол-во этажей -1


	SET i = 1;
	SET j = 1;
	SET t = 1;

	
	-- i - счетчик текущего дома
	-- j - счетчик текущей лестницы
	-- t - кол-во этажей на доме
	-- maxd - кол-во домов
	
	WHILE i<=maxd DO
	
		
		
		SET t =
		
			(

				SELECT
				  COUNT(*)
				FROM
				  tz.`этаж`
				WHERE tz.`этаж`.`id_дома` = i 

			);
		
		  
		  WHILE j<=t-1 DO
		  
			INSERT INTO tz.`лестница` (id_дома) VALUES (i);
			SET j=j+1;
			
		  END WHILE;
		  
	SET j = 1;
	SET i = i + 1;
	
	END WHILE;

	

	-- ----Этаж_лестница----

	-- Генерация связок обычных лестниц и этажей для всех зданий
	
	
	CALL tz.`cur_simple`();
	
	
	
	
	-- ----------------------------------
	


-- maxd - количество домов
-- a - счетчик
-- b - переменная либо 0 (нет пожарных лестниц), либо 1. Случайная величина.
-- t - случайное число


   SET maxd =
	  (
		  SELECT
		    COUNT(*)
		  FROM
		    tz.дом
	    );


  WHILE
    a <= maxd -- для каждого дома делаем так:
    DO 

	SET c = 
	(
		SELECT
		  COUNT(*) AS 'fl_count'
		FROM
		  tz.`этаж` AS t1
		WHERE
		  t1.`id_дома` = a
	);

    SET b = (SELECT FLOOR(2*RAND()));
    
    IF b = 1
    THEN
    
	SET t = (SELECT FLOOR(3+(c-2)*RAND())); -- длина пролета
	
	SET temp1 = 
		(
	
			SELECT
			  MIN(t2.`id_этажа`) AS mn
			FROM
			  tz.`дом` AS t1,
			  tz.`этаж` AS t2,
			  tz.`лестница` AS t3
			WHERE 
			  t1.`id_дома` = t2.`id_дома`
			  AND t3.`id_дома` = t2.`id_дома` AND
			  t1.`id_дома` = a
			LIMIT 0, 10000
		);
	
	INSERT INTO tz.`лестница` (`id_дома`) VALUES (a);
	

	
	INSERT INTO tz.`этаж_лестница` (`id_этажа`, `id_лестницы`) VALUES (
	
											temp1, 	
											
											(
												SELECT 
												MAX(tmp2.`id_лестницы`)
												FROM
												tz.`лестница` AS tmp2
												WHERE
												tmp2.`id_дома` = a
											)
											
									);
									
	INSERT INTO tz.`этаж_лестница` (`id_этажа`, `id_лестницы`) VALUES (
	
											temp1+t, 	
											
											(
												SELECT 
												MAX(tmp2.`id_лестницы`)
												FROM
												tz.`лестница` AS tmp2
												WHERE
												tmp2.`id_дома` = a
											)
											
									);
	

	
    
    END IF;


    SET a = a + 1;






  END WHILE;
	
	-- ----------------------------------
	
	
	
	
END//
DELIMITER ;

CALL tz.ins_proc();


