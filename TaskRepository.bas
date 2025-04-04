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
	Return database.GetAllTasks("")
End Sub

Public Sub GetAllTasksSortedByCreatedAt(ascending As Boolean) As List
	If ascending == True Then
		Return database.GetAllTasks("ORDER BY created_at ASC")
	Else
		Return database.GetAllTasks("ORDER BY created_at DESC")
	End If
End Sub

Public Sub GetAllTasksSortedByTitle(ascending As Boolean) As List
	If ascending == True Then
		Return database.GetAllTasks("ORDER BY title ASC")
	Else
		Return database.GetAllTasks("ORDER BY title DESC")
	End If
End Sub

Public Sub GetAllTasksSortedByDueDate(ascending As Boolean) As List
	If ascending == True Then
		Return database.GetAllTasks("ORDER BY due_date ASC")
	Else
		Return database.GetAllTasks("ORDER BY due_date DESC")
	End If
End Sub

Public Sub GetAllTasksSortedByPriority(ascending As Boolean) As List
	If ascending == True Then
		Return database.GetAllTasks("ORDER BY priority ASC")
	Else
		Return database.GetAllTasks("ORDER BY priority DESC")
	End If
End Sub

' Calls closure of database,
Public Sub Release
	database.CloseDatabase
End Sub