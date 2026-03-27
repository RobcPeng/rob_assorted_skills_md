# Record Type: Employee

**Object:** `recordType!Employee`
**Source:** Database table `hr_employees`

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer (PK) | Auto-generated employee ID |
| `firstName` | Text | First name |
| `lastName` | Text | Last name |
| `email` | Text | Work email address |
| `phone` | Text | Phone number (optional) |
| `jobTitle` | Text | Current job title |
| `department` | Text | Department code |
| `status` | Text | `ACTIVE` or `INACTIVE` |
| `startDate` | Date | Employment start date |
| `endDate` | Date | Employment end date (nullable) |
| `managerId` | Integer (FK) | References `hr_employees.id` |
| `notes` | Text | Free-text notes (optional) |
| `createdDate` | DateTime | Record creation timestamp |
| `modifiedDate` | DateTime | Last modification timestamp |

## Relationships

| Relationship | Type | Target | Join |
|-------------|------|--------|------|
| `manager` | Many-to-One | `recordType!Employee` | `managerId` = `id` |
| `directReports` | One-to-Many | `recordType!Employee` | `id` = `managerId` |

## Custom Record Fields

| Field | Expression | Description |
|-------|-----------|-------------|
| `fullName` | `a!customFieldValue(recordType!Employee.fields.firstName) & " " & a!customFieldValue(recordType!Employee.fields.lastName)` | Concatenated full name |
| `tenureDays` | `a!customFieldDifference(today(), recordType!Employee.fields.startDate, "DAY")` | Days since start |

## Record Actions

| Action | Type | Interface |
|--------|------|-----------|
| Create Employee | Record Action | `HR_employeeForm` |
| Edit Employee | Record Action | `HR_employeeForm` (with existing record) |
| Onboard Employee | Related Action | `HR_wizardOnboarding` |

## Record Views

| View | Interface | Description |
|------|-----------|-------------|
| Summary | `HR_recordSummary` | Header with key details |
| Team | `HR_directReportsGrid` | Manager's direct reports |
| History | `HR_employeeHistory` | Audit trail of changes |
