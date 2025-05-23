﻿B4A=true
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
	Private m_dayId(7) As Int
	
	Public Const REPEAT_SUNDAY As Int = 0
	Public Const REPEAT_MONDAY As Int = 1
	Public Const REPEAT_TUESDAY As Int = 2
	Public Const REPEAT_WEDNESDAY As Int = 3
	Public Const REPEAT_THURSDAY As Int = 4
	Public Const REPEAT_FRIDAY As Int = 5
	Public Const REPEAT_SATURDAY As Int = 6
	
	Private m_lang As LanguageManager
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(lang As LanguageManager)
	For Each enabledItem As Boolean In m_enabled
		enabledItem = False
	Next
	
	For Each dayItem As Int In m_dayId
		dayItem = 0
	Next
	
	m_lang = lang
End Sub

' Check if all repeat options are disabled. A return value of True indicates that no repeat option is used and
' a default repeat value is reserved for the day 0 of this object.
Public Sub AreAllDisabled() As Boolean
	Dim count As Int = 0
	
	For Each enabledItem As Boolean In m_enabled
		If enabledItem == True Then
			count = count + 1
		End If
	Next
	
	If count > 0 Then
		Return False
	Else
		Return True
	End If
End Sub

' Encapsulate repeat value
Public Sub IsEnabled As Boolean(7)
	Return m_enabled
End Sub

Public Sub GetDayID(pos As Int) As Int
	Return m_dayId(pos)
End Sub

Public Sub GetID(day As Int) As Long
	Return m_id(day)
End Sub

' Retrieves the repeat information such as "Weekdays," "Weekends," "Daily," or names of the days of
' the week.
Public Sub GetRepeatInfo As String
	Dim repeatStr As String
	
	' Set the repeat information as "Weekends" if Sunday and Saturday are enabled
	If IsEnabled(REPEAT_SUNDAY) == True And _
	IsEnabled(REPEAT_MONDAY) == False And _
	IsEnabled(REPEAT_TUESDAY) == False And _
	IsEnabled(REPEAT_WEDNESDAY) == False And _
	IsEnabled(REPEAT_THURSDAY) == False And _
	IsEnabled(REPEAT_FRIDAY) == False And _
	IsEnabled(REPEAT_SATURDAY) == True Then
		repeatStr = m_lang.Get("weekends")
		Return repeatStr
	End If
	
	' Set the repeat information as "Weekdays" if Monday-Friday are enabled.
	If IsEnabled(REPEAT_SUNDAY) == False And _
	IsEnabled(REPEAT_MONDAY) == True And _
	IsEnabled(REPEAT_TUESDAY) == True And _
	IsEnabled(REPEAT_WEDNESDAY) == True And _
	IsEnabled(REPEAT_THURSDAY) == True And _
	IsEnabled(REPEAT_FRIDAY) == True And _
	IsEnabled(REPEAT_SATURDAY) == False Then
		repeatStr = m_lang.Get("weekdays")
		Return repeatStr
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
			repeatStr = ""
		Case 1:
			' If only 1 day is enabled, then set the information as "Every [day of the week]"
			repeatStr = m_lang.Get("every") & " " & m_lang.Get(DaysOfTheWeek.Days(repeatingIndexes.Get(0)))
		Case 7:
			' Set the repeat information as "Everyday" if all repeat options are enabled.
			repeatStr = m_lang.Get("everyday")
		Case Else:
			' Set the repeat information as "Every [shortened day of the week 1] [shortened day of the week 2] ... [shortened day of the week 6]"
			' such that 6 is the maximum possible days to be displayed.
			repeatStr = m_lang.Get("every") & " "
			For Each index In repeatingIndexes
				Log(DaysOfTheWeek.Days(index) & "_abbr")
				repeatStr = repeatStr & m_lang.Get(DaysOfTheWeek.Days(index) & "_abbr") & " "
			Next
	End Select

	Return repeatStr
End Sub

Public Sub GetSchedule(day As Byte) As Long
	Return m_schedule(day)
End Sub

Public Sub CalculateSchedule()
	'Dim result As Map
	'result.Initialize
	
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
		If IsEnabled(itr) Then
			Dim timeCurrent As Long = dateObj.GetDateNoTime(DateTime.Now)
			Dim timeObj As Long = DateTime.Add(timeCurrent, 0, 0, i)
			'result.Put(GetID(itr), timeObj)
			m_schedule(itr) = timeObj
			
			Log("Repeat.OnCalculateSchedule() Day of the week ID: " & GetID(itr))
		End If
		
		j = j + 1
	Next
End Sub

Public Sub SetEnabled(day As Byte, enabled As Boolean)
	m_enabled(day) = enabled
End Sub

Public Sub SetDayID(day As Int, value As Int)
	m_dayId(day) = value
End Sub

Public Sub SetID(day As Byte, value As Long)
	m_id(day) = value
End Sub

Public Sub SetSchedule(day As Byte, value As Long)
	m_schedule(day) = value
End Sub