# Appian 26.2 Functions Registry (742 Functions)

This is the authoritative list of all valid Appian functions. **Do NOT use any function not listed here.**

Source: https://docs.appian.com/suite/help/26.2/Appian_Functions.html

## Array (14)
`a!flatten()` `a!update()` `append()` `index()` `insert()` `joinarray()` `ldrop()` `length()` `rdrop()` `remove()` `reverse()` `updatearray()` `where()` `wherecontains()`

## Set (5)
`contains()` `difference()` `intersection()` `symmetricdifference()` `union()`

## Base Conversion (12)
`bin2dec()` `bin2hex()` `bin2oct()` `dec2bin()` `dec2hex()` `dec2oct()` `hex2bin()` `hex2dec()` `hex2oct()` `oct2bin()` `oct2dec()` `oct2hex()`

## Connector — reCAPTCHA (1)
`a!verifyRecaptcha()`

## Connector — Web Service Helper (10)
`a!httpAuthenticationBasic()` `a!httpFormPart()` `a!httpHeader()` `a!httpQueryParameter()` `a!scsField()` `a!wsConfig()` `a!wsHttpCredentials()` `a!wsHttpHeaderField()` `a!wsUsernameToken()` `a!wsUsernameTokenScs()`

## Conversion (19)
`cast()` `displayvalue()` `externalize()` `internalize()` `toboolean()` `tocommunity()` `todate()` `todatetime()` `todecimal()` `todocument()` `toemailaddress()` `toemailrecipient()` `tofolder()` `tointeger()` `tointervalds()` `toknowledgecenter()` `tostring()` `totime()` `touniformstring()`

## Custom Fields (10)
`a!customFieldConcat()` `a!customFieldCondition()` `a!customFieldDateDiff()` `a!customFieldDefaultValue()` `a!customFieldDivide()` `a!customFieldLogicalExpression()` `a!customFieldMatch()` `a!customFieldMultiply()` `a!customFieldSubtract()` `a!customFieldSum()`

## Date and Time (37)
`a!addDateTime()` `a!subtractDateTime()` `calisworkday()` `calisworktime()` `calworkdays()` `calworkhours()` `date()` `datetime()` `datevalue()` `day()` `dayofyear()` `days360()` `daysinmonth()` `edate()` `eomonth()` `gmt()` `hour()` `intervalds()` `isleapyear()` `lastndays()` `local()` `milli()` `minute()` `month()` `networkdays()` `now()` `second()` `time()` `timevalue()` `timezone()` `timezoneid()` `today()` `weekday()` `weeknum()` `workday()` `year()` `yearfrac()`

## Evaluation (8)
`a!asyncVariable()` `a!controlPanelRecords()` `a!localVariables()` `a!refreshVariable()` `a!save()` `bind()` `load()` `with()`

## Informational (19)
`a!automationId()` `a!automationType()` `a!defaultValue()` `a!isNotNullOrEmpty()` `a!isNullOrEmpty()` `a!keys()` `a!listType()` `a!submittedOfflineTaskIds()` `error()` `infinity()` `isinfinite()` `isnegativeinfinity()` `isnull()` `ispositiveinfinity()` `nan()` `null()` `runtimetypeof()` `typename()` `typeof()`

## Interface Component — Action (18)
`a!authorizationLink()` `a!buttonArrayLayout()` `a!buttonLayout()` `a!buttonWidget()` `a!buttonWidget_23r3()` `a!documentDownloadLink()` `a!dynamicLink()` `a!linkField()` `a!newsEntryLink()` `a!processTaskLink()` `a!recordActionField()` `a!recordActionItem()` `a!recordLink()` `a!reportLink()` `a!safeLink()` `a!startProcessLink()` `a!submitLink()` `a!userRecordLink()`

## Interface Component — Browsers (11)
`a!documentAndFolderBrowserFieldColumns()` `a!documentBrowserFieldColumns()` `a!folderBrowserFieldColumns()` `a!groupBrowserFieldColumns()` `a!hierarchyBrowserFieldColumns()` `a!hierarchyBrowserFieldColumnsNode()` `a!hierarchyBrowserFieldTree()` `a!hierarchyBrowserFieldTreeNode()` `a!orgChartField()` `a!userAndGroupBrowserFieldColumns()` `a!userBrowserFieldColumns()`

## Interface Component — Charts (16)
`a!areaChartConfig()` `a!areaChartField()` `a!barChartConfig()` `a!barChartField()` `a!chartReferenceLine()` `a!chartSeries()` `a!colorSchemeCustom()` `a!columnChartConfig()` `a!columnChartField()` `a!grouping()` `a!lineChartConfig()` `a!lineChartField()` `a!measure()` `a!pieChartConfig()` `a!pieChartField()` `a!scatterChartField()`

## Interface Component — Display (30)
`a!documentImage()` `a!documentViewerField()` `a!gaugeField()` `a!gaugeFraction()` `a!gaugeIcon()` `a!gaugePercentage()` `a!headingField()` `a!horizontalLine()` `a!imageField()` `a!kpiField()` `a!messageBanner()` `a!milestoneField()` `a!progressBarField()` `a!richTextBulletedList()` `a!richTextDisplayField()` `a!richTextIcon()` `a!richTextImage()` `a!richTextItem()` `a!richTextListItem()` `a!richTextNumberedList()` `a!stampField()` `a!tagField()` `a!tagItem()` `a!tagItem_24r2()` `a!timeDisplayField()` `a!userImage()` `a!videoField()` `a!webContentField()` `a!webImage()` `a!webVideo()`

## Interface Component — Grids and Lists (10)
`a!eventData()` `a!eventHistoryListField()` `a!gridColumn()` `a!gridField()` `a!gridField_25r2()` `a!gridField_25r3()` `a!gridLayout()` `a!gridLayoutColumnConfig()` `a!gridLayoutHeaderCell()` `a!gridRowLayout()`

## Interface Component — Inputs (16)
`a!barcodeField()` `a!chatField()` `a!chatMessage()` `a!dataFabricChatField()` `a!dateField()` `a!dateTimeField()` `a!documentsChatField()` `a!encryptedTextField()` `a!fileUploadField()` `a!floatingPointField()` `a!integerField()` `a!paragraphField()` `a!recordsChatField()` `a!signatureField()` `a!styledTextEditorField()` `a!textField()`

## Interface Component — Layouts (25)
`a!barOverlay()` `a!billboardLayout()` `a!boxLayout()` `a!cardGroupLayout()` `a!cardLayout()` `a!columnLayout()` `a!columnOverlay()` `a!columnsLayout()` `a!formLayout()` `a!fullOverlay()` `a!headerContentLayout()` `a!headerTemplateFull()` `a!headerTemplateImage()` `a!headerTemplateSimple()` `a!pane()` `a!paneLayout()` `a!sectionLayout()` `a!sidebarTemplate()` `a!sideBySideItem()` `a!sideBySideLayout()` `a!tabItem()` `a!tabLayout()` `a!validationMessage()` `a!wizardLayout()` `a!wizardStep()`

## Interface Component — Pickers (8)
`a!pickerFieldCustom()` `a!pickerFieldDocuments()` `a!pickerFieldDocumentsAndFolders()` `a!pickerFieldFolders()` `a!pickerFieldGroups()` `a!pickerFieldRecords()` `a!pickerFieldUsers()` `a!pickerFieldUsersAndGroups()`

## Interface Component — Selection (14)
`a!booleanCheckboxField()` `a!cardChoiceField()` `a!cardTemplateBarTextJustified()` `a!cardTemplateBarTextStacked()` `a!cardTemplateTile()` `a!checkboxField()` `a!checkboxFieldByIndex()` `a!dropdownField()` `a!dropdownFieldByIndex()` `a!multipleDropdownField()` `a!multipleDropdownFieldByIndex()` `a!radioButtonField()` `a!radioButtonFieldByIndex()` `a!toggleField()`

## Logical (8)
`a!match()` `and()` `choose()` `false()` `if()` `not()` `or()` `true()`

## Looping (9)
`a!forEach()` `all()` `any()` `apply()` `filter()` `merge()` `none()` `reduce()` `reject()`

## Mathematical (32)
`a!distanceBetween()` `abs()` `ceiling()` `combin()` `e()` `enumerate()` `even()` `exp()` `fact()` `factdouble()` `floor()` `int()` `ln()` `log()` `mod()` `mround()` `multinomial()` `odd()` `pi()` `power()` `product()` `quotient()` `rand()` `round()` `rounddown()` `roundup()` `sign()` `sqrt()` `sqrtpi()` `sum()` `sumsq()` `trunc()`

## People (16)
`a!doesGroupExist()` `a!groupMembers()` `a!groupsByName()` `a!groupsByType()` `a!groupsForUser()` `a!isUserMemberOfGroup()` `getdistinctusers()` `getgroupattribute()` `group()` `isusernametaken()` `loggedInUser()` `supervisor()` `togroup()` `topeople()` `touser()` `user()`

## Scripting (49)
`a!isNativeMobile()` `a!isPageWidth()` `a!portalUrlWithLocale()` `a!recordTypeProperties()` `a!urlForPortal()` `a!urlForRecord()` `a!urlForSite()` `a!urlForTask()` `averagetaskcompletiontimeforprocessmodel()` `averagetasklagtimeforprocessmodel()` `averagetaskworktimeforprocessmodel()` `community()` `datetext()` `document()` `folder()` `isInDaylightSavingTime()` `knowledgecenter()` `numontimeprocessesforprocessmodel()` `numontimetasksforprocessmodel()` `numoverdueprocessesforprocessmodel()` `numoverduetasksforprocessmodel()` `numprocessesforprocessmodelforstatus()` `numtasksforprocessmodelforstatus()` `offsetFromGMT()` `property()` `repeat()` `todatasubset()` `topaginginfo()` `torecord()` `toxml()` `urlwithparameters()` `userdate()` `userdatetime()` `userdatevalue()` `userday()` `userdayofyear()` `userdaysinmonth()` `useredate()` `usereomonth()` `userisleapyear()` `userlocale()` `usermonth()` `usertimezone()` `userweekday()` `userweeknum()` `useryear()` `webservicequery()` `webservicewrite()` `xpathdocument()` `xpathsnippet()`

## Smart Service — Communication (1)
`a!sendPushNotification()`

## Smart Service — Data Services (7)
`a!deleteFromDataStoreEntities()` `a!deleteRecords()` `a!executeStoredProcedureOnSave()` `a!syncRecords()` `a!writeRecords()` `a!writeToDataStoreEntity()` `a!writeToMultipleDataStoreEntities()`

## Smart Service — Document Generation (4)
`a!exportDataStoreEntityToCsv()` `a!exportDataStoreEntityToExcel()` `a!exportProcessReportToCsv()` `a!exportProcessReportToExcel()`

## Smart Service — Document Management (16)
`a!createFolder()` `a!createKnowledgeCenter()` `a!deleteDocument()` `a!deleteFolder()` `a!deleteKnowledgeCenter()` `a!editDocumentProperties()` `a!editFolderProperties()` `a!editKnowledgeCenterProperties()` `a!lockDocument()` `a!modifyFolderSecurity()` `a!modifyKnowledgeCenterSecurity()` `a!moveDocument()` `a!moveFolder()` `a!unlockDocument()` `a!docExtractionResult()` `a!docExtractionStatus()`

## Smart Service — Identity Management (15)
`a!addAdminsToGroup()` `a!addMembersToGroup()` `a!createGroup()` `a!createUser()` `a!deactivateUser()` `a!deleteGroup()` `a!editGroup()` `a!modifyUserSecurity()` `a!reactivateUser()` `a!removeGroupAdmins()` `a!removeGroupMembers()` `a!renameUsers()` `a!setGroupAttributes()` `a!updateUserProfile()` `a!updateUserType()`

## Smart Service — Process Management (4)
`a!cancelProcess()` `a!completeTask()` `a!startProcess()` `a!startProcess_24r3()`

## Smart Service — Testing (4)
`a!startRuleTestsAll()` `a!startRuleTestsApplications()` `a!testRunResultForId()` `a!testRunStatusForId()`

## Statistical (18)
`avedev()` `average()` `count()` `frequency()` `gcd()` `geomean()` `harmean()` `lcm()` `lookup()` `max()` `median()` `min()` `mode()` `rank()` `stdev()` `stdevp()` `var()` `varp()`

## System (60)
`a!aggregationFields()` `a!applyComponents()` `a!applyValidations()` `a!callLanguageModel()` `a!controlPanelRecordHierarchyMetadata()` `a!dataSubset()` `a!deployment()` `a!documentFolderForRecordType()` `a!doesUserHaveAccess()` `a!endsWith()` `a!entityData()` `a!entityDataIdentifiers()` `a!executeStoredProcedureForQuery()` `a!fromJson()` `a!genAiModels()` `a!getDataSourceForPlugin()` `a!httpResponse()` `a!iconIndicator()` `a!iconNewsEvent()` `a!integrationError()` `a!isBetween()` `a!isInText()` `a!jsonPath()` `a!latestHealthCheck()` `a!listViewItem()` `a!map()` `a!pageResponse()` `a!pagingInfo()` `a!query()` `a!queryAggregation()` `a!queryAggregationColumn()` `a!queryColumn()` `a!queryEntity()` `a!queryFilter()` `a!queryLogicalExpression()` `a!queryProcessAnalytics()` `a!queryRecordByIdentifier()` `a!queryRecordByIdentifier_25r2()` `a!queryRecordType()` `a!queryRecordType_25r2()` `a!queryRecordType_25r3()` `a!querySelection()` `a!recordData()` `a!recordFilterChoices()` `a!recordFilterDateRange()` `a!recordFilterList()` `a!recordFilterListOption()` `a!relatedRecordData()` `a!selectionFields()` `a!sentimentScore()` `a!sortInfo()` `a!startsWith()` `a!storedProcedureInput()` `a!submitUploadedFiles()` `a!toJson()` `a!toRecordIdentifier()` `a!userRecordFilterList()` `a!userRecordIdentifier()` `a!userRecordListViewItem()`

## Text (50)
`a!currency()` `a!formatPhoneNumber()` `a!isPhoneNumber()` `a!swissFranc()` `cents()` `char()` `charat()` `clean()` `cleanwith()` `code()` `concat()` `exact()` `extract()` `extractanswers()` `find()` `fixed()` `initials()` `insertkey()` `insertkeyval()` `insertquestions()` `keyval()` `left()` `leftb()` `len()` `lenb()` `like()` `lower()` `mid()` `midb()` `padleft()` `padright()` `proper()` `replace()` `replaceb()` `rept()` `resource()` `right()` `search()` `searchb()` `soundex()` `split()` `strip()` `stripHtml()` `stripwith()` `substitute()` `text()` `toHtml()` `trim()` `upper()` `value()`

## Trigonometry (14)
`acos()` `acosh()` `asin()` `asinh()` `atan()` `atanh()` `cos()` `cosh()` `degrees()` `radians()` `sin()` `sinh()` `tan()` `tanh()`

---

## Commonly Hallucinated Functions (DO NOT USE)

These functions **DO NOT EXIST** in Appian. They are commonly hallucinated:

| Hallucinated | Correct Alternative |
|-------------|-------------------|
| `a!milestoneStep()` | Use `a!milestoneField()` with `steps` parameter |
| `a!decimalField()` | Use `a!floatingPointField()` |
| `a!numberField()` | Use `a!integerField()` or `a!floatingPointField()` |
| `a!tableField()` | Use `a!gridField()` or `a!gridLayout()` |
| `a!listLayout()` | Use `a!forEach()` with layout components |
| `a!dialog()` | Use `a!boxLayout()` or inline pattern |
| `a!modalLayout()` | No such thing — use `a!boxLayout()` pattern |
| `a!alertField()` | Use `a!messageBanner()` |
| `a!notificationField()` | Use `a!messageBanner()` |
| `a!accordionLayout()` | Use `a!sectionLayout(collapsible: true)` |
| `a!breadcrumbField()` | Use `a!richTextDisplayField()` with links |
| `a!navLayout()` | No such thing — use `a!headerContentLayout()` |
| `a!divider()` | Use `a!horizontalLine()` |
| `a!spacer()` | Use `a!richTextDisplayField(value: "")` |
| `a!labelField()` | Use `a!richTextDisplayField()` or `a!headingField()` |
| `a!iconField()` | Use `a!richTextIcon()` inside `a!richTextDisplayField()` |
| `a!currencyField()` | Use `a!floatingPointField()` + `a!currency()` for display |
| `a!phoneField()` | Use `a!textField()` + `a!isPhoneNumber()` for validation |
| `a!emailField()` | Use `a!textField()` with `like()` validation |
| `a!urlField()` | Use `a!textField()` |
| `a!colorField()` | Does not exist |
| `a!sliderField()` | Does not exist |
| `a!ratingField()` | Does not exist |
| `a!switchField()` | Use `a!toggleField()` |
| `a!treeView()` | Use `a!hierarchyBrowserFieldTree()` |
| `a!refreshVariable()` as standalone | Use inside `a!localVariables()` via `a!refreshVariable()` |
| `isnotnull()` | Use `a!isNotNullOrEmpty()` or `not(isnull())` |
| `isNotNull()` | Use `a!isNotNullOrEmpty()` or `not(isnull())` |
| `a!link()` | Use `a!dynamicLink()`, `a!recordLink()`, `a!safeLink()`, etc. |
| `a!sectionLayoutColumns()` | Deprecated — use `a!sectionLayout()` + `a!columnsLayout()` |
| `sortfield()` | Not a function — use `a!sortInfo()` in queries |
| `first()` | Use `index(list, 1, null)` |
| `last()` | Use `index(list, length(list), null)` |
| `coalesce()` | Use `a!defaultValue()` |
| `concatenate()` | Use `concat()` or `joinarray()` |
| `isnotnull()` | Use `not(isnull())` or `a!isNotNullOrEmpty()` |
| `groupmembers()` | Use `a!groupMembers()` (with a! prefix) |
| `displaynameofuser()` | Not a function — use `user(username, "displayName")` |
| `username()` | Not a function — use `user(userValue, "username")` |
