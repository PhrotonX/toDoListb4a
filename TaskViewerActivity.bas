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
	
	' This variable is responsible for handling the current data that can be used for performing
	' CRUD into the database.
	Private m_task As ToDo
	Private Label1 As Label
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

	c.DrawLine(0, Label1.Height - borderHeight / 2, Label1.Width, Label1.Height - borderHeight / 2, borderColor, borderHeight)

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
	
	' Retrieve the task sent by MainActivity.
	m_task = Starter.TaskViewModelInstance.GetTask(Starter.InstanceState.Get(Starter.EXTRA_EDITOR_TASK_ID))
	
	' Validate if the task exists by checking the task ID which cannot be zero on
	' the database. Else, return back to MainActivity.
	If m_task.GetId == 0 Then
		Activity.Finish
	End If
	
	' Display the retrieved task into the views.
	viewTitle.Text = m_task.GetTitle
	viewTitle.Checked = m_task.Done
	viewNotes.Text = m_task.GetNotes
	viewRepeat.Text = m_task.GetRepeatInfo
	viewPriority.Text = m_task.GetPriorityInfo
	viewDueDate.Text = m_task.GetDueDate.GetFormattedDate
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

' Return back to MainActivity if back button is clicked.
Sub btnBack_Click
	Activity.Finish
End Sub

' Open editor activity.
Private Sub btnEdit_Click
	' Send the task ID into EditorActivity.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_TASK_ID, m_task.GetId)
	
	' Set the EditorActivity mode into edit mode.
	Starter.InstanceState.Put(Starter.EXTRA_EDITOR_MODE, Starter.EDITOR_MODE_EDIT)
	
	' Start the EditorActivity.
	StartActivity(EditorActivity)
End Sub

' Make update transactions into the database if checkbox tick occured.
Private Sub viewTitle_CheckedChange(Checked As Boolean)
	' Toggle the completions status of the task
	m_task.Done = Checked
	
	' Update the task to reflect changes with the completion value.
	Starter.TaskViewModelInstance.UpdateTask(m_task)
End Sub