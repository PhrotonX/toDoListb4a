B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class separates the data and UI layer.

Sub Class_Globals
	Private repository As TaskRepository
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	repository.Initialize
End Sub

Public Sub InsertTask(item As ToDo)
	repository.InsertTask(item)
End Sub

Public Sub DeleteTask(item As ToDo)
	repository.DeleteTask(item)
End Sub

Public Sub UpdateTask(Item As ToDo)
	repository.UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return repository.GetTask(id)
End Sub

Public Sub GetAllTasks() As List
	Return repository.GetAllTasks
End Sub

Public Sub GetAllTasksSortedByCreatedAt(ascending As Boolean) As List
	Return repository.GetAllTasksSortedByCreatedAt(ascending)
End Sub

Public Sub GetAllTasksSortedByTitle(ascending As Boolean) As List
	Return repository.GetAllTasksSortedByTitle(ascending)
End Sub

Public Sub GetAllTasksSortedByDueDate(ascending As Boolean) As List
	Return repository.GetAllTasksSortedByDueDate(ascending)
End Sub

Public Sub GetAllTasksSortedByPriority(ascending As Boolean) As List
	Return repository.GetAllTasksSortedByPriority(ascending)
End Sub

' Releases data handled by Repository
Public Sub Release
	repository.Release
End Sub