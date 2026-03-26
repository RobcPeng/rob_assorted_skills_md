# SAIL Coding Guide (Aurora Design System)

Based on: https://appian-design.github.io/aurora/SAIL_CODING_GUIDE/

## Core Principles

1. **All interfaces start with `a!localVariables()`** — this is the foundational wrapper
2. **Logical operators are functions**: `and()`, `or()`, `not()` — NOT symbolic operators
3. **Null checking**: Use `a!isNotNullOrEmpty()`, `a!isNullOrEmpty()`, and `a!defaultValue()`
4. **Never use deprecated functions** — `load()`, `with()`, `a!dashboardLayout()`

---

## Layout Patterns

### Form Layout (Start/Task Forms)
```
a!localVariables(
  local!data: null,
  a!formLayout(
    label: "Form Title",
    instructions: "Brief instructions here.",
    contents: {
      a!sectionLayout(
        label: "Section Title",
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(contents: { /* fields */ }),
              a!columnLayout(contents: { /* fields */ })
            }
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
          color: "ACCENT"
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

### Dashboard / Header Content Layout
```
a!headerContentLayout(
  header: {
    a!headerTemplateFull(
      title: "Dashboard Title",
      subtitle: "Description text"
    )
  },
  contents: {
    a!columnsLayout(
      columns: {
        a!columnLayout(width: "NARROW", contents: { /* sidebar */ }),
        a!columnLayout(contents: { /* main content */ })
      }
    )
  }
)
```

### Responsive Three-Column Layout
For centering content on wide screens:
```
a!columnsLayout(
  columns: {
    a!columnLayout(
      width: "AUTO",
      showWhen: a!isPageWidth(pageWidths: {"TABLET_LANDSCAPE", "DESKTOP_WIDE", "DESKTOP_NARROW"}),
      contents: {}
    ),
    a!columnLayout(
      width: "3X",
      contents: { /* main content */ }
    ),
    a!columnLayout(
      width: "AUTO",
      showWhen: a!isPageWidth(pageWidths: {"TABLET_LANDSCAPE", "DESKTOP_WIDE", "DESKTOP_NARROW"}),
      contents: {}
    )
  }
)
```
- Always include at least one `AUTO` width column
- Hide margin columns on mobile using `a!isPageWidth()`

### Pane Layout
```
a!paneLayout(
  header: "Pane Title",
  headerActions: {
    a!buttonWidget(label: "Action", size: "SMALL", style: "OUTLINE")
  },
  contents: { /* content */ }
)
```

### Wizard Layout
```
a!localVariables(
  local!currentStep: 1,
  a!wizardLayout(
    currentStep: local!currentStep,
    steps: {
      a!wizardStep(label: "Step 1"),
      a!wizardStep(label: "Step 2"),
      a!wizardStep(label: "Review")
    },
    contents: {
      choose(
        local!currentStep,
        /* Step 1 contents */
        { a!sectionLayout(label: "Step 1", contents: { /* ... */ }) },
        /* Step 2 contents */
        { a!sectionLayout(label: "Step 2", contents: { /* ... */ }) },
        /* Review contents */
        { a!sectionLayout(label: "Review", contents: { /* ... */ }) }
      )
    },
    buttons: a!buttonLayout(
      primaryButtons: {
        a!buttonWidget(
          label: if(local!currentStep = 3, "Submit", "Next"),
          saveInto: if(
            local!currentStep = 3,
            {},
            a!save(local!currentStep, local!currentStep + 1)
          ),
          submit: local!currentStep = 3,
          style: "SOLID",
          color: "ACCENT"
        )
      },
      secondaryButtons: {
        a!buttonWidget(
          label: "Back",
          saveInto: a!save(local!currentStep, local!currentStep - 1),
          showWhen: local!currentStep > 1,
          style: "OUTLINE"
        )
      }
    )
  )
)
```

---

## Button Guidelines

### Placement
- Buttons go inside `a!buttonArrayLayout()` or `a!buttonLayout()`
- Never place buttons loose in a section

### Styles
| Style | Color | When to Use |
|-------|-------|-------------|
| `SOLID` | `ACCENT` | Primary constructive action (Submit, Save, Create) |
| `OUTLINE` | default | Secondary actions (Cancel, Back) |
| `GHOST` | `NEGATIVE` | Destructive actions (Delete, Remove) |
| `LINK` | default | Tertiary/navigation actions |

**Rule: Only ONE `SOLID` + `ACCENT` button per view.**

### Button Widget Pattern
```
a!buttonWidget(
  label: "Submit",
  style: "SOLID",
  color: "ACCENT",
  submit: true,
  validate: true,
  saveInto: { /* save actions */ }
)
```

---

## Grid Guidelines

### Read-Only Grid (`a!gridField`)
- Use for displaying record data
- Default to `LIGHT` borders
- 25 items/page for full-page grids, 10 for embedded grids
- Right-align currency/number columns
- Always provide `initialSorts`

### Editable Grid (`a!gridLayout`)
- Use when users need to edit inline
- Always provide Add/Remove row functionality
- Validate each cell independently

### Grid Column Best Practices
```
a!gridColumn(
  label: "Amount",
  sortField: recordType!Invoice.fields.amount,
  value: a!currency(amount: fv!row[recordType!Invoice.fields.amount]),
  align: "END",    /* right-align numbers */
  width: "NARROW"
)
```

---

## Common Mistakes to Avoid

| Mistake | Correct Approach |
|---------|-----------------|
| `a!milestoneStep()` | Does NOT exist — use `a!milestoneField()` with data param |
| `style: "PRIMARY"` on buttons | Use `style: "SOLID", color: "ACCENT"` |
| `showLegend: true` on pie charts | Use `seriesLabelStyle: "LEGEND"` |
| Adding `*` to required field labels | The `required: true` param auto-adds the asterisk |
| `showSearchBox` on non-record grids | Only works with Record Type `data` source |
| Using `text()` excessively | Use `a!richTextDisplayField()` or `a!headingField()` for display |
| `a!sectionLayoutColumns()` | Deprecated — use `a!sectionLayout()` with `a!columnsLayout()` inside |
| Inline `a!cardLayout` with no `link` | Use `a!cardLayout(link: ..., isSelectable: true)` for clickable cards |
| Column widths that don't follow rules | Use "NARROW", "MEDIUM", "WIDE", "AUTO", "1X"-"10X" |

---

## Cards and Card Groups

### Card Layout
```
a!cardLayout(
  contents: { /* card body */ },
  style: "STANDARD",
  showBorder: true,
  padding: "STANDARD",
  link: a!dynamicLink(saveInto: { /* action */ }),
  accessibilityText: "Description for screen readers"
)
```

### Card Choice Field (Cards as Selection)
```
a!cardChoiceField(
  label: "Select Option",
  data: {
    a!map(id: 1, label: "Option A", icon: "folder"),
    a!map(id: 2, label: "Option B", icon: "file")
  },
  cardTemplate: a!cardTemplateTile(
    id: fv!data.id,
    primaryText: fv!data.label,
    icon: fv!data.icon
  ),
  value: local!selected,
  saveInto: local!selected
)
```

---

## Rich Text Patterns

### Rich Text Display
```
a!richTextDisplayField(
  value: {
    a!richTextItem(text: "Status: ", style: {"BOLD"}),
    a!richTextItem(
      text: local!status,
      style: {"STRONG"},
      color: if(local!status = "Active", "POSITIVE", "NEGATIVE")
    )
  }
)
```

### Rich Text with Icons
```
a!richTextDisplayField(
  value: {
    a!richTextIcon(icon: "check-circle", color: "POSITIVE"),
    " ",
    a!richTextItem(text: "Approved")
  }
)
```

---

## Tabs
```
a!tabLayout(
  tabs: {
    a!tabItem(label: "Details", isActive: local!activeTab = 1),
    a!tabItem(label: "History", isActive: local!activeTab = 2),
    a!tabItem(label: "Files", isActive: local!activeTab = 3)
  },
  contents: choose(
    local!activeTab,
    { /* Details content */ },
    { /* History content */ },
    { /* Files content */ }
  ),
  saveInto: local!activeTab
)
```

---

## Accessibility Checklist

1. **Heading hierarchy**: H1 → H2 → H3, no skipping levels
2. **`accessibilityText`**: Required on cards, images, icons used as status indicators
3. **Color contrast**: 4.5:1 minimum ratio for text
4. **Labels**: Every input must have a `label` (use `labelPosition: "COLLAPSED"` to hide visually)
5. **Link text**: Descriptive labels, never "click here"
6. **Tab order**: Logical reading order, no reordering via CSS hacks
7. **Screen reader testing**: Test with VoiceOver/NVDA

---

## Voice and Tone

- **Concise**: Short, clear sentences
- **Sentence case**: For headings and labels (not Title Case)
- **Verb + noun**: For button labels ("Submit Request", "Download Report")
- **No jargon**: Use plain language users understand
- **Consistent**: Same terms for same concepts throughout
