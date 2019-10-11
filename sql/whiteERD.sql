SET SESSION FOREIGN_KEY_CHECKS=0;

/* Drop Tables */

DROP TABLE IF EXISTS admin_board_comment;
DROP TABLE IF EXISTS admin_board;
DROP TABLE IF EXISTS side_menu;
DROP TABLE IF EXISTS nav_menu;
DROP TABLE IF EXISTS POS_AUTH;
DROP TABLE IF EXISTS auth_name;
DROP TABLE IF EXISTS BOARD_CMT;
DROP TABLE IF EXISTS BOARD;
DROP TABLE IF EXISTS COMMON_CD;
DROP TABLE IF EXISTS free_board_comment;
DROP TABLE IF EXISTS free_board;
DROP TABLE IF EXISTS money_record;
DROP TABLE IF EXISTS MEANS;
DROP TABLE IF EXISTS purpose_detail;
DROP TABLE IF EXISTS purpose;
DROP TABLE IF EXISTS source_board;
DROP TABLE IF EXISTS white_user;




/* Create Tables */

CREATE TABLE admin_board
(
	board_seq int NOT NULL AUTO_INCREMENT,
	USER_SEQ int NOT NULL,
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
	USER_SEQ int NOT NULL,
	comment varchar(1000) NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (comment_seq),
	UNIQUE (comment_seq)
);


CREATE TABLE auth_name
(
	auth_nm_seq int NOT NULL AUTO_INCREMENT,
	auth_nm varchar(20) NOT NULL,
	auth_order int NOT NULL,
	auth_cmt varchar(50) NOT NULL,
	PRIMARY KEY (auth_nm_seq),
	UNIQUE (auth_nm_seq),
	UNIQUE (auth_nm)
);


CREATE TABLE BOARD
(
	BOARD_SEQ int NOT NULL AUTO_INCREMENT,
	USER_SEQ int NOT NULL,
	BOARD_TP_CD varchar(6) NOT NULL,
	TITLE varchar(50) NOT NULL,
	CONTENT varchar(4000) NOT NULL,
	EDIT_DATE datetime NOT NULL,
	REG_DATE datetime NOT NULL,
	PRIMARY KEY (BOARD_SEQ),
	UNIQUE (BOARD_SEQ)
);


CREATE TABLE BOARD_CMT
(
	BOARD_CMT_SEQ int NOT NULL AUTO_INCREMENT,
	BOARD_SEQ int NOT NULL,
	USER_SEQ int NOT NULL,
	COMMENT varchar(1000) NOT NULL,
	EDIT_DATE datetime NOT NULL,
	REG_DATE datetime NOT NULL,
	PRIMARY KEY (BOARD_CMT_SEQ),
	UNIQUE (BOARD_CMT_SEQ)
);


CREATE TABLE COMMON_CD
(
	CODE_SEQ int NOT NULL AUTO_INCREMENT,
	CODE varchar(6) NOT NULL,
	CODE_PRT varchar(6) NOT NULL,
	CODE_NM varchar(20) NOT NULL,
	MOD_USER varchar(20) NOT NULL,
	MOD_DATE datetime NOT NULL,
	REG_USER varchar(20) NOT NULL,
	REG_DATE datetime NOT NULL,
	PRIMARY KEY (CODE_SEQ),
	UNIQUE (CODE)
);


CREATE TABLE free_board
(
	board_seq int NOT NULL AUTO_INCREMENT,
	USER_SEQ int NOT NULL,
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
	USER_SEQ int NOT NULL,
	comment varchar(1000) NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (comment_seq),
	UNIQUE (comment_seq)
);


CREATE TABLE MEANS
(
	MEANS_SEQ int NOT NULL,
	USER_SEQ int NOT NULL,
	MEANS_NM varchar(50) NOT NULL,
	MEANS_DTL_NM varchar(50),
	MEANS_INFO varchar(50),
	MEANS_USE_YN varchar(1) NOT NULL,
	MEANS_REMARK varchar(100),
	MEANS_ORDER int NOT NULL,
	PRIMARY KEY (MEANS_SEQ)
);


CREATE TABLE money_record
(
	record_seq int NOT NULL AUTO_INCREMENT,
	USER_SEQ int NOT NULL,
	record_date datetime NOT NULL,
	position varchar(20),
	content varchar(50),
	pur_seq int NOT NULL,
	pur_dtl_seq int NOT NULL,
	MEANS_SEQ int NOT NULL,
	money int NOT NULL,
	stats_yn varchar(1) DEFAULT 'Y' NOT NULL,
	edit_date datetime NOT NULL,
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


CREATE TABLE POS_AUTH
(
	POS_AUTH_SEQ int NOT NULL AUTO_INCREMENT,
	USER_SEQ int NOT NULL,
	auth_nm_seq int NOT NULL,
	PRIMARY KEY (POS_AUTH_SEQ),
	UNIQUE (POS_AUTH_SEQ)
);


CREATE TABLE purpose
(
	pur_seq int NOT NULL AUTO_INCREMENT,
	USER_SEQ int NOT NULL,
	pur_order int NOT NULL,
	purpose varchar(20) NOT NULL,
	pur_type varchar(6) NOT NULL,
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
	USER_SEQ int NOT NULL,
	lang_cd varchar(6) NOT NULL,
	title varchar(50) NOT NULL,
	content varchar(4000) NOT NULL,
	edit_date datetime NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (source_seq),
	UNIQUE (source_seq)
);


CREATE TABLE white_user
(
	USER_SEQ int NOT NULL AUTO_INCREMENT,
	user_id varchar(20) NOT NULL,
	user_name varchar(10) NOT NULL,
	user_passwd varchar(60) NOT NULL,
	PRIMARY KEY (USER_SEQ),
	UNIQUE (USER_SEQ),
	UNIQUE (user_id)
);



/* Create Foreign Keys */

ALTER TABLE admin_board_comment
	ADD FOREIGN KEY (board_seq)
	REFERENCES admin_board (board_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE nav_menu
	ADD FOREIGN KEY (nav_auth_nm_seq)
	REFERENCES auth_name (auth_nm_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE POS_AUTH
	ADD FOREIGN KEY (auth_nm_seq)
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


ALTER TABLE BOARD_CMT
	ADD FOREIGN KEY (BOARD_SEQ)
	REFERENCES BOARD (BOARD_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE free_board_comment
	ADD FOREIGN KEY (board_seq)
	REFERENCES free_board (board_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE money_record
	ADD FOREIGN KEY (MEANS_SEQ)
	REFERENCES MEANS (MEANS_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE side_menu
	ADD FOREIGN KEY (nav_seq)
	REFERENCES nav_menu (nav_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE money_record
	ADD FOREIGN KEY (pur_seq)
	REFERENCES purpose (pur_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE purpose_detail
	ADD FOREIGN KEY (pur_seq)
	REFERENCES purpose (pur_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE money_record
	ADD FOREIGN KEY (pur_dtl_seq)
	REFERENCES purpose_detail (pur_dtl_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE admin_board
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE admin_board_comment
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE BOARD
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE BOARD_CMT
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE free_board
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE free_board_comment
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE MEANS
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE money_record
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE POS_AUTH
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE purpose
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE source_board
	ADD FOREIGN KEY (USER_SEQ)
	REFERENCES white_user (USER_SEQ)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



