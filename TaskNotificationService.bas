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
	' Make this service only start if the app has been started or a notification has occured.
	Service.StopAutomaticForeground 'Call this when the background task completes (if there is one)
	Log("=========================================")
	
	' Initialize the database.
	ToDoDatabaseInstance.Initialize
	taskRepo.Initialize(ToDoDatabaseInstance)
	TaskViewModelInstance.Initialize(taskRepo)
	repeatRepo.Initialize(ToDoDatabaseInstance)
	RepeatViewModelInstance.Initialize(repeatRepo)
	
	Dim notifications As List
	notifications.Initialize

	' Obtaining the first repeat.
	Dim repeatItem As Repeat = RepeatViewModelInstance.GetFirstScheduledRepeat()
	
	Log("TaskNotificationScheduler: repeatItem " & repeatItem)

	If repeatItem.IsInitialized Then
		' Obtaining the task ID based on the repeat ID of the first repeat.
		Dim task_id As Long = RepeatViewModelInstance.GetTaskIdFromRepeat(repeatItem.GetID(0))
		Log("TaskNotificationScheduler: task_id " & task_id)
		' Obtaining the task based on the task ID.
		Dim task As ToDo = TaskViewModelInstance.GetTask(task_id)
		
		If task <> Null Then
			Log("TaskNotificationScheduler: repeatItem.GetDayID(0) " & repeatItem.GetDayID(0))
	
			' Make a notification
			Dim notification As Notification
	
			notification.Initialize
			
			Dim priority As String = GetImportanceLevel(task)
	
			Dim notificationBuilder As NB6
			notificationBuilder.Initialize(CHANNEL_TASK_NOTIFICATION_ID, CHANNEL_TASK_NOTIFICATION, priority)
			notificationBuilder.SetDefaults(True, False, True)
			notificationBuilder.ShowBadge(True)
			notificationBuilder.SmallIcon(LoadBitmap(File.DirAssets, "ic_launcher_small.png"))
			notificationBuilder.AutoCancel(True)
			
			notificationBuilder.AddButtonAction(Null, "Dismiss", TaskNotificationDismissReceiver, repeatItem.GetID(0))
			If task.Snooze.GetSnooze <> task.Snooze.SNOOZE_OFF Then
				notificationBuilder.AddButtonAction(Null, "Snooze", TaskNotificationSnoozeReceiver, repeatItem.GetID(0))
			End If
			notificationBuilder.AddButtonAction(Null, "Complete", TaskNotificationCompleteReceiver, repeatItem.GetID(0))
			notificationBuilder.DeleteAction(TaskNotificationDismissReceiver, repeatItem.GetID(0))
	
			notification = notificationBuilder.Build(GetTitle(task), task.GetNotes, _
		task_id, TaskViewerActivity)

			'notification.Cancel(repeatId)
			notification.Notify(repeatItem.GetID(0))
		
			' Recalculate current task.
			Log("TaskNotificationScheduler: repeatItem.IsEnabled(0) " & repeatItem.IsEnabled(0))
		
			Dim fullRepeat As Repeat = RepeatViewModelInstance.GetTaskRepeat(task.GetId)
		
		
			If fullRepeat.AreAllDisabled == True Then
				' Remove reminder schedule if no repeat option is set.
				repeatItem.SetSchedule(0, 0)
				RepeatViewModelInstance.UpdateSingleRepeatSchedule(repeatItem.GetID(0), repeatItem.GetSchedule(0))
			
				Log("TaskNotificationService: repeatItem.GetSchedule(0) " & repeatItem.GetSchedule(0))
			Else
				' Update the reminder schedule if the repeat item or the "day of the week" is enabled.
				' This reschedules the reminder into next week.
				' Note: All off this will be turned off after tapping on "Complete" or marking such task as done.
				If repeatItem.IsEnabled(0) Then
					Dim newDate As Long = DateTime.Now - (DateTime.Now Mod task.GetDueDate.DAY_LENGTH)
					newDate = newDate + task.Reminder.GetUnixTime
					newDate = newDate + (DateTime.Add(newDate, 0, 0, 7) - newDate)
		
					Log("TaskNotificationService: newDate " & newDate)
		
					repeatItem.SetSchedule(0, newDate)
		
					' Save to database.
					RepeatViewModelInstance.UpdateSingleRepeatSchedule(repeatItem.GetID(0), repeatItem.GetSchedule(0))
				
					' Make another notification for the next schedule.
					StartServiceAtExact(TaskNotificationScheduler, DateTime.Now, True)
				End If
			End If
		End If
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