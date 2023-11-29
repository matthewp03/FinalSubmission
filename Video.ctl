LOAD DATA
INFILE 'Video.csv'
INTO TABLE Video
FIELDS TERMINATED BY ',' optionally enclosed by '"'
(Video_Name, Length, Likes_Dislikes, Views, Channel_Name, Date_Posted "YYYY-MM-DD", View_Count, Date_Watched "YYYY-MM-DD")

'Intro_to_SQL', 10, 500, 50000, 'TechChannel', '2023-01-01', 2000, '2023-01-05'
'Pasta_Recipe', 15, 200, 30000, 'CookingChannel', '2023-02-01', 1500, '2023-02-10'
'Guitar_Tutorial', 8, 300, 40000, 'MusicChannel', '2023-03-01', 1800, '2023-03-15'
'Physics_Experiment', 12, 150, 25000, 'ScienceChannel', '2023-04-01', 1200, '2023-04-08'
'Travel_Diaries', 20, 600, 70000, 'TravelChannel', '2023-05-01', 2500, '2023-05-12'
'Gaming_Playthrough', 25, 800, 90000, 'GamingChannel', '2023-06-01', 3000, '2023-06-18'
'Fashion_Showcase', 18, 400, 55000, 'FashionChannel', '2023-07-01', 2200, '2023-07-20'
'Fitness_Workout', 30, 700, 80000, 'FitnessChannel', '2023-08-01', 2800, '2023-08-25'
'Comedy_Skit', 12, 100, 18000, 'ComedyChannel', '2023-09-01', 900, '2023-09-10'
'News_Report', 15, 250, 35000, 'NewsChannel', '2023-10-01', 1200, '2023-10-15'
