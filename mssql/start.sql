set NoCount ON

create database planzdor

go

create table planzdor.dbo.apt
(
	idapt INT IDENTITY (1,1) NOT NULL,
	name VARCHAR (15) NOT NULL
	CONSTRAINT PK_idapt PRIMARY KEY (idapt)
)

go
create table planzdor.dbo.dok
(
	id_ndok INT IDENTITY (1,1) NOT NULL,
	dd DATE NOT NULL,
	apteka INT NOT NULL
	CONSTRAINT PK_idndok PRIMARY KEY (id_ndok)
	CONSTRAINT FK_idapt FOREIGN KEY (apteka)
		REFERENCES dbo.apt (idapt)
)

go

create table planzdor.dbo.tovar
(
	idpos INT IDENTITY (1,1) NOT NULL,
	shortname VARCHAR (15) NOT NULL
	CONSTRAINT PK_idpos PRIMARY KEY (idpos)
		
)

go

create table planzdor.dbo.dbsgroups
(
	id_gr INT IDENTITY (1,1) NOT NULL,
	name_gr VARCHAR (15) NOT NULL
	CONSTRAINT PK_idgr PRIMARY KEY (id_gr)
		
)

go 

create table planzdor.dbo.dbsgroupkeys
(
	id_gr INT NOT NULL,
	id_line INT NOT NULL
	CONSTRAINT FK_idgr FOREIGN KEY (id_gr)
		REFERENCES dbo.dbsgroups (id_gr),
	CONSTRAINT FK_idline FOREIGN KEY (id_line)
		REFERENCES dbo.tovar (idpos)
		
)

go 

create table planzdor.dbo.dok_sost
(
	id_ndok INT NOT NULL,
	idpos INT NOT NULL,
	kol INT NOT NULL,
	summa FLOAT NOT NULL,
	summa_sale FLOAT NOT NULL,
	discount FLOAT NOT NULL
	CONSTRAINT FK_idndok FOREIGN KEY (id_ndok)
		REFERENCES dbo.dok (id_ndok),
	CONSTRAINT FK_idpos FOREIGN KEY (idpos)
		REFERENCES dbo.tovar (idpos)
)

go


/* заполнение данными */


DECLARE @tovar_count INT;	 -- общее количество товаров во всех группах 
DECLARE @tov_in_group INT;	 -- количество товаров в одной группе


begin

set @tovar_count = 155;	
set @tov_in_group = 10;	

with Ttovar as
(
	select 
		1 as N
union ALL
	select 
		N+1
	from
		Ttovar
	where
		N+1<@tovar_count+1
)

insert into planzdor.dbo.tovar (shortname) 
select 
 	'Товар '+CONVERT (varchar(15), N)
from
	Ttovar 
option 
(MAXRECURSION 0);



with Tdbsgroups as
(
	select 
		1 as N
union ALL
	select 
		N+1
	from
		Tdbsgroups
	where
		N+1<ceiling(cast (@tovar_count as float) / cast(@tov_in_group as float)) + 1
)

insert into planzdor.dbo.dbsgroups (name_gr) 
select 
 	'Группа '+CONVERT (varchar(15),N)
from
	Tdbsgroups
option 
	(MAXRECURSION 0);
	
	
declare @i INT;
set @i = 1;
declare @j INT;
set @j = 1;
declare @k INT;
set @k = 0;

-- текущая dbsgroups.id_gr < округления (@tovar_count/@tov_in_group) в большую сторону
while @i <= CEILING (CAST(@tovar_count as float)/CAST(@tov_in_group as float)) 

	begin

		-- пробегаем от 1 до кол-ва товаров в группе, чтобы сделать в группах по одинаковому кол-ву товаров
		while @j <= @tov_in_group 

			begin	
					insert into planzdor.dbo.dbsgroupkeys (id_gr, id_line)
						select 
							t1.id_gr,
							t2.idpos 
						from	
							planzdor.dbo.dbsgroups as t1,
							planzdor.dbo.tovar as t2
						where
							t1.id_gr = @i
							and t2.idpos = @j + @k;
					
					set @j = @j + 1;
			end;

set @k = @k + @j - 1;			
set @j = 1;
set @i = @i + 1;


	end;



with Tapt as	-- 50 аптек
(
	select 
		1 as N
union ALL
	select 
		N+1
	from
		Tapt
	where
		N+1<51
)

insert into planzdor.dbo.apt (name) 
select 
 	'Аптека '+CONVERT (varchar(15),N)
from
	Tapt
option
	(MAXRECURSION 0);
	
	






declare @i2 INT;
set @i2 = 1;
declare @j2 INT;
set @j2 = 1;


while @i2 <= 50 -- в каждой аптеке по 10 документов

	begin
		
		while @j2 <= 10

			begin	
					insert into planzdor.dbo.dok (dd, apteka)
						select 
							CONVERT(date, '2015-07-'+CAST(round(RAND()*29+1,0) as varchar(2))),
							t1.idapt
						from	
							planzdor.dbo.apt as t1
						where
							t1.idapt = @i2
					
					set @j2 = @j2 + 1;
												
			end;
set @j2 = 1;
set @i2 = @i2 + 1;


	end;	
	




	-- генерация состава документа
	
DECLARE @tov_in_dok INT;	-- количество товаров в одном документе
	
DECLARE @tid_i INT;			-- счетчик для количества товаров в документе
	SET @tid_i =1;	
	
DECLARE @dc_i INT;			-- счетчик для цикла @dok_count
	SET @dc_i = 1;
	
DECLARE @i3 INT;
	SET @i3 = -1;

DECLARE @s1 float;
DECLARE @s2 float;
DECLARE @disc float;


-- для каждого документа выполним

while @dc_i <= 500
	begin
	
		SET @tov_in_dok = ROUND(RAND()*2+1, 0); -- может быть от 1 до 3 товаров в одном документе
	
		while @tid_i<=@tov_in_dok
			
			begin
				
				set @i3 = RAND()*154+1;		-- выбор случайного товара 
				
				while exists 
						(
							select 
									1 
							from 
								planzdor.dbo.dok_sost 
							where 
								idpos = @i3 and 
								id_ndok = @dc_i
						)
				
					set @i3 = RAND()*154+1;		-- выбор случайного товара 
			 		
			 		set @s1 = ROUND(RAND()*4300+200, 2);
			 		set @s2 = @s1 + ROUND(RAND()*4300+200, 2); 
			 		set @disc = ROUND (ROUND(RAND()*5, 0)*@s2/100, 0);
			 	
			 	
			 		insert into planzdor.dbo.dok_sost (id_ndok, idpos, kol, summa, summa_sale, discount)
				 	
					select 
							@dc_i	, 
							@i3		,
			 				ROUND(RAND()*4+1, 0),
			 				@s1,
			 				@s2,
			 				@disc;
				 						 			
				 					
					set @tid_i = @tid_i + 1;
						
			end
	print 'Обработан документ №'+cast(@dc_i as varchar)+' содержит '+cast(@tid_i-1 as varchar)+' товар/а/ов';
	
	
	set  @tid_i = 1;
	
	set  @dc_i = @dc_i + 1
	
	end;
	
end;
	
	
	
	



