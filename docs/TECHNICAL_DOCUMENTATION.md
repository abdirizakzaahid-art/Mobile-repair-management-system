# Technical Documentation

## Architecture

MRMS uses a three-tier architecture:

1. **Presentation tier** — Bootstrap, HTML, CSS, and JavaScript in the browser.
2. **Application tier** — PHP controllers, session authentication, role rules, validation, and business operations.
3. **Data tier** — MySQL relational database accessed through PDO prepared statements.

## Main workflow

1. A receptionist registers a customer and at least one device.
2. The receptionist creates a repair ticket and optionally assigns a technician.
3. The technician diagnoses the device and updates its progress.
4. An administrator records used spare parts, reducing inventory quantities.
5. Repair costs are calculated from labor and spare parts.
6. An administrator or receptionist creates an invoice and records payments.
7. The customer can track progress using the ticket number and registered phone.
8. Management reviews reports and technician performance.

## Functional requirements implemented

- FR-01 User authentication and role authorization
- FR-02 Customer and device information management
- FR-03 Repair ticket generation
- FR-04 Technician assignment
- FR-05 Repair status tracking and history
- FR-06 Inventory and parts consumption
- FR-07 Invoice and payment management
- FR-08 Customer notification records
- FR-09 Public repair tracking
- FR-10 Reports and dashboard analytics
- FR-11 User and system-setting administration
- FR-12 Activity logging

## Non-functional design considerations

- **Security:** Password hashing, prepared statements, CSRF tokens, session controls, escaping, and permissions.
- **Usability:** Responsive navigation, consistent forms, status badges, validation feedback, and printable records.
- **Maintainability:** Modular folders, centralized helpers, shared layouts, and relational schema.
- **Reliability:** Database transactions for stock consumption and payments.
- **Performance:** Indexed ticket, status, technician, customer, payment-date, and history fields.
- **Scalability:** Separated application modules and normalized core entities.

## Current prototype limitations

- Email defaults to a database log rather than external SMTP delivery.
- The application uses CDN-hosted front-end libraries.
- Pagination is not required for the demonstration dataset and can be added for large installations.
- No online payment gateway is included, consistent with the project scope.
- No multi-branch support or supplier integration is included.
