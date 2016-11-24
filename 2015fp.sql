-- ******************************************************
-- 2015fp.sql
--
-- Loader for Final project Database
--
-- Description: This script contains the DDL to load
--              the tables of the
--              Salon Appointent traking database
--
--
-- Assignment:  CSCIE-60 Final Project 
--
-- Author:  Rajrupa Bakshi
--
-- Date:   16 December, 2015
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool 2015fp.lst


-- ******************************************************
--    DROP TABLES
-- ******************************************************
    DROP TABLE tbServiceRendered purge;
    DROP TABLE tbInvoice purge;
    DROP TABLE tbAppointment purge;
    DROP TABLE tbService purge;
    DROP TABLE tbClient purge;
    DROP TABLE tblogin purge;

-- ******************************************************
--    DROP SEQUENCES
-- ******************************************************

    DROP sequence seq_serviceId ;
    DROP sequence seq_rendered;
    DROP sequence seq_client;
    Drop sequence seq_appointment;
    Drop sequence seq_invoice;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************
CREATE TABLE tblogin (
    uname       varchar2(20)        not null,
    pwd         varchar2(20)        not null,
    fname       varchar2(20)        null,
    userview    varchar2(20)        null
);

CREATE table tbClient (
    clientId        char(4)            not null
    CONSTRAINT pk_clientId PRIMARY KEY
    CONSTRAINT rg_clientId CHECK (clientId between 1 and 9999),
    name            varchar2(50)            not null,
    phone           varchar2(15)            not null,
    email           varchar2(50)            null   
);

CREATE table tbService (
    serviceId           char(2)          not null
    CONSTRAINT pk_serviceId PRIMARY KEY
    CONSTRAINT serviceId_range CHECK (serviceId between 1 and 99),
    serviceType         varchar2(20)        not null,
    serviceDescr        varchar2(20)        not null,
    serviceDuration     number(5,0)         null,
    servicePrice        number(10,2)        default 0.00    not null
    constraint rg_price check (servicePrice >= 0)
);


CREATE table tbAppointment (
    appointmentNo       char(4)        not null
    CONSTRAINT pk_appointmentNo PRIMARY KEY
    CONSTRAINT rg_apptNo CHECK (appointmentNo between 1 and 9999),
    visitDate       date         default CURRENT_DATE     not null,
    visitTime       varchar2(5)         not null,
    status         char(8)              not null,
    clientId        char(4)        not null
    CONSTRAINT fk_clientId_tbAppointment
    REFERENCES tbClient(clientId) on delete cascade
);

CREATE table tbInvoice (
    invoiceNo        char(3)               not null
    CONSTRAINT pk_invoiceNo PRIMARY KEY,
    paymentDate       date                 not null,
    paymentAmt      number(11,2)           default 0.00     not null,
    paymentMethod     char(4)             not null,
    clientId        char(4)            not null
    CONSTRAINT fk_clientId_tbInvoice
    REFERENCES tbClient(clientId) on delete cascade,
    CONSTRAINT rg_paymentAmt CHECK (paymentAmt >= 0)
);

CREATE table tbServiceRendered (
    renderedNo          number(11,2)               not null
    CONSTRAINT pk_renderedNo PRIMARY KEY,
    serviceId       char(2)           not null
    CONSTRAINT fk_serviceId_tbServiceRendered
    REFERENCES tbService(serviceId),
    appointmentNo       char(4)        not null
    CONSTRAINT fk_apptNo_tbServiceRendered 
    REFERENCES tbAppointment(appointmentNo),
    servicePrice        number(11,2)        default 0.00    not null,
    invoiceNo        char(3)               null
    CONSTRAINT fk_invoiceNo_tbServiceRendered 
    REFERENCES tbInvoice(invoiceNo) on delete cascade
);


-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************

CREATE sequence seq_serviceId
    increment by 1
    start with 1;

CREATE sequence seq_rendered
    increment by 1
    start with 1;

CREATE sequence seq_client
    increment by 1
    start with 1;

CREATE sequence seq_appointment
    increment by 1
    start with 1;

CREATE sequence seq_invoice
    increment by 1
    start with 1;
    
    
-- ******************************************************
--    POPULATE TABLES
-- ******************************************************
/* tbLogin */
insert into tblogin values ('admin', '60admin', 'Lisa', 'all');



/* tbClient */
Insert into tbClient values (seq_client.nextval, 'Jessica Smith','714-222-3333','jessica.s@gmail.com');
Insert into tbClient values (seq_client.nextval, 'Abbie Vincent','543-333-2222','abbie.v@gmail.com');
Insert into tbClient values (seq_client.nextval, 'Dana Jones','777-4444-5555','dana.j@gmail.com');
Insert into tbClient values (seq_client.nextval, 'Tina Miller','333-888-9999','tina.m@gmail.com');
Insert into tbClient values (seq_client.nextval, 'Pamela Davis','233-243-3434','p.davis@gmail.com');
Insert into tbClient values (seq_client.nextval, 'Nancy Taylor','718-324-5434','nancy.t@gmail.com');


/* tbService */
Insert into tbService values (seq_serviceId.nextval,'facials', 'custom blend', 60, 95.00);
Insert into tbService values (seq_serviceId.nextval,'facials', 'acne clearing', 60, 95.00);
Insert into tbService values (seq_serviceId.nextval,'facials', 'calming', 60, 95.00);
Insert into tbService values (seq_serviceId.nextval,'facials', 'revitalizing', 60, 100.00);
Insert into tbService values (seq_serviceId.nextval,'waxing face', 'brow', null, 20.00);
Insert into tbService values (seq_serviceId.nextval,'waxing face', 'lip',null, 12.00);
Insert into tbService values (seq_serviceId.nextval,'waxing face', 'chin',null, 12.00);
Insert into tbService values (seq_serviceId.nextval,'waxing face', 'side of face',null, 12.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'under arm',null, 25.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'full arm', 30, 20.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'back', 30, 42.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'chest', 20, 50.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'sholders', 15, 20.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'neck', 15, 20.00);
Insert into tbService values (seq_serviceId.nextval,'waxing body', 'full legs', 45, 60.00);


/* tbAppointment*/
Insert into tbAppointment values (seq_appointment.nextval,to_date('09-04-2015', 'mm-dd-yyyy'), '3:30', 'complete','1');
Insert into tbAppointment values (seq_appointment.nextval,to_date('09-04-2015', 'mm-dd-yyyy'), '4:30','complete','2');
Insert into tbAppointment values (seq_appointment.nextval,to_date('09-04-2015', 'mm-dd-yyyy'), '6:00','complete','3');
Insert into tbAppointment values (seq_appointment.nextval,to_date('09-05-2015', 'mm-dd-yyyy'), '2:00','pending','4');
Insert into tbAppointment values (seq_appointment.nextval,to_date('09-05-2015', 'mm-dd-yyyy'), '4:00','missed','5');
Insert into tbAppointment values (seq_appointment.nextval,to_date('09-05-2015', 'mm-dd-yyyy'), '5:00','complete','6');
Insert into tbAppointment values (seq_appointment.nextval,to_date('10-07-2015', 'mm-dd-yyyy'), '5:00','complete','6');
Insert into tbAppointment values (seq_appointment.nextval,to_date('11-10-2015', 'mm-dd-yyyy'), '5:00','complete','6');
Insert into tbAppointment values (seq_appointment.nextval,to_date('12-22-2015', 'mm-dd-yyyy'), '2:00','pending','6');



/* tbInvoice */
Insert into tbInvoice values (seq_invoice.nextval,to_date('09-04-2015', 'mm-dd-yyyy'), 115, 'card', '1');
Insert into tbInvoice values (seq_invoice.nextval,to_date('09-04-2015', 'mm-dd-yyyy'), 95, 'cash', '2');
Insert into tbInvoice values (seq_invoice.nextval,to_date('09-04-2015', 'mm-dd-yyyy'), 50, 'cash', '3');
Insert into tbInvoice values (seq_invoice.nextval,to_date('09-05-2015', 'mm-dd-yyyy'), 92, 'cash', '4');
Insert into tbInvoice values (seq_invoice.nextval,to_date('09-05-2015', 'mm-dd-yyyy'), 95, 'card', '6');
Insert into tbInvoice values (seq_invoice.nextval,to_date('10-07-2015', 'mm-dd-yyyy'), 95, 'card', '6');
Insert into tbInvoice values (seq_invoice.nextval,to_date('11-10-2015', 'mm-dd-yyyy'), 95, 'card', '6');


/* tbServiceRendered */
Insert into tbServiceRendered values (seq_rendered.nextval,'3', '1', 95, '1');
Insert into tbServiceRendered values (seq_rendered.nextval,'5', '1', 20, '1');
Insert into tbServiceRendered values (seq_rendered.nextval,'2', '2', 95, '2');
Insert into tbServiceRendered values (seq_rendered.nextval,'11', '3', 50, '3');
Insert into tbServiceRendered values (seq_rendered.nextval,'10', '4', 42, '4');
Insert into tbServiceRendered values (seq_rendered.nextval,'11', '4', 50, '4');
Insert into tbServiceRendered values (seq_rendered.nextval,'3', '5', 95, null);
Insert into tbServiceRendered values (seq_rendered.nextval,'2', '6', 95, '5');
Insert into tbServiceRendered values (seq_rendered.nextval,'2', '7', 95, '6');
Insert into tbServiceRendered values (seq_rendered.nextval,'2', '8', 95, '7');
Insert into tbServiceRendered values (seq_rendered.nextval,'2', '9', 95, null);



-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
-- ******************************************************

SELECT * FROM tblogin;
SELECT * FROM tbClient;
SELECT * FROM tbService;
SELECT * FROM tbAppointment;
SELECT * FROM tbInvoice;
SELECT * FROM tbServiceRendered;

-- ******************************************************
--   Triggers
-- ******************************************************
-- Trigger is to increment appontmentNo by 1 every time data is inserted
    CREATE or REPLACE trigger TR_new_appointment_IN
       before insert on tbAppointment
       for each row
       /* trigger executes before an insert into the appointment table */
       begin
          SELECT seq_appointment.nextval
               into :new.appointmentNo
                FROM dual;
       end TR_new_appointment_IN;
    /


-- Trigger is to increment clientId by 1 every time client is addded
    CREATE or REPLACE trigger TR_new_client_IN
       before insert on tbClient
       for each row
       /* trigger executes before an insert into the tbClient */
       begin
          SELECT seq_client.nextval
               into :new.clientId
                FROM dual;
       end TR_new_client_IN;
    /

-- Trigger is to increment renderedNo by 1 every time data is inserted
    CREATE or REPLACE trigger TR_new_rendered_IN
       before insert on tbServiceRendered
       for each row
       /* trigger executes before an insert into the tbServiceRendered */
       begin
          SELECT seq_rendered.nextval
               into :new.renderedNo
                FROM dual;
       end TR_new_rendered_IN;
    /

-- Trigger is to increment serviceId by 1 every time data is inserted
    CREATE or REPLACE trigger TR_new_service_IN
       before insert on tbService
       for each row
       /* trigger executes before an insert into the tbService */
       begin
          SELECT seq_serviceId.nextval
               into :new.serviceId
                FROM dual;
       end TR_new_service_IN;
    /

-- Trigger is to increment invoiceNo by 1 every time data is inserted
    CREATE or REPLACE trigger TR_new_invoice_IN
       before insert on tbInvoice
       for each row
       /* trigger executes before an insert into the tbInvoice*/
       begin
          SELECT seq_invoice.nextval
               into :new.invoiceNo
                FROM dual;
       end TR_new_invoice_IN;
    /

 
-- ******************************************************
--    END SESSION
-- ******************************************************

spool off
