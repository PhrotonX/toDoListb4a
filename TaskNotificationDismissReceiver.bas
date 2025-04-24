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
	SettingsViewModelInstance.Initialize()
	
	Dim toastMsg As String = "Task Dimissed. No recurring task follows."
	
	If StartingIntent.IsInitialized Then
		Dim itemId As Long = StartingIntent.Action
		
		Log(itemId)
		
		Dim item As ToDo = TaskViewModelInstance.GetTask(itemId)
		
		If item.IsInitialized Then
			If item.Done == False Then
				Dim fullRepeat As Repeat = RepeatViewModelInstance.GetTaskRepeat(item.GetId)
				
				If fullRepeat.AreAllDisabled == False Then
					Dim repeatItem As Repeat = RepeatViewModelInstance.GetNextTaskRepeat(item.GetId)
				
					If repeatItem.IsInitialized Then
						Dim dateObj As DateAndTime
						dateObj.Initialize()
						dateObj.SetUnixTime(repeatItem.GetSchedule(0) + item.Reminder.GetUnixTime)
					
						toastMsg = "Task Dimissed. Next task will be on: " & dateObj.GetFormattedDateAndTime( _
						SettingsViewModelInstance.Is24HourFormatEnabled)
					End If
				End If
								
			End If
		Else
			toastMsg = "Error in dismissing task (task id: " & itemId
		End If
	End If
	
	'ToastMessageShow(, False)
	ToastMessageShow(toastMsg, False)
End Sub

