/*
Задание:
В нашей компании замеряется такой показатель, 
как “30-дневная активная база”. 
Для любого дня - это число клиентов за предыдущие 30 дней. 
(Например, для 2022-01-01 - это число уникальных клиентов, 
совершивших визит за 30 дней до 2022-01-01, включая 2022-01-01. 
Для 2022-01-02 - это число уникальных клиентов, 
совершивших визит за 30 дней до 2022-01-02, включая 2022-01-02 и т.д.)
Допустим у вас есть таблица с чековыми данными по двум городам 
со следующими полями: 
	cityname - наименование города, 
	date - дата чека, 
	orderid - id чека, 
	clientid - id клиента, 
	sales - сумма чека в рублях
Данные в таблице с 2022-01-01 по 2022-06-30.
Посчитайте подневную динамику 30-дневной активной базы по каждому городу, 
отсортируйте по городу и дате по возрастанию.

city1 2022-02-01 534
city1 2022-06-30 976
city2 2022-02-01 3450
city2 2022-06-30 4210
*/
CREATE TABLE public.dodo
(
    cityname "char" NOT NULL,
    date date,
    clientid integer,
    orderid integer,
    sales numeric,
    PRIMARY KEY (cityname)
);

ALTER TABLE IF EXISTS public.dodo
    OWNER to postgres;


SELECT cityname, date, 
	SUM(client_per_day) OVER (PARTITION BY cityname
							 ORDER BY date
							 RANGE BETWEEN INTERVAL '30' DAY PRECEDING
							 AND CURRENT ROW
							 ) as active_base 
	FROM (
			SELECT cityname, date, COUNT (clientid) AS client_per_day
			FROM (
				SELECT DISTINCT cityname, date, clientid
				FROM dodo
				) AS t1
			
			GROUP BY cityname, date
			) AS count_clients_day
ORDER BY cityname, date
