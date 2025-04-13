B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Public BackPanel As B4XView
	Public Name As B4XView
	Public Icon As B4XView
	Public Root As B4XView
	Public ID As Long ' Group ID from the DB.
	Public IsSeparator As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	IsSeparator = False
End Sub