B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_dayOfTheWeek As DaysOfTheWeek
	Private m_id As Long
	Private m_title As String
	Private m_notes As String
	' 0 represents the least critical task while 3 represents most critical task.
	Private m_priority As Int
	' Index 0 represents Sunday while index 6 represents Saturday.
	Private m_repeat(7) As Boolean
	Public Done As Boolean
	
	Public Const PRIORITY_LOW As Int = 0
	Public Const PRIORITY_MEDIUM As Int = 1
	Public Const PRIORITY_HIGH As Int = 2
	Public Const PRIORITY_CRITICAL As Int = 3
	
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
	m_dayOfTheWeek.Initialize
	
	For Each REPEAT As Boolean In m_repeat
		REPEAT = False
	Next
End Sub

' Retrieves the glance information to be displayed on TaskItemLayout.
Public Sub GetGlance As String
	Dim priorityLabel As String = "Priority: "
	Dim priority As String = priorityLabel & GetPriorityInfo
	Dim repeat As String = GetRepeatInfo
	
	' Separate variable for hyphen is used to toggle it if either priority or repeat is not
	' available.
	Dim hyphen As String = " - "
	
	' Remove glance info for priority if the value is medium since it is the default value.
	If priority == priorityLabel & "Medium" Then
		priority = ""
		hyphen = ""
	End If
	
	' Remove hyphen for if repeat information is not available.
	If repeat == "" Then
		hyphen = ""
	End If
	
	
	Return priority & hyphen & repeat
End Sub

Public Sub GetId As Long
	Return m_id
End Sub

' Encapsulate title value
Public Sub GetTitle As String
	Return m_title
End Sub

' Encapsulate notes value
Public Sub GetNotes As String
	Return m_notes
End Sub

' Encapsulate priority value
Public Sub GetPriority As Int
	Return m_priority
End Sub

Public Sub GetPriorityInfo As String
	Select GetPriority
		Case PRIORITY_CRITICAL:
			Return "Critical"
		Case PRIORITY_HIGH:
			Return "High"
		Case PRIORITY_MEDIUM:
			Return "Medium"
		Case PRIORITY_LOW:
			Return "Low"
		Case Else:
			Return "Error retrieving task priority"
	End Select
End Sub

' Encapsulate repeat value
Public Sub GetRepeat As Boolean(7)
	Return m_repeat
End Sub

' Retrieves the repeat information such as "Weekdays," "Weekends," "Daily," or names of the days of
' the week.
Public Sub GetRepeatInfo As String
	Dim repeat As String
	
	' Set the repeat information as "Weekends" if Sunday and Saturday are enabled
	If GetRepeat(REPEAT_SUNDAY) == True And _
	GetRepeat(REPEAT_MONDAY) == False And _
	GetRepeat(REPEAT_TUESDAY) == False And _
	GetRepeat(REPEAT_WEDNESDAY) == False And _
	GetRepeat(REPEAT_THURSDAY) == False And _
	GetRepeat(REPEAT_FRIDAY) == False And _
	GetRepeat(REPEAT_SATURDAY) == True Then
		repeat = "Weekends"
		Return repeat
	End If
	
	' Set the repeat information as "Weekdays" if Monday-Friday are enabled.
	If GetRepeat(REPEAT_SUNDAY) == False And _
	GetRepeat(REPEAT_MONDAY) == True And _
	GetRepeat(REPEAT_TUESDAY) == True And _
	GetRepeat(REPEAT_WEDNESDAY) == True And _
	GetRepeat(REPEAT_THURSDAY) == True And _
	GetRepeat(REPEAT_FRIDAY) == True And _
	GetRepeat(REPEAT_SATURDAY) == False Then
		repeat = "Weekdays"
		Return repeat
	End If
	
	' If not repeeat information is not weekend nor weekday, then count the number of enabled
	' days and take their indices into a dynamic array or list.
	Dim itr As Int = 0
	Dim repeatingIndexes As List
	repeatingIndexes.Initialize
	
	For Each item In GetRepeat
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
			repeat = "Every " & m_dayOfTheWeek.Days(repeatingIndexes.Get(0))
		Case 7:
			' Set the repeat information as "Everyday" if all repeat options are enabled.
			repeat = "Everyday"
		Case Else:
			' Set the repeat information as "Every [shortened day of the week 1] [shortened day of the week 2] ... [shortened day of the week 6]"
			' such that 6 is the maximum possible days to be displayed.
			repeat = "Every "
			For Each index In repeatingIndexes
				repeat = repeat & m_dayOfTheWeek.ShortenedDay(index) & " "
			Next
	End Select

	Return repeat
End Sub

Public Sub SetId(id As String)
	m_id = id
End Sub

Public Sub SetTitle(title As String)
	m_title = title
End Sub

Public Sub SetNotes(notes As String)
	m_notes = notes
End Sub

Public Sub SetRepeat(day As Int, repeat As Boolean)
	m_repeat(day) = repeat
End Sub

Public Sub SetPriority(priority As Int)
	m_priority = priority
End Sub