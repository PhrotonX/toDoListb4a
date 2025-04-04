B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_hour As Int
	Private m_minute As Int
	Private m_second As Int
	Private m_marker As String
	Private m_24hour As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(hour As Int, minute As Int, second As Int)
	m_hour = hour
	m_minute = minute
	m_second = second
End Sub

' Converts currently set hour into a 12-hour format.
Private Sub Convert24HourInto12HourFormat As Int
	If m_hour > 12 And m_hour < 24 Then
		Dim result As Int = m_hour - 12
		
		' Check if current result is zero and return 12 instead of 0.
		If result == 0 Then
			Return 12
		End If
	End If
End Sub

' Sets the time based on ticks of UNIX Time format.
Public Sub SetUnixTime(ticks As Long)
	m_hour = DateTime.GetHour(ticks)
	m_minute = DateTime.GetHour(ticks)
	m_second = DateTime.GetHour(ticks)
End Sub

' Returns a formatted time.
Public Sub GetFormattedTime As String
	'Check if the time uses a 24-hour format to return a string of Time of HH:MM:SS format.
	If m_24hour == True Then
		Return GetNumWithLeadingZero(m_hour) & ":" & GetNumWithLeadingZero(m_minute) & ":" & _
		":" & GetNumWithLeadingZero(m_second)	
	Else
		' Return a 12-hour format (hh:mm:ss a) instead
		Return GetNumWithLeadingZero(Convert24HourInto12HourFormat) & ":" & _
			GetNumWithLeadingZero(m_minute) & ":" & _
			GetNumWithLeadingZero(m_second) & ":" & _
			" " & GetTimeMarker
	End If
End Sub

Public Sub GetHour As Int
	Return m_hour
End Sub

' Returns a numeric string with 1 leading zero. Works for numbers intended to be displayed
' as a two digit number with a single zero.
Private Sub GetNumWithLeadingZero(num As Int) As String
	Select num
		Case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9:
			Return "0" & num
		Case Else:
			Return num
	End Select
End Sub

Public Sub GetMinute As Int
	Return m_minute
End Sub

Public Sub GetSecond As Int
	Return m_second
End Sub

' Returns the AM/PM time market based on the hour value.
Public Sub GetTimeMarker As String
	If m_hour > 11 Then
		Return "PM"
	Else
		Return "AM"	
	End If
End Sub

Public Sub SetHour(hour As Int)
	m_hour = hour
End Sub

Public Sub SetMinute(minute As Int)
	m_minute = minute
End Sub

Public Sub SetSecond(second As Int)
	m_second = second
End Sub

Public Sub Use24HourTimeFormat(value As Boolean)
	m_24hour = value
End Sub



