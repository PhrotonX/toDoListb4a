B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.1
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

' Cuts the name of the day of the week into three characters
Public Sub ShortenedDay(Day As Int) As String
	Return Days(Day).SubString2(0, 3)
End Sub

Public Sub Days(day As Int) As String
	Select day:
		Case 0:
			Return "sunday"
		Case 1:
			Return "monday"
		Case 2:
			Return "tuesday"
		Case 3:
			Return "wednesday"
		Case 4:
			Return "thursday"
		Case 5:
			Return "friday"
		Case 6:
			Return "saturday"
	End Select
End Sub