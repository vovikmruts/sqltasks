use [labor_sql];
go

---[1]------------------
SELECT [maker], [type] FROM [product]
WHERE [type] = 'laptop'
ORDER BY [maker];

---[2]------------------
SELECT [model], [ram], [screen], [price] FROM [laptop]
WHERE [price] > 1000
ORDER BY [ram] ASC, [price] DESC;

---[3]------------------
SELECT * FROM [printer]
WHERE [color] = 'y'
ORDER BY [price] DESC;

---[4]------------------
SELECT [model], [speed], [hd], [cd], [price] FROM [pc]
WHERE [cd] = '12x' OR [cd] = '24x' AND [price] < 600
ORDER BY [speed] DESC;

---[5]------------------
SELECT [name], [class] FROM [ships]
WHERE [name] = [class]
ORDER BY [name];

---[6]------------------
SELECT * FROM [pc]
WHERE [speed] >= 500 AND [price] < 800
ORDER BY [price] DESC;

---[7]------------------
SELECT * FROM [printer]
WHERE [type] != 'Matrix' AND [price] < 300
ORDER BY [type] DESC;

---[8]------------------
SELECT [model], [speed] FROM [pc]
WHERE [price] BETWEEN 400 AND 600
ORDER BY [hd];

---[9]------------------
SELECT [model], [speed], [hd], [price] FROM [laptop]
WHERE [screen] >= 12
ORDER BY [price] DESC;

---[10]------------------
SELECT [model], [type], [price] FROM [printer]
WHERE [price] < 300
ORDER BY [type] DESC;

---[11]------------------
SELECT [model], [ram], [price] FROM [laptop]
WHERE [ram] = 64
ORDER BY [screen];

---[12]------------------
SELECT [model], [ram], [price] FROM [pc]
WHERE [ram] = 64
ORDER BY [hd];

---[13]------------------
SELECT [model], [speed], [price] FROM [pc]
WHERE [speed] BETWEEN 500 AND 750
ORDER BY [hd] DESC;
/*Якщо не включно*/
SELECT [model], [speed], [price] FROM [pc]
WHERE [speed] > 500 AND [speed] < 750
ORDER BY [hd] DESC;

---[14]------------------
SELECT * FROM [outcome_o]
WHERE  [out] > 2000
ORDER BY [date] DESC;

---[15]------------------
SELECT * FROM [income_o]
WHERE [inc] BETWEEN 5000 AND 10000
ORDER BY [inc];

---[16]------------------
SELECT * FROM [income]
WHERE [point] = 1
ORDER BY [inc];

---[17]------------------
SELECT * FROM [outcome]
WHERE [point] = 2
ORDER BY [out];

---[18]------------------
SELECT * FROM [classes]
WHERE [country] = 'Japan'
ORDER BY [type] DESC;

---[19]------------------
SELECT [name], [launched] FROM [ships]
WHERE [launched] BETWEEN 1920 AND 1942
ORDER BY [launched] DESC;

---[20]------------------
SELECT [ship], [battle], [result] FROM [outcomes]
WHERE [battle] = 'Guadalcanal' AND [result] != 'sunk'
ORDER BY [ship] DESC;

---[21]------------------
SELECT [ship], [battle], [result] FROM [outcomes]
WHERe [result] = 'sunk'
ORDER BY [ship] DESC;

---[22]------------------
SELECT [class], [displacement] FROM [classes]
WHERE [displacement] > 40000
ORDER BY [type];

---[23]------------------
SELECT [trip_no], [town_from], [town_to] FROM [trip]
WHERE [town_from] = 'London' OR [town_to] = 'London'
ORDER BY [time_out];

---[24]------------------
SELECT [trip_no], [plane], [town_from], [town_to] FROM [trip]
WHERE [plane] = 'TU-134'
ORDER BY [time_out] DESC;

---[25]------------------
SELECT [trip_no], [plane], [town_from], [town_to] FROM [trip]
WHERE [plane] != 'IL-86'
ORDER BY [plane];

---[26]------------------
SELECT [trip_no], [plane], [town_from], [town_to] FROM [trip]
WHERE [town_from] != 'Rostov' AND [town_to] != 'Rostov'
ORDER BY [plane];

---[27]------------------
SELECT * FROM [pc]
WHERE [model] LIKE '%1%1%';

---[28]------------------
SELECT * FROM [outcome]
WHERE FORMAT([date], 'MM') = '03';

---[29]------------------
SELECT * FROM [outcome_o]
WHERE FORMAT([date], 'dd') = '14';

---[30]------------------
SELECT [name] FROM [ships]
WHERE [name] LIKE 'W%n';

---[31]------------------
SELECT [name] FROM [ships]
WHERE [name] LIKE '%e%e%' AND [name] NOT LIKE '%e%e%e%';

---[32]------------------
SELECT [name], [launched] FROM [ships]
WHERE [name] NOT LIKE '%a';

---[33]------------------
SELECT [name] FROM [battles]
WHERE [name] LIKE '% %' AND [name] NOT LIKE '%c' AND [name] NOT LIKE '% % %';

---[34]------------------
SELECT * FROM [trip]
WHERE FORMAT([time_out], 'HH') BETWEEN '12' AND '17';

---[35]------------------
SELECT * FROM [trip]
WHERE FORMAT([time_in], 'HH') BETWEEN '17' AND '23';

---[36]------------------
SELECT * FROM [trip]
WHERE FORMAT([time_in], 'HH') BETWEEN 21 AND 24 OR FORMAT([time_in], 'HH') BETWEEN 0 AND 10;

---[37]------------------
SELECT [date] FROM [pass_in_trip]
WHERE [place] LIKE '1%';

---[38]------------------
SELECT [date] FROM [pass_in_trip]
WHERE [place] LIKE '%c';

---[39]------------------
SELECT SUBSTRING([name], CHARINDEX(' ',[name])+1, LEN([name] ) - 1) AS [SN] FROM [passenger]
WHERE [name] LIKE '% C%';

---[40]------------------
SELECT SUBSTRING([name], CHARINDEX(' ',[name])+1, LEN([name] ) - 1) AS [SN] FROM [passenger]
WHERE [name] NOT LIKE '% J%';

---[41]------------------
SELECT CONCAT('середня ціна= ', AVG([price])) AS price FROM [laptop];

---[42]------------------
SELECT CONCAT('Code: ', [code]) AS [code], CONCAT('Model: ', [model]) AS [model], CONCAT('Speed: ', [speed]) AS [speed], CONCAT('RAM: ', [ram]) AS [ram], CONCAT('HD: ', [hd]) AS [hd], CONCAT('CD: ', [cd]) AS [cd], CONCAT('Price: ', [price]) AS [price] FROM [pc];

---[43]------------------
SELECT FORMAT([date], 'yyyy.MM.dd') FROM [income];

---[44]------------------
SELECT [ship], [battle],
  CASE
    WHEN [result] = 'sunk' THEN 'потоплений'
    WHEN [result] = 'OK' THEN 'цілий'
    WHEN [result] = 'damaged' THEN 'пошкоджений'
  END [result]
FROM [outcomes];

---[45]------------------
SELECT [trip_no], [date], [id_psg],  CONCAT('ряд: ' ,SUBSTRING([place], 1,1)) AS [row], CONCAT('місце: ' ,SUBSTRING([place], 2,1)) AS [seat] FROM [pass_in_trip];

---[46]------------------
/*Якщо треба видалити зайві пробіли*/
SELECT [trip_no], [id_comp], [plane], CONCAT('from: ', REPLACE([town_from], ' ',''), ' to: ', [town_to]), [time_out], [time_in] FROM [trip];
/*Якщо не треба*/
SELECT [trip_no], [id_comp], [plane], CONCAT('from: ', [town_from], 'to: ', [town_to]), [time_out], [time_in] FROM [trip];

---[47]------------------
/*Невпевнений, що правильно зрозумів суть завдання.
Запит збирає в кожного поля рядка перший та останній символ та додає його у спеціально створене поле.*/
SELECT *, CONCAT(
SUBSTRING(CONVERT(varchar(150),[trip_no]), 1, 1), SUBSTRING(CONVERT(varchar(150),[trip_no]), LEN([trip_no]), 1),
SUBSTRING(CONVERT(varchar(150),[id_comp]), 1, 1), SUBSTRING(CONVERT(varchar(150),[id_comp]), LEN([id_comp]), 1),
SUBSTRING(CONVERT(varchar(150),[plane]), 1, 1), SUBSTRING(CONVERT(varchar(150),[plane]), LEN([plane]), 1),
SUBSTRING(CONVERT(varchar(150),[town_from]), 1, 1), SUBSTRING(CONVERT(varchar(150),[town_from]), LEN([town_from]), 1),
SUBSTRING(CONVERT(varchar(150),[town_to]), 1, 1), SUBSTRING(CONVERT(varchar(150),[town_to]), LEN([town_to]), 1),
SUBSTRING(CONVERT(varchar(150), [time_out], 121) , 1, 1), SUBSTRING(CONVERT(varchar(150),[time_out], 121), LEN([time_out]), 1),
SUBSTRING(CONVERT(varchar(150), [time_in], 121) , 1, 1), SUBSTRING(CONVERT(varchar(150),[time_in], 121), LEN([time_in]), 1))
AS [all]
FROM [trip]

---[48]------------------
SELECT [maker], COUNT([model]) FROM [product]
WHERE [type] = 'pc'
GROUP BY [maker]
HAVING COUNT([model]) >= 2

---[49]------------------
SELECT town, COUNT(town) AS quan FROM(
SELECT [town_from] AS town FROM [trip]
UNION ALL
SELECT [town_to] AS town FROM [trip]
) AS t
GROUP BY town;

---[50]------------------
SELECT [type], COUNT([model]) FROM [printer]
GROUP BY [type];

---[51]------------------
SELECT [cd], COUNT([model]) FROM [pc]
GROUP BY [cd];

---[52]------------------
SELECT [trip_no], [town_from], [town_to], DATEDIFF(hour, [time_out], [time_in]) FROM [trip];

---[53]------------------
SELECT [point], [date], SUM([out]) AS [day_total] FROM [outcome]
GROUP BY [date], [point];---для кожної дати

SELECT [point], SUM([out]) AS [total], MIN([out]) AS [Min], MAX([out]) AS [Max] FROM [outcome]
GROUP BY [point];---для всіх

---[54]------------------
SELECT [trip_no], SUBSTRING([place], 1, 1) AS [row], COUNT(SUBSTRING([place], 1, 1)) AS [quan] FROM [pass_in_trip]
GROUP BY [trip_no], SUBSTRING([place], 1, 1) 
ORDER BY [trip_no];

---[55]------------------
SELECT COUNT([id_psg]) AS [total] FROM [passenger]
WHERE [name] LIKE '% S%' OR [name] LIKE '% B%' OR [name] LIKE '% A%';