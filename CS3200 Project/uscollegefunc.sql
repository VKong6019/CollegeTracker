use uscolleges;
DROP PROCEDURE IF EXISTS get_favorite;
DROP FUNCTION IF EXISTS get_college_name;
DROP FUNCTION IF EXISTS get_college_id;
DROP PROCEDURE IF EXISTS track_superlative;
DROP PROCEDURE IF EXISTS track_college_profile;
DROP PROCEDURE IF EXISTS track_user_favorites;
DROP FUNCTION IF EXISTS get_rank;
DROP FUNCTION IF EXISTS get_tuition;
DROP FUNCTION IF EXISTS get_desc;
DROP FUNCTION IF EXISTS get_address;
DROP FUNCTION IF EXISTS get_location;
DROP FUNCTION IF EXISTS get_type;
DROP PROCEDURE IF EXISTS track_colleges;
DROP PROCEDURE IF EXISTS create_fav;
DROP PROCEDURE IF EXISTS delete_fav;
DROP PROCEDURE IF EXISTS update_coll_fav;
DROP PROCEDURE IF EXISTS update_rank_fav;
DROP PROCEDURE IF EXISTS update_review_fav;
# all functions and procedures go here
# C - Adding college with preference and comment into favorite list
# R - Reading all colleges and their data
# U - Updating favorite list college or pref ranking
# D - Deleting college in the favorite list

# operations to read the data in uscollege database
# read operations below so far retrieve college name, superlative set, and profile set (which has some references to other tables in the db)

# given favorite id, return all fields of favorite
DELIMITER //
CREATE PROCEDURE get_favorite(
    IN uname VARCHAR(250),
	IN favorite_id INT
)
BEGIN
	SELECT cid, pref_rank, review
	FROM favorites
	WHERE favorite_id = cid AND uname = username;
END //
DELIMITER ;

# given a college id, return respective college name if it exists
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

# given a college name, return respective college id if it exists
DELIMITER //
CREATE FUNCTION get_college_id(
	coll_name	VARCHAR(250)
)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE uni_id INT;

    SELECT cid
    INTO uni_id
    FROM college_name
    WHERE cname = coll_name;

    RETURN IFNULL(uni_id, "Invalid College");
END //
DELIMITER ;

# given a college id, return a result set containing college name, rank, and superlative title
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

# given a college id, return a result set containing references
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

# given a user's name, returns all entries in the user's favorited list
DELIMITER //
CREATE PROCEDURE track_user_favorites(
	IN uname	VARCHAR(250)
)
BEGIN
	SELECT get_college_id(cname), pref_rank, cname, review
    FROM favorites INNER JOIN college_name ON favorites.cid = college_name.cid
    WHERE uname = username;
END //
DELIMITER ;

# retrieves the superlative given the college id
DELIMITER //
CREATE FUNCTION get_rank(
	college_id INT
)
RETURNS MEDIUMTEXT
READS SQL DATA
BEGIN
	DECLARE msg MEDIUMTEXT;
    
    SELECT CONCAT(srank, ' ', superlative)
    INTO msg
    FROM ranking
    WHERE rid = college_id;
    
    RETURN msg;
END //
DELIMITER ;

# retrieves the room and board pricing given a college
DELIMITER //
CREATE FUNCTION get_tuition(
	college_id INT
)
RETURNS MEDIUMTEXT
READS SQL DATA
BEGIN
	DECLARE msg MEDIUMTEXT;
    
    SELECT CONCAT('tuition: ', tuition, ' room: ', room)
    INTO msg
    FROM price
    WHERE pid = college_id;

	RETURN msg;
END //
DELIMITER ;

# retrieves description of the college location
DELIMITER //
CREATE FUNCTION get_desc(
	college_id INT
)
RETURNS MEDIUMTEXT
READS SQL DATA
BEGIN
	DECLARE msg MEDIUMTEXT;
    
    SELECT CONCAT(set_type, ' area: ', set_desc)
    INTO msg
    FROM setting
    WHERE sid = college_id;
    
    RETURN msg;
END //
DELIMITER ;

# retrieves address of college as a text
DELIMITER //
CREATE FUNCTION get_address(
	college_id INT
)
RETURNS MEDIUMTEXT
READS SQL DATA
BEGIN
	DECLARE msg MEDIUMTEXT;
    
    SELECT CONCAT(city, ', ', state, ', ', zipcode)
    INTO msg
    FROM address
    WHERE aid = college_id;
    
    RETURN msg;
END //
DELIMITER ;

# retrieves the complete location profile of a college
DELIMITER //
CREATE FUNCTION get_location(
	college_id MEDIUMTEXT
)
RETURNS MEDIUMTEXT
READS SQL DATA
BEGIN
	DECLARE loc_msg MEDIUMTEXT;
    
    SELECT CONCAT('Address: ', get_address(aid), ' Phone: ', phone, ' Setting: ', get_desc(sid))
    INTO loc_msg
    FROM location
    WHERE lid = college_id;
    
    RETURN loc_msg;
END //
DELIMITER ;

# concatenates college type into a brief sentence
DELIMITER //
CREATE FUNCTION get_type(
	college_id INT
)
RETURNS MEDIUMTEXT
READS SQL DATA
BEGIN
	DECLARE msg MEDIUMTEXT;
    
    SELECT CONCAT('A ', sector, ' ', emphasis, ' school')
    INTO msg
    FROM college_type
    WHERE tid = college_id;
    
    RETURN msg;
END //
DELMIITER ;

# returns a set of all college profiles without references
DELIMITER //
CREATE PROCEDURE track_colleges()
BEGIN
	SELECT cid, get_college_name(cid), pres_name, get_rank(rank_id), get_tuition(price),
    get_location(loc), get_type(ctype), endowment
    FROM college;
END //
DELIMITER ;

# operations below create entries in the user table associated with the user's profile

# given college id, username, ranking, and review, add entry into favorite's list
# all arguments are required so front end should prompt this to user
# if the entry already exists, prompt an error message
DELIMITER //
CREATE PROCEDURE create_fav(
	IN college_id INT,
    IN uname VARCHAR(250),
    IN college_rank INT,
    IN review_text MEDIUMTEXT
)
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
		SELECT CONCAT('This already exists in your list') as message;
    END;
    
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SELECT CONCAT('Invalid College') as message;
	END;
    
	INSERT INTO favorites(username, cid, pref_rank, review)
    VALUES (uname, college_id, college_rank, review_text);
    
    SELECT CONCAT('Successfully added a college!') as message;
END //
DELIMITER ;

# operations below delete entries in the favorites table

# given a username and college id, delete this entry from favorites table
DELIMITER //
CREATE PROCEDURE delete_fav(
	IN uname VARCHAR(250),
    IN college_id INT
)
BEGIN
	DELETE FROM favorites
    WHERE username = uname AND cid = college_id;
END //
DELIMITER ;

# operations below update fields of a entry in the favorites table

# updates the college id with old and new college id
DELIMITER //
CREATE PROCEDURE update_coll_fav (
	IN uname VARCHAR(250),
    IN old_id INT,
    IN new_id INt
)
BEGIN
	UPDATE favorites
    SET cid = new_id
    WHERE username = uname AND cid = old_id;
END //
DELIMITER ;

# updates user's ranking of a college
DELIMITER //
CREATE PROCEDURE update_rank_fav(
	IN uname VARCHAR(250),
    IN college_id INT,
    IN new_rank INT
)
BEGIN
	UPDATE favorties
    SET pref_rank = new_rank
    WHERE username = uname AND cid = college_id;
END //
DELIMITER ;

# updates user's review of a college
DELIMITER //
CREATE PROCEDURE update_review_fav(
	IN uname VARCHAR(250),
    IN college_id INT,
    IN new_review MEDIUMTEXT
)
BEGIN
	UPDATE favorites
    SET review = new_review
    WHERE username = uname AND cid = college_id;
END //
DELIMITER ;
