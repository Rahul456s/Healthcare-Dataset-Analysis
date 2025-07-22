# 🏥 Healthcare SQL Database Project

This project models a comprehensive **healthcare management system** using SQL, focusing on patients, appointments, billing, prescriptions, and doctors. It showcases advanced querying techniques used for real-world data analysis, reporting, and administration in the healthcare domain.

---

## 📂 Database Overview

**Database Name**: `healthcare`

### 📋 Key Tables

* `patients`: Patient demographic and contact details.
* `doctors`: Doctor profiles including specialty.
* `appointments`: Patient-doctor appointments with reasons and dates.
* `prescriptions`: Medications prescribed during appointments.
* `billing`: Billing and payment records linked to appointments.

---

## 📦 Setup Instructions

```sql
CREATE DATABASE healthcare;
USE healthcare;
```

You will then need to define the schema (not included here) and insert data accordingly. After that, you can run the queries found in this project.

---

## 📊 SQL Query Categories

### 🔍 Data Retrieval

```sql
SELECT * FROM patients;
SELECT * FROM appointments;
SELECT * FROM billing;
SELECT * FROM prescriptions;
```

### 👨‍⚕️ Appointment & Patient Analysis

* Appointments by patient:

  ```sql
  SELECT * FROM appointments WHERE patient_id = 1;
  ```

* Patients with appointments in the last 30 days:

  ```sql
  SELECT DISTINCT p.* FROM patients p
  JOIN appointments a ON p.patient_id = a.patient_id
  WHERE a.appointment_date >= CURDATE() - INTERVAL 30 DAY;
  ```

* Patients who missed appointments:

  ```sql
  SELECT p.patient_id, p.first_name, p.last_name
  FROM patients p
  LEFT JOIN appointments a ON p.patient_id = a.patient_id
  WHERE a.appointment_id IS NULL;
  ```

### 💰 Billing Analysis

* Total billed vs. paid:

  ```sql
  SELECT
    (SELECT SUM(amount) FROM billing) AS total_billed,
    (SELECT SUM(amount) FROM billing WHERE status = 'Paid') AS total_paid;
  ```

* Unpaid bills by patient:

  ```sql
  SELECT p.first_name, p.last_name, SUM(b.amount) AS total_unpaid
  FROM patients p
  JOIN appointments a ON p.patient_id = a.patient_id
  JOIN billing b ON a.appointment_id = b.appointment_id
  WHERE b.status = 'Pending'
  GROUP BY p.patient_id;
  ```

### 💊 Prescription Analytics

* Most prescribed medications:

  ```sql
  SELECT medication, COUNT(*) AS frequency
  FROM prescriptions
  GROUP BY medication
  ORDER BY frequency DESC;
  ```

* Prescriptions linked to pending payments:

  ```sql
  SELECT pr.medication, pr.dosage
  FROM prescriptions pr
  JOIN appointments a ON pr.appointment_id = a.appointment_id
  JOIN billing b ON a.appointment_id = b.appointment_id
  WHERE b.status = 'Pending';
  ```

### 📈 Trends & Metrics

* Appointments over time (monthly):

  ```sql
  SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS total
  FROM appointments
  GROUP BY month
  ORDER BY month;
  ```

* Doctor performance:

  ```sql
  SELECT d.first_name, d.last_name, COUNT(a.appointment_id) AS number_of_appointments
  FROM doctors d
  LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
  GROUP BY d.doctor_id;
  ```

* Total billed per doctor:

  ```sql
  SELECT d.first_name, d.last_name, d.specialty, SUM(b.amount) AS total_billed
  FROM doctors d
  JOIN appointments a ON d.doctor_id = a.doctor_id
  JOIN billing b ON a.appointment_id = b.appointment_id
  GROUP BY d.doctor_id
  ORDER BY total_billed DESC;
  ```

---

## 📸 Screenshots

> Replace these with your actual image file names placed in a `screenshots/` folder.

```markdown
### Dashboard Overview
![Dashboard](screenshots/healthcare_dashboard.png)

### Billing Summary
![Billing Summary](screenshots/billing_summary.png)
```

---

## 🧠 Technologies Used

* **MySQL / MariaDB**
* Relational Database Design
* Complex SQL Queries
* Joins, Subqueries, Aggregates
* Time-based Data Analysis

---

## 📄 License

This project is licensed under the MIT License.
See the [LICENSE](LICENSE) file for details.

---

## 🙋 Author

**Your Name**
GitHub: [yourusername](https://github.com(https://github.com/Rahul456s))
Email: [youremail@example.com](mailto:Rahul456shende@gmail.com)

---

Would you like me to bundle this as a downloadable `README.md` or help you upload it to GitHub?
