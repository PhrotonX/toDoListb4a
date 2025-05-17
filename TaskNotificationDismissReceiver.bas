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
	SettingsViewModelInstance.Initialize
	Lang.Initialize(SettingsViewModelInstance)
	
	' Initialize the database.
	ToDoDatabaseInstance.Initialize(Lang)
	taskRepo.Initialize(ToDoDatabaseInstance)
	repeatRepo.Initialize(ToDoDatabaseInstance)
	TaskViewModelInstance.Initialize(taskRepo)
	RepeatViewModelInstance.Initialize(repeatRepo)
	SettingsViewModelInstance.Initialize()
	
	' Make a notification builder instance.
	Dim nb As Notification
	nb.Initialize
	
	Dim toastMsg As String = "Task Dimissed. No recurring task follows."
	
	If StartingIntent.IsInitialized Then
		' Notification ID is the same as the repeat ID.
		Dim notificationId As Long = StartingIntent.Action
		Dim itemId As Long = RepeatViewModelInstance.GetTaskIdFromRepeat(notificationId)
		
		Log("TaskNotificationDismissReceiver: Task id " & itemId)
		
		Dim item As ToDo = TaskViewModelInstance.GetTask(itemId)

		If item.IsInitialized Then
			If item.Done == False Then
				Dim fullRepeat As Repeat = RepeatViewModelInstance.GetTaskRepeat(item.GetId)
				
				If fullRepeat.AreAllDisabled == False Then
					Dim repeatItem As Repeat = RepeatViewModelInstance.GetNextTaskRepeat(item.GetId)
				
					If repeatItem.IsInitialized Then
						Dim dateObj As DateAndTime
						dateObj.Initialize()
						Dim nextSchedule As Long = repeatItem.GetSchedule(0)
						
						Dim computedSchedule As Long = nextSchedule + item.Reminder.GetUnixTime
						
						Log("TaskNotificationDismissReceiver: nextSchedule " & nextSchedule)
						Log("TaskNotificationDismissReceiver: item.Reminder.GetUnixTime " & item.Reminder.GetUnixTime)
						Log("TaskNotificationDismissReceiver: computedSchedule " & computedSchedule)
						
						dateObj.SetUnixTime(computedSchedule)
						
						' Save the computed value into the DB.
						RepeatViewModelInstance.UpdateSingleRepeatSchedule(repeatItem.GetID(0), computedSchedule)
						
						toastMsg = "Task Dimissed. Next task will be on: " & dateObj.GetFormattedDateAndTime( _
						SettingsViewModelInstance.Is24HourFormatEnabled)
					End If
				End If
				
				' Close the notification.
				nb.Cancel(notificationId)
						
				' Make another schedule if possible.
				StartServiceAtExact(TaskNotificationScheduler, DateTime.Now, True)
			End If
		Else
			toastMsg = "Error in dismissing task - task id: " & itemId
		End If
	End If
	
	ToastMessageShow(toastMsg, True)
End Sub

