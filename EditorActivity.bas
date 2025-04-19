B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Private xui As XUI
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private editNotes As EditText
	Private editTitle As EditText
	
	' This variable is used to determine the current mode of editor such as EDITOR_MODe_CREATE or
	' EDITOR_MODE_EDIT.
	Private m_mode As String
	
	' This variable is responsible for handling the current data that can be used for performing
	' CRUD into the database.
	Private m_task As ToDo
	Private m_group As Group
	
	' Attachment that are pending for saving.
	Private m_pendingAttachmentInsert As List
	Private m_pendingAttachmentDelete As List
	
	'Private m_runtimePermission As RuntimePermissions
	
	Private radioPriorityCritical As RadioButton
	Private radioPriorityHigh As RadioButton
	Private radioPriorityLow As RadioButton
	Private radioPriorityMedium As RadioButton
	Private checkRepeatFri As CheckBox
	Private checkRepeatMon As CheckBox
	Private checkRepeatSat As CheckBox
	Private checkRepeatSun As CheckBox
	Private checkRepeatThu As CheckBox
	Private checkRepeatTue As CheckBox
	Private checkRepeatWed As CheckBox
	Private btnDelete As Button
	Private editorScrollView As ScrollView
	Private Label1 As Label
	Private editDueDateYear As EditText
	Private spinnerDueDateDay As Spinner
	Private spinnerDueDateMonth As Spinner
	
	Private Const SPINNER_DUE_DATE_DAY_HINT_TEXT As String = "Select day here..."
	Private Const SPINNER_DUE_DATE_MONTH_HINT_TEXT As String = "Select month here..."
	Private clvAttachments As CustomListView
	Private btnAttachmentOpen As Button
	Private btnAttachmentRemove As Button
	Private imgAttachmentIcon As ImageView
	Private lblAttachmentFileName As Label
	Private pnlAttachmentRoot As Panel
	Private spnTaskGroup As Spinner
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("EditorLayout")
	
	m_pendingAttachmentInsert.Initialize
	m_pendingAttachmentDelete.Initialize
	
	editorScrollView.Panel.LoadLayout("EditorScrollLayout")
	
	Dim c As Canvas
	c.Initialize(Label1)
	Dim borderColor As Int = Colors.RGB(209, 209, 209)
	Dim borderHeight As Int = 1dip

	
	c.DrawLine(0, Label1.Height - borderHeight / 2, Label1.Width, Label1.Height - borderHeight / 2, borderColor, borderHeight)

	Label1.Invalidate
	
	' Initialize variables
	m_task.Initialize
	
	' Retrieve the data sent by MainActivity to check the editor mode.
	m_mode = Starter.InstanceState.Get(Starter.EXTRA_EDITOR_MODE)
	
	' Fill the due date spinners with data
	PopulateDueDate
	
	' Load the task groups
	LoadTaskGroup
	
	' Check the editor mode to set the appropriate EditorActivity functionalities.
	If m_mode == Starter.EDITOR_MODE_EDIT Then
		' Rename the activity if editing.
		Label1.Text = "Edit Task"
		
		' Retrieve the stored ID that is sent from MainActivity.
		Dim itemId As Int = Starter.InstanceState.Get(Starter.EXTRA_EDITOR_TASK_ID)
		
		' Retrieve the data stored in the database based on itemId.
		m_task = Starter.TaskViewModelInstance.GetTask(itemId)
		m_group = Starter.GroupViewModelInstance.GetGroupByTaskId(m_task.GetId)
		
		If m_group.IsInitialized == False Then
			m_group.Initialize(0)
		End If
		
		' Update the fields to display the data retrieved from the database for editing.
		editTitle.Text = m_task.GetTitle
		editNotes.Text = m_task.GetNotes
		
		' Determine the priority value that was saved. But first, initialize all radio buttons
		' into False in order to avoid redundnacy within the Select statement.
		ClearPriorityField
		
		Select m_task.GetPriority
			Case m_task.PRIORITY_LOW:
				radioPriorityLow.Checked = True
			Case m_task.PRIORITY_MEDIUM:
				radioPriorityMedium.Checked = True
			Case m_task.PRIORITY_HIGH:
				radioPriorityHigh.Checked = True
			Case m_task.PRIORITY_CRITICAL:
				radioPriorityCritical.Checked = True
		End Select
		
		' Update the repeat values.
		checkRepeatSun.Checked = m_task.GetRepeat(m_task.REPEAT_SUNDAY)
		checkRepeatMon.Checked = m_task.GetRepeat(m_task.REPEAT_MONDAY)
		checkRepeatTue.Checked = m_task.GetRepeat(m_task.REPEAT_TUESDAY)
		checkRepeatWed.Checked = m_task.GetRepeat(m_task.REPEAT_WEDNESDAY)
		checkRepeatThu.Checked = m_task.GetRepeat(m_task.REPEAT_THURSDAY)
		checkRepeatFri.Checked = m_task.GetRepeat(m_task.REPEAT_FRIDAY)
		checkRepeatSat.Checked = m_task.GetRepeat(m_task.REPEAT_SATURDAY)
		
		' Update the selected value of due date month spinner based on the numeric month that is 
		' set on m_task.
		spinnerDueDateMonth.SelectedIndex = m_task.GetDueDate.GetMonth
		' Update the selected value of due date day spinner based on the day that is
		' set on m_task.
		spinnerDueDateDay.SelectedIndex = m_task.GetDueDate.GetDay
		editDueDateYear.Text = m_task.GetDueDate.GetYear
		
		' Load the attachments
		LoadAttachments
		
		' Load the selected task group.
		spnTaskGroup.SelectedIndex = spnTaskGroup.IndexOf(m_group.GetTitle)
		
	Else If m_mode == Starter.EDITOR_MODE_CREATE Then
		' Disable the delete button if the editor mode is EDITOR_MODE_CREATE
		btnDelete.Visible = False
		
		' Load the default task group based on the last opened task group.
		Dim groupId As Long = Starter.InstanceState.Get(Starter.EXTRA_EDITOR_GROUP_ID)
		
		If groupId > 0 Then
			m_group = Starter.GroupViewModelInstance.GetGroup(groupId)
			If m_group.IsInitialized Then
				spnTaskGroup.SelectedIndex = spnTaskGroup.IndexOf(m_group.GetTitle())
			End If
		End If
		
		
		' Set the current date as the default value of due date fields.
		spinnerDueDateDay.SelectedIndex = DateTime.GetDayOfMonth(DateTime.Now)
		spinnerDueDateMonth.SelectedIndex = DateTime.GetMonth(DateTime.Now)
		editDueDateYear.Text = DateTime.GetYear(DateTime.Now)
		
		' Load the due date data on the fields into the m_task variable.
		' Even if spinner and edit fields are updated, the m_task.GetDueDate
		' remains unset.
		m_task.GetDueDate.SetMonth(spinnerDueDateMonth.SelectedIndex)
		m_task.GetDueDate.SetDay(spinnerDueDateDay.SelectedIndex)
		m_task.GetDueDate.SetYear(editDueDateYear.Text)
	End If
	
	' Remove editor mode key from the bundle to avoid some potential application state-related bugs.
	Starter.InstanceState.Remove(Starter.EXTRA_EDITOR_MODE)
	Starter.InstanceState.Remove(Starter.EXTRA_EDITOR_GROUP_ID)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub btnSave_Click
	' Add the current editor result into the instance state.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_RESULT, Starter.EDITOR_RESULT_SAVE)
	
	' Validation to check if editTitle is empty.
	If editTitle.Text == "" Then
		MsgboxAsync("Title cannot be empty!", "Error")
		Return
	End If
	
	' Validation for priority radio buttons.
	If radioPriorityCritical.Checked == False And radioPriorityHigh.Checked == False _
	And radioPriorityMedium.Checked == False And radioPriorityLow.Checked == False Then
		MsgboxAsync("Priority cannot be empty!", "Error")
		Return
	End If
	
	' Set values into m_task.
	m_task.SetTitle(editTitle.Text)
	m_task.SetNotes(editNotes.Text)
	
	' Priority, Due Date Day, Due date Month, and Repeat values are already set once the
	' buttons are clicked.
	
	' Primarily validate the due date year field if null before taking another validation if
	' the date is a valid date.
	If editDueDateYear.Text.Trim = "" Then
		MsgboxAsync("Due date field cannot be empty!", "Error")
		Return
	Else
		' Save the due date year value.
		m_task.GetDueDate.SetYear(editDueDateYear.Text)
	End If
	
	' Validate the due date values
	If validateDueDate == False Then
		Return
	End If
	
	' Get the selected group
	Dim selectedGroup As Group
	If spnTaskGroup.SelectedIndex > 0 Then
		Dim groupTitle As String = spnTaskGroup.GetItem(spnTaskGroup.SelectedIndex)
		selectedGroup = Starter.GroupViewModelInstance.GetGroupByTitle(groupTitle)
	Else
		selectedGroup.Initialize(0)
	End If
	
	
	' Check the editor mode to set the appropriate EditorActivity saving functionalities.
	If m_mode == Starter.EDITOR_MODE_EDIT Then
		Starter.TaskViewModelInstance.UpdateTask(m_task)
		
		Starter.GroupViewModelInstance.UpdateTaskGroup(m_task.GetId, m_group.GetID, selectedGroup.GetID)
	Else If m_mode == Starter.EDITOR_MODE_CREATE Then
		Starter.TaskViewModelInstance.InsertTask(m_task)
		
		Starter.GroupViewModelInstance.InsertTaskGroup(m_task.GetId, selectedGroup.GetID)
	End If
	
	' Save the attachments that are pending for insertion.
	For Each item As Attachment In m_pendingAttachmentInsert
		If Starter.AttachmentViewModelInstance.InsertAttachment(item, m_task.GetId) == False Then
			MsgboxAsync("Failed to insert attachment: " & item.GetFilename, "Error")
		End If
	Next
	
	' Save the attachmentsthat are pending for deletion.
	For Each item As Attachment In m_pendingAttachmentDelete
		Log("Pending delete:" & item.GetFilename)
		If Starter.AttachmentViewModelInstance.DeleteAttachment(item) == False Then
			MsgboxAsync("Failed to delete attachment: " & item.GetFilename, "Error")
		End If
	Next
	
	' Close the activity after saving
	Activity.Finish
End Sub

Private Sub btnPriorityClear_Click
	ClearPriorityField
End Sub

Private Sub btnCancel_Click
	' Add the current editor result into the instance state.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_RESULT, Starter.EDITOR_RESULT_CANCEL)
	
	' Close the activity after cancelling
	Activity.Finish
End Sub

Private Sub checkRepeatSun_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(0, Checked)
End Sub

Private Sub checkRepeatMon_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(1, Checked)
End Sub

Private Sub checkRepeatTue_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(2, Checked)
End Sub

Private Sub checkRepeatWed_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(3, Checked)
End Sub

Private Sub checkRepeatThu_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(4, Checked)
End Sub

Private Sub checkRepeatFri_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(5, Checked)
End Sub

Private Sub checkRepeatSat_CheckedChange(Checked As Boolean)
	m_task.SetRepeat(6, Checked)
End Sub

Private Sub radioPriorityMedium_CheckedChange(Checked As Boolean)
	m_task.SetPriority(1)
End Sub

Private Sub radioPriorityLow_CheckedChange(Checked As Boolean)
	m_task.SetPriority(0)
End Sub

Private Sub radioPriorityHigh_CheckedChange(Checked As Boolean)
	m_task.SetPriority(2)
End Sub

Private Sub radioPriorityCritical_CheckedChange(Checked As Boolean)
	m_task.SetPriority(3)
End Sub

Private Sub btnDelete_Click
	Msgbox2Async("Do you really want to delete this task?", "Alert", "Yes", "Cancel", "No", _
	Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		Starter.TaskViewModelInstance.DeleteTask(m_task)
		Starter.GroupViewModelInstance.DeleteTaskGroup(m_task.GetId, m_group.GetID)
		' Close the editor after deleting,
		Activity.Finish
	End If
End Sub

Private Sub btnClearAll_Click
	editTitle.Text = ""
	editNotes.Text = ""
	ClearPriorityField
	ClearRadioButtons
	ClearDueDate
	
	editTitle.RequestFocus
End Sub

Private Sub ClearPriorityField
	radioPriorityCritical.Checked = False
	radioPriorityHigh.Checked = False
	radioPriorityLow.Checked = False
	radioPriorityMedium.Checked = False
End Sub

Private Sub ClearRadioButtons
	checkRepeatSun.Checked = False
	checkRepeatMon.Checked = False
	checkRepeatTue.Checked = False
	checkRepeatWed.Checked = False
	checkRepeatThu.Checked = False
	checkRepeatFri.Checked = False
	checkRepeatSat.Checked = False
End Sub

Private Sub LoadAttachments
	Dim attachments As List = Starter.AttachmentViewModelInstance.GetTaskAttachments(m_task.GetId())
	
	If attachments.IsInitialized Then
		For Each item As Attachment In attachments
			OnAddAttachment(item)
		Next
	End If
	
End Sub

Private Sub LoadTaskGroup
	Dim groups As List = Starter.GroupViewModelInstance.GetGroups()
	
	' Has index of 0 by default
	spnTaskGroup.Add("Tasks")
	spnTaskGroup.IndexOf("Tasks")
	
	If groups.IsInitialized Then
		For Each item As Group In groups
			spnTaskGroup.Add(item.GetTitle)
		Next
	End If
End Sub

Private Sub OnAddAttachment(item As Attachment)
	Dim panel As B4XView = xui.CreatePanel("")
		
	panel.SetLayoutAnimated(0, 0, 0, 100%x, 70dip)
	panel.LoadLayout("AttachmentItemLayout")
	panel.SetColorAndBorder(Theme.ForegroundColor, 0, Theme.ForegroundColor, 0)
	
	Dim viewHolder As AttachmentViewHolder
	viewHolder.Initialize
	viewHolder.Root = panel
	viewHolder.Icon = imgAttachmentIcon
	viewHolder.AttachmentLabel = lblAttachmentFileName
	viewHolder.OpenButton = btnAttachmentOpen
	viewHolder.OpenButton.Visible = False
	viewHolder.DeleteButton = btnAttachmentRemove
	viewHolder.ID = item.GetID
	
	clvAttachments.Add(panel, viewHolder)
End Sub

' Fill items into the due date Spinners.
Private Sub PopulateDueDate
	' Clear the spinner items to prevent potential item duplication bug.
	spinnerDueDateDay.Clear
	spinnerDueDateMonth.Clear
	
	' Populate with months. Include the 0 value or null.
	For i = 0 To 12
		' If i is equal to 0, then add a hint text as an option
		If i == 0 Then
			spinnerDueDateMonth.Add(SPINNER_DUE_DATE_MONTH_HINT_TEXT)
			Continue
		End If
		' Retrieves the month name based on the iteration value and add it to the spinner.
		spinnerDueDateMonth.Add(m_task.GetDueDate.GetMonthFromNum(i))
	Next
	
	' Populate with days. Include the 0 value or null.
	For i = 0 To 31
		' If i is equal to 0, then add a hint text as an option
		If i == 0 Then
			spinnerDueDateDay.Add(SPINNER_DUE_DATE_DAY_HINT_TEXT)
			Continue
		End If
		' Sets the current iteration value as a day.
		spinnerDueDateDay.Add(i)
	Next
End Sub

Private Sub spinnerDueDateMonth_ItemClick (Position As Int, Value As Object)
	' Retrieve the item as string from the Spinner.
	Dim monthStr As String = spinnerDueDateMonth.GetItem(Position)
	
	If monthStr == SPINNER_DUE_DATE_MONTH_HINT_TEXT Then
		' If the month value that is clicked is invalid, then clear the month
		' value that is set into m-task.
		m_task.GetDueDate.SetMonth(0)
	Else
		' Convert the month String retrieved from the spinner into an int.
		Dim month As Int = m_task.GetDueDate.GetNumericMonth(monthStr)
		
		' Set the month value into the task based on the month item that is
		' clicked from the spinner.
		m_task.GetDueDate.SetMonth(month)
	End If
	
End Sub

Private Sub spinnerDueDateDay_ItemClick (Position As Int, Value As Object)	
	Dim day As String = spinnerDueDateDay.GetItem(Position)
	
	If day == SPINNER_DUE_DATE_DAY_HINT_TEXT Then
		' If the day value that is clicked is invalid, then clear the day
		' value that is set into m-task.
		m_task.GetDueDate.SetDay(0)
	Else
		' Set the day value into the task based on the day item that is
		' clicked from the spinner.
		m_task.GetDueDate.SetDay(day)
	End If
	
End Sub

Private Sub btnRepeatClear_Click
	ClearRadioButtons
End Sub

' Validates if the date input is valid, ranging from January 1, 1970 until February 18, 2038.
' and is not unset.
Private Sub validateDueDate As Boolean
	Dim dateObj As Date = m_task.GetDueDate
	
	' Check if the date is unset. Unset values cannot be valid.
	If dateObj.IsUnset Then
		MsgboxAsync("Due date cannot be empty", "Error")
		Return False
	End If
	
	' Check if the year input is valid. The input only supports from years 1970 until 2038.
	If m_task.GetDueDate.IsRangeValid() == False Then
		MsgboxAsync("Due date is beyond the supported range: " & CRLF & _ 
		"January 1, 1970 to January 19, 2038", "Error")	
		Return False
	End If
	
	' Check for malformations within the date. The date could be on the valid range 1970 to 2038
	' but malformed date such as January -20, 2023 or February 29, 2025.
	If m_task.GetDueDate.IsDateValid() == False Then
		MsgboxAsync("Due date is not valid", "Error")
		Return False
	End If
	
	Return True
End Sub

Public Sub ClearDueDate()
	' Clear the due date-related spinners and edit texts.
	spinnerDueDateDay.SelectedIndex = 0
	spinnerDueDateMonth.SelectedIndex = 0
	editDueDateYear.Text = ""
	
	' Also call the Unset() function on the task model to avoid
	' errors.
	m_task.GetDueDate.Unset()
End Sub

Private Sub btnClearDueDate_Click
	ClearDueDate
End Sub

Private Sub clvAttachments_ItemClick (Index As Int, Value As Object)	
	Dim viewHolder As AttachmentViewHolder = Value	

	Starter.AttachmentViewModelInstance.OpenAttachment(viewHolder.ID)
End Sub

Private Sub btnAttachmentRemove_Click
	' Get the index of item from the list view that was clicked.
	Dim index As Long = clvAttachments.GetItemFromView(Sender)
	
	' Get the viewHolder of the item from list view.
	Dim viewHolder As AttachmentViewHolder = clvAttachments.GetValue(index)
	
	Dim itemId As Long  = viewHolder.ID
	
	' Check if the item ID is valid. 0 is the default ID of new attachments inserted into the database.
	If itemId > 0 Then
		' Get the item for the database for deletion of the database and the file system.
		Dim item As Attachment = Starter.AttachmentViewModelInstance.GetAttachment(itemId)
		
		' Add the item into the items pending for deletion.
		m_pendingAttachmentDelete.Add(item)
	End If
	
	' Remove the item from the list view.
	clvAttachments.RemoveAt(index)
End Sub

Private Sub btnAttachmentOpen_Click
	Dim index As Int = clvAttachments.GetItemFromView(Sender)
	
	Dim viewHolder As AttachmentViewHolder = clvAttachments.GetValue(index)
	
	' Sample code only!
	Dim item As Attachment
	
	ProgressDialogShow("Loading attachment...")
	
	Wait For (Starter.AttachmentViewModelInstance.GetAttachment(viewHolder.ID)) Complete _
	(Result As Attachment)
	ProgressDialogHide()
	item = Result
	
	' Sample code only!
	If item.IsInitialized Then
		MsgboxAsync(item.GetFilename, "Sample Test")
	Else
		MsgboxAsync("Error obtaining file!", "Error")
	End If
End Sub

Private Sub btnAddAttachment_Click
	'm_runtimePermission.CheckAndRequest(m_runtimePermission.PERMISSION_READ_EXTERNAL_STORAGE)
	
	Private filepicker As ContentChooser
	
	filepicker.Initialize("filepicker")
	filepicker.Show("*/*", "Choose file")
End Sub

Private Sub filepicker_Result (Success As Boolean, Dir As String, FileName As String)
	If Success Then
		' Obtain file information from a Uri that can be stored in a database.
		Try
			' Obtain a list of Attachments based on the URI retrieved from ContentChooser.
			Dim item As Attachment = Starter.AttachmentViewModelInstance.GetAttachmentsFromUri(FileName)
			
			MsgboxAsync("Title: " & item.GetFilename, "Info")
			
			' Add the attachment into the list.
			OnAddAttachment(item)
			
			' Add the attachment into the list of pending attachments to be saved.
			m_pendingAttachmentInsert.Add(item)
			
			' Do not save the file yet unless Save button is clicked.
		Catch
			Log(LastException)
		End Try
	Else
		MsgboxAsync("Unable to retrieve attachment", "Error")
	End If
End Sub

Private Sub spnTaskGroup_ItemClick (Position As Int, Value As Object)
	
End Sub