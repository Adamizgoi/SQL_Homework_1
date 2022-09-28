--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.

SELECT DISTINCT city 
FROM city;


--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.


SELECT DISTINCT city 
FROM city
WHERE city NOT LIKE '% %' AND city ILIKE 'L%a'


--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.


SELECT payment_date::date AS date_of_payment, amount, payment_id, customer_id, staff_id, rental_id
FROM payment
WHERE payment_date::date BETWEEN '2005-06-17' AND '2005-06-19 24:00:00' AND amount > 1.00
ORDER BY payment_date DESC


--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.

SELECT payment_date, amount, payment_id, customer_id, staff_id, rental_id
FROM payment
ORDER BY payment_date DESC, payment_id DESC 
LIMIT 10


--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.


SELECT CONCAT(first_name, ' ', last_name) AS "ФИО", email AS "Почта", CHARACTER_LENGTH(email) AS "Длина названия почты", CAST(last_update AS date) AS "Последнее обновление"
FROM customer


--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.


SELECT customer_id, LOWER(first_name), LOWER(last_name), store_id, email, address_id, create_date, last_update, activebool, active  
FROM customer
WHERE activebool AND first_name ILIKE 'KELLY' OR first_name ILIKE 'WILLIE'

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите одним запросом информацию о фильмах, у которых рейтинг "R" 
--и стоимость аренды указана от 0.00 до 3.00 включительно, 
--а также фильмы c рейтингом "PG-13" и стоимостью аренды больше или равной 4.00.

SELECT rental_rate, rating, title || ' ' || release_year AS film_info
FROM film
WHERE rating::text ilike 'R' AND rental_rate BETWEEN 0.00 AND 3.00 OR rating::text ilike 'PG-13' AND rental_rate >= 4.00
ORDER BY rental_rate 


--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.

SELECT title || ' ' || release_year AS film_info, description, CHAR_LENGTH(description) 
FROM film
ORDER BY char_length DESC
LIMIT 3


--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.

SELECT customer_id, SPLIT_PART(email, '@'::VARCHAR, 1) AS email_name, SPLIT_PART(email, '@'::VARCHAR, 2) AS email_domain 
FROM customer


--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква должна быть заглавной, остальные строчными.

SELECT customer_id, OVERLAY(email_name placing UPPER(LEFT(email_name, 1)) FROM 1 FOR 1) AS email_name, OVERLAY(email_domain PLACING UPPER(LEFT(email_domain, 1)) FROM 1 FOR 1) AS email_domain
FROM (
	SELECT customer_id, SPLIT_PART(LOWER(email), '@'::VARCHAR, 1) AS email_name, SPLIT_PART(email, '@'::VARCHAR, 2) AS email_domain
	FROM customer) email_new


