use labor_sql;
go

---[1]------------------
SELECT maker, type, speed, hd FROM product
INNER JOIN pc ON product.model = pc.model
WHERE pc.hd <= '8';

---[2]------------------
SELECT maker FROM product
INNER JOIN pc ON product.model = pc.model
WHERE pc.speed >= '600';

---[3]------------------
SELECT maker FROM product
INNER JOIN laptop ON product.model = laptop.model
WHERE laptop.speed <= '500';

---[4]------------------
SELECT DISTINCT one.model, two.model, one.hd, one.ram FROM laptop AS one
CROSS JOIN laptop AS two
WHERE one.RAM = two.RAM AND one.hd = two.hd AND one.code != two.code
ORDER BY one.model DESC, two.model ASC;

---[5]------------------
/*Лише країна*/
SELECT one.country FROM classes AS one
WHERE one.type = 'bb'
INTERSECT
SELECT two.country FROM classes AS two
WHERE type = 'bc'
ORDER BY country

/*Країна і клас, адекватно працює, лише тоді, коли в країни тільки по одному bb i bc*/
SELECT DISTINCT t1.country, t1.class, t2.class 
FROM Classes t1
INNER JOIN Classes t2 ON t1.country = t2.country 
WHERE t1.type='bb'
AND t2.type='bc'

/*Просто хотів заморочитись і зробити, як в неправильно сформованому завданні :)
Збирає всі класи з типами bb i bc і записує ії в одне поле через кому*/
SELECT DISTINCT c.country,
substring(
        (select cl1.class + ',' AS 'data()' from classes AS cl1
		WHERE cl1.type = 'bb' AND cl1.country = c.country
		for xml path('')), 1, 255) AS bb,
substring(
        (select cl2.class + ',' AS 'data()' from classes AS cl2
		WHERE cl2.type = 'bc' AND cl2.country = c.country
		for xml path('')), 1, 255) AS bc
FROM classes AS c
WHERE (substring(
        (select cl2.class + ',' AS 'data()' from classes AS cl2
		WHERE cl2.type = 'bc' AND cl2.country = c.country
		for xml path('')), 1, 255)) IS NOT NULL
AND
(substring(
        (select cl1.class + ',' AS 'data()' from classes AS cl1
		WHERE cl1.type = 'bb' AND cl1.country = c.country
		for xml path('')), 1, 255)) IS NOT NULL

---[6]------------------
SELECT pc.model, p.maker FROM pc
INNER JOIN product AS p ON p.model = pc.model
WHERE price < 600;

---[7]------------------
SELECT pr.model, p.maker FROM printer AS pr
INNER JOIN product AS p ON pr.model = p.model
WHERE pr.price > 300;

---[8]------------------
SELECT p.maker, pc.model, price FROM pc
INNER JOIN product AS p ON p.model = pc.model
UNION ALL
SELECT p.maker, laptop.model, price FROM laptop
INNER JOIN product AS p ON p.model = laptop.model;

---[9]------------------
SELECT p.maker, pc.model, price FROM pc
INNER JOIN product AS p ON p.model = pc.model;

---[10]------------------
SELECT p.maker, p.type, laptop.model, speed FROM laptop
INNER JOIN product AS p ON p.model = laptop.model
WHERE speed > 600;

---[11]------------------
SELECT s.*, c.displacement FROM ships AS s
INNER JOIN classes AS c ON c.class = s.class;

---[12]------------------
SELECT o.ship, b.name, b.date FROM outcomes AS o
INNER JOIN battles AS b ON o.battle = b.name
WHERE result != 'sunk' /*Якщо вцілілий - це не потоплений. Якщо який навіть не пошкодило - то WHERE result = 'OK'*/
ORDER BY o.ship;

---[13]------------------
SELECT s.name, c.country FROM ships AS s
INNER JOIN classes AS c ON c.class = s.class;

---[14]------------------
SELECT t.plane, c.name FROM company AS c
INNER JOIN trip AS t ON t.id_comp = c.id_comp
WHERE t.plane = 'Boeing';

---[15]------------------
SELECT p.name, pit.date FROM passenger AS p
INNER JOIN pass_in_trip AS pit ON p.id_psg = pit.id_psg;

---[16]------------------
SELECT pc.model, speed, hd FROM pc
INNER JOIN product AS p ON p.model = pc.model
WHERE hd = 10 OR hd = 20 AND p.maker = 'A'
UNION ALL/*Якщо комп'ютер - це лише ПК - то перша частина. Якщо і ПК і лептоп -то все*/
SELECT l.model, speed, hd FROM laptop AS l
INNER JOIN product AS p ON p.model = l.model
WHERE hd = 10 OR hd = 20 AND p.maker = 'A';

---[17]------------------
SELECT maker, [pc], [laptop], [printer]
FROM product
PIVOT (COUNT(model) FOR type IN ([pc],[laptop],[printer])) AS cnt;

---[18]------------------
SELECT 'average price' AS avg_, [11], [12], [14], [15] 
FROM (SELECT price, screen FROM laptop) AS ddd
PIVOT (AVG(price) FOR screen IN ([11], [12], [14], [15])) AS avg;

---[19]------------------
SELECT *
FROM laptop AS l
CROSS APPLY (
SELECT maker FROM product P
WHERE P.model = l.model
) AS maker

---[20]------------------
SELECT * FROM laptop AS lap
INNER JOIN product AS pro ON lap.model = pro.model
CROSS APPLY(
SELECT MAX(L.price) AS max_price FROM product AS P
INNER JOIN laptop AS L ON L.model = P.model
WHERE L.model = P.model AND P.maker = Pro.maker
)
AS max_price

---[21]------------------
SELECT * FROM laptop AS lap
CROSS APPLY
(SELECT TOP 1 * FROM Laptop l 
WHERE lap.model < l.model OR (lap.model = l.model AND lap.code < l.code) 
ORDER BY model, code) X
ORDER BY lap.model;

---[22]------------------
SELECT * FROM laptop AS lap
OUTER APPLY
(SELECT TOP 1 * FROM Laptop l 
WHERE lap.model < l.model OR (lap.model = l.model AND lap.code < l.code) 
ORDER BY model, code) X
ORDER BY lap.model;

---[23]------------------
SELECT pro.* FROM 
(SELECT DISTINCT type FROM product) AS pr
CROSS APPLY 
(SELECT TOP 3 * FROM product Pro
 WHERE Pr.type=Pro.type 
 ORDER BY pro.model) AS pro;

 ---[24]------------------
SELECT code, name, value FROM laptop AS lap
CROSS APPLY
(VALUES('speed', speed)
,('ram', ram)
,('hd', hd)
,('screen', screen)
) spec(name, value)
ORDER BY code, name, value;