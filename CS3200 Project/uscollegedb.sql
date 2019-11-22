# creates the database schema
DROP DATABASE IF EXISTS uscolleges;
CREATE DATABASE uscolleges;

use uscolleges;

CREATE TABLE college_name (
	cid INT PRIMARY KEY AUTO_INCREMENT,
    cname VARCHAR(250) UNIQUE
);

INSERT INTO college_name (cname)
VALUES("Princeton University"),
("Harvard University"),
("Columbia University"),
("Stanford University"),
("Northwestern University"),
("University of California - Los Angeles"),
("University of Southern California"),
("New York University"),
("Boston University"),
("Northeastern University");


CREATE TABLE ranking (
	rid INT PRIMARY KEY AUTO_INCREMENT,
    srank INT NOT NULL,
    superlative MEDIUMTEXT NOT NULL
);

INSERT INTO ranking (srank, superlative)
VALUES(1, "Best Place to Create a Golf Business"),
(2, "Best Place to Accept Lil Pump's Children"),
(3, "Best Place to Riot Against Administration"),
(6, "Best Place to Repopulate the World with Trees"),
(9, "Best Place to Want to Be Northeastern"),
(20, "Best Place to Produce Doctors"),
(22, "Best Place to Have the Richest Children"),
(29, "Best Place to Study"),
(40, "Best Place to Walk in a Single Street"),
(1, "Best Place to Be");

CREATE TABLE price (
	pid INT PRIMARY KEY AUTO_INCREMENT,
    tuition MEDIUMINT NOT NULL DEFAULT 0,
    room MEDIUMINT NOT NULL DEFAULT 0
);

INSERT INTO price(tuition, room)
VALUES(51870, 17150),
(51925, 17682),
(61850, 14490),
(53529, 16433),
(56691, 17019),
(13226, 42218),
(58195, 15912),
(53308, 18684),
(55892, 16160),
(53506, 16930);

CREATE TABLE setting (
	sid INT PRIMARY KEY AUTO_INCREMENT,
    set_type ENUM('rural', 'urban', 'suburban') NOT NULL,
    set_desc MEDIUMTEXT NOT NULL
);

INSERT INTO setting(set_type, set_desc)
VALUES("suburban", "Quiet city with affluent neighborhood"),
("suburban", "Expensive location nearby other expensive university"),
("urban", "Busy rich neighborhood in the middle of the city"),
("suburban", "Located in the small florescent tree neighborhood"),
("suburban", "Located on the outskirts of busy Chicago"),
("suburban", "Big city access with quiet suburban neighborhood"),
("suburban", "Quiet neighborhood with rich people"),
("urban", "Campus all around the big city"),
("urban", "Street-like campus within a busy city environment"),
("urban", "Expanding campus strategically located near the attractive Fenway Park");


CREATE TABLE address (
	aid INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zipcode MEDIUMINT(5) UNSIGNED ZEROFILL
);

INSERT INTO address(city, state, zipcode)
VALUES("Princeton", "NJ", 08544),
("Cambridge", "MA", 02138),
("New York", "NY", 10027),
("Stanford", "CA", 94305),
("Evanston", "IL", 60208),
("Los Angeles", "CA", 90095),
("Los Angeles", "CA", 90089),
("New York", "NY", 10012),
("Boston", "MA", 02215),
("Boston", "MA", 02115);

CREATE TABLE location (
	lid INT PRIMARY KEY AUTO_INCREMENT,
    aid INT NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL,
    sid INT NOT NULL,
    CONSTRAINT aid_fk
    FOREIGN KEY (aid)
    REFERENCES address (aid) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT sid_fk
    FOREIGN KEY (sid)
    REFERENCES setting (sid) ON UPDATE CASCADE ON DELETE CASCADE
);

# TODO:
INSERT INTO location(aid, phone, sid)
VALUES(1, "1234567890",1),
(2,"0000000000",2),
(3, "1234123456",3),
(4, "7182903336",4),
(5, "9160082735", 5),
(6, "2120987654", 6),
(7, "7078934567", 7),
(8, "8885552341", 8),
(9, "1010101010", 9),
(10, "0987654321", 10);

CREATE TABLE college_type (
	tid INT PRIMARY KEY AUTO_INCREMENT,
    sector ENUM('public', 'private') NOT NULL,
    emphasis ENUM('liberal arts', 'research', 'vocational') NOT NULL
);

INSERT INTO college_type(sector, emphasis)
VALUES("private", "research"),
("private", "liberal arts"),
("private", "research"),
("private", "research"),
("private", "research"),
("public", "research"),
("private", "research"),
("private", "liberal arts"),
("private", "research"),
("private", "research");

CREATE TABLE college (
	cid INT PRIMARY KEY AUTO_INCREMENT,
    pres_name VARCHAR(250) NOT NULL,
    rank_id INT NOT NULL,
    price INT NOT NULL,
    loc INT NOT NULL UNIQUE,
    ctype INT NOT NULL,
    endowment BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT cid_fk
    FOREIGN KEY (cid)
    REFERENCES college_name (cid) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT rank_id_fk
    FOREIGN KEY (rank_id)
    REFERENCES ranking (rid) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT price_fk
    FOREIGN KEY (price)
    REFERENCES price (pid) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT loc_fk
    FOREIGN KEY (loc)
    REFERENCES location (lid) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT ctype_fk
    FOREIGN KEY (ctype)
    REFERENCES college_type (tid) ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO college(pres_name, rank_id, price, loc, ctype, endowment)
VALUES("Christopher Eisgruber", 1, 1, 1, 1, 25000000000),
("Lawrence Bacow", 2, 2, 2, 2, 39200000000),
("Ivan Duque Marquez", 3, 3, 3, 3, 10900000000),
("Marc Tessier-Lavigne", 4, 4, 4, 4, 26500000000),
("Morton Schapiro", 5, 5, 5, 5, 8400000000),
("Gene Block", 6, 6, 6, 6, 4600000000),
("Carol Folt", 7, 7, 7, 7, 5500000000),
("Andrew Hamilton", 8, 8, 8, 8, 4200000000),
("Robert Brown", 9, 9, 9, 9, 2200000000),
("Joseph Aoun", 10, 10, 10, 10, 174600000);

CREATE TABLE favorites (
	fav_id INT PRIMARY KEY AUTO_INCREMENT,
    pref_rank INT NOT NULL,
    cid INT NOT NULL UNIQUE,
    review MEDIUMTEXT NOT NULL,
    CONSTRAINT fav_cid_fk
    FOREIGN KEY (cid)
    REFERENCES college (cid) ON UPDATE CASCADE ON DELETE RESTRICT
);
