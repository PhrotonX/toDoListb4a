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
		' Track an iterator to also compare with the task's repeat information into the
		' queried repeat information. ALso the iterator for the day of the week.
		Dim i As Int = 0
		Dim skip As Boolean = False
		
		' Compare if the current queried repeat boolean matches with the tasks repeat boolean.
		' If it did not match, set the skip value as true.
		For Each item In repeat
			If task.GetRepeat(i) <> item Then
				skip = True
			End If
			
			' Iterate into the next day of the week.
			i = i + 1
		Next
		
		' Skip the task if matching has failed. Else, add the current task as a result.
		If skip == True Then
			Continue
		Else
			result.Add(task)
		End If
	Next
	
	Return result
End Sub

' Releases data handled by Repository
Public Sub Release
	repository.Release
End Sub