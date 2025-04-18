B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	' 0 represents the least critical task while 3 represents most critical task.
	' Index 0 represents Sunday while index 6 represents Saturday.
	Private m_id(7) As Long
	Private m_enabled(7) As Boolean
	Private m_schedule(7) As Long
	
	Public Const REPEAT_SUNDAY As Int = 0
	Public Const REPEAT_MONDAY As Int = 1
	Public Const REPEAT_TUESDAY As Int = 2
	Public Const REPEAT_WEDNESDAY As Int = 3
	Public Const REPEAT_THURSDAY As Int = 4
	Public Const REPEAT_FRIDAY As Int = 5
	Public Const REPEAT_SATURDAY As Int = 6
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

' Encapsulate repeat value
Public Sub IsEnabled As Boolean(7)
	Return m_enabled
End Sub

Public Sub GetID(day As Byte) As Long
	Return m_id(day)
End Sub

' Retrieves the repeat information such as "Weekdays," "Weekends," "Daily," or names of the days of
' the week.
Public Sub GetRepeatInfo As String
	Dim repeat As String
	
	' Set the repeat information as "Weekends" if Sunday and Saturday are enabled
	If IsEnabled(REPEAT_SUNDAY) == True And _
	IsEnabled(REPEAT_MONDAY) == False And _
	IsEnabled(REPEAT_TUESDAY) == False And _
	IsEnabled(REPEAT_WEDNESDAY) == False And _
	IsEnabled(REPEAT_THURSDAY) == False And _
	IsEnabled(REPEAT_FRIDAY) == False And _
	IsEnabled(REPEAT_SATURDAY) == True Then
		repeat = "Weekends"
		Return repeat
	End If
	
	' Set the repeat information as "Weekdays" if Monday-Friday are enabled.
	If IsEnabled(REPEAT_SUNDAY) == False And _
	IsEnabled(REPEAT_MONDAY) == True And _
	IsEnabled(REPEAT_TUESDAY) == True And _
	IsEnabled(REPEAT_WEDNESDAY) == True And _
	IsEnabled(REPEAT_THURSDAY) == True And _
	IsEnabled(REPEAT_FRIDAY) == True And _
	IsEnabled(REPEAT_SATURDAY) == False Then
		repeat = "Weekdays"
		Return repeat
	End If
	
	' If not repeeat information is not weekend nor weekday, then count the number of enabled
	' days and take their indices into a dynamic array or list.
	Dim itr As Int = 0
	Dim repeatingIndexes As List
	repeatingIndexes.Initialize
	
	For Each item In IsEnabled
		If item == True Then
			repeatingIndexes.Add(itr)
		End If
		itr = itr + 1
	Next
	
	' Set the appropriate repeat information based on the enabled repeat information
	Select repeatingIndexes.Size
		Case 0:
			' Do not set repeat information if all repeat options are disabled.
			repeat = ""
		Case 1:
			' If only 1 day is enabled, then set the information as "Every [day of the week]"
			repeat = "Every " & DaysOfTheWeek.Days(repeatingIndexes.Get(0))
		Case 7:
			' Set the repeat information as "Everyday" if all repeat options are enabled.
			repeat = "Everyday"
		Case Else:
			' Set the repeat information as "Every [shortened day of the week 1] [shortened day of the week 2] ... [shortened day of the week 6]"
			' such that 6 is the maximum possible days to be displayed.
			repeat = "Every "
			For Each index In repeatingIndexes
				repeat = repeat & DaysOfTheWeek.ShortenedDay(index) & " "
			Next
	End Select

	Return repeat
End Sub

Public Sub GetSchedule(day As Byte) As Long
	Return m_schedule(day)
End Sub

Public Sub SetEnabled(day As Byte, enabled As Boolean)
	m_enabled(day) = enabled
End Sub

Public Sub SetID(day As Byte, value As Long)
	m_id(day) = value
End Sub

Public Sub SetSchedule(day As Byte, value As Long)
	m_schedule(day) = value
End Sub