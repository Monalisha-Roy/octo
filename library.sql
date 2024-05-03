CREATE DATABASE library;
USE library;

--2
CREATE TABLE book(
    book_id INT PRIMARY KEY,
    title VARCHAR(50),
    publisher_name VARCHAR(50),
    FOREIGN KEY(publisher_name) REFERENCES publisher(publisher_name)
);

--3
CREATE TABLE book_author(
    book_id INT,
    author_name VARCHAR(60),
    PRIMARY KEY(book_id, author_name),
    FOREIGN KEY(book_id) REFERENCES book(book_id)
);

-- 1
CREATE TABLE publisher(
    publisher_name VARCHAR(50) PRIMARY KEY,
    address VARCHAR(50),
    phone_number VARCHAR(50)
);

--6
CREATE TABLE book_copies(
    book_id INT ,
    branch_id INT ,
    no_of_copies INT,
    PRIMARY KEY(book_id, branch_id),
    FOREIGN key(book_id) REFERENCES book(book_id),
    FOREIGN KEY(branch_id) REFERENCES library_branch(branch_id)
);

--7
CREATE TABLE book_loans(
    book_id INT ,
    branch_id INT,
    card_no INT ,
    date_out DATE,
    due_date DATE,
    PRIMARY KEY(book_id, branch_id, card_no),
    FOREIGN kEY(book_id) REFERENCES book(book_id),
    FOREIGN KEY(branch_id) REFERENCES library_branch(branch_id),
    FOREIGN kEY(card_no) REFERENCES borrower(card_no)
);


--4
CREATE TABLE library_branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50),
    address VARCHAR(50)
);

--5
CREATE TABLE borrower(
    card_no INT PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(50),
    phone_number VARCHAR(50)
);

INSERT INTO publisher values('Star publications', '3rd-street, Mumbai', 7894561230),
('Pearson', 'jk-street Delhi', 1234568970),
('Dutta publications', 'jd-road Assam', 4568972130),
('Sharma publications', '32-bombay', 4567891230),
('Calcutta publications', 'South Calcutta', 1245658930),
('Tata Mcgrow hilll', 'California', 781761475);


INSERT INTO book values(1, 'Atomic Habits', 'Pearson'),
(2, 'Three Mistakes of my Life', 'Calcutta publications'),
(3, 'The kite Runner', 'Dutta publications'),
(4, 'The Story of My Life', 'Star publications'),
(5, 'The girl next door', 'Sharma publications'),
(6, 'Midnight sun', 'Pearson'),
(7, 'Hope we meet again', 'Star publications'),
(8, 'Say something bitter', 'Sharma publications'),
(9, 'Life is a Turmoil', 'Star publications'),
(10, 'Who am I?', 'Pearson'),
(11, 'She saw me', 'Tata Mcgrow hilll');

INSERT INTO book_author 
values(1, 'Ruby Jhonson'),
(2, 'Chetan Bhagat'),
(3, 'Hamid Ali'),
(4, 'Neena Sharma'),
(5, 'Ruby Jhonson'),
(6, 'Shreya Paul'),
(7, 'Shreya Paul'),
(8, 'Neena Sharma'),
(9, 'Tony Desuza'),
(10, 'Ele Whitmore');

INSERT INTO library_branch
values(1, 'South Delhi', '21-street South Delhi'),
(2, 'Bangalore', 'Bangalore'),
(3, 'North Kokrajhar', 'Kokrajhar, Assam'),
(4, 'East Diphu', 'jalukbari, Assam');

INSERT INTO borrower
values(101, 'Rahul Mishra', 'Diphu', 123457860),
(102, 'Rishab Chopra', 'Delhi', 45889230),
(103, 'Daviss', 'Delhi', 784561054),
(104, 'Priyanka Gaur', 'Delhi', 841561408),
(105, 'Gargi Deka', 'Assam', 794561324),
(106, 'Priya Shukla', 'Bangalore', 618465405),
(107, 'Shanti kumari', 'Bangalore', 408405145),
(108, 'Shreya Roy', 'Kokrajhar', 5617641054),
(109, 'Esha Basumatary', 'Kokrajhar', 4167450545),
(110, 'Raj Chetry', 'Gossaigaon', 47451215025);

INSERT INTO book_copies
values(1, 1, 200),(1, 2, 150),(1, 3, 120),(1, 4, 100),
(2, 1, 50),(2, 2, 160), 
 (3, 3, 150), (3, 4, 20),
(4, 1, 90), (4, 2, 40), (4, 3, 70), (4, 4, 23),
(5, 1, 78), (5, 2, 7), 
 (6, 2, 64), (6, 3, 7), (6, 4, 9),
(7, 1, 98),(7, 4, 0),
(8, 1, 3), (8, 2, 5),
 (9, 3, 121), (9, 4, 90),
(10, 2, 43), (10, 3, 4);


INSERT INTO book_loans
VALUES
    (1, 1, 103, '2024-01-01', '2024-05-30'),
    (6, 2, 103, '2024-01-19', '2024-04-30'), 
    (10, 1, 103, '2024-05-01', '2024-11-30'),
    (5, 3, 109, '2023-01-01', '2023-02-21'),
    (7, 2, 104, '2024-09-23', '2024-12-31'),
    (3, 1, 102, '2024-03-01', '2024-06-30'),
    (9, 3, 109, '2023-01-01', '2023-05-14'), 
    (10, 4, 107, '2024-01-25', '2024-07-31'),
    (4, 2, 102, '2024-02-21', '2024-02-21'),
    (3, 2, 105, '2024-05-01', '2024-11-30');


-- select the name of borrower who borrowed all the books published by pearson
SELECT bor.name
FROM borrower bor
JOIN book_loans bl ON bor.card_no = bl.card_no
JOIN book b ON bl.book_id = b.book_id
JOIN publisher pub ON b.publisher_name = pub.publisher_name
WHERE pub.publisher_name = 'jk publications'
GROUP BY bor.name
HAVING COUNT(DISTINCT b.book_id) = (
    SELECT COUNT(*)
    FROM book
    WHERE publisher_name = 'jk publications'
);

-- find all the book ids which having naumber of copies greater than at least one book id (without using aggregate function);
select DISTINCT b1.book_id, b1.no_of_copies
from book_copies b1
join book_copies b2 on b1.book_id != b2.book_id
where b1.no_of_copies > b2.no_of_copies;

--find the title of the book which has highest number of copies
select b.title, b_cp.no_of_copies
from book b
join book_copies b_cp on b.book_id = b_cp.book_id
order by b_cp.no_of_copies desc 
limit 1;

--find the name of the person who has returned the book within one day
select bor.card_no, bor.name
from borrower bor 
join book_loans bl on bl.card_no = bor.card_no
where bl.date_out = bl.due_date;

-- find the name of person with book titles borrowed on 1st jan 2023;
select bor.name, b.title
from borrower bor 
join book_loans bl on bl.card_no = bor.card_no
join book b on b.book_id = bl.book_id 
where bl.date_out = '2023-01-01';

-- find total number of books published by 'Tata Mcgrow hilll'
select count(book_id) from book where publisher_name = 'Tata Mcgrow hilll';

-- find the name of borrowers whose name start with character D and exactly 6 characters;
select name from borrower where name like 'D_____';

-- count the number of books of each publisher
select publisher_name,  count( DISTINCT book_id) from book 
GROUP by publisher_name;