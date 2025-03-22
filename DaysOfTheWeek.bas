B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Public Days(7) As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	Days(0) = "Sunday"
	Days(1) = "Monday"
	Days(2) = "Tuesday"
	Days(3) = "Wednesday"
	Days(4) = "Thursday"
	Days(5) = "Friday"
	Days(6) = "Saturday"
End Sub

Public Sub ShortenedDay(day As Int) As String
	Return Days(day).SubString2(0, 3)
End Sub