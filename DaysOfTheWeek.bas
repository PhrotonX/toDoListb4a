B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Public Days As String(7)
	Public Enabled As Boolean(7)
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	For Each day As DayOfTheWeek In Days
		day.Initialize
	Next
	
	Days(0).Day = "Sunday"
	Days(1).Day = "Monday"
	Days(2).Day = "Tuesday"
	Days(3).Day = "Wednesday"
	Days(4).Day = "Thursday"
	Days(5).Day = "Friday"
	days(6).Day = "Saturday"
End Sub