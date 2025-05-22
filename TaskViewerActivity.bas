B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.2
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

	Private btnBack As Button
	Private taskView As ScrollView
	Private viewDueDate As Label
	Private viewNotes As Label
	Private viewPriority As Label
	Private viewRepeat As Label
	Private viewTitle As CheckBox
	Private viewCreatedAt As Label
	Private viewModifiedAt As Label
	
	Private m_selectedColor As Int = Theme.COLOR_DEFAULT
	
	' This variable is responsible for handling the current data that can be used for performing
	' CRUD into the database.
	Private m_task As ToDo
	Private m_repeat As Repeat
	Private Label1 As Label
	
	Private viewTaskGroup As Label
	Private btnAttachmentOpen As Button
	Private btnAttachmentRemove As Button
	Private imgAttachmentIcon As ImageView
	Private lblAttachmentFileName As Label
	Private pnlAttachmentRoot As Panel
	
	Private svAttachments As ScrollView
	Private clvAttachments As CustomListView
	Private pnlTaskViewBar As Panel
	Private lblListofAttachments As Label
	Private lblListofCanvas As Label
	Private viewCreatedAtLbl As Label
	Private viewDueDateLbl As Label
	Private viewModifiedlbl As Label
	Private viewNotesLbl As Label
	Private viewPriorityLbl As Label
	Private viewReminderlbl As Label
	Private viewReminders As Label
	Private viewRepeatLbl As Label
	Private viewSnooze As Label
	Private viewSnoozeLbl As Label
	Private viewTaskGrouplbl As Label
	Private viewTitleLbl As Label
	Private lblTask As Label
	Private btnEdit As Button
	Private hsvCanvas As HorizontalScrollView
	Private Panel1 As Panel
	Private pnlAttachments As Panel
	Private pnlCanvas As Panel
	
	Private m_attachmentScrollIndex As Int = -1
	Private lblAttachmentIcon As Label
	Private btnAttachmentUp As Button
	Private btnAttachmentDown As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("TaskViewLayout")
	button_design

	' Add the TaskViewScrollLayout as the view of taskView of the ScrollView in TaskViewLayout.
	taskView.Panel.LoadLayout("TaskViewScrollLayout")
	pnlTaskViewBar.Elevation = 10

	OnLoadTasks
End Sub


Private Sub OnLoadTasks()
	lblTask.Text = Starter.Lang.Get("task")
	btnEdit.Text = Starter.Lang.Get("edit_uppercase")
	
	viewCreatedAtLbl.Text = Starter.Lang.Get("created_at")
	viewModifiedlbl.Text = Starter.Lang.Get("updated_at")
	viewTitleLbl.Text = Starter.Lang.Get("title")
	viewNotesLbl.Text = Starter.Lang.Get("notes")
	viewDueDateLbl.Text = Starter.Lang.Get("due_date")
	viewPriorityLbl.Text = Starter.Lang.Get("priority")
	viewReminderlbl.Text = Starter.Lang.Get("reminder")
	viewRepeatLbl.Text = Starter.Lang.Get("repeat")
	viewSnoozeLbl.Text = Starter.Lang.Get("snooze")
	viewTaskGrouplbl.Text = Starter.Lang.Get("task_group")
	lblListofCanvas.Text = Starter.Lang.Get("canvas")
	lblListofAttachments.Text = Starter.Lang.Get("attachments")
End Sub

Private Sub button_design
	'Makes the bg, border of the buttons transparent
	
	Dim transparentBg As ColorDrawable
	
	transparentBg.Initialize(Colors.Transparent, 0)
	btnBack.Background = transparentBg
End Sub

Sub Activity_Resume
	Darkmode
	' Prevent instance errors.
	Starter.CheckInstanceState
	
	' Replace the task ID if there is a task_id sent by a notification.
	Dim in As Intent = Activity.GetStartingIntent
	If in.IsInitialized And in.HasExtra("Notification_Tag") Then
		Dim task_id_fromNotification As String = in.GetExtra("Notification_Tag")
		
		If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
			Log("TaskViewerActivity: task_id_fromNotification " & task_id_fromNotification)
		End If
		
		If task_id_fromNotification > 0 Then
			Starter.InstanceState.Put(Starter.EXTRA_EDITOR_TASK_ID, task_id_fromNotification)
		End If
	End If
	
	Dim task_id As Long = Starter.InstanceState.Get(Starter.EXTRA_EDITOR_TASK_ID)
	
	If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
		Log("TaskViewerActivity: task_id " & task_id)
	End If
	
	' Retrieve the task sent by MainActivity.
	m_task = Starter.TaskViewModelInstance.GetTask(task_id)
	
	If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
		Log("TaskViewerActivity: m_task " & m_task)
	End If
	
	' Validate if the task is null.
	If m_task <> Null Then
		If task_id == 0 Then
			Activity.Finish
		End If
		
		' Validate if the task exists by checking the task ID which cannot be zero on
		' the database. Else, return back to MainActivity.
		If m_task.GetId == 0 Then
			Activity.Finish
		End If
		
		' Get the repeat information from task.
		m_repeat = Starter.RepeatViewModelInstance.GetTaskRepeat(m_task.GetId)
		
		' Display the retrieved task into the views.
		viewTitle.Text = m_task.GetTitle
		
		viewTitle.Checked = m_task.Done
		
		' Notes
		If m_task.GetNotes == "" Then
			viewNotes.Text = Starter.Lang.Get("none")
		Else
			viewNotes.Text = m_task.GetNotes
		End If
		
		' Repeat
		If m_repeat.GetRepeatInfo == "" Then
			viewRepeat.Text = Starter.Lang.Get("none")
		Else
			viewRepeat.Text = m_repeat.GetRepeatInfo
		End If
		
		' Reminder
		If m_task.IsReminderEnabled == True Then
			Dim reminderStr As String = m_task.Reminder.GetFormattedTime(Starter.SettingsViewModelInstance.Is24HourFormatEnabled)
			If reminderStr == "" Then
				viewReminders.Text = Starter.Lang.Get("none")
			Else
				viewReminders.Text = reminderStr
			End If
		Else
			viewReminders.Text = Starter.Lang.Get("off")
		End If
		
		
		viewSnooze.Text = Starter.Lang.Get(m_task.Snooze.GetSnoozeInfo)
		
		viewPriority.Text = Starter.Lang.Get(m_task.GetPriorityInfo)
		viewDueDate.Text = m_task.GetDueDate.GetFormattedDate(Starter.Lang)
		viewCreatedAt.Text = m_task.GetCreatedAt.GetFormattedDateAndTime( _
			Starter.SettingsViewModelInstance.Is24HourFormatEnabled, Starter.Lang)
		viewModifiedAt.Text = m_task.GetUpdatedAt.GetFormattedDateAndTime( _
			Starter.SettingsViewModelInstance.Is24HourFormatEnabled, Starter.Lang)
		
		' Load group to load color and group title
		Dim taskGroup As Group = Starter.GroupViewModelInstance.GetGroupByTaskId(m_task.GetId())
		If taskGroup.IsInitialized Then
			viewTaskGroup.Text = taskGroup.GetTitle
			
			m_selectedColor = taskGroup.GetColor
			
			If Starter.SettingsViewModelInstance.IsDarkModeEnabled == False Then
				pnlTaskViewBar.Color = Theme.GetPrimaryColor(taskGroup.GetColor)
				
				taskView.Color = Theme.GetBackgroundColor(taskGroup.GetColor)
				
				Panel1.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewNotes.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewDueDate.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewPriority.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewReminders.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewRepeat.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewSnooze.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewTaskGroup.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewCreatedAt.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
				viewModifiedAt.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
		
				pnlAttachments.Color = Theme.GetBackgroundColor2(taskGroup.GetColor)
			Else
				lblTask.TextColor = Theme.GetTextColor(taskGroup.GetColor)
				
				btnEdit.TextColor = Theme.GetTextColor(taskGroup.GetColor)
				btnBack.TextColor = Theme.GetTextColor(taskGroup.GetColor)
			End If
		Else
			viewTaskGroup.Text = Starter.GroupViewModelInstance.DefaultGroup().GetTitle()
		End If
		
		LoadAttachments
	Else
		Activity.Finish
	End If
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

' Return back to MainActivity if back button is clicked.
Sub btnBack_Click
	Activity.Finish
End Sub

' Open editor activity.
Private Sub btnEdit_Click
	' Send the task and group ID into EditorActivity.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_TASK_ID, m_task.GetId)
	
	' Set the EditorActivity mode into edit mode.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_MODE, Starter.EDITOR_MODE_EDIT)
	
	m_task = Null
	
	' Start the EditorActivity.
	StartActivity(EditorActivity)
End Sub

' Make update transactions into the database if checkbox tick occured.
Private Sub viewTitle_CheckedChange(Checked As Boolean)	
	If m_task.Done <> Checked Then
		' Toggle the completions status of the task
		m_task.Done = Checked
		
		' Play task completion sound.
		If Checked Then
			Starter.TaskViewModelInstance.PlayTaskCompletionSound
		End If
	
		' Update the task to reflect changes with the completion value.
		Starter.TaskViewModelInstance.UpdateTask(m_task)
		Starter.RepeatViewModelInstance.CalculateSchedule(m_task)
	End If
End Sub

Private Sub pnlAttachmentRoot_Click
	Dim index As Int = clvAttachments.GetItemFromView(Sender)
	
	OnAttachmentOpen(index)
End Sub

Private Sub btnAttachmentRemove_Click
	MsgboxAsync("Editing is not supported on task viewer", "Error")
End Sub

Private Sub btnAttachmentOpen_Click
	Dim index As Int = clvAttachments.GetItemFromView(Sender)
	
	OnAttachmentOpen(index)
End Sub

Private Sub LoadAttachments
	clvAttachments.Clear
	' Load the attachments list layout.
	'svAttachments.Panel.LoadLayout("attachmentlistlayout")
	
	'Log("svAttachments: " & svAttachments)
	'Log("svAttachments.Panel: " & svAttachments.Panel)

	Dim attachments As List = Starter.AttachmentViewModelInstance.GetTaskAttachments(m_task.GetId())
	
	If attachments.IsInitialized Then
		Log("m_task.GetId(): " & m_task.GetId())
		Log("attachments.Size: " & attachments.Size)
		For Each item As Attachment In attachments
			OnAddAttachment(item)
		Next
	End If
	
End Sub

Private Sub OnAddAttachment(item As Attachment)
	Dim panel As B4XView = xui.CreatePanel("")
		
	panel.SetLayoutAnimated(0, 0, 0, 100%x, 65dip)
	panel.LoadLayout("AttachmentItemLayout")
	panel.SetColorAndBorder(Colors.Transparent, 0, Colors.Transparent, 15dip)
	
	Dim viewHolder As AttachmentViewHolder
	viewHolder.Initialize
	viewHolder.Root = panel
	'viewHolder.Icon = imgAttachmentIcon
	viewHolder.AttachmentLabel = lblAttachmentFileName
	If item.GetFilename.Length > 45 Then
		viewHolder.AttachmentLabel.Text = item.GetFilename.SubString2(0, 44) & "..."
	Else
		viewHolder.AttachmentLabel.Text = item.GetFilename
	End If
	viewHolder.OpenButton = btnAttachmentOpen
	viewHolder.DeleteButton = btnAttachmentRemove
	' Hide the remove button for attachments. Attachments cannot be edited within TaskViewerActivity.
	viewHolder.DeleteButton.Visible = False
	viewHolder.ID = item.GetID
	
	Dim b4xPanel As B4XView = pnlAttachmentRoot
	
	If Starter.SettingsViewModelInstance.IsDarkModeEnabled == False Then
		lblAttachmentFileName.TextColor = Colors.RGB(33,37,41)
		lblAttachmentIcon.TextColor = Colors.RGB(33,37,41)
		'pnlAttachmentRoot.Color = Colors.White
		b4xPanel.SetColorAndBorder(Colors.ARGB(16, 0, 0, 0), 0, _
			Colors.ARGB(16, 0, 0, 0), 15dip)
	Else
		lblAttachmentIcon.TextColor = Theme.ForegroundText
		lblAttachmentFileName.TextColor = Theme.ForegroundText
		'pnlAttachmentRoot.Color = Colors.Black
		b4xPanel.SetColorAndBorder(Colors.Black, 0, Colors.Black, 15dip)
	End If
	
	clvAttachments.Add(panel, viewHolder)
	
	Log("clvAttachments: " & clvAttachments.Size)
End Sub


Private Sub OnAttachmentOpen(index As Int)
	Dim viewHolder As AttachmentViewHolder = clvAttachments.GetValue(index)
	
	' Sample code only!
	Dim item As Attachment
	
	ProgressDialogShow("Loading attachment...")
	
	'Wait For (Starter.AttachmentViewModelInstance.GetAttachment(viewHolder.ID)) Complete _
	'(Result As Attachment)
	item = Starter.AttachmentViewModelInstance.GetAttachment(viewHolder.ID)
	ProgressDialogHide()
	'item = Result
	
	' Sample code only!
	If item.IsInitialized Then
		Starter.AttachmentViewModelInstance.OpenAttachment(item.GetID)
	Else
		MsgboxAsync("Error obtaining file!", "Error")
	End If
End Sub

Private Sub clvAttachments_ItemClick (Index As Int, Value As Object)
	Dim viewHolder As AttachmentViewHolder = Value

	Starter.AttachmentViewModelInstance.OpenAttachment(viewHolder.ID)
End Sub

Private Sub Darkmode
	If Starter.SettingsViewModelInstance.IsDarkModeEnabled() = False Then
		lblTask.TextColor = Colors.White
		btnBack.TextColor = Colors.White
		btnEdit.TextColor = Colors.White
		
		taskView.Color = Colors.RGB(244,246,250)
		pnlTaskViewBar.Color = Colors.RGB(75,93,140)
		
		viewTitleLbl.TextColor = Colors.RGB(33,37,41)
		viewNotesLbl.TextColor = Colors.RGB(33,37,41)
		viewDueDateLbl.TextColor = Colors.RGB(33,37,41)
		viewPriorityLbl.TextColor = Colors.RGB(33,37,41)
		viewReminderlbl.TextColor = Colors.RGB(33,37,41)
		viewRepeatLbl.TextColor = Colors.RGB(33,37,41)
		viewSnoozeLbl.TextColor = Colors.RGB(33,37,41)
		lblListofCanvas.TextColor = Colors.RGB(33,37,41)
		lblListofAttachments.TextColor = Colors.RGB(33,37,41)
		viewTaskGrouplbl.TextColor = Colors.RGB(33,37,41)
		viewCreatedAtLbl.TextColor = Colors.RGB(33,37,41)
		viewModifiedlbl.TextColor = Colors.RGB(33,37,41)
		Panel1.Color = Theme.RootColor
		viewTitle.TextColor = Colors.RGB(33,37,41)
		viewNotes.TextColor = Colors.RGB(33,37,41)
		viewDueDate.TextColor = Colors.RGB(33,37,41)
		viewPriority.TextColor = Colors.RGB(33,37,41)
		viewReminders.TextColor = Colors.RGB(33,37,41)
		viewRepeat.TextColor = Colors.RGB(33,37,41)
		viewSnooze.TextColor = Colors.RGB(33,37,41)
		hsvCanvas.Color = Colors.RGB(232,236,245)
		'svAttachments.Color = Colors.RGB(232,236,245)
		viewTaskGroup.TextColor = Colors.RGB(33,37,41)
		viewCreatedAt.TextColor = Colors.RGB(33,37,41)
		viewModifiedAt.TextColor = Colors.RGB(33,37,41)
		
		
		viewTitle.Color = Colors.Transparent
		Panel1.Color = Colors.RGB(232,236,245)
		viewNotes.Color = Colors.RGB(232,236,245)
		viewDueDate.Color = Colors.RGB(232,236,245)
		viewPriority.Color = Colors.RGB(232,236,245)
		viewReminders.Color = Colors.RGB(232,236,245)
		viewRepeat.Color = Colors.RGB(232,236,245)
		viewSnooze.Color = Colors.RGB(232,236,245)
		viewTaskGroup.Color = Colors.RGB(232,236,245)
		viewCreatedAt.Color = Colors.RGB(232,236,245)
		viewModifiedAt.Color = Colors.RGB(232,236,245)
		
		pnlAttachments.Color = Colors.RGB(232,236,245)
	Else
		lblTask.TextColor = Theme.ForegroundText
		btnBack.TextColor = Theme.ForegroundText
		btnEdit.TextColor = Theme.ForegroundText
		
		taskView.Color = Theme.DarkbackgroundColor
		pnlTaskViewBar.Color = Colors.RGB(28,28,28)
		
		viewTitleLbl.TextColor = Theme.ForegroundText
		viewNotesLbl.TextColor = Theme.ForegroundText
		viewDueDateLbl.TextColor = Theme.ForegroundText
		viewPriorityLbl.TextColor = Theme.ForegroundText
		viewReminderlbl.TextColor = Theme.ForegroundText
		viewRepeatLbl.TextColor = Theme.ForegroundText
		viewSnoozeLbl.TextColor = Theme.ForegroundText
		lblListofCanvas.TextColor = Theme.ForegroundText
		lblListofAttachments.TextColor = Theme.ForegroundText
		viewTaskGrouplbl.TextColor = Theme.ForegroundText
		viewCreatedAtLbl.TextColor = Theme.ForegroundText
		viewModifiedlbl.TextColor = Theme.ForegroundText
		Panel1.Color = Theme.RootColor
		viewTitle.TextColor = Theme.ForegroundText
		viewNotes.TextColor = Theme.ForegroundText
		viewDueDate.TextColor = Theme.ForegroundText
		viewPriority.TextColor = Theme.ForegroundText
		viewReminders.TextColor = Theme.ForegroundText
		viewRepeat.TextColor = Theme.ForegroundText
		viewSnooze.TextColor = Theme.ForegroundText
		hsvCanvas.Color = Theme.RootColor
		'svAttachments.Color = Theme.RootColor
		viewTaskGroup.TextColor = Theme.ForegroundText
		viewCreatedAt.TextColor = Theme.ForegroundText
		viewModifiedAt.TextColor = Theme.ForegroundText
		
		
		viewTitle.Color = Theme.RootColor
		viewNotes.Color = Theme.RootColor
		viewDueDate.Color = Theme.RootColor
		viewPriority.Color = Theme.RootColor
		viewReminders.Color = Theme.RootColor
		viewRepeat.Color = Theme.RootColor
		viewSnooze.Color = Theme.RootColor
		viewTaskGroup.Color = Theme.RootColor
		viewCreatedAt.Color = Theme.RootColor
		viewModifiedAt.Color = Theme.RootColor
		
		pnlAttachments.Color = Theme.RootColor
	End If
	
End Sub

Private Sub btnAttachmentUp_Click
	If m_attachmentScrollIndex > 0 Then
		m_attachmentScrollIndex = m_attachmentScrollIndex - 1
		
		clvAttachments.ScrollToItem (m_attachmentScrollIndex)
	End If
End Sub

Private Sub btnAttachmentDown_Click
	If m_attachmentScrollIndex < clvAttachments.Size - 1 Then
		m_attachmentScrollIndex = m_attachmentScrollIndex + 1
		
		clvAttachments.ScrollToItem (m_attachmentScrollIndex)
	End If
End Sub