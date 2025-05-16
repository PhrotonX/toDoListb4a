B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_snooze As Long = 0
	
	Public Const SNOOZE_OFF As Long = 0
	Public Const SNOOZE_1_MINUTE As Long = 60000
	Public Const SNOOZE_3_MINUTES As Long = 180000
	Public Const SNOOZE_5_MINUTES As Long = 300000
	Public Const SNOOZE_10_MINUTES As Long = 600000
	Public Const SNOOZE_15_MINUTES As Long = 900000
	Public Const SNOOZE_20_MINUTES As Long = 1200000
	Public Const SNOOZE_30_MINUTES As Long = 1800000
	Public Const SNOOZE_1_HOUR As Long = 3600000
	Public Const SNOOZE_2_HOURS As Long = 7200000
	Public Const SNOOZE_5_HOURS As Long = 18000000
	Public Const SNOOZE_12_HOURS As Long = 43200000
	Public Const SNOOZE_1_DAY As Long = 86400000
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub GetSnooze() As Long
	Return m_snooze
End Sub

Public Sub GetSnoozeInfo() As String
	Return GetSnoozeText(m_snooze)
End Sub

Public Sub GetSnoozeText(value As Long) As String
	Select value
		Case SNOOZE_OFF:
			Return "off"
		Case SNOOZE_1_MINUTE:
			Return "1_minute"
		Case SNOOZE_3_MINUTES:
			Return "3_minutes"
		Case SNOOZE_5_MINUTES:
			Return "5_minutes"
		Case SNOOZE_10_MINUTES:
			Return "10_minutes"
		Case SNOOZE_15_MINUTES:
			Return "15_minutes"
		Case SNOOZE_20_MINUTES:
			Return "20_minutes"
		Case SNOOZE_30_MINUTES:
			Return "30_minutes"
		Case SNOOZE_1_HOUR:
			Return "1_hour"
		Case SNOOZE_2_HOURS:
			Return "2_hours"
		Case SNOOZE_5_HOURS:
			Return "5_hours"
		Case SNOOZE_12_HOURS:
			Return "12_hours"
		Case SNOOZE_1_DAY:
			Return "1_day"
		Case Else:
			Return ""
	End Select
End Sub

Public Sub GetSnoozeFromText(value As String) As Long
	Select value
		Case "off":
			Return SNOOZE_OFF
		Case "1_minute":
			Return SNOOZE_1_MINUTE
		Case "3_minutes":
			Return SNOOZE_3_MINUTES
		Case "5_minutes":
			Return SNOOZE_5_MINUTES
		Case "10_minutes":
			Return SNOOZE_10_MINUTES
		Case "15_minutes":
			Return SNOOZE_15_MINUTES
		Case "20_minutes":
			Return SNOOZE_20_MINUTES
		Case "30_minutes":
			Return SNOOZE_30_MINUTES
		Case "1_hour":
			Return SNOOZE_1_HOUR
		Case "2_hours":
			Return SNOOZE_2_HOURS
		Case "5_hours":
			Return SNOOZE_5_HOURS
		Case "12_hours":
			Return SNOOZE_12_HOURS
		Case "1_day":
			Return SNOOZE_1_DAY
		Case Else:
			Return 0
	End Select
End Sub

Public Sub SetSnooze(value As Long)
	m_snooze = value
End Sub