LOAD DATA
INFILE 'Video.csv'
INTO TABLE Video
FIELDS TERMINATED BY ',' optionally enclosed by '"'
(Video_Name, Length, Likes_Dislikes, Views, Channel_Name, Date_Posted "YYYY-MM-DD", View_Count, Date_Watched "YYYY-MM-DD")
