use planzdor
go

select
	t4.name 'Аптека',
	t3.dd	'Дата',
	sum(t2.kol)	'Кол-во',
	sum(t2.summa) 'Приход',
	sum(t2.summa_sale) 'Розница',
	sum(t2.discount) 'Скидка'
	
		
from
	dbsgroupkeys t1 
join dok_sost t2
	on t1.id_line = t2.idpos
join dok t3
	on t2.id_ndok = t3.id_ndok
join apt t4
	on t3.apteka = t4.idapt
where
	t1.id_gr = 1
	
group by t4.idapt, t4.name, t3.dd
order by t4.idapt, t3.dd;	
	
	