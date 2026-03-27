# Constants: HR Application

All constants use the `HR_` prefix.

## Department Lists

| Constant | Type | Value |
|----------|------|-------|
| `cons!HR_DEPARTMENT_LABELS` | List of Text | `{"Engineering", "Product", "Design", "Marketing", "Sales", "Finance", "HR", "Legal", "Operations"}` |
| `cons!HR_DEPARTMENT_VALUES` | List of Text | `{"ENG", "PROD", "DES", "MKT", "SAL", "FIN", "HR", "LEG", "OPS"}` |

## Status Values

| Constant | Type | Value |
|----------|------|-------|
| `cons!HR_STATUS_ACTIVE` | Text | `"ACTIVE"` |
| `cons!HR_STATUS_INACTIVE` | Text | `"INACTIVE"` |
| `cons!HR_STATUS_LABELS` | List of Text | `{"Active", "Inactive"}` |
| `cons!HR_STATUS_VALUES` | List of Text | `{"ACTIVE", "INACTIVE"}` |

## Employment Types

| Constant | Type | Value |
|----------|------|-------|
| `cons!HR_EMPLOYMENT_TYPE_LABELS` | List of Text | `{"Full-Time", "Part-Time", "Contractor", "Intern"}` |
| `cons!HR_EMPLOYMENT_TYPE_VALUES` | List of Text | `{"FT", "PT", "CTR", "INT"}` |

## Connected Systems

| Constant | Type | Description |
|----------|------|-------------|
| `cons!HR_IDENTITY_PROVIDER_CS` | Connected System | Okta/Azure AD identity provider |
| `cons!HR_SLACK_WEBHOOK_CS` | Connected System | Slack incoming webhook |

## Data Store Entities

| Constant | Type | Description |
|----------|------|-------------|
| `cons!HR_EMPLOYEE_ENTITY` | Data Store Entity | `hr_employees` table |

## Pagination

| Constant | Type | Value |
|----------|------|-------|
| `cons!HR_DEFAULT_BATCH_SIZE` | Integer | `25` |
| `cons!HR_MAX_BATCH_SIZE` | Integer | `100` |
