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
	
	' Make a notification builder instance to cancel the tapped notification.
	Dim nb As Notification
	nb.Initialize
	
	If StartingIntent.IsInitialized Then
		' Notification ID is the same as the repeat ID.
		Dim notificationId As Long = StartingIntent.Action
		Dim itemId As Long = RepeatViewModelInstance.GetTaskIdFromRepeat(notificationId)
		
		Log("TaskNotificationCompleteReceiver: Task id " & itemId)
		
		Dim item As ToDo = TaskViewModelInstance.GetTask(itemId)
		
		nb.Cancel(notificationId)
		If item.IsInitialized Then
			item.Done = True
			
			TaskViewModelInstance.UpdateTask(item)
			RepeatViewModelInstance.CalculateSchedule(item)
			
			ToastMessageShow(Lang.Get("completed") & "!", False)
		End If
	End If
End Sub

