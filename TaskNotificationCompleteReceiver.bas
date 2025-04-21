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
	'Public RepeatViewModelInstance As RepeatViewModel

	'Public SettingsViewModelInstance As SettingsViewModel
End Sub

'Called when an intent is received. 
'Do not assume that anything else, including the starter service, has run before this method.
Private Sub Receiver_Receive (FirstTime As Boolean, StartingIntent As Intent)
	' Initialize the database.
	ToDoDatabaseInstance.Initialize
	taskRepo.Initialize(ToDoDatabaseInstance)
	TaskViewModelInstance.Initialize(taskRepo)
	
	If StartingIntent.IsInitialized Then
		Dim itemId As Long = StartingIntent.Action
		
		Dim item As ToDo = TaskViewModelInstance.GetTask(itemId)
		
		Log(item)
		
		If item.IsInitialized Then
			item.Done = True
			
			TaskViewModelInstance.UpdateTask(item)
		End If
	End If
End Sub

