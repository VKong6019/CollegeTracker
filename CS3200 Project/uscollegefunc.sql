use uscolleges;
# all functions and procedures go here
# C - Adding college with preference and comment into favorite list
# R - Reading all colleges and their data
# U - Updating Favorite List college or pref ranking
# D - Deleting college in the favorite list

# operations to read the data in uscollege database
# read operations below so far retrieve college name, superlative set, and profile set (which has some references to other tables in the db)

# given a college id, return respective college name if it exists
DROP FUNCTION IF EXISTS get_college_name;
DELIMITER //
CREATE FUNCTION get_college_name(
	college_id	INT
)
RETURNS VARCHAR(250)
READS SQL DATA
BEGIN
	DECLARE uni_name VARCHAR(250);

    SELECT cname
    INTO uni_name
    FROM college_name
    WHERE cid = college_id;

    RETURN IFNULL(uni_name, "Invalid College");
END //
DELIMITER ;

# test cases
SELECT get_college_name(10);
SELECT get_college_name(-1);

# given a college id, return a result set containing college name, rank, and superlative title
DROP PROCEDURE IF EXISTS track_superlative;
DELIMITER //
CREATE PROCEDURE track_superlative(
	IN college_id INT
)
BEGIN
	SELECT cid, cname, srank, superlative
    FROM college_name LEFT JOIN ranking ON cid = rid
    WHERE college_id = cid;
END //
DELIMITER ;

# test cases
CALL track_superlative(10);
CALL track_superlative(-1);

# given a college id, return a result set containing references
DROP PROCEDURE IF EXISTS track_college_profile;
DELIMITER //
CREATE PROCEDURE track_college_profile(
	IN college_id INT
)
BEGIN
	SELECT *
    FROM college
    WHERE cid = college_id;
END //
DELIMITER ;

# test cases
# TODO: Consider whether to create an error msg or just leave it as an empty relation
CALL track_college_profile(10);
CALL track_college_profile(-1);
