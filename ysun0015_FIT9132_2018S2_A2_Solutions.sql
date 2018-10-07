--Student ID: 28297830
--Student Fullname: Yue Sun
--Tutor Name: Minh Le

/*  --- COMMENTS TO YOUR MARKER --------

for task 1.2 ,I drop all the table inculde the table in the schema script.

for the task 4.2 I give the example of Good bookcopy,the other two type are the same code.




*/

--Q1
/*
1.1
Add to your solutions script, the CREATE TABLE and CONSTRAINT definitions which are missing from the 
FIT9132_2018S2_A2_Schema_Start.sql script. You MUST use the relation and attribute names shown in the data model above 
to name tables and attributes which you add.
*/

CREATE TABLE book_copy (
    branch_code           NUMBER(2) NOT NULL,
    bc_id                 NUMBER(6) NOT NULL,
    bc_purchase_price     NUMBER(7,2) NOT NULL,
    bc_resrve_flag        CHAR(1) NOT NULL,
    book_call_no          VARCHAR2(20) NOT NULL
);

ALTER TABLE book_copy ADD CONSTRAINT book_copy_pk PRIMARY KEY ( branch_code,
																bc_id );
CREATE TABLE reserve (
	branch_code           NUMBER(2) NOT NULL,
	bc_id                 NUMBER(6) NOT NULL,
	reserve_date_time_placed  Date NOT NULL,
	bor_no                NUMBER(6) NOT NULL
);
ALTER TABLE reserve ADD CONSTRAINT reserve_pk PRIMARY KEY ( branch_code,
																bc_id,
														reserve_date_time_placed );
CREATE TABLE loan (
	branch_code           NUMBER(2) NOT NULL,
	bc_id                 NUMBER(6) NOT NULL,
	loan_date_time        Date NOT NULL,
	loan_due_time         Date NOT NULL,
	loan_actual_return_date Date ,
	bor_no                NUMBER(6) NOT NULL
);
ALTER TABLE loan ADD CONSTRAINT loan_pk PRIMARY KEY ( branch_code,
																bc_id,
														loan_date_time );

ALTER TABLE reserve
    ADD CONSTRAINT branch_reserve FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE reserve
    ADD CONSTRAINT bc_reserve FOREIGN KEY ( branch_code )
        REFERENCES book_copy ( branch_code );

ALTER TABLE reserve
    ADD CONSTRAINT borr_reserve FOREIGN KEY ( bor_no )
        REFERENCES borrower ( bor_no );

ALTER TABLE book_copy
    ADD CONSTRAINT branch_bc FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );        

ALTER TABLE book_copy
    ADD CONSTRAINT bd_bc FOREIGN KEY ( book_call_no )
        REFERENCES BOOK_DETAIL ( book_call_no );   

ALTER TABLE loan
    ADD CONSTRAINT branch_loan FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE loan
    ADD CONSTRAINT bc_loan FOREIGN KEY ( branch_code )
        REFERENCES book_copy ( branch_code );

ALTER TABLE loan
    ADD CONSTRAINT borr_loan FOREIGN KEY ( bor_no )
        REFERENCES borrower ( bor_no );


/*
1.2
Add the full set of DROP TABLE statements to your solutions script. In completing this section you must not use the CASCADE 
CONSTRAINTS clause as part of your DROP TABLE statement (you should include the PURGE clause).
 
*/
ALTER TABLE loan DROP CONSTRAINT branch_loan;
ALTER TABLE loan DROP CONSTRAINT bc_loan;
ALTER TABLE loan DROP CONSTRAINT borr_loan;
ALTER TABLE book_copy DROP CONSTRAINT branch_bc;
ALTER TABLE book_copy DROP CONSTRAINT bd_bc;
ALTER TABLE reserve DROP CONSTRAINT branch_reserve;
ALTER TABLE reserve DROP CONSTRAINT bc_reserve;
ALTER TABLE reserve DROP CONSTRAINT borr_reserve;
ALTER TABLE bd_author DROP CONSTRAINT author_ta ;
ALTER TABLE bd_author DROP CONSTRAINT bd_ta ;
ALTER TABLE bd_subject DROP CONSTRAINT bd_ts;
ALTER TABLE borrower DROP CONSTRAINT branch_borr ;
ALTER TABLE branch  DROP CONSTRAINT manager_branch ;
ALTER TABLE book_detail DROP CONSTRAINT publisher_bd ;
ALTER TABLE bd_subject DROP CONSTRAINT subject_ts ;
DROP TABLE AUTHOR ;
DROP TABLE BD_AUTHOR ;
DROP TABLE BD_SUBJECT ;
DROP TABLE BOOK_COPY ;
DROP TABLE BOOK_DETAIL ;
DROP TABLE BORROWER ;
DROP TABLE BRANCH ;
DROP TABLE LOAN ;
DROP TABLE MANAGER ;
DROP TABLE PUBLISHER ;
DROP TABLE RESERVE ;
DROP TABLE SUBJECT ;






--Q2
/*
2.1
MonLib has just purchased its first 3 copies of a recently released edition of a book. Readers of this book will learn about 
the subjects "Database Design" and "Database Management". 

Some of  the details of the new book are:

	      	Call Number: 005.74 C822D 2018
Title: Database Systems: Design, Implementation, and Management
	      	Publication Year: 2018
	      	Edition: 13
	      	Publisher: Cengage
	Authors: Carlos CORONEL (author_id = 1 ) and 
   Steven MORRIS  (author_id = 2)  	      	
Price: $120
	
You may make up any other reasonable data values you need to be able to add this book.

Each of the 3 MonLib branches listed below will get a single copy of this book, the book will be available for borrowing 
(ie not on counter reserve) at each branch:

		Caulfield (Ph: 8888888881)
		Glen Huntly (Ph: 8888888882)
        Carnegie (Ph: 8888888883)

Your are required to treat this add of the book details and the three copies as a single transaction.
*/

INSERT INTO book_detail VALUES (
    '005.74 C822D 2018',
    'Database Systems: Design, Implementation, and Management',
    'R',
    791,
    TO_DATE('2018','YYYY'),
    '12',
    1
);

INSERT INTO BD_AUTHOR VALUES (
'005.74 C822D 2018',
1
);
INSERT INTO BD_AUTHOR VALUES (
'005.74 C822D 2018',
2
);
INSERT INTO BOOK_COPY VALUES (
10,
666,
120,
'8',
'005.74 C822D 2018'
);
INSERT INTO BOOK_COPY VALUES (
11,
666,
120,
'8',
'005.74 C822D 2018'
);

INSERT INTO BOOK_COPY VALUES (
12,
666,
120,
'8',
'005.74 C822D 2018'
);

commit;









/*
2.2
An Oracle sequence is to be implemented in the database for the subsequent insertion of records into the database for  
BORROWER table. 

Provide the CREATE 	SEQUENCE statement to create a sequence which could be used to provide primary key values for the BORROWER 
table. The sequence should start at 10 and increment by 1.
*/


CREATE SEQUENCE borr_seq START WITH 10 INCREMENT BY 1;







/*
2.3
Provide the DROP SEQUENCE statement for the sequence object you have created in question 2.2 above. 
*/




DROP SEQUENCE borr_seq;





--Q3
/*
--3.1
Today is 20th September, 2018, add a new borrower in the database. Some of the details of the new borrower are:

		Name: Ada LOVELACE
		Home Branch: Caulfield (Ph: 8888888881)

You may make up any other reasonable data values you need to be able to add this borrower.

*/

DROP SEQUENCE borr_seq;

CREATE SEQUENCE borr_seq START WITH 10 INCREMENT BY 1;

INSERT INTO borrower VALUES (
    borr_seq.NEXTVAL,
    'LOVELACE',
    'Ada',
    '2 Alphabet Way',
    'Alphaville',
    '2000',
    10
);










/*
--3.2
Immediately after becoming a member, at 4PM, Ada places a reservation on a book at the Carnegie branch (Ph: 8888888883). Some 
of the details of the book that Ada  has placed a reservation on are:

		Call Number: 005.74 C822D 2018
        Title: Database Systems: Design, Implementation, and Management
		Publication Year: 2018
		Edition: 13

You may assume:
MonLib has not purchased any further copies of this book, beyond those which you inserted in Task 2.1
that nobody has become a member of the library between Ada becoming a member and this reservation.

*/


INSERT INTO reserve VALUES(
	12,
	666,
	TO_DATE('2018-09-20 16','yyyy-MM-dd HH24'),
	borr_seq.CURRVAL	
);







/*
3.3
After 7 days from reserving the book, Ada receives a notification from the Carnegie library that the book she had placed
reservation on is available. Ada is very excited about the book being available as she wants to do very well in FIT9132 unit 
that she is currently studying at Monash University. Ada goes to the library and borrows the book at 2 PM on the same day of 
receiving the notification.

You may assume that there is no other borrower named Ada Lovelace.
*/


INSERT INTO loan VALUES(
	12,
	666,
	TO_DATE('2018-09-27 14','yyyy-MM-dd HH24'),
	TO_DATE('2018-10-11','yyyy-MM-dd'),
	TO_DATE(NULL),
	borr_seq.CURRVAL
);






  
/*
3.4
At 2 PM on the day the book is due, Ada goes to the library and renews the book as her exam for FIT9132 is in 2 weeks.
		
You may assume that there is no other borrower named Ada Lovelace.
*/

UPDATE loan
    SET loan_due_time = TO_DATE('2018-10-25','yyyy-MM-dd')
WHERE
    branch_code = 12 and
    bc_id = 666 and
    loan_date_time = TO_DATE('2018-09-27 14','yyyy-MM-dd HH24');

COMMIT;




--Q4
/*
4.1
Record whether a book is damaged (D) or lost (L). If the book is not damaged or lost,then it  is good (G) which means, 
it can be loaned. The value cannot be left empty  for this. Change the "live" database and add this required information 
for all the  books currently in the database. You may assume that condition of all existing books will be recorded as being 
good. The information can be updated later, if need be. 
*/

ALTER TABLE book_copy ADD (
	loanornot  CHAR(1) DEFAULT 'G' NOT NULL,
	CONSTRAINT loanornot_chk CHECK ( loanornot IN (
		 'D',
		 'L',
		 'G'
		)
		)
);

COMMENT ON COLUMN book_copy.loanornot IS
    'D=Damage,L=lost,G=good';







/*
4.2
Allow borrowers to be able to return the books they have loaned to any library branch as MonLib is getting a number of requests 
regarding this from borrowers. As part of this process MonLib wishes to record which branch a particular loan is returned to. 
Change the "live" database and add this required information for all the loans  currently in the database. For all completed 
loans, to this time, books were returned at the same branch from where those were loaned.
*/


UPDATE BOOK_COPY
SET
	loanornot = 'G'
WHERE
  branch_code = (
  select branch_code
  from loan
  where
  branch_code = 12 and
    bc_id = 666 and
    loan_date_time = TO_DATE('2018-09-27 14','yyyy-MM-dd HH24')
   )
  and
  bc_id = (
  select branch_code
  from loan
  where
  branch_code = 12 and
    bc_id = 666 and
    loan_date_time = TO_DATE('2018-09-27 14','yyyy-MM-dd HH24')
   );

COMMIT;




/*
4.3
Some of the MonLib branches have become very large and it is difficult for a single manager to look after all aspects of the 
branch. For this reason MonLib are intending to appoint two managers for the larger branches starting in the new year - one 
manager for the Fiction collection and another for the Non-Fiction collection. The branches which continue to have one manager 
will ask this manager to manage the branches Full collection. The number of branches which will require two managers is quite 
small (around 10% of the total MonLib branches). Change the "live" database to allow monLib the option of appointing two 
managers to a branch and track and also record, for all managers, which collection/s they are managing. 

In the new year, since the Carnegie branch (Ph: 8888888883) has a huge collection of books in comparison to the Caulfield and 
Glen Huntly branches, Robert (Manager id: 1) who is currently managing the Caulfield branch (Ph: 8888888881) has been asked to 
manage the Fiction collection of the Carnegie branch, as well as the full collection at the Caulfield branch. Thabie 
(Manager id: 2) who is currently managing the Glen Huntly branch (Ph: 8888888882) has been asked to manage the Non-Fiction 
collection of Carnegie branch, as well as the full collection at the Glen Huntly branch. Write the code to implement these 
changes.
*/


CREATE TABLE Fiction (
	branch_code NUMBER(2) NOT NULL,
	fiction_type CHAR(1),
	man_id       NUMBER(2) NOT NULL
);

ALTER TABLE  Fiction ADD(
	CONSTRAINT Fiction_pk PRIMARY KEY (branch_code,
										fiction_type
	                                  ),
	CONSTRAINT fiction_type_chk CHECK ( fiction_type IN(
		'N',
		'F',
		'A'
		))
	
);

COMMENT ON COLUMN Fiction.fiction_type IS
    'type of fiction (N=Non-Fiction;F=Fiction;A=full
collection )';

ALTER TABLE Fiction ADD
CONSTRAINT branch_fiction FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE Fiction ADD
CONSTRAINT manager_fiction FOREIGN KEY ( man_id )
        REFERENCES manager ( man_id );

INSERT INTO Fiction VALUES(
	(select branch_code
		from branch
		where branch_contact_no = '8888888883'),
	'F',
	1
);

INSERT INTO Fiction VALUES(
	(select branch_code
		from branch
		where branch_contact_no = '8888888881'),
	'A',
	1
);

INSERT INTO Fiction VALUES(
	(select branch_code
		from branch
		where branch_contact_no = '8888888882'),
	'A',
	2
);
INSERT INTO Fiction VALUES(
	(select branch_code
		from branch
		where branch_contact_no = '8888888883'),
	'N',
	2
);











