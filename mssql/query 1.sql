use planzdor
go

select 
	t3.idpos 'Код товара',
	t3.shortname 'Название',
	sum(t2.kol)	'Кол-во',
	sum(t2.summa-t2.discount) 'Сумма со скидкой'
	
from 
	dbo.dok t1 
join dbo.dok_sost t2 
	on t1.id_ndok = t2.id_ndok 
join dbo.tovar t3 
	on t3.idpos = t2.idpos
where
	t1.dd between '2015-07-01' and '2015-07-02'

group by t3.idpos, t3.shortname
order by t3.idpos;