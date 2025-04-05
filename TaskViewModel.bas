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

Public Sub GetTasksSortedByCreatedAt(ascending As Boolean) As List
	Return repository.GetTasksSortedByCreatedAt(ascending)
End Sub

Public Sub GetTasksSortedByTitle(ascending As Boolean) As List
	Return repository.GetTasksSortedByTitle(ascending)
End Sub

Public Sub GetTasksSortedByDueDate(ascending As Boolean) As List
	Return repository.GetTasksSortedByDueDate(ascending)
End Sub

Public Sub GetTasksSortedByPriority(ascending As Boolean) As List
	Return repository.GetTasksSortedByPriority(ascending)
End Sub


Public Sub FindTasksByTitle(query As String, ascending As Boolean) As List
	Return repository.FindTasksByTitle(query, ascending)
End Sub

Public Sub FindTasksByNotes(query As String, ascending As Boolean) As List
	Return repository.FindTasksByNotes(query, ascending)
End Sub

Public Sub FindTasksByPriority(query As Int, ascending As Boolean) As List
	Return repository.FindTasksByPriority(query, ascending)
End Sub

Public Sub FindTasksByDueDate(tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
	Return repository.FindTasksByDueDate(tickBegin, tickEnd, ascending)
End Sub

' repeat - Expects a list of 7 boolean values.
Public Sub FindTasksByRepeat(repeat As List, ascending As Boolean) As List
	Dim tasks As List = repository.GetAllTasksSortedById(ascending)
	Dim result As List
	result.Initialize
	
	' Check each task if they consist of correct repeat items.
	For Each task As ToDo In tasks
		Dim i As Int = 0
		Dim correct(7) As Int
		
		' Identify the correct items and put their indexes into an array of correct items.
		For Each item In repeat
			correct(i) = -1
			If task.GetRepeat(i) == item Then
				correct(i) = i
			End If
			i = i + 1
		Next
		
		' Check if the repeat items match with the correct array, then add the task into the
		' results if none failed.
		For Each j As Int In correct
			If j <> -1 Then
				If task.GetRepeat(j) == False Then
					' Skips searching
					j = 7
				Else
					' Add the task as a result.
					result.Add(task)
					j = 7
				End If
			End If
		Next
	Next
	
	Return result
End Sub

' Releases data handled by Repository
Public Sub Release
	repository.Release
End Sub