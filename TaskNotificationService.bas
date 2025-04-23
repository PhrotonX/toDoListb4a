B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=13.1
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

	Public ToDoDatabaseInstance As ToDoDatabase
	
	' Repository instances
	Private taskRepo As TaskRepository
	Private repeatRepo As RepeatRepository
	
	' Global instance of TaskViewModel where the database can be accessed.
	Public TaskViewModelInstance As TaskViewModel
	Public RepeatViewModelInstance As RepeatViewModel

	'Public SettingsViewModelInstance As SettingsViewModel
	
	Public Const ACTION_TASK_NOTIFICATION_DISMISS As String = Application.PackageName & ".ACTION_TASK_NOTIFICATION_DISMISS"
	Public Const CHANNEL_TASK_NOTIFICATION As String = "Task Notification"
	Public Const CHANNEL_TASK_NOTIFICATION_ID As String = Application.PackageName & ".CHANNEL_TASK_NOTIFICATION"
	Public Const TAG_TASK_NOTIFICATION As String = Application.PackageName & ".TAG_TASK_NOTIFICATION"
End Sub

Sub Service_Create
	
End Sub

Sub Service_Start (StartingIntent As Intent)
	' Initialize the database.
	ToDoDatabaseInstance.Initialize
	taskRepo.Initialize(ToDoDatabaseInstance)
	TaskViewModelInstance.Initialize(taskRepo)
	repeatRepo.Initialize(ToDoDatabaseInstance)
	RepeatViewModelInstance.Initialize(repeatRepo)
	
	If StartingIntent.IsInitialized Then
		Dim task As ToDo
		task.Initialize
		
		task.SetId(StartingIntent.GetExtra(task.EXTRA_TASK_ID))
		task.SetTitle(StartingIntent.GetExtra(task.EXTRA_TITLE))
		task.SetNotes(StartingIntent.GetExtra(task.EXTRA_NOTES))
		task.SetPriority(StartingIntent.GetExtra(task.EXTRA_PRIORITY))
		
		Dim repeatId As Long = StartingIntent.GetExtra(task.EXTRA_REPEAT_ID)
		
		Dim notification As Notification
	
		notification.Initialize
		notification.Cancel(repeatId)
	
		Dim priority As String = GetImportanceLevel(task)
	
		Dim notificationBuilder As NB6
		notificationBuilder.Initialize(CHANNEL_TASK_NOTIFICATION_ID, CHANNEL_TASK_NOTIFICATION, priority)
		notificationBuilder.SetDefaults(True, False, True)
		notificationBuilder.ShowBadge(True)
		notificationBuilder.SmallIcon(LoadBitmap(File.DirAssets, "ic_launcher_small.png"))
	
		notificationBuilder.AddButtonAction(Null, "Dismiss", TaskNotificationDismissReceiver, task.GetId)
		notificationBuilder.AddButtonAction(Null, "Snooze", TaskNotificationSnoozeReceiver, task.GetId)
		notificationBuilder.AddButtonAction(Null, "Complete", TaskNotificationCompleteReceiver, task.GetId)
		notificationBuilder.DeleteAction(TaskNotificationDismissReceiver, "Action String")
	
		'Dim notificationTimeProcessed As Long = notificationTime + item.Reminder.GetUnixTime

		'Log("notificationTimeProcessed: " & notificationTimeProcessed)

		'notificationBuilder.ShowWhen(notificationTimeProcessed)
	
		notification = notificationBuilder.Build(GetTitle(task), task.GetNotes, _
		TAG_TASK_NOTIFICATION, TaskViewerActivity)

		'notification.Cancel(repeatId)
		notification.Notify(repeatId)
	End If
	
End Sub

Sub Service_Destroy

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
			Return cs.Initialize().Bold.Color(Colors.RGB(255, 0, 0)).Append("Critical: " & item.GetTitle)
		Case Else:
			Return item.GetTitle
	End Select
End Sub