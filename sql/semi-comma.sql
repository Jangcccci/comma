-- ======================================================================
-- 관리자 계정 system
-- ======================================================================
alter session set "_oracle_script" = true;  -- c## 접두어 없이 계정 생성 가능

create user comma
identified by comma
default tablespace users;

alter user comma quota unlimited on users;

grant connect, resource to comma;

--select * from (select row_number()over(order by no desc) rnum, c.* from counseling c ) where rnum between ? and ?

-- ======================================================================
-- COMMA 계정
-- ======================================================================

-- ======================================================================
-- 모든 테이블 select
-- ======================================================================
select * from member;
--update member set member_role = 'A' where email like ('admin%');
select * from leave_member;
select * from friends;
select * from letter;
select * from attachment_letter;
select * from diary;
select * from design;
select * from font;
select * from complain;
select * from counseling;
select * from like_counseling;
select * from attachment_counseling;
select * from cs_comment;
select * from question;
select * from attachment_question;
select * from q_comment;
select * from faq;
select * from chatting;
select * from chatting_member;
select * from chatting_log;
select * from like_counseling;


-- ======================================================================
-- 모든 테이블 drop
-- ======================================================================
--drop table member cascade constraints;
--drop table leave_member;
--drop table friends;
--drop table letter;
--drop table attachment_letter;
--drop table diary cascade constraints;
--drop table design;
--drop table font;
--drop table complain;
--drop table counseling cascade constraints;
--drop table attachment_counseling;
--drop table cs_comment;
--drop table question;
--drop table attachment_question;
--drop table q_comment;
--drop table faq;
--drop table chatting cascade constraints;
--drop table chatting_member cascade constraints;
--drop table chatting_log;
--drop sequence seq_friends_no;
--drop sequence seq_letter_no;
--drop sequence seq_attach_letter_no;
--drop sequence seq_diary_no;
--drop sequence seq_design_no;
--drop sequence seq_font_no;
--drop sequence seq_cs_no;
--drop sequence seq_cs_attach_no;
--drop sequence seq_cs_comment_no;
--drop sequence seq_question_no;
--drop sequence seq_q_attach_no;
--drop sequence seq_q_comment_no;
--drop sequence seq_faq_no;
--drop sequence seq_complain_no;
--drop sequence seq_chatting_no;
--drop sequence seq_chatting_member_no;
--drop sequence seq_chatting_log_no;


-- ======================================================================
-- 테이블 생성 (create)
-- ======================================================================
-- member 테이블 생성
create table member(
    email varchar2(30),
    nickname varchar2(50) not null,
    password varchar2(300) not null,
    birthday date not null,
    gender char(1) not null,
    enroll_date date default sysdate not null,
    member_role char(1) default 'U' not null,
    original_filename varchar2(300) default 'default.png',
    renamed_filename varchar2(300),
    warning_count number default 0 not null,
    age number not null
);
-- member 제약조건 추가
alter table member
    add constraint pk_member_email primary key (email)
    add constraint uq_member_nickname unique (nickname)
    add constraint ck_member_gender check (gender in ('M', 'F'))
    add constraint ck_member_role check (member_role in ('U', 'M', 'A'))
    add constraint ck_warning_count check (warning_count >= 0 and warning_count <= 3);


-- leave_member 테이블 생성
create table leave_member
as
(select 1 no, m.*, sysdate leave_date from member m where 1 = 0);
-- leave_member 제약조건 추가
alter table leave_member
    add constraint pk_leave_member_no primary key (no)
    modify leave_date default sysdate
    modify original_filename default 'default.png';

create sequence seq_leave_member_no;
    

-- friends 테이블 생성
create table friends (
    no number,
    my_nickname varchar2(50),
    f_nickname varchar2(50),
    is_friend char(1) default 'X' not null
);
-- friends 제약조건 추가
alter table friends
    add constraint pk_friends_no primary key (no)
    add constraint fk_friends_my_nickname foreign key (my_nickname) references member(nickname) on delete cascade
    add constraint fk_friends_f_nickname foreign key (f_nickname) references member(nickname) on delete cascade
    add constraint ck_friends_is_friend check (is_friend in ('O', 'X'));

-- seq_friends_no 시퀀스 생성
create sequence seq_friends_no;

--insert into friends values (seq_friends_no.nextval, 'test1', 'test4', 'O');
--insert into friends values (seq_friends_no.nextval, 'test2', 'test5', 'O');
--insert into friends values (seq_friends_no.nextval, 'test4', 'test1', 'O');
--insert into friends values (seq_friends_no.nextval, 'test5', 'test2', 'O');
--insert into friends values (seq_friends_no.nextval, 'test1', 'test3', 'O');
--insert into friends values (seq_friends_no.nextval, 'test3', 'test1', 'O');

--insert into friends values (seq_friends_no.nextval, 'test1', 'test2', 'O');
--insert into friends values (seq_friends_no.nextval, 'test2', 'test1', 'O');
--insert into friends values (seq_friends_no.nextval, 'test1', 'test3', 'O');
--insert into friends values (seq_friends_no.nextval, 'test2', 'test3', 'O');

-- design 테이블 생성
create table design (
	no number,
	part char(1) not null,
	original_filename varchar2(300),
	renamed_filename varchar2(300),
	reg_date date default sysdate not null
);
-- design 제약조건 추가
alter table design
    add constraint pk_design_no primary key (no)
    add constraint ck_design_part check (part in ('L', 'D'));

-- seq_design_no 시퀀스 생성
create sequence seq_design_no;
--insert into design values (seq_design_no.nextval, 'L', null, null, default);
--insert into design values (seq_design_no.nextval, 'L', null, null, default);

-- font 테이블 생성
create table font (
	no number,
	name varchar2(100) not null
);
-- font 제약조건 추가
alter table font
    add constraint pk_font_no primary key (no);

-- seq_font_no 시퀀스 생성
create sequence seq_font_no;

select seq_cs_no.currval from dual;
select seq_letter_no.currval from dual;

--insert into font values (seq_font_no.nextval, '테스트', '테스트');

-- letter 테이블 생성
create table letter (
	no number,
	writer varchar2(50),
	addressee varchar2(50),
	design_no number not null,
	font_no number not null,
	content clob not null,
	reg_date date default sysdate not null,
	read_check char(1) default 'X' not null,
    limit_gender char(1) default 'X' not null,
    limit_age number default 0 not null,
    anonymous char(1),
    send_who char(1)
);
-- letter 테이블 제약조건 추가
alter table letter
    add constraint pk_letter_no primary key (no)
    add constraint fk_letter_writer foreign key (writer) references member(nickname) on delete set null
    add constraint fk_letter_addressee foreign key (addressee) references member(nickname) on delete set null
    add constraint fk_letter_design_no foreign key (design_no) references design(no)
    add constraint fk_letter_font_no foreign key (font_no) references font(no)
    add constraint ck_letter_read_check check (read_check in ('O', 'X'))
    add constraint ck_letter_limit_gender check (limit_gender in ('M', 'F', 'X'))
    add constraint ck_letter_limit_age check (limit_age >= 0 and limit_age <= 5)
    add constraint ck_letter_anonymous check (anonymous in ('O', 'X'))
    add constraint ck_letter_send_who check (send_who in ('A', 'F'));
    
-- seq_letter_no 시퀀스 생성
create sequence seq_letter_no;
    
-- attachment_letter 테이블 생성
create table attachment_letter (
	no number,
	letter_no number not null,
	original_filename varchar2(300),
	renamed_filename varchar2(300),
	reg_date date	default sysdate not null
);
-- attachment_letter 제약조건 추가
alter table attachment_letter
    add constraint pk_attachment_letter_no primary key (no)
    add constraint fk_attachment_letter_letter_no foreign key (letter_no) references letter(no) on delete cascade;

-- seq_attach_letter_no 시퀀스 생성
create sequence seq_attach_letter_no;


-- diary 테이블 생성
create table diary (
	no number,
	writer varchar2(50),
	design_no number not null,
	font_no number not null,
	content clob not null,
	original_filename varchar2(300),
	renamed_filename varchar2(300),
	reg_date char(10)
);
-- diary 제약조건 추가
alter table diary
    add constraint pk_diary_no primary key (no)
    add constraint fk_diary_writer foreign key (writer) references member(nickname) on delete cascade;

-- seq_diary_no 시퀀스 생성
create sequence seq_diary_no;


-- counseling 테이블 생성
create table counseling (
	no number,
	writer varchar2(50) not null,
	title varchar2(100) not null,
	content varchar2(4000) not null,
	views number default 0 not null,
	cs_like number default 0 not null,
	category varchar2(15) not null,
	reg_date date default sysdate not null,
    limit_gender char(1) default 'X' not null,
    limit_age number default 0 not null,
    anonymous char(1)
);
-- counseling 제약조건 추가
alter table counseling
    add constraint pk_counseling_no primary key (no)
    add constraint fk_counseling_writer foreign key (writer) references member(nickname) on delete cascade
    add constraint ck_counseling_category check (category in ('ALL', 'DAILY', 'CAREER', 'LOVE', 'FRIENDS', 'FAMILY', 'STUDY', 'CHILDCARE'))
    add constraint ck_counseling_limit_gender check (limit_gender in ('M', 'F', 'X'))
    add constraint ck_counseling_limit_age check (limit_age >= 0 and limit_age <= 5)
    add constraint ck_counseling_anonymous check (anonymous in ('O', 'X'));

-- seq_cs_no 시퀀스 생성
create sequence seq_cs_no;

-- like_counseling 테이블 생성
create table like_counseling (
    no number,
    cs_no number not null,
    mem_nick varchar2(50) not null,
    reg_date date default sysdate not null
);
-- like_counseling 제약조건 추가  
alter table like_counseling
    add constraint pk_like_counseling_no primary key (no)
    add constraint fk_like_counseling_cs_no foreign key (cs_no) references counseling(no) on delete cascade;
-- seq_like_cs_no 시퀀스 생성
create sequence seq_cs_like_no;

-- attachment_counseling 테이블 생성
create table attachment_counseling (
	no number,
	cs_no number not null,
	original_filename varchar2(300),
	renamed_filename varchar2(300),
	reg_date date default sysdate not null
);
-- attachment_counseling 제약조건 추가
alter table attachment_counseling
    add constraint pk_attachment_counseling_no primary key (no)
    add constraint fk_attachment_countseling_cs_no foreign key (cs_no) references counseling(no) on delete cascade;

-- seq_cs_attach_no 시퀀스 생성
create sequence seq_cs_attach_no;

-- cs_comment 테이블 생성
create table cs_comment (
	no number,
	writer varchar2(50) not null,
	cs_no number not null,
	content varchar2(4000) not null,
	choice char(1) default 'X' not null,
	comment_level char(1) default 'X' not null,
	ref_comment_no number default null,
	reg_date date default sysdate not null
);

-- cs_comment 제약조건 추가
alter table cs_comment
    add constraint pk_cs_comment_no primary key (no)
    add constraint fk_cs_comment_writer foreign key (writer) references member(nickname) on delete cascade
    add constraint fk_cs_comment_cs_no foreign key (cs_no) references counseling(no) on delete cascade
    add constraint ck_cs_comment_choice check (choice in ('O', 'X'))
    add constraint ck_cs_comment_level check (comment_level in ('O', 'X'));

-- seq_cs_comment_no 시퀀스 생성
create sequence seq_cs_comment_no;


-- question 테이블 생성
create table question (
	no number,
	writer varchar2(50) not null,
	title varchar2(100) not null,
	content clob not null,
	reg_date date default sysdate not null
);
-- question 제약조건 추가
alter table question
    add constraint pk_question_no primary key (no)
    add constraint fk_question_writer foreign key (writer) references member(nickname) on delete cascade;

-- a 시퀀스 생성
create sequence seq_question_no;

-- attachment_question 테이블 생성
create table attachment_question (
	no number,
	q_no number not null,
	original_filename varchar2(300),
	renamed_filename varchar2(300),
	reg_date date default sysdate not null
);
-- attachment_question 제약조건 추가
alter table attachment_question
    add constraint pk_attachment_question_no primary key (no)
    add constraint fk_attachment_question_q_no foreign key (q_no) references question(no) on delete cascade;

-- seq_q_attach_no 시퀀스 생성
create sequence seq_q_attach_no;

-- q_comment 테이블 생성
create table q_comment (
	no number,
	writer varchar2(50) not null,
	q_no number not null,
	content varchar2(4000) not null,
	reg_date date default sysdate not null
);
-- q_comment 제약조건 추가
alter table q_comment
    add constraint pk_q_comment_no primary key (no)
    add constraint fk_q_comment_writer foreign key (writer) references member(nickname) on delete cascade
    add constraint fk_q_comment_q_no foreign key (q_no) references question(no) on delete cascade;

-- seq_q_comment_no 시퀀스 생성
create sequence seq_q_comment_no;


-- faq 테이블 생성
create table faq(
	no number,
	title varchar2(100) not null,
	content varchar2(4000) not null
);

-- seq_faq_no 시퀀스 생성
create sequence seq_faq_no;


-- complain 테이블 생성
create table complain (
	no number,
	writer varchar2(50) not null,
	villain varchar2(50) not null,
	partition varchar2(15) not null,
	content varchar2(4000) not null,
	partition_no number not null,
	reg_date date default sysdate not null
);
-- complain 제약조건 추가
alter table complain
    add constraint pk_complain_no primary key (no)
    add constraint fk_complain_writer foreign key (writer) references member(nickname) on delete cascade
    add constraint fk_complain_villain foreign key (villain) references member(nickname) on delete cascade
    add constraint ck_complain_partition check (partition in ('LETTER', 'COUNSELING', 'COMMENT'));

-- seq_complain_no 시퀀스 생성
create sequence seq_complain_no;


-- chatting 테이블 생성
create table chatting (
    no number,
    name varchar2(100) not null, -- 채팅방 이름
    password varchar2(100),
    captin varchar2(50) not null,  -- 방장
    category varchar2(15) not null,
    able_gender char(1) not null,
    able_age number not null,
    now_count number default 0 not null,
    able_count number not null,
    reg_date date default sysdate
);

-- chatting 제약조건 추가
alter table chatting
    add constraint pk_chatting_no primary key (no)
    add constraint fk_chatting_maker foreign key (captin) references member(nickname) on delete cascade
    add constraint ck_chatting_category check (category in ('ALL', 'DAILY', 'CAREER', 'LOVE', 'FRIENDS', 'FAMILY', 'STUDY', 'CHILDCARE'))
    add constraint ck_chatting_able_gender check (able_gender in ('M', 'F', 'X'))
    add constraint ck_chatting_able_age check (able_age >= 0 and able_age <= 5);

-- seq_chatting_no 시퀀스 생성
create sequence seq_chatting_no;


-- chatting_member 테이블 생성
create table chatting_member (
    no number,                                          -- 채팅방 별 참여자 테이블 고유 번호
    chat_no number not null,
    nickname varchar2(50) not null,               -- 회원 닉네임
    start_date date default sysdate not null,   -- 채팅방 참여일
    end_date date default null                      -- 채팅방 퇴장일
);
-- chatting_member 제약조건 추가
alter table chatting_member
    add constraint pk_chatting_member_no primary key (no)
    add constraint fk_chatting_member_chat_no foreign key (chat_no) references chatting(no) on delete cascade
    add constraint fk_chatting_member_member foreign key (nickname) references member(nickname) on delete cascade;

-- seq_chatting_member_no 시퀀스 생성
create sequence seq_chatting_member_no;


-- chatting_log 테이블 생성
create table chatting_log (
    no number, -- 채팅로그 별 고유 번호
    chat_no number not null,
    member_nick varchar2(50) not null,
    content varchar2(1000) not null,
    reg_date timestamp default systimestamp
);
-- chatting_log 제약조건 추가
alter table chatting_log
    add constraint pk_chatting_log_no primary key (no)
    add constraint fk_chatting_log_chat_no foreign key (chat_no) references chatting(no) on delete cascade
    add constraint fk_chatting_log_member_nick foreign key (member_nick) references member(nickname) on delete cascade;

-- seq_chatting_log_no 시퀀스 생성
create sequence seq_chatting_log_no;

-- notification 테이블 생성
create table notification (
    no number,
    mem_nick varchar2(50) not null,
    not_type varchar2(50) not null,
    not_content_pk number not null,
    not_message varchar2(100) not null,
    not_datetime timestamp default systimestamp not null,
    check_read char(1) not null
);

-- notification 제약조건 추가
alter table notification
    add constraint pk_notification_no primary key(no)
    add constraint fk_notification_mem_nick foreign key (mem_nick) references member(nickname) on delete cascade
    add constraint ck_notification_check_read check (check_read in ('O', 'X'));


alter table notification
    modify not_message varchar2(1000);

-- seq_notification_no 시퀀스 생성
create sequence seq_notification_no;

-- ======================================================================
-- 트리거 생성 (create)
-- ======================================================================
    
-- member delete 시 leave_member insert
create or replace trigger trig_member_leave_member
    before
    delete on member
    for each row
begin
    insert into
        leave_member
    values(
        seq_leave_member_no.nextval,
        :old.email,
        :old.nickname,
        :old.password,
        :old.birthday,
        :old.gender,
        :old.phone,
        :old.email,
        :old.enroll_date,
        :old.member_role,
        :old.warning_count,
        sysdate
    );
end;
/
--drop trigger trig_member_leave_member;


-- member에 warning_count가 3이 되면 member 탈퇴 (에러나서 보류)
--create or replace trigger trig_member_warning_count
--    before
--    update on member
--    for each row
--begin
--    if :new.warning_count = 3 then
--        delete from
--            member
--        where
--            member_id = :old.member_id;
--    end if;
--end;
--/
--drop trigger trig_member_warning_count;


-- ======================================================================
-- TABLE 및 COLUMN 주석
-- ======================================================================
-- member 테이블
comment on table member is '회원관리테이블';
comment on column member.email is '회원 이메일(PK, 변경불가)';
comment on column member.nickname is '회원 닉네임(UQ)';
comment on column member.password is '회원 비밀번호(필수입력)';
comment on column member.birthday is '회원 생년월일(필수입력)';
comment on column member.gender is '회원 성별(필수입력)';
comment on column member.enroll_date is '회원가입일';
comment on column member.member_role is '회원권한(CK in (U, M, A))';
comment on column member.original_filename is '원본 파일 이름';
comment on column member.renamed_filename is '저장 파일 이름';
comment on column member.warning_count is '누적경고숫자(CK 0 <= count <= 3)';
comment on column member.age is '회원 나이';

-- leave_member 테이블
comment on table leave_member is '탈퇴회원관리테이블';
comment on column leave_member.no is '탈퇴회원 번호(PK, 변경불가)';
comment on column leave_member.email is '탈퇴회원 이메일';
comment on column leave_member.nickname is '탈퇴회원 닉네임(UQ)';
comment on column leave_member.password is '탈퇴회원 비밀번호(필수입력)';
comment on column leave_member.birthday is '탈퇴회원 생년월일(필수입력)';
comment on column leave_member.gender is '탈퇴회원 성별(필수입력)';
comment on column leave_member.enroll_date is '탈퇴회원가입일';
comment on column leave_member.member_role is '탈퇴회원권한(CK in (U, M, A))';
comment on column leave_member.original_filename is '탈퇴회원 원본 파일 이름';
comment on column leave_member.renamed_filename is '탈퇴회원 저장 파일 이름';
comment on column leave_member.warning_count is '탈퇴회원 누적경고숫자(CK 0 <= count <= 3)';
comment on column leave_member.age is '탈퇴회원 나이';
comment on column leave_member.leave_date is '회원탈퇴일';

-- friends 테이블
comment on table friends is '친구관리테이블';
comment on column friends.no is '친구 관리 번호(PK, 변경불가)';
comment on column friends.my_nickname is '회원닉네임(FK member.nickname on delete cascade)';
comment on column friends.f_nickname is '친구닉네임(FK member.nickname on delete cascade)';
comment on column friends.is_friend is '친구여부(CK in (O, X))';

-- letter 테이블
comment on table letter is '편지테이블';
comment on column letter.no is '편지 번호(PK, 변경불가)';
comment on column letter.writer is '편지 발신인(FK member.nickname on delete set null)';
comment on column letter.addressee is '편지 수신인(FK member.nickname on delete set null)';
comment on column letter.design_no is '편지선택디자인(FK design.no)';
comment on column letter.font_no is '편지선택폰트(FK font.no)';
comment on column letter.content is '편지 내용(필수입력)';
comment on column letter.reg_date is '편지 작성일';
comment on column letter.read_check is '편지수신여부(CK in (O, X))';
comment on column letter.limit_gender is '편지 수신인 성별 선택(CK in (M, F, X))';
comment on column letter.limit_age is '편지 수신인 연령 선택(CK 0 <= age <= 5)';
comment on column letter.anonymous is '편지 발신인 익명 여부(CK in (O, X))';
comment on column letter.send_who is '편지 수신인 여부(CK in (A, F))';

-- attachment_letter 테이블
comment on table attachment_letter is '편지첨부파일테이블';
comment on column attachment_letter.no is '편지 첨부파일번호(PK, 변경불가)';
comment on column attachment_letter.letter_no is '참조한 편지번호(FK letter.no on delete cascade)';
comment on column attachment_letter.original_filename is '업로드한 편지첨부파일명';
comment on column attachment_letter.renamed_filename is '저장된 편지첨부파일명';
comment on column attachment_letter.reg_date is '편지 첨부파일 등록일';

-- diary 테이블
comment on table diary is '일기장테이블';
comment on column diary.no is '일기장 번호(PK, 변경불가)';
comment on column diary.writer is '일기 작성자(FK member.nickname on delete cascade)';
comment on column diary.design_no is '일기장선택디자인(FK design.no)';
comment on column diary.font_no is '일기장선택폰트(FK font.no)';
comment on column diary.content is '일기장 내용(필수입력)';
comment on column diary.original_filename is '업로드한 일기장첨부파일명';
comment on column diary.renamed_filename is '저장된 일기장첨부파일명';
comment on column diary.reg_date is '일기장 작성한 날짜';

-- design 테이블
comment on table design is '디자인테이블';
comment on column design.no is '디자인 번호(PK, 변경불가)';
comment on column design.part is '디자인 분류기호(CK in (L, D))';
comment on column design.original_filename is '업로드한 디자인첨부파일명';
comment on column design.renamed_filename is '저장된 디자인첨부파일명';
comment on column design.reg_date is '디자인 등록일';

-- font 테이블
comment on table font is '폰트테이블';
comment on column font.no is '폰트 번호(PK, 변경불가)';
comment on column font.name is '폰트 이름(필수입력)';
comment on column font.link is '폰트 링크(필수입력)';

-- counseling 테이블
comment on table counseling is '고민상담소테이블';
comment on column counseling.no is '고민글 번호(PK, 변경불가)';
comment on column counseling.writer is '고민글 작성자(FK member.nickname on delete cascade)';
comment on column counseling.title is '고민글 제목(필수입력)';
comment on column counseling.content is '고민글 내용(필수입력)';
comment on column counseling.views is '고민글 조회 수';
comment on column counseling.cs_like is '고민글 추천 수';
comment on column counseling.category is '고민글 카테고리(CK in (DAILY, CAREER, LOVE, FRIENDS, FAMILY, STUDY, CHILDCARE))';
comment on column counseling.reg_date is '고민글 작성한 날짜';
comment on column counseling.limit_gender is '고민글 조회자 성별 제한(CK in (M, F, X))';
comment on column counseling.limit_age is '고민글 조회자 연령 제한(CK 0 <= age <= 5)';
comment on column counseling.anonymous is '고민글 발신인 익명 여부(CK in (O, X))';

-- attachment_counseling 테이블
comment on table attachment_counseling is '고민상담소 첨부파일테이블';
comment on column attachment_counseling.no is '고민상담소 첨부파일번호(PK, 변경불가)';
comment on column attachment_counseling.cs_no is '참조한 고민글번호(FK counseling.no on delete cascade)';
comment on column attachment_counseling.original_filename is '업로드한 고민글첨부파일명';
comment on column attachment_counseling.renamed_filename is '저장된 고민글첨부파일명';
comment on column attachment_counseling.reg_date is '고민글 첨부파일 등록일';

-- cs_comment 테이블
comment on table cs_comment is '고민상담소 댓글테이블';
comment on column cs_comment.no is '고민상담소 댓글번호(PK, 변경불가)';
comment on column cs_comment.writer is '고민글 댓글 작성자(FK member.nickname on delete cascade)';
comment on column cs_comment.cs_no is '참조한 고민글 번호(FK counseling.no on delete cascade)';
comment on column cs_comment.content is '고민글 댓글 내용(필수입력)';
comment on column cs_comment.choice is '고민글 작성자가 채택한 댓글 여부(CK in (O, X))';
comment on column cs_comment.comment_level is '댓글 및 대댓글 여부(CK in (O, X))';
comment on column cs_comment.ref_comment_no is '참조한 댓글 번호(대댓글인 경우)';
comment on column cs_comment.reg_date is '고민글 댓글 작성일';

-- question 테이블
comment on table question is '문의게시판테이블';
comment on column question.no is '문의글 번호(PK, 변경불가)';
comment on column question.writer is '문의글 작성자(FK member.nickname)';
comment on column question.title is '문의글 제목(필수입력)';
comment on column question.content is '문의 내용(필수입력)';
comment on column question.reg_date is '문의글 작성일';

-- attachment_question 테이블
comment on table attachment_question is '문의게시판 첨부파일테이블';
comment on column attachment_question.no is '문의게시판 첨부파일번호(PK, 변경불가)';
comment on column attachment_question.q_no is '참조한 문의게시판번호(FK question.no on delete cascade)';
comment on column attachment_question.original_filename is '업로드한 문의글첨부파일명';
comment on column attachment_question.renamed_filename is '저장된 문의글첨부파일명';
comment on column attachment_question.reg_date is '문의게시판 첨부파일 등록일';

-- q_comment 테이블
comment on table q_comment is '문의게시판 댓글테이블';
comment on column q_comment.no is '문의게시판 댓글번호(PK, 변경불가)';
comment on column q_comment.writer is '문의게시판 댓글 작성자(FK member.nickname on delete cascade)';
comment on column q_comment.q_no is '참조한 문의게시판번호(FK question.no on delete cascade)';
comment on column q_comment.content is '문의게시판 댓글 내용(필수입력)';
comment on column q_comment.reg_date is '문의게시판 댓글 작성일';

-- faq 테이블
comment on table faq is '자주묻는 질의응답 테이블';
comment on column faq.no is '자주묻는 질의응답 번호(PK, 변경불가)';
comment on column faq.title is '자주묻는 질의응답 제목(필수입력)';
comment on column faq.content is '자주묻는 질의응답 내용(필수입력)';

-- complain 테이블
comment on table complain is '신고 테이블';
comment on column complain.no is '신고 번호(PK, 변경불가)';
comment on column complain.writer is '신고자(FK member.nickname on delete cascade)';
comment on column complain.villain is '피신고자(FK member.nickname on delete cascade)';
comment on column complain.partition is '신고 분류 문자(CK in (LETTER, COUNSELING, COMMENT))';
comment on column complain.content is '신고 내용(필수 입력)';
comment on column complain.partition_no is '신고 분류 번호(편지, 고민상담소, 댓글, 채팅의 no)';
comment on column complain.reg_date is '신고일';

-- chatting 테이블
comment on table chatting is '채팅방 테이블';
comment on column chatting.no is '채팅방 번호(PK, 변경불가)';
comment on column chatting.name is '채팅방 이름(필수입력)';
comment on column chatting.password is '채팅방 비밀번호';
comment on column chatting.captin is '채팅방 방장(FK member.nickname on delete cascade)';
comment on column chatting.category is '채팅방 카테고리';
comment on column chatting.able_gender is '채팅방 참여 가능 성별(CK in (M, F, X))';
comment on column chatting.able_age is '채팅방 참여 가능 연령(CK 0 <= age <= 5)';
comment on column chatting.now_count is '채팅방 현재 참가 인원';
comment on column chatting.able_count is '채팅방 참여 가능 인원';
comment on column chatting.reg_date is '채팅방 생성일';

-- chatting_member 테이블
comment on table chatting_member is '채팅 참여자 테이블';
comment on column chatting_member.no is '채팅 참여자 번호(PK, 변경불가)';
comment on column chatting_member.chat_no is '채팅방 참조 번호(FK chatting.no on delete cascade)';
comment on column chatting_member.nickname is '채팅방 참여자 닉네임(FK member.nickname on delete cascade)';
comment on column chatting_member.start_date is '채팅방 참여 시작일';
comment on column chatting_member.end_date is '채팅방 퇴장일';

-- chatting_log 테이블
comment on table chatting_log is '채팅로그 테이블';
comment on column chatting_log.no is '채팅로그 번호 테이블(PK, 변경불가)';
comment on column chatting_log.chat_no is '참여 채팅방 번호(FK chatting.no on delete cascade)';
comment on column chatting_log.member_nick is '채팅 작성자(FK member.nickname on delete cascade)';
comment on column chatting_log.content is '채팅 내용';
comment on column chatting_log.reg_date is '채팅시간';

-- notification 테이블
comment on table notification is '알람 테이블';
comment on column notification.no is '알람 번호 테이블(PK, 변경불가)';
comment on column notification.mem_nick is '알람 받을 회원 닉네임(FK member.nickname on delete cascade)';
comment on column notification.not_type is '알람 받은 컨텐츠';
comment on column notification.not_content_pk is '알람 받은 컨텐츠 pk';
comment on column notification.not_message is '알람 메세지';
comment on column notification.not_datetime is '알람 발송 시간';
comment on column notification.check_read is '알람 확인여부(CK in (O,X))';


-- like_counseling 테이블
comment on table like_counseling is '좋아요 테이블';
comment on column like_counseling.no is '좋아요 번호(PK, 변경불가)';
comment on column like_counseling.cs_no is '좋아요 누른 게시물 번호(FK, counseling.no)';
comment on column like_counseling.mem_nick is '좋아요 누른 회원 닉네임';
comment on column like_counseling.reg_date is '좋아요 누른 시간';

-- ======================================================================
-- member 테이블 insert
-- ======================================================================
--insert into member values ('test@naver.com', 'test', 'test', '1989-01-11', 'M', default, default, null, null, default);
--insert into member values ('test1@naver.com', 'test1', 'test1', '1990-09-09', 'M', default, default, null, null, default);
--insert into member values ('test2@naver.com', 'test2', 'test2', '1999-09-19', 'F', default, default, null, null, default);


-- ======================================================================
-- friends 테이블 insert
-- ======================================================================
--insert into friends values (seq_friends_no.nextval, 'test1', 'test2', 'O');
--insert into friends values (seq_friends_no.nextval, 'test', 'test1', 'O');
--insert into friends values (seq_friends_no.nextval, 'test', 'test2', 'O');

--select * from friends f left join member m on f.f_nickname = m.nickname where my_nickname = 'test';