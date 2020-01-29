SELECT
  t1.id_дома
FROM
  tz.Этаж AS t1,
  tz.Лестница AS t2,
  tz.Этаж_лестница AS t3
WHERE (t2.id_дома = t1.id_дома)
  AND (
    t3.id_этажа = t1.id_этажа
  )
  AND (
    t3.id_лестницы = t2.id_лестницы
  )
  AND (
    (
      t1.номер_этажа LIKE 'первый%'
    )
    OR (
      t1.номер_этажа LIKE 'пятый%'
    )
  )
GROUP BY t1.id_дома,
  t2.id_лестницы
HAVING COUNT(
    DISTINCT t1.номер_этажа
  ) > 1
ORDER BY t1.id_дома;