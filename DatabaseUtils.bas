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

' Converts boolean into numeric value since inserting the boolean value directly
' into the database results into an error.
Public Sub BoolToInt(value As Boolean) As Int
	If value == True Then
		Return 1
	Else
		Return 0
	End If
End Sub

' Converts numeric into boolean value.
Public Sub IntToBool(value As Int) As Boolean
	If value == 1 Then
		Return True
	Else
		Return False
	End If
End Sub

' Determines whether the ascending value is true or false, and then returns the
' corresponding SQL keyword for querying.
' Requires space before (and after if needed) concatenating within a query.
Public Sub IsAscending(ascending As Boolean) As String
	If ascending == True Then
		Return "ASC"
	Else
		Return "DESC"
	End If
End Sub
