use histor72_sapp;
CREATE TABLE Location (
    lName VARCHAR(100) NOT NULL,
    lID INT NOT NULL AUTO_INCREMENT,
	street VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	state VARCHAR(50) NOT NULL DEFAULT "GA",
	zipcode VARCHAR(50) NOT NULL,
    PRIMARY KEY (lID)
);

CREATE TABLE User (
	email VARCHAR(50) NOT NULL,
    password VARCHAR(200) NOT NULL,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
    lID int NOT NULL,
    lastLogin timestamp default current_timestamp,
	PRIMARY KEY (email, role),
	FOREIGN KEY (lID)
		REFERENCES Location (lID)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER `user_update_to_gmt-5` BEFORE INSERT ON `User` FOR EACH ROW BEGIN
set new.lastLogin=addtime(current_timestamp, '01:00:00');
END//
DELIMITER ;

CREATE TABLE Class (
	school VARCHAR(50) NOT NULL,
    classNum int NOT NULL,
	PRIMARY KEY (school, classNum)
);


CREATE TABLE Student (
	school VARCHAR(50) NOT NULL,
	classNum int NOT NULL,
    email VARCHAR(50) NOT NULL,
	PRIMARY KEY (school, classNum, email),
	FOREIGN KEY (school)
		REFERENCES Class (school)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (classNum)
		REFERENCES Class (classNum)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (email)
		REFERENCES User (email)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);


CREATE TABLE groupC (
	gName VARCHAR(50) NOT NULL,
    PRIMARY KEY (gName)
);

CREATE TABLE GroupMember (
	gName VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
	PRIMARY KEY (gName, email),
	FOREIGN KEY (gName)
		REFERENCES groupC (gName)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (email)
		REFERENCES User (email)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);

CREATE TABLE Posts (
	email VARCHAR(50) NOT NULL,
	role TINYINT NOT NULL,
    postId int NOT NULL auto_increment,
	postText VARCHAR(300) NOT NULL,
	postDate timestamp default current_timestamp,
	PRIMARY KEY (postId),
    FOREIGN KEY (email, role)
		REFERENCES User (email, role)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
DELIMITER //
CREATE TRIGGER `post_update_to_gmt-5` BEFORE INSERT ON `Posts` FOR EACH ROW BEGIN
set new.postDate=addtime(current_timestamp, '01:00:00');
END//
DELIMITER ;
CREATE TABLE Comments (
	email VARCHAR(50) NOT NULL,
	role TINYINT NOT NULL,
    postId int NOT NULL,
	commentText VARCHAR(300) NOT NULL,
	commentDate timestamp default current_timestamp,
	PRIMARY KEY (email, postId, commentDate),
    FOREIGN KEY (email, role)
		REFERENCES User (email, role)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (postId)
		REFERENCES Posts (postId)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
DELIMITER //
CREATE TRIGGER `comment_update_to_gmt-5` BEFORE INSERT ON `Comments` FOR EACH ROW BEGIN
set new.commentDate=addtime(current_timestamp, '01:00:00');
END//
DELIMITER ;
CREATE TABLE Notifications (
	email VARCHAR(50) NOT NULL,
	role ENUM('Class', 'Group', 'All') NOT NULL,
	notifDate timestamp default current_timestamp,
	content VARCHAR(250) NOT NULL,
	PRIMARY KEY (email, notifDate, content),
    FOREIGN KEY (email)
		REFERENCES User (email)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
DELIMITER //
CREATE TRIGGER `notif_update_to_gmt-5` BEFORE INSERT ON `Notifications` FOR EACH ROW BEGIN
set new.notifDate=addtime(current_timestamp, '01:00:00');
END//
DELIMITER ;
CREATE TABLE NotificationSettings (
	email VARCHAR(50) NOT NULL,
	frequency ENUM('Immediate', 'Every 8 hours', 'Once a day') NOT NULL,
	method ENUM('Phone', 'Email', 'Email and Phone') NOT NULL,
	toggle ENUM('On', 'Off') NOT NULL,
	PRIMARY KEY (email),
    FOREIGN KEY (email)
		REFERENCES User (email)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);