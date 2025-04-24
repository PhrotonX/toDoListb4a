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
			Return "Off"
		Case SNOOZE_1_MINUTE:
			Return "1 Minute"
		Case SNOOZE_3_MINUTES:
			Return "3 Minutes"
		Case SNOOZE_5_MINUTES:
			Return "5 Minutes"
		Case SNOOZE_10_MINUTES:
			Return "10 Minutes"
		Case SNOOZE_15_MINUTES:
			Return "15 Minutes"
		Case SNOOZE_20_MINUTES:
			Return "20 Minutes"
		Case SNOOZE_30_MINUTES:
			Return "30 Minutes"
		Case SNOOZE_1_HOUR:
			Return "1 Hour"
		Case SNOOZE_2_HOURS:
			Return "2 Hours"
		Case SNOOZE_5_HOURS:
			Return "5 Hours"
		Case SNOOZE_12_HOURS:
			Return "12 Hours"
		Case SNOOZE_1_DAY:
			Return "1 Day"
		Case Else:
			Return ""
	End Select
End Sub

Public Sub GetSnoozeFromText(value As String) As Long
	Select value
		Case "Off":
			Return SNOOZE_OFF
		Case "1 Minute":
			Return SNOOZE_1_MINUTE
		Case "3 Minutes":
			Return SNOOZE_3_MINUTES
		Case "5 Minutes":
			Return SNOOZE_5_MINUTES
		Case "10 Minutes":
			Return SNOOZE_10_MINUTES
		Case "15 Minutes":
			Return SNOOZE_15_MINUTES
		Case "20 Minutes":
			Return SNOOZE_20_MINUTES
		Case "30 Minutes":
			Return SNOOZE_30_MINUTES
		Case "1 Hour":
			Return SNOOZE_1_HOUR
		Case "2 Hours":
			Return SNOOZE_2_HOURS
		Case "5 Hours":
			Return SNOOZE_5_HOURS
		Case "12 Hours":
			Return SNOOZE_12_HOURS
		Case "1 Day":
			Return SNOOZE_1_DAY
		Case Else:
			Return 0
	End Select
End Sub

Public Sub SetSnooze(value As Long)
	m_snooze = value
End Sub