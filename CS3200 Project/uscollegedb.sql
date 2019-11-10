# creates the database schema
DROP DATABASE IF EXISTS uscolleges;
CREATE DATABASE uscolleges;

use uscolleges;

CREATE TABLE college_name (
	cid INT PRIMARY KEY AUTO_INCREMENT,
    cname VARCHAR(250) UNIQUE
);

CREATE TABLE ranking (
	rid INT PRIMARY KEY AUTO_INCREMENT,
    srank INT NOT NULL,
    superlative MEDIUMTEXT NOT NULL
);

CREATE TABLE price (
	pid INT PRIMARY KEY AUTO_INCREMENT,
    tuition MEDIUMINT NOT NULL DEFAULT 0,
    room MEDIUMINT NOT NULL DEFAULT 0
);

CREATE TABLE setting (
	sid INT PRIMARY KEY AUTO_INCREMENT,
    set_type ENUM('rural', 'urban', 'suburban') NOT NULL,
    set_desc MEDIUMTEXT NOT NULL
);

CREATE TABLE address (
	aid INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    street VARCHAR(100) NOT NULL,
    zipcode MEDIUMINT (5) UNSIGNED ZEROFILL
);

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

CREATE TABLE college_type (
	tid INT PRIMARY KEY AUTO_INCREMENT,
    sector ENUM('public', 'enum') NOT NULL,
    emphasis ENUM('liberal art', 'research', 'vocational') NOT NULL
);

CREATE TABLE college (
	cid INT PRIMARY KEY AUTO_INCREMENT,
    pres_name VARCHAR(250) NOT NULL,
    rank_id INT NOT NULL,
    price INT NOT NULL,
    loc INT NOT NULL UNIQUE,
    ctype INT NOT NULL,
    endowment INT NOT NULL DEFAULT 0,
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

CREATE TABLE favorites (
	fav_id INT PRIMARY KEY AUTO_INCREMENT,
    pref_rank INT NOT NULL,
    cid INT NOT NULL UNIQUE,
    review MEDIUMTEXT NOT NULL,
    CONSTRAINT fav_cid_fk
    FOREIGN KEY (cid)
    REFERENCES college (cid) ON UPDATE CASCADE ON DELETE RESTRICT
);