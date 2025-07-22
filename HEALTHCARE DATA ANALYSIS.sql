create database healthcare;
use healthcare;

-- Retrieve all table information
select * from patients;
select * from appointments;
select * from billing;
select * from doctors;
select * from prescriptions;

-- Get all appointments for a specific patient
select * from appointments
where patient_id=1;

-- Retrieve all prescriptions for specific patient
select * from prescriptions
where appointment_id=1;

-- Get billing information for a specific appointment
select * from billing
where appointment_id=2;

-- List all appointments with billing status
select a.appointment_id,p.first_name as patient_first_name,p.last_name as patient_last_name,
d.first_name as doctor_first_name,d.last_name as doctor_last_name,
b.amount,b.payment_date,b.status
from appointments a
join patients p on a.patient_id=p.patient_id
join doctors d on a.doctor_id=d.doctor_id
join billing b on a.appointment_id=b.appointment_id;

-- Find all paid billing
select * from billing
where status='Paid';

-- Calculate total amount billed and total paid amount 
select
(select sum(amount) from billing) as total_billed,
(select sum(amount) from billing where status='Paid') as total_paid;


-- get the number of apointments by specialty
select d.specialty,count(a.appointment_id) as number_of_appointments
from appointments a
join doctors d on a.doctor_id=d.doctor_id
group by d.specialty;

-- Find the most common reason for appointments
select reason,
count(*) as count
from appointments
group by reason
order by count desc;

-- List patients with their latest appointment date
select p.patient_id,p.first_name,p.last_name,max(a.appointment_date) as latest_appointment
from patients p
join appointments a on p.patient_id=a.patient_id
group by p.patient_id,p.first_name,p.last_name;

-- List all doctors and the number of appointments they had
select d.doctor_id,d.first_name,d.last_name,count(a.appointment_id) as number_of_appointments
from doctors d
left join appointments a on d.doctor_id=a.doctor_id
group by d.doctor_id,d.first_name,d.last_name
order by number_of_appointments desc;

-- Retrieve patients who had appointments in the last 30 days
select distinct p.*
from patients p
join appointments a on p.patient_id=a.patient_id
where a.appointment_date >=curdate()-Interval 30 day;

-- Find prescriptions associated with appointments that are pending payment
select pr.prescription_id,pr.medication,pr.dosage,pr.instructions
from prescriptions pr
join appointments a on pr.appointment_id = a.appointment_id
join billing b on a.appointment_id=b.appointment_id
where b.status='Pending'
order by dosage desc;

-- Deatailed view of each patient , including their appointment and billing status
select p.patient_id,p.first_name,p.last_name,p.dob,p.gender,p.address,p.phone_number,
a.appointment_id,a.appointment_date,a.reason,
b.amount,b.payment_date,b.status as billing_status
from patients p
left join appointments a on p.patient_id=a.patient_id
left join billing b on a.appointment_id=b.appointment_id
order by p.patient_id,a.appointment_date;


-- Analyse patient demographics
select gender , count(*) as count
from patients
group by gender; 

-- Analyze the trend of appointments over months or year
select date_format(appointment_date,'%Y-%m') as month,count(*) as number_of_appointments
from appointments
group by month
order by month;

-- Yearly trend
select year(appointment_date) as year,count(*) as number_of_appointments
from appointments
group by year
order by year;

-- Analyze the trend of appointments over month or years
select date_format(appointment_date,'%Y-%m') as month,count(*) as number_of_appointments
from appointments
group by month
order by month;

-- Identify the most frequently prescribed medications and their total dosage
select medication , count(*) as frequency ,sum(cast(substring_index(dosage,' ',1) as unsigned)) as total_dosage
from prescriptions
group by medication
order by frequency desc;

-- Average billing amount by number of appointments
select p.patient_id,count(a.appointment_id) as apppointment_count,avg(b.amount) as avg_billing_amount
from patients p
left join appointments a on p.patient_id=a.patient_id
left join billing b on a.appointment_id=b.appointment_id
group by p.patient_id;

-- Analyze the correlation between appointment frequency and billing status
select p.patient_id,p.first_name,p.last_name,sum(b.amount) as total_billed
from patients p
join appointments a on p.patient_id=a.patient_id
join billing b on a.appointment_id=b.appointment_id
group by p.patient_id,p.first_name,p.last_name
order by total_billed desc
limit 10;

-- Payment status over time
select date_format(payment_date,'%Y-%m') as month,status,count(*) as count
from billing
group by month,status
order by month,status;

-- Unpaid bills analysis
select p.patient_id,p.first_name,p.last_name,sum(b.amount) as total_unpaid
from patients p
join appointments a on p.patient_id=a.patient_id
join billing b on a.appointment_id=b.appointment_id
where b.status='Pending'
group by p.patient_id,p.first_name,p.last_name
order by total_unpaid desc;

-- doctor performance metrics
select d.doctor_id,d.first_name,d.last_name,count(a.aapointment_id) as number_of_appointments
from doctors d
left join appointments a on d.doctor_id=a.doctor_id
group by d.doctor_id,d.d.first_name,d.last_name;

-- Day wise appointment counts
select appointment_date,count(*) as appointment_count
from appointments
group by appointment_date;

-- Find patients with missing appointments
select p.patient_id,p.first_name,p.last_name
from patients p
left join appointments a on p.patient_id=a.patient_id
where a.appointment_id is null;

-- Find appointments without billing records
select a.appointment_id,a.patient_id,a.doctor_id,a.appointment_date
from appointments a
left join billing b on a.appointment_id=b.appointment_id
where b.billing_id is null;

-- Find all appointments for doctor with ID 1
select a.appointment_id,p.first_name as patient_first_name,p.last_name as patient_last_name,a.appointment_date,a.reason
from appointments a
join patients p on a.patient_id=p.patient_id
where a.doctor_id=1;


-- All prescriptions with payment status or pending
select p.medication,p.dosage,p.instructions,b.amount,b.payment_date,b.status
from prescriptions p
join appointments a on p.appointment_id=a.appointment_id
join billing b on a.appointment_id=b.appointment_id
where b.status='pending';

-- List all patients who had appointments in august
select distinct p.first_name,p.last_name,p.dob,p.gender,a.appointment_date
from patients p
join appointments a on p.patient_id=a.patient_id
where date_format(a.appointment_date,'%Y-%m')='2024-08';

-- List all doctors and their appointments in august till today 
select d.first name,d.last_name,a.appointment_date,p.first_name as patient_first_name,p.last_name as patient_last_name
from doctors d
join appointments a on d.doctor_id=a.doctor_id
join patients p on a.patient_id=p.patient_id
where a.appointment_date between '2024-08-01' and '2024-08-10';

-- Get total amount billed per doctor
select d.first_name,d.last_name,d,specialty,sum(b.amount) as total_billed
from doctors d
join appointments a on d.doctor_id=a.doctor_id
join billing b on a.appointment_id=b.appointment_id
group by d.first_name,d.last_name,d.specialty
order by total_billed desc;



