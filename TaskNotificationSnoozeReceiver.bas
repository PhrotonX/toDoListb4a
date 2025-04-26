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

	'Public SettingsViewModelInstance As SettingsViewModel
End Sub

'Called when an intent is received. 
'Do not assume that anything else, including the starter service, has run before this method.
Private Sub Receiver_Receive (FirstTime As Boolean, StartingIntent As Intent)
	' Initialize the database.
	ToDoDatabaseInstance.Initialize
	taskRepo.Initialize(ToDoDatabaseInstance)
	repeatRepo.Initialize(ToDoDatabaseInstance)
	TaskViewModelInstance.Initialize(taskRepo)
	RepeatViewModelInstance.Initialize(repeatRepo)
	
	If StartingIntent.IsInitialized Then
		Dim itemId As Long = StartingIntent.Action
		
		Log(itemId)
		
		Dim item As ToDo = TaskViewModelInstance.GetTask(itemId)
		
		'Log(item)
		
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
					
					StartServiceAtExact(TaskNotificationService, calculatedTime, True)
				End If
				
			End If
		End If
	End If
End Sub

