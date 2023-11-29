LOAD DATA
INFILE 'Viewer.csv'
INTO TABLE Viewer
FIELDS TERMINATED BY ',' optionally enclosed by '"'
(User_Name, Date_Created "YYYY-MM-DD", Num_Videos_Viewed, Num_Liked_Disliked_Videos, Video_Name)

'JohnDoe', '2022-01-01', 20, 10, 'Intro_to_SQL'
'AliceSmith', '2022-02-01', 15, 5, 'Pasta_Recipe'
'BobJohnson', '2022-03-01', 25, 12, 'Guitar_Tutorial'
'EveWilliams', '2022-04-01', 18, 8, 'Physics_Experiment'
'CharlieBrown', '2022-05-01', 30, 15, 'Travel_Diaries'
'LilyGreen', '2022-06-01', 35, 18, 'Gaming_Playthrough'
'MaxTaylor', '2022-07-01', 28, 14, 'Fashion_Showcase'
'SophieMiller', '2022-08-01', 40, 20, 'Fitness_Workout'
'DaveWilson', '2022-09-01', 15, 7, 'Comedy_Skit'
'EmmaDavis', '2022-10-01', 22, 11, 'News_Report'
