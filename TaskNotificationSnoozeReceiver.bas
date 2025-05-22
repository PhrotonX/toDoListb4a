B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Receiver
Version=13.1
@EndOfDesignText@
Sub Process_Globals
	Public ToDoDatabaseInstance As ToDoDatabase
	
	' Repository instances
	Private taskRepo As TaskRepository
	Private repeatRepo As RepeatRepository
	
	' Global instance of TaskViewModel where the database can be accessed.
	Public TaskViewModelInstance As TaskViewModel
	Public RepeatViewModelInstance As RepeatViewModel

	Public SettingsViewModelInstance As SettingsViewModel
	Public Lang As LanguageManager
End Sub

'Called when an intent is received. 
'Do not assume that anything else, including the starter service, has run before this method.
Private Sub Receiver_Receive (FirstTime As Boolean, StartingIntent As Intent)
	' Initialize the database.
	SettingsViewModelInstance.Initialize
	Lang.Initialize(SettingsViewModelInstance)
	
	ToDoDatabaseInstance.Initialize(Lang)
	taskRepo.Initialize(ToDoDatabaseInstance)
	repeatRepo.Initialize(ToDoDatabaseInstance)
	TaskViewModelInstance.Initialize(taskRepo)
	RepeatViewModelInstance.Initialize(repeatRepo)
	
	' Make a notification builder instance to cancel the tapped notification.
	Dim nb As Notification
	nb.Initialize
	
	If StartingIntent.IsInitialized Then
		' Notification ID is the same as the repeat ID.
		Dim notificationId As Long = StartingIntent.Action
		Dim itemId As Long = RepeatViewModelInstance.GetTaskIdFromRepeat(notificationId)
		
		Log("TaskNotificationSnoozeReceiver: Task id " & itemId)
		
		Dim item As ToDo = TaskViewModelInstance.GetTask(itemId)
		
		If item.IsInitialized Then
			' Reschedule the task based on the snooze value and the current time.
			
			Dim currentDayOfTheWeek As Int = DateTime.GetDayOfWeek(DateTime.Now) - 1
			Dim repeatItem As Repeat = RepeatViewModelInstance.GetTaskRepeat(item.GetId)
				
			If repeatItem.IsInitialized Then
				Dim snoozeObj As Long = item.Snooze.GetSnooze
				
				Log("TaskNotificationSnoozeReceiver: snoozeObj: " & snoozeObj)
				Log("TaskNotificationSnoozeReceiver: currentDayOfTheWeek: " & currentDayOfTheWeek)
				If snoozeObj <> item.Snooze.SNOOZE_OFF Then
					Dim calculatedTime As Long = DateTime.Now + snoozeObj
					repeatItem.SetSchedule(currentDayOfTheWeek, calculatedTime)
				
					Log("TaskNotificationSnoozeReceiver: calculatedTime: " & calculatedTime)
					
					RepeatViewModelInstance.UpdateSingleRepeatSchedule(repeatItem.GetID(currentDayOfTheWeek), _
					repeatItem.GetSchedule(currentDayOfTheWeek))
					
					ToastMessageShow(Lang.Get("task_snoozed") & " (" & _ 
						Lang.Get(item.Snooze.GetSnoozeText(item.Snooze.GetSnooze)) & ")", True)
					
					nb.Cancel(notificationId)
		
					'Run the task notification scheduler service to start the next scheduled task.
					StartServiceAtExact(TaskNotificationService, calculatedTime, True)
				End If
				
			End If
		End If
	End If
End Sub

