B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_repository As RepeatRepository
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(repository As RepeatRepository)
	m_repository = repository
End Sub

Public Sub CalculateSchedule(item As ToDo)
	Dim fullRepeat As Repeat = GetTaskRepeat(item.GetId)
	
	If item.Done == True Then
		' Remove the reminder schedule if the item is done.
		For i = 0 To 6
			fullRepeat.SetSchedule(i, 0)
		Next
	Else
		' Re-calculate schedule if the item is not done. The function should be located within Repeat class.
		fullRepeat.CalculateSchedule()
	End If
	
	' Update the repeat values for the udpated schedule.
	UpdateRepeat(fullRepeat)
End Sub

Public Sub InsertTaskRepeat(task_id As Long, item As Repeat) As Boolean
	Return m_repository.InsertTaskRepeat(task_id, item)
End Sub

Public Sub GetTaskRepeat(task_id As Long) As Repeat
	Return m_repository.GetTaskRepeat(task_id)
End Sub

Public Sub GetTaskIdFromRepeat(repeat_id As Long) As Long
	Return m_repository.GetTaskIdFromRepeat(repeat_id)
End Sub

' Returns only single repeat item. Indexes 1-6 cannot be accessed other than 0.
Public Sub GetFirstScheduledRepeat() As Repeat
	Return m_repository.GetFirstScheduledRepeat()
End Sub

Public Sub UpdateRepeat(item As Repeat) As Boolean
	Return m_repository.UpdateRepeat(item)
End Sub

Public Sub UpdateSingleRepeatSchedule(repeat_id As Long, schedule As Long) As Boolean
	Return m_repository.UpdateSingleRepeatSchedule(repeat_id, schedule)
End Sub

Public Sub DeleteRepeat(item As Repeat) As Boolean
	Return m_repository.DeleteRepeat(item)
End Sub

' item - Expects repeat items in which all IDs are already 
Public Sub CreateOrUpdateNotificationSchedule(item As ToDo, repeatItem As Repeat)
	' Create the notification
	Log("TaskNotificationScheduler: Creating Notification")
	If item.IsReminderEnabled == True Then
		Dim notificationTimes As Map = OnCalculateSchedule(repeatItem)
		
		If notificationTimes.Size > 0 Then
			' Create separate notifications for each repeat days.
			' @NOTE: This code does currently not handle notifications that will repeat per week.
			For Each notificationKey As Long In notificationTimes.Keys
				
				Log("notificationTime key:" & notificationTimes.Get(notificationKey))
				
				' Save the schedule to DB.
				Starter.RepeatViewModelInstance.UpdateSingleRepeatSchedule(notificationKey, _ 
				notificationTimes.Get(notificationKey))
				
			Next
		Else
			Dim dateObj As Date
			dateObj.Initialize(0,0,0)
	
			Dim timeObj As Long = dateObj.GetDateNoTime(DateTime.Now)
			
			Log("timeObj: " & timeObj)
			
			' Save the sechdule to DB.
			' Single notification only.
			' Pass first repeat ID if no repeat information is enabled.
			UpdateSingleRepeatSchedule(repeatItem.GetID(0), timeObj)
		End If
		
	End If
	
	'StopService(TaskNotificationScheduler)
	StartServiceAt(TaskNotificationScheduler, DateTime.Now, True)
End Sub

Private Sub OnCalculateSchedule(item As Repeat) As Map
	Dim result As Map
	result.Initialize
	
	Dim dateObj As Date
	dateObj.Initialize(0,0,0)
	
	' Get the current day of the week. The value should be decreased by 1 since the value that this function
	' returns is 1-based instead of 0.
	Dim j As Int = DateTime.GetDayOfWeek(DateTime.Now) - 1

	' Iterator for 0 to 6.
	Dim itr As Int = -1
	
	For i = 0 To 6
		' If the current iterated value is greater than 6 or Saturday, then set the iterator value into
		' 0 until the value is less than j. Else, set the itr value as the current iterated value.
		If j + (j - i) > 6 Then
			itr = itr + 1
		Else
			itr = i
		End If
		
		' If the current repeat day is enabled, then get its date value and then add it into the resulting list.
		If item.IsEnabled(itr) Then
			Dim timeCurrent As Long = dateObj.GetDateNoTime(DateTime.Now)
			Dim timeObj As Long = DateTime.Add(timeCurrent, 0, 0, i)
			result.Put(item.GetID(itr), timeObj)
			
			Log("TaskNotification.OnCalculateSchedule() Day of the week ID: " & item.GetID(itr))
		End If
		
		j = j + 1
	Next
	
	Return result
End Sub