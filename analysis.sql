-- Instagram User Analytics
-- Description:
-- User analysis is the process by which we track how users engage and interact with our digital
-- product (software or mobile application)
-- in an attempt to derive business insights for marketing, product & development teams.

USE ig_clone;

-- 1. Find the 5 oldest users of the Instagram from the database provided
SELECT * FROM users;
SELECT  username,created_at FROM users ORDER BY created_at LIMIT 5;

-- 2. Find the users who have never posted a single photo on Instagram
SELECT * FROM photos,users;
SELECT * FROM users u LEFT JOIN photos p on p.user_id=u.id WHERE p.image_url IS NULL ORDER BY u.username;

-- 3. Identify the winner of the contest and provide their details to the team
SELECT * FROM likes, photos, users;

SELECT likes.photo_id, users.username, count(likes.user_id) AS total_likes
FROM likes INNER JOIN photos ON likes.photo_id=photos.id 
INNER JOIN users ON photos.user_id=users.id GROUP BY
likes.photo_id, users.username ORDER BY total_likes DESC;

-- 4. Identify and suggest the top 5 most commonly used hashtags on the platform
SELECT * FROM photo_tags,tags;

SELECT t.tag_name, COUNT(p.photo_id) AS ht FROM photo_tags p INNER JOIN tags t ON t.id=p.tag_id GROUP BY t.tag_name ORDER BY ht DESC;

-- 5. What day of the week od most users register on? Provide insighs on when to schedule an ad campaign
SELECT * FROM users;

SELECT DATE_FORMAT((created_at), '%W') as dayy, count(username) FROM users GROUP BY 1 ORDER BY 2 DESC;

-- 6. Provide how many times does average user posts on Instagram. Also, provide the total number of
--    photos on Instagram/total number of users
SELECT * FROM photos, users;
WITH base AS(
SELECT u.id AS userid, count(p.id) AS photoid FROM users u LEFT JOIN photos p ON p.user_id=u.id GROUP BY u.id)
SELECT sum(photoid) AS totalphotos, COUNT(userid) AS total_users, SUM(photoid)/count(userid) AS photo_per_user
FROM base;

-- 7. Provide data on users (bots) who have liked every single photo on the site (since any normal user would
--    not be able to do this).
SELECT * FROM users,likes;
WITH base AS(
SELECT u.username, COUNT(l.photo_id) AS likess FROM likes l INNER JOIN users u ON u.id=user_id
GROUP BY u.username)
SELECT username,likess FROM base WHERE likess=(SELECT COUNT(*) FROM photos) ORDER BY username;
