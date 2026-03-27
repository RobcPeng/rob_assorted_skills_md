# Appian Development Examples

Example Appian 26.2 objects for an HR Employee Management application.

## Structure

```
interfaces/
  HR_employeeForm.txt          Start/task form — create or edit employee
  HR_employeeGrid.txt          Searchable, filterable employee grid
  HR_employeeDashboard.txt     Executive KPI dashboard with charts
  HR_wizardOnboarding.txt      3-step onboarding wizard
  HR_recordSummary.txt         Employee record summary view

expression-rules/
  HR_getActiveEmployees.txt    Query active employees by department
  HR_formatCurrency.txt        Format numbers as USD
  HR_validateEmail.txt         Email validation with error messages
  HR_calculateTenure.txt       Human-readable tenure from start date
  HR_isManager.txt             Check if employee has direct reports

integrations/
  HR_getExternalUserProfile.txt  GET user from identity provider
  HR_postSlackNotification.txt   POST new hire announcement to Slack

record-types/
  HR_Employee.md               Employee record type definition

constants/
  HR_constants.md              Application constants reference
```

## Patterns Demonstrated

- **Form layout hierarchy**: `a!formLayout` > `a!sectionLayout` > `a!columnsLayout`
- **Multi-step wizard**: Milestone field with step tracking
- **Record summary view**: `a!headerContentLayout` with record variables
- **Searchable grid**: Filters with `ignoreFiltersWithEmptyValues`, pagination, export
- **KPI dashboard**: Aggregation queries, card layouts, conditional formatting
- **Expression rules**: Data retrieval, formatting, validation, boolean checks
- **Integration patterns**: GET/POST with error handling
- **Tag fields**: Status badges with conditional colors
- **Record links**: Navigation between records
