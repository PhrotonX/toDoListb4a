B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.1
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
	Public Const ACTION_TASK_NOTIFICATION_DISMISS As String = Application.PackageName & ".ACTION_TASK_NOTIFICATION_DISMISS"
	Public Const CHANNEL_TASK_NOTIFICATION As String = "Task Notification"
	Public Const CHANNEL_TASK_NOTIFICATION_ID As String = Application.PackageName & ".CHANNEL_TASK_NOTIFICATION"
	Public Const TAG_TASK_NOTIFICATION As String = Application.PackageName & ".TAG_TASK_NOTIFICATION"
End Sub

' This function creates or replaces a notification.
Sub CreateNotification(item As ToDo, repeatItem As Repeat) As List
	Dim notifications As List
	notifications.Initialize
	
	Log("CreateNotification()")
	If item.IsReminderEnabled == True Then
		Dim notificationTimes As Map = OnCalculateSchedule(repeatItem)
		
		If notificationTimes.Size > 0 Then
			' Create separate notifications for each repeat days.
			' @NOTE: This code does currently not handle notifications that will repeat per week.
			For Each notificationKey As Long In notificationTimes.Keys
				
				Log("notificationTime key:" & notificationTimes.Get(notificationKey))
				
				notifications.Add(OnCreateNotification(item, notificationTimes.Get(notificationKey), notificationKey))
			Next
		Else
			Dim dateObj As Date
			dateObj.Initialize(0,0,0)
	
			Dim timeObj As Long = dateObj.GetDateNoTime(DateTime.Now)
			
			Log("timeObj: " & timeObj)
			
			' Single notification only.
			' Pass first repeat ID if no repeat information is enabled.
			notifications.Add(OnCreateNotification(item, timeObj,repeatItem.GetID(0)))
		End If
		
	End If
	
	Return notifications
End Sub

' repeatId - The repeat_id of the repeat day as the notification ID. If repeat is disabled, then the 
Private Sub OnCreateNotification(item As ToDo, notificationTime As Long, repeatId As Long) As Notification
	Dim notification As Notification
	
	notification.Initialize
	notification.Cancel(repeatId)
	
	Dim priority As String = GetImportanceLevel(item)
	
	Dim notificationBuilder As NB6
	notificationBuilder.Initialize(CHANNEL_TASK_NOTIFICATION_ID, CHANNEL_TASK_NOTIFICATION, priority)
	notificationBuilder.SetDefaults(True, False, True)
	notificationBuilder.ShowBadge(True)
	notificationBuilder.SmallIcon(LoadBitmap(File.DirAssets, "ic_launcher_small.png"))
	
	notificationBuilder.AddButtonAction(Null, "Dismiss", TaskNotificationDismissReceiver, item.GetId)
	notificationBuilder.AddButtonAction(Null, "Snooze", TaskNotificationSnoozeReceiver, item.GetId)
	notificationBuilder.AddButtonAction(Null, "Complete", TaskNotificationCompleteReceiver, item.GetId)
	notificationBuilder.DeleteAction(TaskNotificationDismissReceiver, "Action String")
	
	Dim notificationTimeProcessed As Long = notificationTime + item.Reminder.GetUnixTime

	Log("notificationTimeProcessed: " & notificationTimeProcessed)

	notificationBuilder.ShowWhen(notificationTimeProcessed)
	
	notification = notificationBuilder.Build(GetTitle(item), item.GetNotes, _ 
		TAG_TASK_NOTIFICATION, TaskViewerActivity)

	'notification.Cancel(repeatId)
	notification.Notify(repeatId)
	'notification.
	
	Return notification
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