-- Mobile Repair Management System
-- MySQL 8+ / MariaDB 10.5+

CREATE DATABASE IF NOT EXISTS mobile_repair_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mobile_repair_system;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS activity_logs;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS repair_parts;
DROP TABLE IF EXISTS repair_status_history;
DROP TABLE IF EXISTS repairs;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS settings;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL,
 email VARCHAR(160) NOT NULL UNIQUE,
 phone VARCHAR(40) NULL,
 password VARCHAR(255) NOT NULL,
 role ENUM('admin','receptionist','technician') NOT NULL,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE customers (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(150) NOT NULL,
 phone VARCHAR(40) NOT NULL UNIQUE,
 email VARCHAR(160) NULL UNIQUE,
 address VARCHAR(255) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX idx_customer_name(full_name)
) ENGINE=InnoDB;

CREATE TABLE devices (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 customer_id INT UNSIGNED NOT NULL,
 brand VARCHAR(80) NOT NULL,
 model VARCHAR(100) NOT NULL,
 imei VARCHAR(80) NULL UNIQUE,
 color VARCHAR(50) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_devices_customer FOREIGN KEY(customer_id) REFERENCES customers(id) ON DELETE CASCADE,
 INDEX idx_device_customer(customer_id)
) ENGINE=InnoDB;

CREATE TABLE inventory (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 part_name VARCHAR(150) NOT NULL,
 sku VARCHAR(80) NOT NULL UNIQUE,
 category VARCHAR(80) NOT NULL DEFAULT 'Other',
 quantity INT NOT NULL DEFAULT 0,
 reorder_level INT NOT NULL DEFAULT 5,
 unit_price DECIMAL(12,2) NOT NULL DEFAULT 0,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE repairs (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 ticket_no VARCHAR(40) NOT NULL UNIQUE,
 customer_id INT UNSIGNED NOT NULL,
 device_id INT UNSIGNED NOT NULL,
 technician_id INT UNSIGNED NULL,
 fault_description TEXT NOT NULL,
 diagnosis TEXT NULL,
 estimated_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
 labor_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
 parts_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
 total_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
 status ENUM('pending','under_diagnosis','repairing','waiting_parts','completed','collected','cancelled') NOT NULL DEFAULT 'pending',
 priority ENUM('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
 expected_date DATE NULL,
 completed_at DATETIME NULL,
 created_by INT UNSIGNED NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_repairs_customer FOREIGN KEY(customer_id) REFERENCES customers(id),
 CONSTRAINT fk_repairs_device FOREIGN KEY(device_id) REFERENCES devices(id),
 CONSTRAINT fk_repairs_technician FOREIGN KEY(technician_id) REFERENCES users(id) ON DELETE SET NULL,
 CONSTRAINT fk_repairs_creator FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL,
 INDEX idx_repairs_status(status), INDEX idx_repairs_technician(technician_id), INDEX idx_repairs_created(created_at)
) ENGINE=InnoDB;

CREATE TABLE repair_status_history (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 repair_id INT UNSIGNED NOT NULL,
 status ENUM('pending','under_diagnosis','repairing','waiting_parts','completed','collected','cancelled') NOT NULL,
 note TEXT NULL,
 changed_by INT UNSIGNED NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_history_repair FOREIGN KEY(repair_id) REFERENCES repairs(id) ON DELETE CASCADE,
 CONSTRAINT fk_history_user FOREIGN KEY(changed_by) REFERENCES users(id) ON DELETE SET NULL,
 INDEX idx_history_repair(repair_id)
) ENGINE=InnoDB;

CREATE TABLE repair_parts (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 repair_id INT UNSIGNED NOT NULL,
 inventory_id INT UNSIGNED NOT NULL,
 quantity INT NOT NULL DEFAULT 1,
 unit_price DECIMAL(12,2) NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_parts_repair FOREIGN KEY(repair_id) REFERENCES repairs(id) ON DELETE CASCADE,
 CONSTRAINT fk_parts_inventory FOREIGN KEY(inventory_id) REFERENCES inventory(id),
 INDEX idx_parts_repair(repair_id)
) ENGINE=InnoDB;

CREATE TABLE invoices (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 invoice_no VARCHAR(40) NOT NULL UNIQUE,
 repair_id INT UNSIGNED NOT NULL UNIQUE,
 subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
 discount DECIMAL(12,2) NOT NULL DEFAULT 0,
 total DECIMAL(12,2) NOT NULL DEFAULT 0,
 paid_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 payment_status ENUM('unpaid','partial','paid') NOT NULL DEFAULT 'unpaid',
 notes TEXT NULL,
 created_by INT UNSIGNED NULL,
 issued_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_invoice_repair FOREIGN KEY(repair_id) REFERENCES repairs(id),
 CONSTRAINT fk_invoice_creator FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE payments (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 invoice_id INT UNSIGNED NOT NULL,
 amount DECIMAL(12,2) NOT NULL,
 method ENUM('cash','mobile_money','bank','card') NOT NULL DEFAULT 'cash',
 reference_no VARCHAR(100) NULL,
 received_by INT UNSIGNED NULL,
 paid_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_payment_invoice FOREIGN KEY(invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
 CONSTRAINT fk_payment_user FOREIGN KEY(received_by) REFERENCES users(id) ON DELETE SET NULL,
 INDEX idx_payments_date(paid_at)
) ENGINE=InnoDB;

CREATE TABLE notifications (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 repair_id INT UNSIGNED NULL,
 customer_id INT UNSIGNED NULL,
 channel ENUM('email','sms','system') NOT NULL DEFAULT 'email',
 recipient VARCHAR(180) NULL,
 subject VARCHAR(200) NOT NULL,
 message TEXT NOT NULL,
 delivery_status ENUM('logged','sent','failed') NOT NULL DEFAULT 'logged',
 sent_at DATETIME NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_notification_repair FOREIGN KEY(repair_id) REFERENCES repairs(id) ON DELETE SET NULL,
 CONSTRAINT fk_notification_customer FOREIGN KEY(customer_id) REFERENCES customers(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE settings (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 setting_key VARCHAR(100) NOT NULL UNIQUE,
 setting_value TEXT NULL,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE activity_logs (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 action VARCHAR(80) NOT NULL,
 entity_type VARCHAR(80) NOT NULL,
 entity_id INT UNSIGNED NULL,
 description VARCHAR(255) NULL,
 ip_address VARCHAR(50) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_log_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,
 INDEX idx_log_created(created_at)
) ENGINE=InnoDB;

-- Seed users. Change passwords after first login.
-- Admin@123, Reception@123, Tech@123
INSERT INTO users(id,name,email,phone,password,role,status) VALUES
(1,'Admin User','admin@mrms.com','0612345678','$2y$12$w3Rp0gh1.BIdPT/TK0zEjeu/UAWPpRmrb9EaJRzvj4CZsN0FZdPHe','admin','active'),
(2,'Reception User','reception@mrms.com','0612345679','$2y$12$3eoIFoUJfebOpQuXgEJiweKvazz2D6sAcjZBqs/avfqMKiniWyP6m','receptionist','active'),
(3,'Mohamed Hassan','technician@mrms.com','0612345680','$2y$12$0DBapmEPiqJHANGYsM/8CeV/oL.ZFBjIbP5pTfJgU6U7mfoHl1ZeK','technician','active'),
(4,'Khalid Ali','khalid@mrms.com','0612345681','$2y$12$0DBapmEPiqJHANGYsM/8CeV/oL.ZFBjIbP5pTfJgU6U7mfoHl1ZeK','technician','active');

INSERT INTO settings(setting_key,setting_value) VALUES
('shop_name','Mobile Repair Center'),('shop_email','info@mrcenter.com'),('shop_phone','0612-1234567'),('shop_address','Mogadishu, Somalia'),('currency','USD ($)'),('email_notifications','enabled');

INSERT INTO customers(id,full_name,phone,email,address) VALUES
(1,'Ahmed Ali','0611111111','ahmed@example.com','Hodan, Mogadishu'),
(2,'Fatima Noor','0622222222','fatima@example.com','Wadajir, Mogadishu'),
(3,'Bilal Ahmed','0633333333','bilal@example.com','Yaqshid, Mogadishu'),
(4,'Zainab Khan','0644444444','zainab@example.com','Karaan, Mogadishu');

INSERT INTO devices(id,customer_id,brand,model,imei,color) VALUES
(1,1,'Apple','iPhone 13 Pro','356780012345678','Graphite'),
(2,2,'Samsung','Galaxy A54','352222222222222','Black'),
(3,3,'Oppo','A74','353333333333333','Blue'),
(4,4,'Apple','iPhone 11','354444444444444','White');

INSERT INTO inventory(id,part_name,sku,category,quantity,reorder_level,unit_price) VALUES
(1,'iPhone 13 OLED Screen','SCR-IP13-OLED','Display',12,4,55.00),
(2,'Samsung A54 Battery','BAT-SA54','Battery',20,5,22.00),
(3,'USB-C Charging Port','PORT-USBC-01','Port',18,5,10.00),
(4,'iPhone 11 Back Cover','BODY-IP11','Body',8,3,18.00),
(5,'Universal Speaker','SPK-UNI-01','Audio',25,5,8.00);

INSERT INTO repairs(id,ticket_no,customer_id,device_id,technician_id,fault_description,diagnosis,estimated_cost,labor_cost,parts_cost,total_cost,status,priority,expected_date,completed_at,created_by,created_at) VALUES
(1,'MR000125',1,1,3,'Broken screen and touch not responding','OLED display assembly damaged',80,25,55,80,'repairing','high',DATE_ADD(CURRENT_DATE(),INTERVAL 2 DAY),NULL,2,DATE_SUB(NOW(),INTERVAL 4 DAY)),
(2,'MR000126',2,2,4,'Battery drains rapidly','Battery health below normal range',45,20,22,42,'completed','normal',CURRENT_DATE(),NOW(),2,DATE_SUB(NOW(),INTERVAL 6 DAY)),
(3,'MR000127',3,3,3,'Phone does not charge','Charging port requires replacement',35,15,10,25,'waiting_parts','normal',DATE_ADD(CURRENT_DATE(),INTERVAL 3 DAY),NULL,2,DATE_SUB(NOW(),INTERVAL 2 DAY)),
(4,'MR000128',4,4,NULL,'Back glass damaged',NULL,50,0,0,0,'pending','low',DATE_ADD(CURRENT_DATE(),INTERVAL 5 DAY),NULL,2,NOW());

INSERT INTO repair_status_history(repair_id,status,note,changed_by,created_at) VALUES
(1,'pending','Repair ticket created',2,DATE_SUB(NOW(),INTERVAL 4 DAY)),(1,'under_diagnosis','Device inspection started',3,DATE_SUB(NOW(),INTERVAL 3 DAY)),(1,'repairing','Screen replacement in progress',3,DATE_SUB(NOW(),INTERVAL 1 DAY)),
(2,'pending','Repair ticket created',2,DATE_SUB(NOW(),INTERVAL 6 DAY)),(2,'repairing','Battery replacement started',4,DATE_SUB(NOW(),INTERVAL 5 DAY)),(2,'completed','Battery replaced and device tested',4,DATE_SUB(NOW(),INTERVAL 3 DAY)),
(3,'pending','Repair ticket created',2,DATE_SUB(NOW(),INTERVAL 2 DAY)),(3,'under_diagnosis','Charging circuit inspected',3,DATE_SUB(NOW(),INTERVAL 1 DAY)),(3,'waiting_parts','Waiting for compatible charging port',3,NOW()),
(4,'pending','Repair ticket created',2,NOW());

INSERT INTO repair_parts(repair_id,inventory_id,quantity,unit_price) VALUES(1,1,1,55.00),(2,2,1,22.00);
UPDATE inventory SET quantity=quantity-1 WHERE id IN(1,2);

INSERT INTO invoices(id,invoice_no,repair_id,subtotal,discount,total,paid_amount,payment_status,notes,created_by,issued_at) VALUES
(1,'INV000126',2,42,0,42,42,'paid','Thirty-day service warranty.',2,DATE_SUB(NOW(),INTERVAL 3 DAY));
INSERT INTO payments(invoice_id,amount,method,reference_no,received_by,paid_at) VALUES(1,42,'mobile_money','EVC-100126',2,DATE_SUB(NOW(),INTERVAL 3 DAY));

INSERT INTO notifications(repair_id,customer_id,channel,recipient,subject,message,delivery_status,sent_at) VALUES
(1,1,'email','ahmed@example.com','Repair MR000125 status updated','Your device repair is now Repairing.','logged',NOW()),
(2,2,'email','fatima@example.com','Repair MR000126 completed','Your repair is complete and ready for collection.','logged',DATE_SUB(NOW(),INTERVAL 3 DAY));
