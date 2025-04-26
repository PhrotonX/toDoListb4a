B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_date As Date
	Private m_time As Time
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize()
	m_date.Initialize(0, 0, 0)
	m_time.Initialize(0, 0, 0)
End Sub

Public Sub GetDay As Date
	Return m_date
End Sub

Public Sub GetFormattedDateAndTime(hour24 As Boolean) As String
	Return m_date.GetFormattedDate & " " & m_time.GetFormattedTime(hour24)
End Sub

Public Sub GetTime As Time
	Return m_time
End Sub

Public Sub SetDay(value As Date)
	m_date = value
End Sub

Public Sub SetTime(value As Time) 
	m_time = value
End Sub

' Sets the UNIX time into date and time objects.
Public Sub SetUnixTime(ticks As Long)
	m_date.SetUnixTime(ticks)
	m_time.SetUnixTime(ticks)
End Sub