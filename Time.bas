﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class stores time in 24-hour format by default.

Sub Class_Globals
	Private m_hour As Int
	Private m_minute As Int
	Private m_second As Int
	
	' A single day in UNIX time is equal to 86,400,000 milliseconds.
	Private Const DAY_LENGTH As Long = 86400000
	
	Public Const MARKER_AM As String = "AM"
	Public Const MARKER_PM As String = "PM"
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
		
		Return result
	End If
	
	Return m_hour
End Sub

' Sets the time based on ticks of UNIX Time format.
Public Sub SetUnixTime(ticks As Long)
	m_hour = DateTime.GetHour(ticks)
	m_minute = DateTime.GetMinute(ticks)
	m_second = DateTime.GetSecond(ticks)
End Sub

' Returns a formatted time.
Public Sub GetFormattedTime(hour24 As Boolean) As String
	'Check if the time uses a 24-hour format to return a string of Time of HH:MM:SS format.
	If hour24 Then
		Return GetFormattedTime24Hour
	Else
		' Return a 12-hour format (hh:mm:ss a) instead
		Return GetNumWithLeadingZero(Convert24HourInto12HourFormat) & ":" & _
			GetNumWithLeadingZero(m_minute) & ":" & _
			GetNumWithLeadingZero(m_second) & ":" & _
			" " & GetTimeMarker
	End If
End Sub

Public Sub GetFormattedTime24Hour() As String
	Return GetNumWithLeadingZero(m_hour) & ":" & GetNumWithLeadingZero(m_minute) & ":" & _
		GetNumWithLeadingZero(m_second)
End Sub

Public Sub GetHour As Int
	Return m_hour
End Sub

' Returns the hour value, depending on the 24-hour setting.
Public Sub GetHour2(hour24 As Boolean) As Int
	If hour24 Then
		Return m_hour
	Else
		Return Convert24HourInto12HourFormat
	End If
End Sub

Public Sub GetMarker As String
	If m_hour >= 12 And m_hour < 24 Then
		Return MARKER_PM
	Else
		Return MARKER_AM
	End If
End Sub

' Returns a numeric string with 1 leading zero. Works for numbers intended to be displayed
' as a two digit number with a single zero.
Public Sub GetNumWithLeadingZero(num As Int) As String
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

Public Sub GetUnixTime() As Long
	' Get the UNIX time of the time value set into this object. However, this includes the
	' UNIX time of the current date as well.
	Dim unixTime As Long = DateTime.TimeParse(GetFormattedTime24Hour)

	' Retrieve the time only in UNIX format.
	Return unixTime Mod DAY_LENGTH
End Sub

' Expects 24-hour format
Public Sub SetHour(hour As Int)
	m_hour = hour
End Sub

' Sets an hour value depending on the 24-hour settings.
Public Sub SetHour2(hour As Int, hour24 As Boolean)
	If hour24 Then
		SetHour(hour)
	Else
		If hour >= 12 And hour < 24  Then
			SetHour12HourFormat(hour, MARKER_PM)
		Else
			SetHour12HourFormat(hour, MARKER_AM)
		End If
	End If
End Sub

Public Sub SetHour12HourFormat(hour As Int, marker As String)
	If marker == MARKER_AM Then
		' 12:00 AM is 00:00.
		If hour == 12 Then
			m_hour = 0
		Else
			m_hour = hour
		End If
	Else If marker == MARKER_PM Then
		If hour == 12 Then
			m_hour = 12
		Else
			' 1:00 PM is 1 + 12 = 13:00 and 11:00 PM is 11+12 = 23:00.
			m_hour = hour + 12
		End If
	End If
End Sub

Public Sub SetMinute(minute As Int)
	m_minute = minute
End Sub

Public Sub SetSecond(second As Int)
	m_second = second
End Sub


