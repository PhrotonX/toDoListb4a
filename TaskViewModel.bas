B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class separates the data and UI layer.

Sub Class_Globals
	Private m_repository As TaskRepository
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(repository As TaskRepository)
	m_repository = repository
End Sub

Public Sub InsertTask(item As ToDo)
	m_repository.InsertTask(item)
End Sub

Public Sub DeleteTask(item As ToDo)
	m_repository.DeleteTask(item)
End Sub

Public Sub UpdateTask(Item As ToDo)
	m_repository.UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return m_repository.GetTask(id)
End Sub

Public Sub GetAllTasks() As List
	Return m_repository.GetAllTasks
End Sub

Public Sub GetTasksSortedByCreatedAt(ascending As Boolean) As List
	Return m_repository.GetTasksSortedByCreatedAt(ascending)
End Sub

Public Sub GetTasksSortedByTitle(ascending As Boolean) As List
	Return m_repository.GetTasksSortedByTitle(ascending)
End Sub

Public Sub GetTasksSortedByDueDate(ascending As Boolean) As List
	Return m_repository.GetTasksSortedByDueDate(ascending)
End Sub

Public Sub GetTasksSortedByPriority(ascending As Boolean) As List
	Return m_repository.GetTasksSortedByPriority(ascending)
End Sub

Public Sub GetTasksToday() As List
	Dim tasks As List = GetAllTasks
	Dim results As List
	results.Initialize
	
	For Each item As ToDo In tasks
		If item.GetDueDate.IdentifyDate == item.GetDueDate.DATE_TODAY Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

' Move logic to repository.
Public Sub GetTasksCompleted() As List
	Dim tasks As List = GetAllTasks
	Dim results As List
	results.Initialize
	
	For Each item As ToDo In tasks
		If item.Done Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

' Move logic to repository.
Public Sub GetTasksPlanned() As List
	Dim tasks As List = Starter.TaskViewModelInstance.GetTasksSortedByDueDate(False)
	Dim results As List
	results.Initialize
	
	For Each item As ToDo In tasks
		If item.Done == False Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

' Move logic to repository.
Public Sub GetDeletedTasks() As List
	' Shall be tasks sorted by deleted_at.
	Dim tasks As List = Starter.TaskViewModelInstance.GetTasksSortedByDueDate(False)
	Dim results As List
	results.Initialize
	
	For Each item As ToDo In tasks
		If item.IsDeleted == True Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

Public Sub FindTasksByTitle(query As String, ascending As Boolean) As List
	Return m_repository.FindTasksByTitle(query, ascending)
End Sub

Public Sub FindTasksByNotes(query As String, ascending As Boolean) As List
	Return m_repository.FindTasksByNotes(query, ascending)
End Sub

Public Sub FindTasksByPriority(query As Int, ascending As Boolean) As List
	Return m_repository.FindTasksByPriority(query, ascending)
End Sub

Public Sub FindTasksByDueDate(tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
	Return m_repository.FindTasksByDueDate(tickBegin, tickEnd, ascending)
End Sub

' repeat - Expects a list of 7 boolean values.
Public Sub FindTasksByRepeat(repeat As List, ascending As Boolean) As List
	Dim tasks As List = m_repository.GetAllTasksSortedById(ascending)
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