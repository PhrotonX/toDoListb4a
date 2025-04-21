B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.1
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
	Public Const ACTION_TASK_NOTIFICATION_DISMISS As String = Application.PackageName & ".ACTION_TASK_NOTIFICATION_DISMISS"
	Public Const CHANNEL_TASK_NOTIFICATION As String = "Task Notification"
	Public Const CHANNEL_TASK_NOTIFICATION_ID As Int = Application.PackageName & ".CHANNEL_TASK_NOTIFICATION"
	Public Const TAG_TASK_NOTIFICATION As String = Application.PackageName & ".TAG_TASK_NOTIFICATION"
End Sub

Sub DisplayNotification(item As ToDo)
	Dim priority As String = GetImportanceLevel(item)
	
	Dim notificationBuilder As NB6
	notificationBuilder.Initialize(CHANNEL_TASK_NOTIFICATION_ID, CHANNEL_TASK_NOTIFICATION, priority)
	notificationBuilder.SetDefaults(True, False, True)
	notificationBuilder.ShowBadge(True)
	
	notificationBuilder.AddButtonAction(Null, "Dismiss", TaskNotificationDismissReceiver, item.GetId)
	notificationBuilder.AddButtonAction(Null, "Snooze", TaskNotificationSnoozeReceiver, item.GetId)
	notificationBuilder.AddButtonAction(Null, "Complete", TaskNotificationCompleteReceiver, item.GetId)
	notificationBuilder.DeleteAction(TaskNotificationDismissReceiver, "Action String")
	
	notificationBuilder.ShowWhen(item.Reminder.GetUnixTime)
	
	Dim notification As Notification = notificationBuilder.Build(GetTitle(item), item.GetNotes, _ 
		TAG_TASK_NOTIFICATION, TaskViewerActivity)
		
	notification.Notify(item.GetId)
End Sub

Private Sub GetImportanceLevel(item As ToDo) As String
	Select item.GetPriority
		Case item.PRIORITY_LOW:
			Return "LOW"
		Case item.PRIORITY_MEDIUM:
			Return "DEFAULT"
		Case item.PRIORITY_HIGH, item.PRIORITY_CRITICAL:
			Return "HIGH"
		Case Else:
			Return "DEFAULT"
	End Select
End Sub

Private Sub GetTitle(item As ToDo) As Object
	Dim cs As CSBuilder
	
	Select item.GetPriority
		Case item.PRIORITY_CRITICAL:
			Return cs.Initialize().Bold.Color(Colors.RGB(255, 0, 0)).Append(item.GetTitle)
		Case Else:
			Return item.GetTitle
	End Select
End Sub