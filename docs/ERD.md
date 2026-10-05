# Entity Relationship Diagram

The following Mermaid diagram documents the database relationships.

```mermaid
erDiagram
    USERS ||--o{ REPAIRS : assigned_to
    USERS ||--o{ REPAIRS : creates
    USERS ||--o{ REPAIR_STATUS_HISTORY : changes
    USERS ||--o{ INVOICES : creates
    USERS ||--o{ PAYMENTS : receives
    USERS ||--o{ ACTIVITY_LOGS : performs
    CUSTOMERS ||--o{ DEVICES : owns
    CUSTOMERS ||--o{ REPAIRS : requests
    CUSTOMERS ||--o{ NOTIFICATIONS : receives
    DEVICES ||--o{ REPAIRS : submitted_for
    REPAIRS ||--o{ REPAIR_STATUS_HISTORY : records
    REPAIRS ||--o{ REPAIR_PARTS : uses
    INVENTORY ||--o{ REPAIR_PARTS : supplies
    REPAIRS ||--o| INVOICES : billed_by
    INVOICES ||--o{ PAYMENTS : receives
    REPAIRS ||--o{ NOTIFICATIONS : triggers
```

## Main entity purpose

- **users**: Administrator, receptionist, and technician accounts.
- **customers**: Customer identity and contact information.
- **devices**: Customer-owned phones submitted for repair.
- **repairs**: Repair tickets and the current workflow state.
- **repair_status_history**: Audit trail of repair progress.
- **inventory**: Spare-parts stock and pricing.
- **repair_parts**: Parts consumed by each repair.
- **invoices**: One invoice per repair.
- **payments**: One or more payments against an invoice.
- **notifications**: Customer communication records.
- **settings**: Repair-center configuration.
- **activity_logs**: Security and operational audit trail.
