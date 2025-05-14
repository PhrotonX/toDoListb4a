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
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("TaskViewLayout")
	button_design

	' Add the TaskViewScrollLayout as the view of taskView of the ScrollView in TaskViewLayout.
	taskView.Panel.LoadLayout("TaskViewScrollLayout")
	
	' Other supplementary code for UI design.
	Dim c As Canvas
	c.Initialize(Label1)
	Dim borderColor As Int = Colors.RGB(209, 209, 209)
	Dim borderHeight As Int = 1dip

	c.DrawLine(0, Label1.Height - borderHeight / 2, Label1.Width, Label1.Height - borderHeight / 2, borderColor, _ 
		borderHeight)

	Label1.Invalidate
End Sub

Private Sub button_design
	'Makes the bg, border of the buttons transparent
	
	Dim transparentBg As ColorDrawable
	
	transparentBg.Initialize(Colors.Transparent, 0)
	btnBack.Background = transparentBg
End Sub

Sub Activity_Resume
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
		viewNotes.Text = m_task.GetNotes
		viewRepeat.Text = m_repeat.GetRepeatInfo
		viewPriority.Text = m_task.GetPriorityInfo
		viewDueDate.Text = m_task.GetDueDate.GetFormattedDate
		viewCreatedAt.Text = m_task.GetCreatedAt.GetFormattedDateAndTime( _
			Starter.SettingsViewModelInstance.Is24HourFormatEnabled)
		viewModifiedAt.Text = m_task.GetUpdatedAt.GetFormattedDateAndTime( _
			Starter.SettingsViewModelInstance.Is24HourFormatEnabled)
			
		LoadAttachments
		
		Dim taskGroup As Group = Starter.GroupViewModelInstance.GetGroupByTaskId(m_task.GetId())
		If taskGroup.IsInitialized Then
			viewTaskGroup.Text = taskGroup.GetTitle
		Else
			viewTaskGroup.Text = Starter.GroupViewModelInstance.DefaultGroup().GetTitle()
		End If
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
	' Load the attachments list layout.
	svAttachments.Panel.LoadLayout("attachmentlistlayout")
	
	Log("svAttachments: " & svAttachments)
	Log("svAttachments.Panel: " & svAttachments.Panel)

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
	viewHolder.DeleteButton = btnAttachmentRemove
	' Hide the remove button for attachments. Attachments cannot be edited within TaskViewerActivity.
	viewHolder.DeleteButton.Visible = False
	viewHolder.ID = item.GetID
	
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