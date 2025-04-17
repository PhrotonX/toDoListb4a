# Naming Convention
- Applicable to B4X Programming Language (similar to Visual Basic)
- Be sure that the naming convention is not ambiguous.
- Avoid names like "Label1," "Panel1," "btnClick_Click," among others.

## Code files (.bas)
### Variables
- **Private member variables:** m_variableName
- **Public member variables:** VariableName
- **Private global variables:** m_variableName
- **Public global variables:** VariableName
- **Local variables:** variableName or variable_name
- **Parameters:** variableName or variable_name

### Layout Views
**Note:** You may add [SpecificFunctionality] if applicable.\
**Note:** Avoid ambiguous or conflicting prefixes like btn for both Buttons and ToggleButtons.
- **Button:** btn[SpecificFunctionality][ButtonName] e.g. btnSearchTitle, btnSortTitle
- **Label:** lbl[SpecificFunctionality][LabelName]
- **EditText:** [edit or txt][SpecificFunctionality][EditTextName]
- **ImgView:** img[SpecificFunctionality][ImgViewName]
- **Spinner:** [spn or spinner][SpecificFunctionality][SpinnerName]
- **Floating Action Button:** fab[SpecificFunctionality][FloatingActionButtonName]
- **Panel:** pnl[SpecificFunctionality][PanelName]
- **CustomListView:** clv[SpecificFunctionality][CustomListViewName]
- **ListVew:** lv[SpecificFunctionality][ListViewName]
- **Radio:** radio[SpecificFunctionality][RadioName]
- **CheckBox:** [check or cb][SpecificFunctionality][CheckBoxName]
- **ToggleButton:** [toggle][SpecificFunctionality][ToggleButtonName]
- **Switch:** [switch][SpecificFunctionality][SwitchName]
- **ScrollView:** [scroll or sv][SpecificFunctionality][SwitchName]
- **Other Views:** [initials of view name (e.g. WebView -> web or wv, TabHost -> tabh or th)][SpecificFunctionality][ViewName]

### Code Architecture
- **Entity:** EntityName
- **Data Access Objects:** [NameOfDao]Dao
- **Repositories:** [NameOfRepo]Repository
- **ViewModel:** [NameOfVM]ViewModel
- **ViewHolder:** [NameOfVH]ViewHolder

### Functions
- **Functions:** FunctionName() or FunctionName
- **Event handlers:** On[FunctionName]

### Others
- **Layout Files:** layout_name (filename is automatically lowercase)
- **Code Modules:** ModuleName
- **Classes:** ClassName
- **Activity:** [NameOfActivity]Activity (e.g. MainActivity, EditorActivity)
- **Services:** [NameOfService]Service
- **Receiver:** [NameOfReceiver]Receiver
- **Database Tables:** table_name (singular, unless there is a conflict with reserved SQLite keywords)
- **Associative Database Tables:** [independent_table (verb or adverb)]_[dependent_table (singular)]
- **File System Directories:** directory_name
