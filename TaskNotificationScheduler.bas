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
End Sub

Sub Service_Create

End Sub

Sub Service_Start (StartingIntent As Intent)
	' Make this service only start if the app has been started or a notification has occured.
	Service.StopAutomaticForeground 'Call this when the background task completes (if there is one)
	
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
	
	If repeatItem.IsInitialized Then
		' Obtaining the task ID based on the repeat ID of the first repeat.
		Dim task_id As Long = RepeatViewModelInstance.GetTaskIdFromRepeat(repeatItem.GetID(0))
		
		' Obtaining the task based on the task ID.
		Dim item As ToDo = TaskViewModelInstance.GetTask(task_id)
		
		If item <> Null Then
			Log("TaskNotificationScheduler: repeatItem ID " & repeatItem.GetID(0) & " day " & repeatItem.GetDayID(0))
			Log("TaskNotificationScheduler: task_id" & task_id)
			
			Log("TaskNotificationScheduler: item.Reminder.GetUnixTime " & item.Reminder.GetUnixTime)
			Log("TaskNotificationScheduler: repeatItem.GetSchedule(0) + item.Reminder.GetUnixTime " & _
				(repeatItem.GetSchedule(0) + item.Reminder.GetUnixTime))
			
			' Make a notification
			StartServiceAtExact(TaskNotificationService, repeatItem.GetSchedule(0) + item.Reminder.GetUnixTime, True)
		Else
			Log("No new tasks")
		End If
	End If
End Sub

Sub Service_Destroy

End Sub

