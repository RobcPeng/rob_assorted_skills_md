# Appian Functions Quick Reference

## Text Functions
| Function | Usage |
|----------|-------|
| `upper(text)` | Uppercase |
| `lower(text)` | Lowercase |
| `len(text)` | String length |
| `trim(text)` | Remove whitespace |
| `left(text, n)` | First n chars |
| `right(text, n)` | Last n chars |
| `mid(text, start, n)` | Substring |
| `substitute(text, old, new)` | Replace all occurrences |
| `split(text, delimiter)` | Split to list |
| `concat(text1, text2, ...)` | Concatenate texts |
| `joinarray(list, separator)` | Join list to string |
| `char(n)` | Character from code (10 = newline) |
| `like(text, pattern)` | Wildcard match (`%` = any) |
| `find(searchFor, text)` | Find position (1-based) |
| `proper(text)` | Title Case |
| `rept(text, n)` | Repeat text n times |
| `stripHtml(text)` | Remove HTML tags |
| `a!isInText(text, search)` | Contains check |
| `a!startsWith(text, prefix)` | Starts with check |
| `a!endsWith(text, suffix)` | Ends with check |

## Math Functions
| Function | Usage |
|----------|-------|
| `sum(list)` | Sum array |
| `count(list)` | Count non-null |
| `average(list)` | Mean |
| `max(list)` | Maximum |
| `min(list)` | Minimum |
| `abs(n)` | Absolute value |
| `ceiling(n)` | Round up |
| `floor(n)` | Round down |
| `round(n, decimals)` | Round |
| `mod(n, divisor)` | Modulo |
| `power(base, exp)` | Exponent |
| `sqrt(n)` | Square root |
| `enumerate(n)` | List 0 to n-1 |
| `rand()` | Random 0-1 |

## Date/Time Functions
| Function | Usage |
|----------|-------|
| `today()` | Current date |
| `now()` | Current datetime |
| `date(y, m, d)` | Construct date |
| `datetime(y, m, d, h, mi, s)` | Construct datetime |
| `year(date)` | Extract year |
| `month(date)` | Extract month (1-12) |
| `day(date)` | Extract day |
| `hour(datetime)` | Extract hour |
| `minute(datetime)` | Extract minute |
| `eomonth(date, months)` | End of month |
| `edate(date, months)` | Add months |
| `networkdays(start, end)` | Business days |
| `datetext(date, "MM/dd/yyyy")` | Format date |
| `todate(text)` | Parse date |
| `a!addDateTime(date, years, months, days, hours, minutes)` | Add to date/time |
| `a!subtractDateTime(date1, date2, interval)` | Difference |

## Array / List Functions
| Function | Usage |
|----------|-------|
| `append(list, item)` | Add to end |
| `insert(list, item, index)` | Insert at position |
| `remove(list, index)` | Remove by index |
| `index(list, indexOrField, default)` | Get item/field |
| `length(list)` | Array length |
| `count(list)` | Count non-null items |
| `union(a, b)` | Combine unique values |
| `intersection(a, b)` | Common values |
| `difference(a, b)` | Items in a not in b |
| `contains(list, value)` | Check membership |
| `wherecontains(value, list)` | Index of item |
| `where(condition)` | Indices where true |
| `a!flatten(list)` | Flatten nested lists |
| `a!update(data, field, value)` | Update CDT field |
| `updatearray(list, index, value)` | Update at index |
| `reverse(list)` | Reverse list |
| `ldrop(list, n)` | Drop first n |
| `rdrop(list, n)` | Drop last n |
| `filter(predicate, list)` | Filter array |
| `distinct(list)` | Remove duplicates (via `union(list, list)`) |

## Type Conversion
| Function | Usage |
|----------|-------|
| `tostring(value)` | To text |
| `tointeger(value)` | To integer |
| `todecimal(value)` | To decimal |
| `todate(value)` | To date |
| `todatetime(value)` | To datetime |
| `toboolean(value)` | To boolean |
| `cast(type, value)` | Cast to CDT type |
| `a!fromJson(text)` | Parse JSON string |
| `a!toJson(value)` | Convert to JSON |

## Null Checking
| Function | Usage |
|----------|-------|
| `isnull(value)` | Is null |
| `a!isNullOrEmpty(value)` | Is null or empty (preferred) |
| `a!isNotNullOrEmpty(value)` | Is not null/empty (preferred) |
| `a!defaultValue(value, default)` | Coalesce |

## Logical Functions
| Function | Usage |
|----------|-------|
| `if(cond, trueVal, falseVal)` | Conditional |
| `and(...)` | All true |
| `or(...)` | Any true |
| `not(bool)` | Negate |
| `choose(index, ...)` | Select by index |
| `a!match(value, cond1, result1, ..., default)` | Pattern match |
| `a!isBetween(value, low, high)` | Range check |

## People Functions
| Function | Usage |
|----------|-------|
| `loggedInUser()` | Current user |
| `user(userValue, property)` | Get user property |
| `togroup(name)` | Group reference |
| `a!isUserMemberOfGroup(username, groups)` | Group check |
| `a!groupMembers(group, direct)` | List members |
| `getdistinctusers(list)` | Deduplicate users |

## Key System Functions (a! prefix)
| Function | Usage |
|----------|-------|
| `a!localVariables(...)` | Define local variables |
| `a!refreshVariable(value, refreshOnVarChange, ...)` | Variable with refresh config |
| `a!save(target, value)` | Save value to variable |
| `a!forEach(items, expression)` | Loop (`fv!item`, `fv!index`, `fv!isFirst`, `fv!isLast`) |
| `a!pagingInfo(startIndex, batchSize, sort)` | Paging config |
| `a!sortInfo(field, ascending)` | Sort config |
| `a!queryFilter(field, operator, value)` | Query filter |
| `a!queryLogicalExpression(operator, filters)` | AND/OR logic |
| `a!queryRecordType(recordType, fields, filters, pagingInfo)` | Query record type |
| `a!queryEntity(entity, query)` | Query data store entity |
| `a!queryRecordByIdentifier(recordType, identifier, fields)` | Single record |
| `a!map(key1: val1, key2: val2)` | Create map |
| `a!startProcess(processModel, processParameters, onSuccess, onError)` | Start process |
| `a!writeRecords(records, onSuccess, onError)` | Write records |
| `a!deleteRecords(records, onSuccess, onError)` | Delete records |
| `a!httpResponse(statusCode, headers, body)` | Web API response |
| `a!currency(amount, code)` | Format currency |

## Paging with Sorts
```
a!pagingInfo(
  startIndex: 1,
  batchSize: 25,
  sort: {
    a!sortInfo(field: "lastName", ascending: true),
    a!sortInfo(field: "firstName", ascending: true)
  }
)
```

## Query with Aggregation
```
a!queryRecordType(
  recordType: recordType!Order,
  fields: a!aggregationFields(
    groupings: { a!grouping(field: recordType!Order.fields.department, alias: "dept") },
    measures: { a!measure(function: "COUNT", alias: "count") }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
)
```
