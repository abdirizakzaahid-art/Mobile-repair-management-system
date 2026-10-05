# MRMS Graduation Project Guide

## Project title

Design and Implementation of a Web-Based Mobile Repair Management System

## Problem statement

Many repair centers use notebooks, messaging applications, and disconnected spreadsheets to manage customer devices. This makes it difficult to trace repair progress, assign technicians, control spare-parts stock, calculate invoices, and produce management reports. MRMS centralizes those activities in a secure role-based web application.

## Project objectives

1. Register customers and their mobile devices.
2. Create uniquely identified repair tickets.
3. Assign repairs to technicians and record their progress.
4. Allow customers to track repairs using a ticket number and phone number.
5. Control spare-parts inventory and automatically reduce stock when parts are used.
6. Create invoices, record partial or complete payments, and calculate balances.
7. Maintain notification and activity histories.
8. Produce operational and financial reports for management.
9. Protect system functions through authentication, authorization, validation, and CSRF protection.

## Users and permissions

| Role | Main permissions |
|---|---|
| Administrator | Full dashboard, repairs, customers, inventory, invoices, reports, technicians, users, and settings |
| Receptionist | Customers, devices, repair tickets, invoices, payments, notifications, and customer tracking |
| Technician | Assigned repair queue, repair details, diagnosis, status updates, and progress notes |
| Customer | Public repair tracking using ticket number and registered phone number |

## Laravel architecture

- `routes/web.php`: named browser routes and role-protected route groups.
- `app/Http/Controllers`: request processing and application workflows.
- `app/Http/Middleware`: authentication and role authorization.
- `app/Support/helpers.php`: formatting, settings, notifications, and audit helpers.
- `resources/views`: reusable Blade interface and module screens.
- `public/assets`: responsive visual design and browser behavior.
- `database/schema.sql`: relational schema, constraints, indexes, and demonstration records.

## Main workflows for the defense demonstration

### Receptionist workflow

1. Sign in as the receptionist.
2. Register a customer and device.
3. Create a repair ticket and assign a technician.
4. Print or present the generated ticket number.
5. Create an invoice after repair costs are entered.
6. Record a customer payment.

### Technician workflow

1. Sign in as the technician.
2. Open the assigned repair queue.
3. Review customer-reported device faults.
4. Enter a diagnosis and progress note.
5. Move the repair through diagnosis, repair, completion, and collection statuses.

### Administrator workflow

1. Review operational metrics and charts.
2. Add and adjust spare-parts inventory.
3. Add parts to a repair and demonstrate automatic stock reduction.
4. View technician performance and financial reports.
5. Manage users and business settings.

### Customer workflow

1. Open `/track` without signing in.
2. Enter sample ticket `MR000125` and phone `0611111111`.
3. Review the repair status and progress timeline.

## Security controls

- Passwords are verified with Laravel's secure hashing service.
- Sessions are regenerated after successful login.
- Laravel CSRF tokens protect state-changing forms.
- Custom middleware restricts pages by user role.
- Laravel validation checks submitted values.
- Query Builder parameter binding protects database queries.
- Transactions protect multi-table inventory, repair, invoice, and payment operations.
- Activity records provide an audit trail.
- Public tracking requires both a ticket number and the customer's phone number.

## Suggested report chapters

1. Introduction and background
2. Problem statement, objectives, scope, and limitations
3. Literature review and related systems
4. Requirements analysis and system modelling
5. Database and interface design
6. Laravel implementation
7. Testing and results
8. Conclusions and recommendations

## Recommended diagrams

- Use-case diagram for administrator, receptionist, technician, and customer.
- Entity-relationship diagram based on `docs/ERD.md`.
- Activity diagram for repair ticket processing.
- Sequence diagram for customer tracking and repair-status updates.
- Deployment diagram showing browser, Laravel server, and MySQL database.

## Testing priorities

- Correct login and role restrictions.
- Duplicate phone, email, SKU, and IMEI handling.
- Technician ownership restrictions.
- Repair status history creation.
- Insufficient inventory rejection and stock reduction.
- Invoice balance and partial payment calculations.
- Invalid public tracking credentials.
- Responsive layout on desktop, tablet, and mobile screen sizes.
