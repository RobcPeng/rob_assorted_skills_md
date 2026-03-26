# Expression Rules Reference

## What Are Expression Rules?

Expression rules are reusable, named expressions stored as Appian design objects. They accept typed inputs (`ri!`) and return a value. Think of them as pure functions — no side effects.

---

## Structure

Each expression rule is its own file/object with:
- **Name**: `rule!APP_PREFIX_descriptiveName` (e.g., `rule!APP_getActiveEmployees`)
- **Description**: What it does, inputs, return type
- **Rule Inputs** (`ri!`): Typed parameters
- **Expression body**: The logic

```
/* Rule: rule!APP_getActiveEmployees */
/* Inputs: ri!department (Text), ri!activeOnly (Boolean) */
/* Returns: List of Employee records */

a!localVariables(
  local!filters: {
    a!queryFilter(
      field: recordType!Employee.fields.department,
      operator: "=",
      value: ri!department
    ),
    if(
      ri!activeOnly,
      a!queryFilter(
        field: recordType!Employee.fields.status,
        operator: "=",
        value: "ACTIVE"
      ),
      {}
    )
  },
  a!queryRecordType(
    recordType: recordType!Employee,
    filters: a!queryLogicalExpression(
      operator: "AND",
      filters: local!filters,
      ignoreFiltersWithEmptyValues: true
    ),
    pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
  ).data
)
```

---

## Calling Expression Rules

```
/* Simple call */
rule!APP_getActiveEmployees(
  department: "Engineering",
  activeOnly: true
)

/* In an interface */
a!localVariables(
  local!employees: rule!APP_getActiveEmployees(
    department: ri!department,
    activeOnly: true
  ),
  a!gridField(
    data: local!employees,
    columns: { /* ... */ }
  )
)
```

---

## Naming Conventions

| Pattern | Example | Use Case |
|---------|---------|----------|
| `APP_get*` | `rule!APP_getEmployeeById` | Retrieve/query data |
| `APP_format*` | `rule!APP_formatCurrency` | Format display values |
| `APP_validate*` | `rule!APP_validateEmail` | Validation logic |
| `APP_calculate*` | `rule!APP_calculateDiscount` | Business calculations |
| `APP_is*` / `APP_has*` | `rule!APP_isManager` | Boolean checks |
| `APP_build*` | `rule!APP_buildFilterExpression` | Construct complex objects |
| `APP_display*` | `rule!APP_displayEmployeeCard` | Reusable UI component |

**APP** = your application prefix (2-4 uppercase letters).

---

## Common Rule Patterns

### Data Retrieval Rule
```
/* rule!APP_getEmployeeById */
/* ri!employeeId (Integer) */

a!queryRecordByIdentifier(
  recordType: recordType!Employee,
  identifier: ri!employeeId,
  fields: {
    recordType!Employee.fields.firstName,
    recordType!Employee.fields.lastName,
    recordType!Employee.fields.email,
    recordType!Employee.fields.department
  }
)
```

### Formatting Rule
```
/* rule!APP_formatFullName */
/* ri!firstName (Text), ri!lastName (Text) */

if(
  and(a!isNotNullOrEmpty(ri!firstName), a!isNotNullOrEmpty(ri!lastName)),
  ri!lastName & ", " & ri!firstName,
  a!defaultValue(ri!lastName, ri!firstName)
)
```

### Validation Rule
```
/* rule!APP_validateEmail */
/* ri!email (Text) */
/* Returns: Text (error message or empty) */

if(
  or(
    a!isNullOrEmpty(ri!email),
    like(ri!email, "%@%.%")
  ),
  "",
  "Please enter a valid email address"
)
```

### Boolean Check Rule
```
/* rule!APP_isManager */
/* ri!userId (User) */

a!isUserMemberOfGroup(
  username: ri!userId,
  groups: cons!APP_MANAGERS_GROUP
)
```

### Calculation Rule
```
/* rule!APP_calculateOrderTotal */
/* ri!lineItems (List of Map) */
/* ri!taxRate (Decimal) */

a!localVariables(
  local!subtotal: sum(
    a!forEach(
      items: ri!lineItems,
      expression: fv!item.quantity * fv!item.unitPrice
    )
  ),
  local!tax: local!subtotal * a!defaultValue(ri!taxRate, 0),
  a!map(
    subtotal: local!subtotal,
    tax: local!tax,
    total: local!subtotal + local!tax
  )
)
```

### Reusable UI Component Rule
```
/* rule!APP_displayStatusBadge */
/* ri!status (Text) */

a!stampField(
  text: ri!status,
  backgroundColor: choose(
    wherecontains(
      ri!status,
      {"Active", "Pending", "Inactive", "Cancelled"}
    ),
    "POSITIVE",
    "WARN",
    "SECONDARY",
    "NEGATIVE"
  ),
  size: "SMALL"
)
```

---

## Rule Inputs (ri!)

### Types
| Type | Description |
|------|-------------|
| Text | String value |
| Integer | Whole number |
| Decimal | Floating point |
| Boolean | true/false |
| Date | Date only |
| DateTime | Date and time |
| User | User reference |
| Group | Group reference |
| Document | Document reference |
| Record Type | Record type reference |
| CDT | Custom data type |
| List of [Type] | Array of any type |

### Optional vs Required
- Provide `a!defaultValue()` for optional inputs
- Document which inputs are required in the rule description

---

## Testing Expression Rules

Appian supports expression rule test cases:

```
/* Test case for rule!APP_formatFullName */
/* Input: ri!firstName = "John", ri!lastName = "Doe" */
/* Expected: "Doe, John" */

/* Test case for null handling */
/* Input: ri!firstName = null, ri!lastName = "Doe" */
/* Expected: "Doe" */
```

Use `a!startRuleTestsAll()` or `a!startRuleTestsApplications()` to run tests programmatically.

---

## Best Practices

1. **Single responsibility** — each rule does one thing
2. **Descriptive names** with app prefix — `rule!APP_calculateTax`, not `rule!calc`
3. **Document rule inputs** — types, required/optional, expected values
4. **Return consistent types** — don't return Text sometimes and Integer other times
5. **Use `a!defaultValue()`** for optional inputs instead of null checks
6. **Avoid side effects** — expression rules should be pure functions
7. **Keep rules small** — if it's > 100 lines, split it up
8. **Test edge cases** — null inputs, empty lists, boundary values
9. **Use constants (`cons!`)** — never hardcode group names, entity references, or magic values
10. **Compose rules** — call other rules instead of duplicating logic
