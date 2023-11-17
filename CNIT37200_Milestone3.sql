/* The project spec says we need a function or procedure for all of the questions, 
a cursor for at least 1 of the questions, a trigger for at least 1 question, and a package
for all of the functions and procedures. */

--Creates the Tables:
CREATE TABLE Video (
  Video_Name VARCHAR2(255) PRIMARY KEY,
  Length NUMBER,
  Likes_Dislikes NUMBER,
  Views NUMBER,
  Channel_Name VARCHAR2(255) REFERENCES Channel(Channel_Name),
  Date_Posted DATE,
  View_Count NUMBER,
  Date_Watched DATE
);

CREATE TABLE Channel (
  Channel_Name VARCHAR2(255) PRIMARY KEY,
  Num_Videos NUMBER,
  Year_Created NUMBER,
  Num_Views NUMBER
);

CREATE TABLE Viewer (
  User_Name VARCHAR2(255) PRIMARY KEY,
  Date_Created DATE,
  Num_Videos_Viewed NUMBER,
  Num_Liked_Disliked_Videos NUMBER,
  Video_Name VARCHAR2(255) REFERENCES Video(Video_Name)
);
/

--Question Package
CREATE OR REPLACE PACKAGE video_package AS
  TYPE video_info IS RECORD (
    channel_name VARCHAR2(255),
    num_videos NUMBER,
    avg_likes_dislikes NUMBER
  );

  TYPE viewer_info IS RECORD (
    user_name VARCHAR2(255),
    date_created DATE,
    num_videos_viewed NUMBER,
    date_watched DATE
  );

  TYPE viewer_monthly_info IS RECORD (
    user_name VARCHAR2(255),
    year_month VARCHAR2(7),
    num_videos_watched NUMBER
  );

  TYPE viewer_days_since_creation IS RECORD (
    user_name VARCHAR2(255),
    video_name VARCHAR2(255),
    days_since_creation NUMBER
  );

  TYPE popular_channel_info IS RECORD (
    channel_name VARCHAR2(255),
    num_views NUMBER
  );

  TYPE popular_channel_viewer_info IS RECORD (
    user_name VARCHAR2(255),
    date_watched DATE,
    video_name VARCHAR2(255)
  );

  TYPE rewatched_videos_info IS RECORD (
    user_name VARCHAR2(255),
    video_name VARCHAR2(255),
    num_views NUMBER
  );

  TYPE average_watch_time_info IS RECORD (
    user_name VARCHAR2(255),
    average_watch_time NUMBER
  );

  FUNCTION get_channel_info RETURN SYS_REFCURSOR;

  FUNCTION count_videos_watched RETURN SYS_REFCURSOR;

  FUNCTION get_viewer_info RETURN SYS_REFCURSOR;

  FUNCTION get_viewer_monthly_info RETURN SYS_REFCURSOR;

  FUNCTION get_days_since_creation(video_name_in VARCHAR2) RETURN SYS_REFCURSOR;

  FUNCTION get_most_popular_channel RETURN SYS_REFCURSOR;

  FUNCTION get_most_popular_channel_viewers RETURN SYS_REFCURSOR;

  PROCEDURE find_rewatched_videos;

  PROCEDURE calculate_average_watch_time(start_date_in DATE, end_date_in DATE);
END video_package;
/

CREATE OR REPLACE PACKAGE BODY video_package AS
  FUNCTION get_channel_info RETURN SYS_REFCURSOR IS
    channel_cursor SYS_REFCURSOR;
  BEGIN
    OPEN channel_cursor FOR
      SELECT
        c.channel_name,
        COUNT(v.video_name) AS num_videos,
        AVG(v.likes_dislikes) AS avg_likes_dislikes
      FROM
        channel c
        JOIN video v ON c.channel_name = v.channel_name
      GROUP BY
        c.channel_name;

    RETURN channel_cursor;
  END get_channel_info;

  FUNCTION count_videos_watched RETURN SYS_REFCURSOR IS
    watched_cursor SYS_REFCURSOR;
  BEGIN
    OPEN watched_cursor FOR
      SELECT
        c.channel_name,
        COUNT(v.video_name) AS num_videos_watched
      FROM
        channel c
        JOIN video v ON c.channel_name = v.channel_name
      WHERE
        v.date_watched IS NOT NULL
      GROUP BY
        c.channel_name;

    RETURN watched_cursor;
  END count_videos_watched;

  FUNCTION get_viewer_info RETURN SYS_REFCURSOR IS
    viewer_cursor SYS_REFCURSOR;
  BEGIN
    OPEN viewer_cursor FOR
      SELECT
        v.user_name,
        u.date_created,
        COUNT(v.video_name) AS num_videos_viewed,
        MAX(v.date_watched) AS date_watched
      FROM
        viewer v
        JOIN user u ON v.user_name = u.user_name
      GROUP BY
        v.user_name, u.date_created;

    RETURN viewer_cursor;
  END get_viewer_info;

  FUNCTION get_viewer_monthly_info RETURN SYS_REFCURSOR IS
    monthly_cursor SYS_REFCURSOR;
  BEGIN
    OPEN monthly_cursor FOR
      SELECT
        v.user_name,
        TO_CHAR(v.date_watched, 'YYYY-MM') AS year_month,
        COUNT(v.video_name) AS num_videos_watched
      FROM
        viewer v
        JOIN user u ON v.user_name = u.user_name
      WHERE
        v.date_watched IS NOT NULL
      GROUP BY
        v.user_name, TO_CHAR(v.date_watched, 'YYYY-MM');

    RETURN monthly_cursor;
  END get_viewer_monthly_info;

  FUNCTION get_days_since_creation(video_name_in VARCHAR2) RETURN SYS_REFCURSOR IS
    days_since_creation_cursor SYS_REFCURSOR;
  BEGIN
    OPEN days_since_creation_cursor FOR
      SELECT
        v.user_name,
        v.video_name,
        TRUNC(v.date_watched - u.date_created) AS days_since_creation
      FROM
        viewer v
        JOIN user u ON v.user_name = u.user_name
      WHERE
        v.date_watched IS NOT NULL
        AND v.video_name = video_name_in;

    RETURN days_since_creation_cursor;
  END get_days_since_creation;

  FUNCTION get_most_popular_channel RETURN SYS_REFCURSOR IS
    popular_channel_cursor SYS_REFCURSOR;
  BEGIN
    OPEN popular_channel_cursor FOR
      SELECT
        c.channel_name,
        MAX(c.num_views) AS num_views
      FROM
        channel c;

    RETURN popular_channel_cursor;
  END get_most_popular_channel;

  FUNCTION get_most_popular_channel_viewers RETURN SYS_REFCURSOR IS
    popular_channel_viewers_cursor SYS_REFCURSOR;
  BEGIN
    OPEN popular_channel_viewers_cursor FOR
      SELECT
        v.user_name,
        v.date_watched,
        v.video_name
      FROM
        viewer v
        JOIN video vid ON v.video_name = vid.video_name
        JOIN (
          SELECT
            c.channel_name,
            MAX(c.num_views) AS max_views
          FROM
            channel c
        ) max_channel ON vid.channel_name = max_channel.channel_name
      WHERE
        v.date_watched IS NOT NULL;

    RETURN popular_channel_viewers_cursor;
  END get_most_popular_channel_viewers;

  PROCEDURE find_rewatched_videos IS
    rewatched_videos_cursor SYS_REFCURSOR;
  BEGIN
    OPEN rewatched_videos_cursor FOR
      SELECT
        v.user_name,
        v.video_name,
        COUNT(*) AS num_views
      FROM
        viewer v
      WHERE
        v.date_watched IS NOT NULL
      GROUP BY
        v.user_name, v.video_name
      HAVING
        COUNT(*) >= 3;

    -- Display the results or do any necessary processing
    -- ...

    CLOSE rewatched_videos_cursor;
  END find_rewatched_videos;

  PROCEDURE calculate_average_watch_time(start_date_in DATE, end_date_in DATE) IS
    average_watch_time_cursor SYS_REFCURSOR;
  BEGIN
    OPEN average_watch_time_cursor FOR
      SELECT
        v.user_name,
        AVG(v.length) AS average_watch_time
      FROM
        viewer v
        JOIN video vid ON v.video_name = vid.video_name
      WHERE
        v.date_watched BETWEEN start_date_in AND end_date_in
        AND v.date_watched IS NOT NULL
      GROUP BY
        v.user_name;

    -- Display the results or do any necessary processing
    -- ...

    CLOSE average_watch_time_cursor;
  END calculate_average_watch_time;

END video_package;
