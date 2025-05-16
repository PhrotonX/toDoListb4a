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
	Private m_repeat As Repeat
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
	Private lblAddTask As Label
	Private editDueDateYear As EditText
	Private spinnerDueDateDay As Spinner
	Private spinnerDueDateMonth As Spinner
	Private clvAttachments As CustomListView
	Private btnAttachmentOpen As Button
	Private btnAttachmentRemove As Button
	'Private imgAttachmentIcon As ImageView
	Private lblAttachmentFileName As Label
	Private pnlAttachmentRoot As Panel
	Private spnTaskGroup As Spinner
	Private spnReminderHour As Spinner
	Private spnReminderMarker As Spinner
	Private spnReminderMinute As Spinner
	Private spnSnooze As Spinner
	Private toggleReminder As ToggleButton
	Private btnMoveToTrash As Button
	Private btnRestore As Button
	Private pnlEditorBar As Panel
	Private pnlRepeat As Panel
	Private btnClearAll As Button
	Private btnClearDueDate As Button
	Private btnClearNotes As Button
	Private btnClearTitle As Button
	Private btnPriorityClear As Button
	Private btnRepeatClear As Button
	Private btnAddAttachment As Button
	Private btnOpenCanvas As Button
	Private Label2 As Label
	Private Label3 As Label
	Private lblAttachments As Label
	Private lblDueDate As Label
	Private lblNotes As Label
	Private lblPrority As Label
	Private lblRepeat As Label
	Private lblRepeatFri As Label
	Private lblRepeatMon As Label
	Private lblRepeatSat As Label
	Private lblRepeatSun As Label
	Private lblRepeatThu As Label
	Private lblRepeatTue As Label
	Private lblRepeatWed As Label
	Private lblSnooze As Label
	Private lblTaskGroup As Label
	Private lblTitle As Label
	Private pnlAttachmentslbl As Panel
	Private pnlContainerLblRepeat As Panel
	Private pnlNoteslbl As Panel
	Private pnlPrioritylbl As Panel
	Private pnlReminderlbl As Panel
	Private pnlRepeatlbl As Panel
	Private pnlSnoozelbl As Panel
	Private pnlTaskGrplbl As Panel
	Private pnlTitlelbl As Panel
	Private reminderlbl As Label
	Private btnSave As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("EditorLayout")
	
	m_pendingAttachmentInsert.Initialize
	m_pendingAttachmentDelete.Initialize
	
	editorScrollView.Panel.LoadLayout("EditorScrollLayout")
	
	OnLoadText
	
	pnlEditorBar.Elevation = 10
	EditText_removeunderline
	
	If GetDeviceLayoutValues.Scale > 2 Then
		editorScrollView.Panel.Height = 7912
	End If
	
	Dim cd As ColorDrawable
	cd.Initialize(Colors.Transparent, 0) ' 0 is the corner radius
	toggleReminder.Background = cd
	
	' Initialize variables
	m_task.Initialize
	
	m_repeat.Initialize
	
	' Retrieve the data sent by MainActivity to check the editor mode.
	m_mode = Starter.InstanceState.Get(Starter.EXTRA_EDITOR_MODE)
	
	' Fill the spinners with data
	FormHelper.PopulateDate(spinnerDueDateMonth, spinnerDueDateDay)
	FormHelper.PopulateTime(spnReminderHour, spnReminderMinute, spnReminderMarker)
	FormHelper.PopulateSnooze(spnSnooze)
	
	' Load the task groups
	FormHelper.PopulateTaskGroups(spnTaskGroup)
	
	' Check the editor mode to set the appropriate EditorActivity functionalities.
	If m_mode == Starter.EDITOR_MODE_EDIT Then
		' Rename the activity if editing.
		lblAddTask.Text = Starter.Lang.Get("edit_task")
		
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
		m_repeat = Starter.RepeatViewModelInstance.GetTaskRepeat(m_task.GetId)
		
		checkRepeatSun.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_SUNDAY)
		checkRepeatMon.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_MONDAY)
		checkRepeatTue.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_TUESDAY)
		checkRepeatWed.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_WEDNESDAY)
		checkRepeatThu.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_THURSDAY)
		checkRepeatFri.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_FRIDAY)
		checkRepeatSat.Checked = m_repeat.IsEnabled(m_repeat.REPEAT_SATURDAY)
		
		' Update the selected value of due date month spinner based on the numeric month that is 
		' set on m_task.
		spinnerDueDateMonth.SelectedIndex = m_task.GetDueDate.GetMonth
		' Update the selected value of due date day spinner based on the day that is
		' set on m_task.
		spinnerDueDateDay.SelectedIndex = m_task.GetDueDate.GetDay
		editDueDateYear.Text = m_task.GetDueDate.GetYear
		
		' Load the attachments
		LoadAttachments
		
		' Load whether reminder field is enabled or not.
		toggleReminder.Checked = m_task.IsReminderEnabled
		
		' Load reminder field data.
		spnReminderHour.SelectedIndex = _
			spnReminderHour.IndexOf(m_task.Reminder.GetNumWithLeadingZero(m_task.Reminder.GetHour2( _ 
			Starter.SettingsViewModelInstance.Is24HourFormatEnabled)))
		spnReminderMinute.SelectedIndex = _
			spnReminderMinute.IndexOf(m_task.Reminder.GetNumWithLeadingZero(m_task.Reminder.GetMinute))
		spnReminderMarker.SelectedIndex = _
			spnReminderMarker.IndexOf(m_task.Reminder.GetMarker)
			
		' Load snooze data.
		spnSnooze.SelectedIndex = spnSnooze.IndexOf(m_task.Snooze.GetSnoozeInfo())
		
		' Load the selected task group.
		spnTaskGroup.SelectedIndex = spnTaskGroup.IndexOf(m_group.GetTitle)
		
		' Hide the move to trash button if the current opened task is already marked as deleted.
		If m_task.IsDeleted() == True Then
			btnRestore.Visible = True
			btnMoveToTrash.Visible = False
			btnDelete.Visible = True
		Else
			' Show the move to trash buttons while hiding other buttons when the task is not marked as deleted.
			btnRestore.Visible = False
			btnMoveToTrash.Visible = True
			btnDelete.Visible = False
		End If
	Else If m_mode == Starter.EDITOR_MODE_CREATE Then		
		' Disable the delete-related buttons if the editor mode is EDITOR_MODE_CREATE. No tasks can be
		' deleted while still being created.
		btnDelete.Visible = False
		btnRestore.Visible = False
		btnMoveToTrash.Visible = False
		
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
		
		' Set the reminder field as enabled by default.
		toggleReminder.Checked = False
		
		radioPriorityMedium.Checked = True
		m_task.SetPriority(m_task.PRIORITY_MEDIUM)
		
		' Set the hour and marker reminder field
		Dim currentHour As Int = DateTime.GetHour(DateTime.Now)
		
		' Log the current hour if debug mode is enabled.
		If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
			Log("EditorActivity: currentHour " & currentHour)
		End If
		
		If 6 < currentHour And currentHour <= 20 Then
			' Set the current hour plus 2 hour as the default value of the reminder fields if the current hour
			' is ranging within 6:00 AM until 8:00 PM (20:00)
			m_task.Reminder.SetHour(currentHour + 2)
			
			' Logging for debug mode.
			If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
				Log("EditorActivity hour: " & m_task.Reminder.GetNumWithLeadingZero(m_task.Reminder.GetHour2( _
				Starter.SettingsViewModelInstance.Is24HourFormatEnabled())))
				Log("EditorActivity hour index: " & spnReminderHour.IndexOf(m_task.Reminder.GetNumWithLeadingZero(m_task.Reminder.GetHour2( _
				Starter.SettingsViewModelInstance.Is24HourFormatEnabled()))))
			End If
			
			' Set the current hour plus 2 hour as the default value of the reminder fields.
			spnReminderHour.SelectedIndex = _
				spnReminderHour.IndexOf(m_task.Reminder.GetNumWithLeadingZero(m_task.Reminder.GetHour2( _ 
				Starter.SettingsViewModelInstance.Is24HourFormatEnabled())))
			spnReminderMarker.SelectedIndex = spnReminderMarker.IndexOf(m_task.Reminder.GetMarker())
		Else
			' Set the default 8 o'clock as the default time value if the time range condition above has failed.
			
			' Logging for debug mode
			Log("EditorActivity hour: " & m_task.Reminder.GetNumWithLeadingZero(8))
			Log("EditorActivity hour index: " & spnReminderHour.IndexOf(m_task.Reminder.GetNumWithLeadingZero(8)))
			
			' Set the 8:00 hour value.
			spnReminderHour.SelectedIndex = _
				spnReminderHour.IndexOf(m_task.Reminder.GetNumWithLeadingZero(8))
			spnReminderMarker.SelectedIndex = spnReminderMarker.IndexOf(m_task.Reminder.MARKER_AM)
		End If
		
		Log("EditorActiivty marker: " & m_task.Reminder.GetMarker())
		
		' Set the minute reminder field.
		spnReminderMinute.SelectedIndex = spnReminderMinute.IndexOf(m_task.Reminder.GetNumWithLeadingZero(0))
		
		' Set the snooze field.
		spnSnooze.SelectedIndex = spnSnooze.IndexOf(m_task.Snooze.SNOOZE_OFF)
		
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

Private Sub OnLoadText
	lblAddTask.Text = Starter.Lang.Get("add_task")
	lblAttachments.Text = Starter.Lang.Get("attachments") & ":"
	lblDueDate.Text = Starter.Lang.Get("due_date") & ":"
	lblNotes.Text = Starter.Lang.Get("notes") & ":"
	lblPrority.Text = Starter.Lang.Get("priority") & ":"
	lblRepeat.Text = Starter.Lang.Get("repeat") & ":"
	lblRepeatFri.Text = Starter.Lang.Get("friday_abbr")
	lblRepeatMon.Text = Starter.Lang.Get("monday_abbr")
	lblRepeatSat.Text = Starter.Lang.Get("saturday_abbr")
	lblRepeatSun.Text = Starter.Lang.Get("sunday_abbr")
	lblRepeatThu.Text = Starter.Lang.Get("thursday_abbr")
	lblRepeatTue.Text = Starter.Lang.Get("tuesday_abbr")
	lblRepeatWed.Text = Starter.Lang.Get("wednesday_abbr")
	lblSnooze.Text = Starter.Lang.Get("snooze") & ":"
	lblTaskGroup.Text = Starter.Lang.Get("task_group")
	lblTitle.Text = Starter.Lang.Get("title") & ":"
	editTitle.Hint = Starter.Lang.Get("title_hint")
	editNotes.Hint = Starter.Lang.Get("notes_hint")
	reminderlbl.Text = Starter.Lang.Get("reminder")
	editDueDateYear.Hint = Starter.Lang.Get("year")
	
	radioPriorityCritical.Text = Starter.Lang.Get("critical")
	radioPriorityHigh.Text = Starter.Lang.Get("high")
	radioPriorityMedium.Text = Starter.Lang.Get("medium")
	radioPriorityLow.Text = Starter.Lang.Get("low")
	
	btnClearAll.Text = Starter.Lang.Get("clear_all")
	btnClearDueDate.Text = Starter.Lang.Get("clear")
	btnClearNotes.Text = Starter.Lang.Get("clear_uppercase")
	btnClearTitle.Text = Starter.Lang.Get("clear_uppercase")
	btnPriorityClear.Text = Starter.Lang.Get("clear_uppercase")
	btnRepeatClear.Text = Starter.Lang.Get("clear_uppercase")
	
	btnRestore.Text = Starter.Lang.Get("restore")
	btnAddAttachment.Text = Starter.Lang.Get("add_attachment_plus")
	btnMoveToTrash.Text = Starter.Lang.Get("move_to_trash")
	btnSave.Text = Starter.Lang.Get("save_uppercase")
	btnOpenCanvas.Text = Starter.Lang.Get("canvas")
	
	toggleReminder.TextOn = Starter.Lang.Get("on_uppercase")
	toggleReminder.TextOff = Starter.Lang.Get("off_uppercase")
	
End Sub

Private Sub btnSave_Click
	OnSaveTask
End Sub

Private Sub OnSaveTask
	' Add the current editor result into the instance state.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_RESULT, Starter.EDITOR_RESULT_SAVE)
	
	' Validate title
	If FormHelper.ValidateTitle(m_task, editTitle) == False Then
		Return
	End If
	
	m_task.SetTitle(editTitle.Text)
	m_task.SetNotes(editNotes.Text)
	
	' Priority, Due Date Day, Due date Month, and Repeat values are already set once the
	' buttons are clicked.
	
	' Save and validate priority.
	If FormHelper.ValidatePriority(radioPriorityCritical, radioPriorityHigh, radioPriorityMedium, _
		radioPriorityLow) == False Then
		Return
	End If
	
	' Validate the due date values
	If FormHelper.ValidateDate(m_task.GetDueDate(), editDueDateYear) == False Then
		Return
	End If
	
	' Get the selected value whether reminders are enabled or not.
	toggleReminder.Checked = m_task.IsReminderEnabled
	
	' Get the selected value of reminders field.
	FormHelper.GetSelectedTime(m_task.Reminder, spnReminderHour, spnReminderMinute, spnReminderMarker)
	
	' Get the selected snooze
	m_task.Snooze.SetSnooze(m_task.Snooze.GetSnoozeFromText(spnSnooze.SelectedItem))
	
	' Get the selected group
	Dim selectedGroup As Group	
	Dim groupTitle As String = FormHelper.GetSelectedGroup(spnTaskGroup)
	If groupTitle <> "" Then
		selectedGroup = Starter.GroupViewModelInstance.GetGroupByTitle(groupTitle)
	Else
		selectedGroup.Initialize(0)
	End If
	
	
	' Check the editor mode to set the appropriate EditorActivity saving functionalities.
	If m_mode == Starter.EDITOR_MODE_EDIT Then
		Starter.TaskViewModelInstance.UpdateTask(m_task)
		
		Starter.GroupViewModelInstance.UpdateTaskGroup(m_task.GetId, m_group.GetID, selectedGroup.GetID)
		
		Starter.RepeatViewModelInstance.UpdateRepeat(m_repeat)
	Else If m_mode == Starter.EDITOR_MODE_CREATE Then
		Starter.TaskViewModelInstance.InsertTask(m_task)
		
		m_task.SetId(Starter.ToDoDatabaseViewModelInstance.GetLastInsertedID())
		
		Starter.GroupViewModelInstance.InsertTaskGroup(m_task.GetId, selectedGroup.GetID)
		
		Starter.RepeatViewModelInstance.InsertTaskRepeat(m_task.GetId, m_repeat)
	End If
	
	' Get the repeat values but with repeat_id.
	m_repeat = Starter.RepeatViewModelInstance.GetTaskRepeat(m_task.GetId)
	
	Starter.RepeatViewModelInstance.CreateOrUpdateNotificationSchedule(m_task, m_repeat)
	
	' Save the attachments that are pending for insertion.
	For Each item As Attachment In m_pendingAttachmentInsert
		If Starter.AttachmentViewModelInstance.InsertAttachment(item, m_task.GetId) == False Then
			MsgboxAsync(Starter.Lang.Get("attachment_insert_failed") & ": " & item.GetFilename, "Error")
		End If
	Next
	
	' Save the attachmentsthat are pending for deletion.
	For Each item As Attachment In m_pendingAttachmentDelete
		Log("Pending delete:" & item.GetFilename)
		If Starter.AttachmentViewModelInstance.DeleteAttachment(item) == False Then
			MsgboxAsync(Starter.Lang.Get("attachment_delete_failed") & ": " & item.GetFilename, "Error")
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
	m_repeat.SetEnabled(0, Checked)
End Sub

Private Sub checkRepeatMon_CheckedChange(Checked As Boolean)
	m_repeat.SetEnabled(1, Checked)
End Sub

Private Sub checkRepeatTue_CheckedChange(Checked As Boolean)
	m_repeat.SetEnabled(2, Checked)
End Sub

Private Sub checkRepeatWed_CheckedChange(Checked As Boolean)
	m_repeat.SetEnabled(3, Checked)
End Sub

Private Sub checkRepeatThu_CheckedChange(Checked As Boolean)
	m_repeat.SetEnabled(4, Checked)
End Sub

Private Sub checkRepeatFri_CheckedChange(Checked As Boolean)
	m_repeat.SetEnabled(5, Checked)
End Sub

Private Sub checkRepeatSat_CheckedChange(Checked As Boolean)
	m_repeat.SetEnabled(6, Checked)
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
	Msgbox2Async(Starter.Lang.Get("task_delete_question"), Starter.Lang.Get("alert"), _ 
	Starter.Lang.Get("yes"), Starter.Lang.Get("cancel"), Starter.Lang.Get("no"), _
	Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		Starter.TaskViewModelInstance.DeleteTask(m_task)
		Starter.GroupViewModelInstance.DeleteTaskGroup(m_task.GetId, m_group.GetID)
		Starter.RepeatViewModelInstance.DeleteRepeat(m_repeat)
		
		' Set the extra ID into 0.
		Starter.InstanceState.Put(Starter.EXTRA_EDITOR_TASK_ID, 0)
		
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
		Log("attachments.Size: " & attachments.Size)
		For Each item As Attachment In attachments
			OnAddAttachment(item)
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
	'viewHolder.Icon = imgAttachmentIcon
	viewHolder.AttachmentLabel = lblAttachmentFileName
	viewHolder.AttachmentLabel.Text = item.GetFilename
	viewHolder.OpenButton = btnAttachmentOpen
	viewHolder.OpenButton.Visible = False
	viewHolder.DeleteButton = btnAttachmentRemove
	viewHolder.ID = item.GetID
	'viewHolder.Icon.Gravity = Gravity.FILL
	
	clvAttachments.Add(panel, viewHolder)
End Sub

Private Sub spinnerDueDateMonth_ItemClick (Position As Int, Value As Object)
	FormHelper.SetMonthValue(spinnerDueDateMonth, m_task.GetDueDate, Position)
End Sub

Private Sub spinnerDueDateDay_ItemClick (Position As Int, Value As Object)	
	FormHelper.SetDayValue(spinnerDueDateDay, m_task.GetDueDate, Position)
End Sub

Private Sub btnRepeatClear_Click
	ClearRadioButtons
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
			
			MsgboxAsync(Starter.Lang.Get("title") & ": " & item.GetFilename, Starter.Lang.Get("info"))
			
			' Add the attachment into the list.
			OnAddAttachment(item)
			
			' Add the attachment into the list of pending attachments to be saved.
			m_pendingAttachmentInsert.Add(item)
			
			' Do not save the file yet unless Save button is clicked.
		Catch
			Log(LastException)
		End Try
	Else
		MsgboxAsync(Starter.Lang.Get("attachment_retrieve_failed"), Starter.Lang.Get("error"))
	End If
End Sub

Private Sub spnTaskGroup_ItemClick (Position As Int, Value As Object)
	
End Sub

Private Sub toggleReminder_CheckedChange(Checked As Boolean)
	toggleReminder.TextColor = Colors.RGB(73, 93, 143)
	m_task.SetReminderEnabled(Checked)
	
	spnReminderHour.Enabled = Checked
	spnReminderMinute.Enabled = Checked
	spnReminderMarker.Enabled = Checked
	spnSnooze.Enabled = Checked
	
	If Checked = False Then
		toggleReminder.TextColor = Colors.Gray
	End If
End Sub

Private Sub btnRestore_Click
	Msgbox2Async(Starter.Lang.Get("task_restore_question"), Starter.Lang.Get("alert"), _
	Starter.Lang.Get("yes"), Starter.Lang.Get("cancel"), Starter.Lang.Get("no"), _
	Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		m_task.SetDeleted(False)
	
		OnSaveTask
	End If
End Sub

Private Sub btnMoveToTrash_Click
	Msgbox2Async(Starter.Lang.Get("task_move_to_trash_questions"), Starter.Lang.Get("alert"), _
	Starter.Lang.Get("yes"), Starter.Lang.Get("cancel"), Starter.Lang.Get("no"), _
	Null, True)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		m_task.SetDeleted(True)
	
		OnSaveTask
	End If
End Sub

Private Sub EditText_removeunderline
	Dim cd As ColorDrawable
	cd.Initialize(Colors.Transparent, 0)
	editTitle.Background = cd
	editNotes.Background = cd
	editDueDateYear.Background = cd
End Sub

Private Sub btnClearTitle_Click
	editTitle.Text = ""
	m_task.SetTitle("")
End Sub

Private Sub btnClearNotes_Click
	editNotes.Text = ""
	m_task.SetNotes("")
End Sub