B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class handles the database.

Sub Class_Globals
	Private database As ToDoDatabase
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	database.Initialize
End Sub

Public Sub InsertTask(item As ToDo)
	database.InsertTask(item)
End Sub

Public Sub DeleteTask(item As ToDo)
	database.DeleteTask(item)
End Sub

Public Sub UpdateTask(Item As ToDo)
	database.UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return database.GetTask(id)
End Sub

Public Sub GetAllTasks() As List
	Return database.GetAllTasks
End Sub

' Calls closure of database,
Public Sub Release
	database.CloseDatabase
End Sub