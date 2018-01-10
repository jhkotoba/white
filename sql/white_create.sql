SET SESSION FOREIGN_KEY_CHECKS=0;

/* Drop Tables */

DROP TABLE IF EXISTS money_record;
DROP TABLE IF EXISTS purpose;
DROP TABLE IF EXISTS source_board;
DROP TABLE IF EXISTS upper_purpose;
DROP TABLE IF EXISTS user_bank;
DROP TABLE IF EXISTS white_user;
DROP TABLE IF EXISTS authority;




/* Create Tables */

CREATE TABLE authority
(
	authority_no varchar(4) NOT NULL,
	authority varchar(20),
	PRIMARY KEY (authority_no)
);


CREATE TABLE money_record
(
	record_seq int NOT NULL AUTO_INCREMENT,
	group_seq int NOT NULL,
	user_seq int NOT NULL,
	record_date datetime NOT NULL,
	content varchar(50),
	purpose_seq int NOT NULL,
	user_bank_seq int,
	move_to_seq int,
	in_exp_money int NOT NULL,
	ready_money int NOT NULL,
	result_bank_money int NOT NULL,
	reg_date datetime NOT NULL,
	PRIMARY KEY (record_seq),
	UNIQUE (record_seq),
	UNIQUE (record_date)
);


CREATE TABLE purpose
(
	purpose_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	pur_order int NOT NULL,
	upper_pur_sqe int NOT NULL,
	purpose varchar(20) NOT NULL,
	PRIMARY KEY (purpose_seq),
	UNIQUE (purpose_seq)
);


CREATE TABLE source_board
(
	source_seq int NOT NULL AUTO_INCREMENT,
	source_type varchar(20) NOT NULL,
	user_seq int NOT NULL,
	content varchar(4000) NOT NULL,
	PRIMARY KEY (source_seq),
	UNIQUE (user_seq)
);


CREATE TABLE upper_purpose
(
	upper_pur_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	upper_purpose varchar(20) NOT NULL,
	PRIMARY KEY (upper_pur_sqe),
	UNIQUE (user_seq)
);


CREATE TABLE user_bank
(
	user_bank_seq int NOT NULL AUTO_INCREMENT,
	user_seq int NOT NULL,
	bank_name varchar(20) NOT NULL,
	bank_account varchar(60) NOT NULL,
	bank_now_use_yn varchar(1) NOT NULL,
	PRIMARY KEY (user_bank_seq),
	UNIQUE (user_bank_seq)
);


CREATE TABLE white_user
(
	user_seq int NOT NULL AUTO_INCREMENT,
	authority_no varchar(4) NOT NULL,
	user_id varchar(20) NOT NULL,
	user_name varchar(10) NOT NULL,
	user_passwd varbinary(60) NOT NULL,
	PRIMARY KEY (user_seq),
	UNIQUE (user_seq),
	UNIQUE (user_id)
);



/* Create Foreign Keys */

ALTER TABLE white_user
	ADD FOREIGN KEY (authority_no)
	REFERENCES authority (authority_no)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE purpose
	ADD FOREIGN KEY (upper_pur_sqe)
	REFERENCES upper_purpose (upper_pur_sqe)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE money_record
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


ALTER TABLE upper_purpose
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE user_bank
	ADD FOREIGN KEY (user_seq)
	REFERENCES white_user (user_seq)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



