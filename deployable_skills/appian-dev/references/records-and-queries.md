# Records & Queries Reference

## Record Types

Record types are the primary data model in Appian. They define:
- **Fields** — data columns from the source (database, process, Salesforce, etc.)
- **Relationships** — links to other record types (1:1, 1:many, many:many)
- **Record actions** — create, update, delete actions
- **Record views** — UI tabs displayed on the record
- **Record events** — feed of activities
- **Custom record fields** — computed fields using `a!customField*()` functions

### Referencing Record Type Fields
```
recordType!Employee                                    /* the record type */
recordType!Employee.fields.firstName                   /* a field */
recordType!Employee.fields.department                  /* another field */
recordType!Employee.relationships.manager              /* a relationship */
recordType!Employee.relationships.manager.fields.name  /* field through relationship */
```

### Record Variables (rv!)
Inside record views and record actions:
```
rv!record                                              /* the current record */
rv!record[recordType!Employee.fields.firstName]        /* field value */
rv!identifier                                          /* record identifier */
```

---

## Querying Data

### a!queryRecordType() — Preferred for Record Types
```
a!queryRecordType(
  recordType: recordType!Employee,
  fields: {
    recordType!Employee.fields.id,
    recordType!Employee.fields.firstName,
    recordType!Employee.fields.lastName,
    recordType!Employee.fields.department,
    recordType!Employee.relationships.manager.fields.name
  },
  filters: a!queryLogicalExpression(
    operator: "AND",
    filters: {
      a!queryFilter(
        field: recordType!Employee.fields.department,
        operator: "=",
        value: ri!department
      ),
      a!queryFilter(
        field: recordType!Employee.fields.status,
        operator: "=",
        value: "ACTIVE"
      )
    },
    ignoreFiltersWithEmptyValues: true
  ),
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 50,
    sort: a!sortInfo(
      field: recordType!Employee.fields.lastName,
      ascending: true
    )
  )
)
```

**Result structure:**
- `.data` — list of records
- `.startIndex`, `.batchSize`, `.totalCount` — paging info

### a!queryEntity() — For Data Store Entities
```
a!queryEntity(
  entity: cons!EMPLOYEE_ENTITY,
  query: a!query(
    selection: a!querySelection(
      columns: {
        a!queryColumn(field: "id"),
        a!queryColumn(field: "firstName"),
        a!queryColumn(field: "lastName"),
        a!queryColumn(field: "status")
      }
    ),
    logicalExpression: a!queryLogicalExpression(
      operator: "AND",
      filters: {
        a!queryFilter(field: "status", operator: "=", value: "ACTIVE"),
        a!queryFilter(field: "createdDate", operator: ">=", value: date(2024, 1, 1))
      },
      ignoreFiltersWithEmptyValues: true
    ),
    pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 25)
  ),
  fetchTotalCount: false
)
```

### a!queryRecordByIdentifier() — Single Record
```
a!queryRecordByIdentifier(
  recordType: recordType!Employee,
  identifier: ri!employeeId,
  fields: {
    recordType!Employee.fields.firstName,
    recordType!Employee.fields.lastName,
    recordType!Employee.fields.email
  }
)
```

---

## Query Filters

### Supported Operators
| Operator | Description |
|----------|-------------|
| `"="` | Equals |
| `"!="` | Not equals |
| `"<"` | Less than |
| `"<="` | Less than or equal |
| `">"` | Greater than |
| `">="` | Greater than or equal |
| `"in"` | In list |
| `"not in"` | Not in list |
| `"is null"` | Is null (no value param needed) |
| `"is not null"` | Is not null (no value param needed) |
| `"starts with"` | Starts with text |
| `"not starts with"` | Does not start with |
| `"includes"` | Contains text |
| `"not includes"` | Does not contain |
| `"between"` | Between two values |

### Complex Filter Patterns

#### OR within AND
```
a!queryLogicalExpression(
  operator: "AND",
  filters: {
    a!queryFilter(field: recordType!Order.fields.status, operator: "=", value: "OPEN")
  },
  logicalExpressions: {
    a!queryLogicalExpression(
      operator: "OR",
      filters: {
        a!queryFilter(field: recordType!Order.fields.region, operator: "=", value: "EAST"),
        a!queryFilter(field: recordType!Order.fields.region, operator: "=", value: "WEST")
      }
    )
  },
  ignoreFiltersWithEmptyValues: true
)
```

#### Dynamic Search Filters
```
a!localVariables(
  local!searchName: "",
  local!filterDept: null,
  local!filterStatus: null,

  a!queryRecordType(
    recordType: recordType!Employee,
    filters: a!queryLogicalExpression(
      operator: "AND",
      filters: {
        a!queryFilter(
          field: recordType!Employee.fields.lastName,
          operator: "starts with",
          value: local!searchName
        ),
        a!queryFilter(
          field: recordType!Employee.fields.department,
          operator: "=",
          value: local!filterDept
        ),
        a!queryFilter(
          field: recordType!Employee.fields.status,
          operator: "=",
          value: local!filterStatus
        )
      },
      ignoreFiltersWithEmptyValues: true  /* CRITICAL for search forms */
    ),
    pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 25)
  )
)
```

---

## Aggregation Queries

### Count by Group
```
a!queryRecordType(
  recordType: recordType!Employee,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: recordType!Employee.fields.department, alias: "dept")
    },
    measures: {
      a!measure(function: "COUNT", alias: "count")
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
)
```

### Sum with Date Grouping
```
a!queryRecordType(
  recordType: recordType!Order,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: recordType!Order.fields.orderDate,
        alias: "month",
        interval: "MONTH"
      )
    },
    measures: {
      a!measure(
        field: recordType!Order.fields.totalAmount,
        function: "SUM",
        alias: "revenue"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 12)
)
```

### Multiple Measures
```
a!queryRecordType(
  recordType: recordType!Order,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: recordType!Order.fields.status, alias: "status")
    },
    measures: {
      a!measure(function: "COUNT", alias: "orderCount"),
      a!measure(field: recordType!Order.fields.totalAmount, function: "SUM", alias: "totalValue"),
      a!measure(field: recordType!Order.fields.totalAmount, function: "AVG", alias: "avgValue")
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
)
```

### Aggregation with a!queryEntity
```
a!queryEntity(
  entity: cons!ORDER_ENTITY,
  query: a!query(
    aggregation: a!queryAggregation(
      groupings: {
        a!queryGrouping(field: "department", alias: "dept")
      },
      measures: {
        a!queryAggregationColumn(
          field: "id",
          alias: "count",
          aggregationFunction: "COUNT"
        )
      }
    ),
    pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
  )
)
```

---

## Writing Data

### a!writeRecords() — Write to Record Type
```
a!buttonWidget(
  label: "Save",
  style: "SOLID",
  color: "ACCENT",
  submit: true,
  saveInto: {
    a!writeRecords(
      records: local!employee,
      onSuccess: {
        a!save(local!saved, true)
      },
      onError: {
        a!save(local!errorMsg, "Save failed")
      }
    )
  }
)
```

### a!deleteRecords()
```
a!deleteRecords(
  records: local!selectedRecords,
  onSuccess: {
    a!save(local!selectedRecords, {})
  },
  onError: {
    a!save(local!errorMsg, "Delete failed")
  }
)
```

### a!writeToDataStoreEntity() — Legacy
```
a!writeToDataStoreEntity(
  dataStoreEntity: cons!EMPLOYEE_ENTITY,
  valueToStore: local!employee,
  onSuccess: a!save(local!saved, true),
  onError: a!save(local!errorMsg, "Write failed")
)
```

---

## Record Data in Grids

### Using `recordData` for Grid Source
```
a!gridField(
  data: recordType!Employee,
  columns: {
    a!gridColumn(
      label: "Name",
      sortField: recordType!Employee.fields.lastName,
      value: fv!row[recordType!Employee.fields.firstName] & " " & fv!row[recordType!Employee.fields.lastName]
    )
  },
  userFilters: {
    a!recordFilterList(
      name: "Department",
      field: recordType!Employee.fields.department,
      options: a!recordFilterListOption(
        filter: a!queryFilter(
          field: recordType!Employee.fields.department,
          operator: "=",
          value: fv!options.value
        )
      ),
      isVisible: true
    )
  }
)
```

### Related Record Data
```
a!gridField(
  data: a!recordData(
    recordType: recordType!Order,
    filters: a!queryFilter(
      field: recordType!Order.fields.customerId,
      operator: "=",
      value: rv!identifier
    )
  ),
  columns: { /* ... */ }
)
```

---

## Custom Record Fields

Used for computed fields on record types (evaluated at sync time):
```
a!customFieldSum(
  value: recordType!OrderLine.fields.quantity * recordType!OrderLine.fields.unitPrice
)

a!customFieldConcat(
  value: {
    recordType!Employee.fields.firstName,
    " ",
    recordType!Employee.fields.lastName
  }
)

a!customFieldCondition(
  condition: a!customFieldLogicalExpression(
    operator: "AND",
    filters: {
      a!queryFilter(
        field: recordType!Order.fields.total,
        operator: ">",
        value: 1000
      )
    }
  ),
  valueIfTrue: "High Value",
  valueIfFalse: "Standard"
)
```

---

## Best Practices

1. **Always page queries** — never `batchSize: -1` in production
2. **Use `ignoreFiltersWithEmptyValues: true`** on search/filter forms
3. **Prefer `a!queryRecordType()`** over `a!queryEntity()` for record-type data
4. **Use `fetchTotalCount: false`** on `a!queryEntity()` unless pagination needs it
5. **Select only needed fields** — don't query `*`
6. **Use record type relationships** instead of multiple separate queries
7. **Cache with `a!localVariables()`** — identical `a!queryRecordType()` calls auto-deduplicate
8. **Use `a!relatedRecordData()`** to fetch related records in a single query
