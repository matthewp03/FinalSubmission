LOAD DATA
INFILE 'Channel.csv'
INTO TABLE Channel
FIELDS TERMINATED BY ',' optionally enclosed by '"'
(Channel_Name, Num_Videos, Year_Created, Num_Views)

'TechChannel', 50, 2010, 1000000
'CookingChannel', 30, 2015, 800000
'MusicChannel', 40, 2012, 1200000
'ScienceChannel', 25, 2017, 500000
'TravelChannel', 35, 2014, 900000
'GamingChannel', 60, 2008, 1500000
'FashionChannel', 45, 2011, 1100000
'FitnessChannel', 55, 2009, 1300000
'ComedyChannel', 20, 2019, 700000
'NewsChannel', 30, 2016, 850000
