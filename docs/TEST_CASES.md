# System Test Cases

| ID | Module | Test | Expected result |
|---|---|---|---|
| TC-01 | Authentication | Sign in with valid administrator details | Administrator dashboard is displayed |
| TC-02 | Authentication | Sign in with an invalid password | Access is rejected with an error message |
| TC-03 | Authorization | Technician opens User Management | Access is denied |
| TC-04 | Customers | Register a customer and device with valid details | Both records are saved and profile is displayed |
| TC-05 | Customers | Reuse an existing customer phone or device IMEI | Duplicate data is rejected |
| TC-06 | Repairs | Create a repair ticket | Unique ticket and initial history record are created |
| TC-07 | Repairs | Assign a technician | Ticket appears on the selected technician dashboard |
| TC-08 | Repairs | Technician opens another technician's ticket | Access is denied |
| TC-09 | Repair Status | Change status to Repairing | Repair, status history, and notification log are updated |
| TC-10 | Inventory | Add an available spare part to a repair | Repair parts cost increases and stock decreases |
| TC-11 | Inventory | Add more parts than available | Transaction is rejected and stock is unchanged |
| TC-12 | Invoice | Create an invoice from a repair | One invoice is created with calculated totals |
| TC-13 | Payment | Record a partial payment | Invoice becomes Partial and balance is reduced |
| TC-14 | Payment | Record the remaining payment | Invoice becomes Paid and balance reaches zero |
| TC-15 | Tracking | Search with matching ticket and phone | Customer sees current status and progress history |
| TC-16 | Tracking | Search with mismatched phone | Repair details remain private |
| TC-17 | Reports | Open reports after payment entries | Revenue and charts reflect database records |
| TC-18 | CSRF | Submit a modified form without a valid token | Request is rejected with HTTP 419 |
| TC-19 | Session | Sign out | Session ends and protected pages redirect to login |
| TC-20 | Print | Print invoice or repair ticket | Navigation is hidden and printable content is formatted |
