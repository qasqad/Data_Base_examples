use planzdor
go

select 
		t1.name 'Аптека',
		t5.name_gr 'Группа',
		avg((((t3.summa_sale - t3.discount) - t3.summa))/(t3.summa)*100) 'Наценка средняя, %',
		min((((t3.summa_sale - t3.discount) - t3.summa))/(t3.summa)*100) 'Наценка минимальная, %',
		max((((t3.summa_sale - t3.discount) - t3.summa))/(t3.summa)*100) 'Наценка максимальная, %'
		
from
	apt t1
join dok t2
	on t1.idapt = t2.apteka
join dok_sost t3
	on t2.id_ndok = t3.id_ndok 
join dbsgroupkeys t4
	on t3.idpos = t4.id_line
join dbsgroups t5
	on t4.id_gr = t5.id_gr


group by t1.idapt, t1.name, t5.id_gr, t5.name_gr
order by t1.idapt, t5.id_gr
	
	