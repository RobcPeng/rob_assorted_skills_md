# Appian Interfaces Reference

## Interface Types

Appian interfaces serve different purposes. Each is its own design object.

| Interface Type | Top-Level Layout | Used For |
|---------------|-----------------|----------|
| Start Form | `a!formLayout()` | Starting a process from a record action or site |
| Task Form | `a!formLayout()` | User task in a process model |
| Record Summary | `a!headerContentLayout()` | Record view (summary dashboard) |
| Record View | `a!sectionLayout()` or `a!columnsLayout()` | Tab within a record |
| Report/Dashboard | `a!headerContentLayout()` | Standalone report page |
| Action Dialog | `a!formLayout()` | Quick action inside a record |

---

## Form Layout (Start Forms & Task Forms)

```
a!localVariables(
  local!employee: ri!employee,
  local!isNew: a!isNullOrEmpty(ri!employee),
  a!formLayout(
    label: if(local!isNew, "New Employee", "Edit Employee"),
    instructions: "Complete all required fields.",
    contents: {
      a!sectionLayout(
        label: "Personal Information",
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!textField(
                    label: "First Name",
                    value: local!employee.firstName,
                    saveInto: local!employee.firstName,
                    required: true,
                    characterLimit: 255
                  ),
                  a!textField(
                    label: "Last Name",
                    value: local!employee.lastName,
                    saveInto: local!employee.lastName,
                    required: true
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!textField(
                    label: "Email",
                    value: local!employee.email,
                    saveInto: local!employee.email,
                    required: true,
                    validations: if(
                      and(
                        a!isNotNullOrEmpty(local!employee.email),
                        not(like(local!employee.email, "%@%.%"))
                      ),
                      "Enter a valid email address",
                      {}
                    )
                  ),
                  a!dateField(
                    label: "Start Date",
                    value: local!employee.startDate,
                    saveInto: local!employee.startDate,
                    required: true
                  )
                }
              )
            }
          )
        }
      ),
      a!sectionLayout(
        label: "Department",
        contents: {
          a!dropdownField(
            label: "Department",
            placeholder: "-- Select --",
            choiceLabels: cons!APP_DEPARTMENT_LABELS,
            choiceValues: cons!APP_DEPARTMENT_VALUES,
            value: local!employee.department,
            saveInto: local!employee.department,
            required: true
          )
        }
      )
    },
    buttons: a!buttonLayout(
      primaryButtons: {
        a!buttonWidget(
          label: "Submit",
          submit: true,
          style: "SOLID",
          color: "ACCENT",
          validate: true,
          saveInto: {
            a!save(ri!employee, local!employee)
          }
        )
      },
      secondaryButtons: {
        a!buttonWidget(
          label: "Cancel",
          submit: true,
          style: "OUTLINE",
          validate: false
        )
      }
    )
  )
)
```

---

## Read-Only Grid (a!gridField)

```
a!localVariables(
  a!gridField(
    label: "Active Employees",
    labelPosition: "ABOVE",
    data: recordType!Employee,
    columns: {
      a!gridColumn(
        label: "Name",
        sortField: recordType!Employee.fields.lastName,
        value: a!linkField(
          links: a!recordLink(
            label: fv!row[recordType!Employee.fields.firstName] & " " & fv!row[recordType!Employee.fields.lastName],
            recordType: recordType!Employee,
            identifier: fv!identifier
          )
        )
      ),
      a!gridColumn(
        label: "Department",
        sortField: recordType!Employee.fields.department,
        value: fv!row[recordType!Employee.fields.department]
      ),
      a!gridColumn(
        label: "Start Date",
        sortField: recordType!Employee.fields.startDate,
        value: datetext(fv!row[recordType!Employee.fields.startDate], "MM/dd/yyyy"),
        width: "NARROW"
      ),
      a!gridColumn(
        label: "Salary",
        sortField: recordType!Employee.fields.salary,
        value: a!currency(amount: fv!row[recordType!Employee.fields.salary]),
        align: "END",
        width: "NARROW"
      )
    },
    pageSize: 25,
    initialSorts: { a!sortInfo(field: recordType!Employee.fields.lastName, ascending: true) },
    showSearchBox: true,
    showRefreshButton: true,
    borderStyle: "LIGHT",
    shadeAlternateRows: true,
    rowHeader: 1
  )
)
```

---

## Editable Grid (a!gridLayout)

```
a!localVariables(
  local!items: ri!lineItems,
  a!gridLayout(
    label: "Line Items",
    headerCells: {
      a!gridLayoutHeaderCell(label: "Description"),
      a!gridLayoutHeaderCell(label: "Quantity", align: "END"),
      a!gridLayoutHeaderCell(label: "Unit Price", align: "END"),
      a!gridLayoutHeaderCell(label: "Total", align: "END"),
      a!gridLayoutHeaderCell(label: "", width: "ICON")
    },
    rows: a!forEach(
      items: local!items,
      expression: a!gridRowLayout(
        contents: {
          a!textField(
            value: fv!item.description,
            saveInto: local!items[fv!index].description,
            required: true
          ),
          a!integerField(
            value: fv!item.quantity,
            saveInto: local!items[fv!index].quantity,
            required: true,
            align: "END"
          ),
          a!floatingPointField(
            value: fv!item.unitPrice,
            saveInto: local!items[fv!index].unitPrice,
            required: true,
            align: "END"
          ),
          a!richTextDisplayField(
            value: a!richTextItem(
              text: a!currency(amount: fv!item.quantity * fv!item.unitPrice)
            ),
            align: "END"
          ),
          a!richTextDisplayField(
            value: a!richTextIcon(
              icon: "times",
              link: a!dynamicLink(
                saveInto: a!save(local!items, remove(local!items, fv!index))
              ),
              linkStyle: "STANDALONE",
              color: "NEGATIVE"
            )
          )
        }
      )
    ),
    addRowLink: a!dynamicLink(
      label: "Add Line Item",
      saveInto: a!save(
        local!items,
        append(local!items, a!map(description: "", quantity: 1, unitPrice: 0))
      )
    ),
    totalCount: length(local!items),
    rowHeader: 1
  )
)
```

---

## Record Summary View

```
a!localVariables(
  local!record: rv!record,
  a!headerContentLayout(
    header: {
      a!headerTemplateFull(
        title: local!record[recordType!Employee.fields.firstName] & " " & local!record[recordType!Employee.fields.lastName],
        subtitle: local!record[recordType!Employee.fields.department]
      )
    },
    contents: {
      a!columnsLayout(
        columns: {
          a!columnLayout(
            width: "MEDIUM",
            contents: {
              a!sectionLayout(
                label: "Details",
                contents: {
                  a!sideBySideLayout(
                    items: {
                      a!sideBySideItem(
                        item: a!textField(label: "Email", value: local!record[recordType!Employee.fields.email], readOnly: true)
                      ),
                      a!sideBySideItem(
                        item: a!textField(label: "Phone", value: local!record[recordType!Employee.fields.phone], readOnly: true)
                      )
                    }
                  )
                }
              )
            }
          ),
          a!columnLayout(
            width: "NARROW",
            contents: {
              a!sectionLayout(
                label: "Quick Facts",
                contents: {
                  a!kpiField(label: "Years", value: year(today()) - year(local!record[recordType!Employee.fields.startDate])),
                  a!stampField(
                    label: "Status",
                    text: local!record[recordType!Employee.fields.status],
                    backgroundColor: if(
                      local!record[recordType!Employee.fields.status] = "Active",
                      "POSITIVE",
                      "NEGATIVE"
                    )
                  )
                }
              )
            }
          )
        }
      )
    }
  )
)
```

---

## Common Input Components

### Text Input
```
a!textField(label: "Name", value: local!name, saveInto: local!name, required: true, characterLimit: 255, placeholder: "Enter name")
```

### Paragraph (Multi-line)
```
a!paragraphField(label: "Description", value: local!desc, saveInto: local!desc, height: "MEDIUM", characterLimit: 4000)
```

### Integer
```
a!integerField(label: "Count", value: local!count, saveInto: local!count)
```

### Decimal / Currency
```
a!floatingPointField(label: "Amount", value: local!amount, saveInto: local!amount)
```

### Date
```
a!dateField(label: "Start Date", value: local!date, saveInto: local!date, required: true)
```

### DateTime
```
a!dateTimeField(label: "Created", value: local!createdAt, saveInto: local!createdAt)
```

### Dropdown
```
a!dropdownField(
  label: "Status",
  placeholder: "-- Select --",
  choiceLabels: {"Active", "Inactive", "Pending"},
  choiceValues: {"ACTIVE", "INACTIVE", "PENDING"},
  value: local!status,
  saveInto: local!status,
  required: true
)
```

### Multiple Dropdown
```
a!multipleDropdownField(
  label: "Tags",
  choiceLabels: cons!APP_TAG_LABELS,
  choiceValues: cons!APP_TAG_VALUES,
  value: local!tags,
  saveInto: local!tags
)
```

### Checkbox
```
a!checkboxField(
  label: "Permissions",
  choiceLabels: {"Read", "Write", "Admin"},
  choiceValues: {"READ", "WRITE", "ADMIN"},
  value: local!permissions,
  saveInto: local!permissions
)
```

### Radio Button
```
a!radioButtonField(
  label: "Priority",
  choiceLabels: {"High", "Medium", "Low"},
  choiceValues: {1, 2, 3},
  value: local!priority,
  saveInto: local!priority,
  required: true
)
```

### Toggle
```
a!toggleField(
  label: "Active",
  value: local!isActive,
  saveInto: local!isActive
)
```

### File Upload
```
a!fileUploadField(
  label: "Attachments",
  value: local!files,
  saveInto: local!files,
  maxSelections: 5,
  maxFileSize: 25
)
```

### Picker (Record)
```
a!pickerFieldRecords(
  label: "Select Employee",
  recordType: recordType!Employee,
  value: local!selectedEmployee,
  saveInto: local!selectedEmployee
)
```

### Picker (Users)
```
a!pickerFieldUsers(
  label: "Assigned To",
  value: local!assignee,
  saveInto: local!assignee
)
```

---

## Visibility & Validation

### Show/Hide Components
```
a!textField(
  label: "Manager Name",
  value: local!managerName,
  saveInto: local!managerName,
  showWhen: local!isManager
)
```

### Validation Messages
```
a!textField(
  label: "Email",
  value: local!email,
  saveInto: local!email,
  required: true,
  validations: if(
    and(
      a!isNotNullOrEmpty(local!email),
      not(like(local!email, "%@%.%"))
    ),
    "Enter a valid email address",
    {}
  )
)
```

### Cross-field Validation
```
a!dateField(
  label: "End Date",
  value: local!endDate,
  saveInto: local!endDate,
  validations: if(
    and(
      a!isNotNullOrEmpty(local!endDate),
      a!isNotNullOrEmpty(local!startDate),
      local!endDate < local!startDate
    ),
    "End date must be after start date",
    {}
  )
)
```

---

## Charts

### Pie Chart
```
a!pieChartField(
  label: "By Department",
  data: recordType!Employee,
  config: a!pieChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Employee.fields.department,
      alias: "dept"
    ),
    measure: a!measure(
      function: "COUNT",
      alias: "count"
    ),
    seriesLabelStyle: "LEGEND"  /* NOT showLegend */
  )
)
```

### Bar Chart
```
a!barChartField(
  label: "Employees by Department",
  data: recordType!Employee,
  config: a!barChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Employee.fields.department,
      alias: "dept"
    ),
    measure: a!measure(
      function: "COUNT",
      alias: "count"
    )
  ),
  stacking: "NONE",
  showLegend: true
)
```

### Line Chart
```
a!lineChartField(
  label: "Monthly Trend",
  data: recordType!Order,
  config: a!lineChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Order.fields.orderDate,
      alias: "month",
      interval: "MONTH"
    ),
    measure: a!measure(
      field: recordType!Order.fields.total,
      function: "SUM",
      alias: "revenue"
    )
  )
)
```

---

## Confirmation Dialog Pattern

```
a!localVariables(
  local!showDeleteConfirm: false,
  {
    a!buttonWidget(
      label: "Delete",
      style: "GHOST",
      color: "NEGATIVE",
      saveInto: a!save(local!showDeleteConfirm, true)
    ),
    if(
      local!showDeleteConfirm,
      a!boxLayout(
        style: "WARN",
        contents: {
          a!richTextDisplayField(
            value: a!richTextItem(text: "Are you sure? This cannot be undone.")
          ),
          a!buttonArrayLayout(
            buttons: {
              a!buttonWidget(
                label: "Confirm Delete",
                style: "SOLID",
                color: "NEGATIVE",
                saveInto: {
                  a!deleteRecords(records: local!selectedRecord),
                  a!save(local!showDeleteConfirm, false)
                }
              ),
              a!buttonWidget(
                label: "Cancel",
                style: "OUTLINE",
                saveInto: a!save(local!showDeleteConfirm, false)
              )
            }
          )
        }
      ),
      {}
    )
  }
)
```

---

## KPI / Metrics Display

```
a!columnsLayout(
  columns: {
    a!columnLayout(
      contents: {
        a!kpiField(
          label: "Total Orders",
          value: local!totalOrders,
          icon: "shopping-cart"
        )
      }
    ),
    a!columnLayout(
      contents: {
        a!kpiField(
          label: "Revenue",
          value: a!currency(amount: local!totalRevenue),
          icon: "dollar",
          trend: local!revenueTrend,
          trendColor: if(local!revenueTrend > 0, "POSITIVE", "NEGATIVE")
        )
      }
    ),
    a!columnLayout(
      contents: {
        a!gaugeField(
          label: "Completion",
          percentage: local!completionPct,
          primaryText: a!gaugePercentage()
        )
      }
    )
  }
)
```

---

## Milestone Field
```
a!milestoneField(
  label: "Process Status",
  steps: {"Submitted", "In Review", "Approved", "Complete"},
  active: local!currentStep,
  completed: enumerate(local!currentStep - 1) + 1
)
```

**Note:** Use `a!milestoneField()` — there is NO `a!milestoneStep()` function.

---

## Message Banner
```
a!messageBanner(
  message: "Changes saved successfully.",
  type: "SUCCESS",
  showWhen: local!showSuccess
)
```
Types: `"SUCCESS"`, `"WARNING"`, `"ERROR"`, `"INFO"`
