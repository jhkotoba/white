SET SESSION FOREIGN_KEY_CHECKS=0;

/* Drop Tables */

DROP TABLE IF EXISTS admin_board_comment;
DROP TABLE IF EXISTS admin_board;
DROP TABLE IF EXISTS authority;
DROP TABLE IF EXISTS side_menu;
DROP TABLE IF EXISTS nav_menu;
DROP TABLE IF EXISTS auth_name;
DROP TABLE IF EXISTS bank;
DROP TABLE IF EXISTS cmm_code;
DROP TABLE IF EXISTS commute_record;
DROP TABLE IF EXISTS free_board_comment;
DROP TABLE IF EXISTS free_board;
DROP TABLE IF EXISTS memo;
DROP TABLE IF EXISTS money_record_re;
DROP TABLE IF EXISTS purpose_detail;
DROP TABLE IF EXISTS purpose;
DROP TABLE IF EXISTS source_board;
DROP TABLE IF EXISTS white_user;




/* Create Tables */

CREATE TABLE admin_board
(
	board_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	title varchar(50) NOT NULL,
	content varchar(4000) NOT NULL,
	edit_date datetime NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (board_seq),
	UNIQUE (board_seq)
);


CREATE TABLE admin_board_comment
(
	comment_seq int NOT NULL AUTO_INCREMENT,
	board_seq int NOT NULL,
	user_seq int NOT NULL,
	comment varchar(1000) NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (comment_seq),
	UNIQUE (comment_seq)
);


CREATE TABLE authority
(
	auth_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	auth_nm_seq int NOT NULL,
	PRIMARY KEY (auth_seq),
	UNIQUE (auth_seq)
);


CREATE TABLE auth_name
(
	auth_nm_seq int NOT NULL AUTO_INCREMENT,
	auth_nm varchar(20) NOT NULL,
	auth_order int NOT NULL,
	PRIMARY KEY (auth_nm_seq),
	UNIQUE (auth_nm_seq),
	UNIQUE (auth_nm)
);


CREATE TABLE bank
(
	bank_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	bank_name varchar(20) NOT NULL,
	bank_account varchar(60) NOT NULL,
	bank_use_yn varchar(1) NOT NULL,
	bank_order int NOT NULL,
	PRIMARY KEY (bank_seq),
	UNIQUE (bank_seq)
);


CREATE TABLE cmm_code
(
	code varchar(5) NOT NULL,
	code_prt varchar(5) NOT NULL,
	code_nm varchar(20) NOT NULL,
	PRIMARY KEY (code)
);


CREATE TABLE commute_record
(
	commute_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	commute_type varchar(5) NOT NULL,
	commute_date datetime NOT NULL,
	comment varchar(1000),
	PRIMARY KEY (commute_seq)
);


CREATE TABLE free_board
(
	board_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	title varchar(50) NOT NULL,
	content varchar(4000) NOT NULL,
	edit_date datetime NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (board_seq),
	UNIQUE (board_seq)
);


CREATE TABLE free_board_comment
(
	comment_seq int NOT NULL AUTO_INCREMENT,
	board_seq int NOT NULL,
	user_seq int NOT NULL,
	comment varchar(1000) NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (comment_seq),
	UNIQUE (comment_seq)
);


CREATE TABLE memo
(
	memo_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	memo_type varchar(10) NOT NULL,
	memo_content varchar(100) NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (memo_seq)
);


CREATE TABLE money_record_re
(
	record_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	record_date datetime NOT NULL,
	position varchar(20),
	content varchar(50),
	pur_seq int NOT NULL,
	pur_dtl_seq int,
	bank_seq int,
	move_seq int,
	money int NOT NULL,
	stats_yn varchar(1) DEFAULT 'Y' NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (record_seq),
	UNIQUE (record_seq)
);


CREATE TABLE nav_menu
(
	nav_seq int NOT NULL AUTO_INCREMENT,
	nav_nm varchar(20) NOT NULL,
	nav_url varchar(40) NOT NULL,
	nav_auth_nm_seq int NOT NULL,
	nav_show_yn varchar(1) NOT NULL,
	nav_order int NOT NULL,
	PRIMARY KEY (nav_seq),
	UNIQUE (nav_seq)
);


CREATE TABLE purpose
(
	pur_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	pur_order int NOT NULL,
	purpose varchar(20) NOT NULL,
	pur_type varchar(5) NOT NULL,
	PRIMARY KEY (pur_seq),
	UNIQUE (pur_seq)
);


CREATE TABLE purpose_detail
(
	pur_dtl_seq int NOT NULL AUTO_INCREMENT,
	pur_seq int NOT NULL,
	user_seq int NOT NULL,
	pur_dtl_order int NOT NULL,
	pur_detail varchar(20) NOT NULL,
	PRIMARY KEY (pur_dtl_seq),
	UNIQUE (pur_dtl_seq)
);


CREATE TABLE side_menu
(
	side_seq int NOT NULL AUTO_INCREMENT,
	nav_seq int NOT NULL,
	side_nm varchar(20) NOT NULL,
	side_url varchar(40) NOT NULL,
	side_auth_nm_seq int NOT NULL,
	side_show_yn varchar(1) NOT NULL,
	side_order int NOT NULL,
	PRIMARY KEY (side_seq),
	UNIQUE (side_seq)
);


CREATE TABLE source_board
(
	source_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	lang_cd varchar(5) NOT NULL,
	title varchar(50) NOT NULL,
	content varchar(4000) NOT NULL,
	edit_date datetime NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (source_seq),
	UNIQUE (source_seq)
);


CREATE TABLE white_user
(
	user_seq int NOT NULL AUTO_INCREMENT,
	user_id varchar(20) NOT NULL,
	user_name varchar(10) NOT NULL,
	user_passwd varbinary(60) NOT NULL,
	PRIMARY KEY (user_seq),
	UNIQUE (user_seq),
	UNIQUE (user_id)
);



/* Create Foreign Keys */

ALTER TABLE admin_board_comment
	ADD FOREIGN KEY (board_seq)
	REFERENCES admin_board (board_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE authority
	ADD FOREIGN KEY (auth_nm_seq)
	REFERENCES auth_name (auth_nm_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE nav_menu
	ADD FOREIGN KEY (nav_auth_nm_seq)
	REFERENCES auth_name (auth_nm_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE side_menu
	ADD FOREIGN KEY (side_auth_nm_seq)
	REFERENCES auth_name (auth_nm_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE free_board_comment
	ADD FOREIGN KEY (board_seq)
	REFERENCES free_board (board_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE side_menu
	ADD FOREIGN KEY (nav_seq)
	REFERENCES nav_menu (nav_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE purpose_detail
	ADD FOREIGN KEY (pur_seq)
	REFERENCES purpose (pur_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE admin_board
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE admin_board_comment
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE authority
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE bank
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE commute_record
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE free_board
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE free_board_comment
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE memo
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE money_record_re
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE purpose
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE source_board
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



