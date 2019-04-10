use labor_sql;
go

---[1]------------------
;WITH one_CTE AS(
SELECT * FROM outcomes
)
SELECT * FROM one_CTE
WHERE result = 'sunk'
ORDER BY battle;

---[2]------------------
;WITH one_CTE AS(
SELECT * FROM outcomes
),
two_CTE AS(
SELECT * FROM one_CTE
)
SELECT ship, battle FROM two_CTE
WHERE result = 'sunk'
ORDER BY battle;

---[3]------------------
;WITH reg_CTE AS (
SELECT region_id, id, name FROM [Geography]
WHERE region_id = '1'
)
SELECT * from reg_CTE;

---[4]------------------
SELECT * FROM geography
---[5]------------------
;WITH nat_ETC AS(
SELECT 1 AS frst
UNION ALL
SELECT frst + 1 FROM nat_ETC
WHERE frst < 1000
)
SELECT * FROM nat_ETC
OPTION (MAXRECURSION 1000);

---[6]------------------
;WITH nat_ETC AS(
SELECT 1 AS frst
UNION ALL
SELECT frst + 1 FROM nat_ETC
WHERE frst < 100000
)
SELECT * FROM nat_ETC
OPTION (MAXRECURSION 0);

---[7]------------------
;WITH weekends_CTE AS(
SELECT CAST('20190101' AS Date) AS [DATE]
UNION ALL
SELECT DATEADD(dd, 1, [DATE])
FROM weekends_CTE
WHERE DATEADD(dd, 1, [DATE]) < cast('20200101' as Date)
)
SELECT COUNT([DATE]) AS weekends FROM weekends_CTE
WHERE DATENAME(dw, date) = 'Saturday' OR DATENAME(dw, date) = 'Sunday'
OPTION(MAXRECURSION 370);

---[8]------------------
/*Просто селект*/
SELECT DISTINCT maker FROM product
WHERE type = 'pc' AND maker NOT IN (SELECT maker FROM product WHERE type = 'laptop')
---------
/*Заморочений варіант з двома СТЕ :)*/
;WITH pc_CTE AS(
SELECT DISTINCT maker FROM product
WHERE type = 'pc'
),
laptop_CTE AS(
SELECT DISTINCT maker FROM product
WHERE type = 'laptop')
SELECT * FROM pc_CTE
WHERE maker NOT IN(SELECT * FROM laptop_CTE);

---[9]------------------
SELECT DISTINCT maker FROM product
WHERE type = 'pc' AND maker != ALL(SELECT maker FROM product WHERE type = 'laptop')

---[10]------------------
SELECT DISTINCT maker FROM product
WHERE type = 'pc' AND NOT maker = ANY(SELECT maker FROM product WHERE type = 'laptop')

---[11]------------------
SELECT DISTINCT maker FROM product
WHERE type = 'laptop' AND maker IN(SELECT maker FROM product WHERE type = 'pc');

---[12]------------------
SELECT DISTINCT maker FROM product
WHERE type = 'laptop' AND NOT maker != ALL(SELECT maker FROM product WHERE type = 'pc');

---[13]------------------
SELECT DISTINCT maker FROM product
WHERE type = 'laptop' AND maker = ANY(SELECT maker FROM product WHERE type = 'pc');

---[14]------------------
SELECT DISTINCT maker FROM product
WHERE model IN(SELECT model FROM pc);

---[15]------------------
SELECT country, class FROM classes
WHERE country = ALL(SELECT country FROM classes WHERE country = 'Ukraine');

---[16]------------------
SELECT o.ship, o.battle, b.date FROM outcomes AS o
INNER JOIN battles AS b ON o.battle = b.name
WHERE o.result = 'damaged' AND o.ship IN 
(SELECT oo.ship FROM outcomes AS oo
INNER JOIN battles AS bb ON oo.battle = bb.name
WHERE bb.date > b.date);

---[17]------------------
SELECT DISTINCT p.maker FROM product AS p
WHERE EXISTS(SELECT model FROM pc WHERE p.model = pc.model);

---[18]------------------
SELECT DISTINCT maker FROM product
WHERE type = 'printer' AND maker IN(
SELECT p.maker FROM product AS p
INNER JOIN pc ON p.model = pc.model
WHERE p.type='pc' AND pc.speed = (SELECT MAX(ppp.speed) FROM pc AS ppp)
);

---[19]------------------
SELECT DISTINCT class FROM classes
WHERE class IN
(SELECT class FROM ships WHERE name IN
(SELECT ship FROM outcomes WHERE result = 'sunk'));

---[20]------------------
SELECT model, price FROM printer
WHERE price = (SELECT MAX(price) FROM printer);

---[21]------------------
SELECT p.type, l.model, l.speed FROM laptop AS l
INNER JOIN product AS p ON p.model = l.model
WHERE l.speed < ALL(SELECT DISTINCT speed FROM pc);

---[22]------------------
SELECT p.maker, pr.price FROM printer AS pr
INNER JOIN product AS p ON p.model = pr.model
WHERE pr.price = (SELECT MIN(price) FROM printer);

---[23]------------------
SELECT o.battle, c.country, COUNT(battle) AS cnt FROM outcomes AS o
INNER JOIN ships AS s ON s.name = o.ship
INNER JOIN classes AS c ON c.class = s.class
GROUP BY o.battle, c.country
HAVING COUNT(*) >= 2;

---[24]------------------
/*Для оптимізації можна створити функцію для отримання к-сть моделей виробників з таблиці. В якості аргументу надавати назву таблиці*/
SELECT DISTINCT PPP.maker,
(SELECT COUNT(p.model) FROM pc
INNER JOIN product AS p ON p.model = pc.model
WHERE p.maker = PPP.maker) AS PC,

(SELECT COUNT(p.model) FROM laptop AS l
INNER JOIN product AS p ON p.model = l.model
WHERE p.maker = PPP.maker) AS Laptop,

(SELECT COUNT(p.model) FROM printer AS pr
INNER JOIN product AS p ON p.model = pr.model
WHERE p.maker = PPP.maker) AS Printer
FROM product AS PPP;

---[25]------------------
SELECT DISTINCT p.maker, pc =
CASE 
WHEN (SELECT COUNT(pc.model) FROM pc INNER JOIN product ON pc.model = product.model WHERE product.maker = p.maker) > 0 THEN CONCAT('yes', '(', (SELECT COUNT(pc.model) FROM pc INNER JOIN product ON pc.model = product.model WHERE product.maker = p.maker) , ')')
WHEN (SELECT COUNT(pc.model) FROM pc INNER JOIN product ON pc.model = product.model WHERE product.maker = p.maker) = 0 THEN 'no'
END
FROM product AS p
LEFT JOIN pc ON p.model = pc.model;

---[26]------------------
SELECT io.point, io.date, io.inc, (SELECT out FROM outcome_o WHERE date = io.date AND point = io.point) FROM income_o AS io
ORDER BY io.date;

---[27]------------------
SELECT s.name, c.numGuns, c.bore, c.displacement, c.type, c.country, s.launched, c.class FROM ships AS s
INNER JOIN classes AS c ON s.class = c.class
WHERE
( CASE WHEN c.numGuns = 8 THEN 1 ELSE 0 END
+ CASE WHEN c.bore = 15 THEN 1 ELSE 0 END
+ CASE WHEN c.displacement = 32000 THEN 1 ELSE 0 END
+ CASE WHEN c.type = 'bb' THEN 1 ELSE 0 END
+ CASE WHEN c.country = 'USA' THEN 1 ELSE 0 END
+ CASE WHEN s.launched = 1915 THEN 1 ELSE 0 END
+ CASE WHEN c.class = 'Kongo' THEN 1 ELSE 0 END)
>= 3; /*Більше 3, а не 4 тому, що так дозволили зробити в скайпі, щоб спокійніше було :)*/

---[28]------------------
SELECT CASE WHEN o1.point IS NULL THEN o2.point ELSE o1.point END,
CASE WHEN o1.date IS NULL THEN o2.date ELSE o1.date END,
CASE
WHEN o1.out IS NULL AND o2.out IS NOT NULL
THEN 'more than once a day'
WHEN o2.out IS NULL AND o1.out IS NOT NULL
THEN 'once a day'
WHEN o2.out IS NULL AND o1.out IS NULL
THEN 'both'
WHEN o1.out > o2.out THEN 'once a day'
WHEN o1.out < o2.out THEN 'more than once a day'
WHEN o1.out = o2.out THEN 'both'
ELSE 'both' END
FROM
(SELECT point, date, out from outcome_o
WHERE (point in (SELECT DISTINCT point FROM outcome
INTERSECT
SELECT DISTINCT point FROM outcome_o))) AS o1
FULL JOIN
(SELECT point, LEFT(CONVERT(varchar, date, 121), 10) AS date, SUM(out) AS out
FROM outcome
WHERE (point IN (SELECT DISTINCT point FROM outcome
INTERSECT
SELECT DISTINCT point FROM outcome_o))
GROUP BY point, LEFT(CONVERT(varchar, date, 121), 10)) AS o2
ON LEFT(CONVERT(varchar, o1.date, 121), 10) = o2.date AND (o1.point = o2.point);

---[29]------------------
SELECT p.maker, p.model, p.type, 
(SELECT price FROM laptop WHERE model = p.model
UNION 
SELECT price FROM pc WHERE model = p.model
UNION
SELECT price FROM pc WHERE model = p.model) AS PRICE  
FROM product AS p
WHERE p.maker = 'B';

---[30]------------------
(SELECT DISTINCT name FROM ships
UNION 
SELECT DISTINCT ship FROM outcomes)
INTERSECT
(SELECT DISTINCT class FROM classes); /*Лише назви кораблів*/

SELECT name, (SELECT DISTINCT class FROM classes WHERE class = name) AS class  FROM (SELECT name FROM ships
UNION 
SELECT ship FROM outcomes) AS ship
WHERE name IN(SELECT DISTINCT class FROM classes);

---[31]------------------
SELECT c.class FROM classes AS c
WHERE (SELECT COUNT(z.name) FROM(SELECT name FROM ships WHERE ships.class = c.class
UNION 
SELECT ship FROM outcomes WHERE ship = c.class) AS z) = 1

---[32]------------------
SELECT name FROM ships
WHERE launched < 1942
UNION
SELECT ship FROM outcomes INNER JOIN battles ON battle = name
WHERE YEAR(date) < 1942
UNION
SELECT o.ship
FROM outcomes AS o INNER JOIN classes AS cl ON o.ship = cl.class
WHERE (SELECT MIN(launched) FROM ships WHERE class = o.ship) < 1942 /*Головний корабель - це перший корабель в класі. Тому, якщо будь-який інший корабель був точно < 1942 то головний теж < 1942*/
UNION
SELECT name FROM ships WHERE name = class AND class IN (SELECT class FROM ships WHERE launched < 1942)/*Є певні тавтології, щоб точно вивести всі)*/