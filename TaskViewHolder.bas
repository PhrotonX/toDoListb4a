B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' Hold UI elements for the item view

Sub Class_Globals
	' Holds the checkbox from the panel
	Public TaskCheckbox As CheckBox
	
	' Holds a glance of the task.
	Public TaskInfo As Label
	
	' Holds the DB-based ID of the task for easy communication witht the
	' database.
	Public ID As Int
	
	' The clickable area of the panel other than the checkox itself.
	Public TaskPanel As Panel
	
	' The root panel of the layout.
	Public Root As B4XView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize()

End Sub