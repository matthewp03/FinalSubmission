LOAD DATA
INFILE 'Channel.csv'
INTO TABLE Channel
FIELDS TERMINATED BY ',' optionally enclosed by '"'
(Channel_Name, Num_Videos, Year_Created, Num_Views)
