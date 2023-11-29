LOAD DATA
INFILE 'Viewer.csv'
INTO TABLE Viewer
FIELDS TERMINATED BY ',' optionally enclosed by '"'
(User_Name, Date_Created "YYYY-MM-DD", Num_Videos_Viewed, Num_Liked_Disliked_Videos, Video_Name)
