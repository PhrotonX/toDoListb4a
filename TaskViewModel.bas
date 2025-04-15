B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class separates the data and UI layer.

Sub Class_Globals
	Private m_repository As TaskRepository
	
	Public Const TASKS_DEFAULT As Long = -1
	Public Const TASKS_NO_GROUP As Long = 0
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

Public Sub GetTasksSortedByCreatedAt(group_id As Long, ascending As Boolean) As List
	Return m_repository.GetTasksSortedByCreatedAt(group_id, ascending)
End Sub

Public Sub GetTasksSortedByTitle(group_id As Long, ascending As Boolean) As List
	Return m_repository.GetTasksSortedByTitle(group_id, ascending)
End Sub

Public Sub GetTasksSortedByDueDate(group_id As Long, ascending As Boolean) As List
	Return m_repository.GetTasksSortedByDueDate(group_id, ascending)
End Sub

Public Sub GetTasksSortedByPriority(group_id As Long, ascending As Boolean) As List
	Return m_repository.GetTasksSortedByPriority(group_id, ascending)
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
	Dim tasks As List = Starter.TaskViewModelInstance.GetTasksSortedByDueDate(TASKS_DEFAULT, False)
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
	Dim tasks As List = Starter.TaskViewModelInstance.GetTasksSortedByDueDate(TASKS_DEFAULT, False)
	Dim results As List
	results.Initialize
	
	For Each item As ToDo In tasks
		If item.IsDeleted == True Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

Public Sub GetGroupedTasks(group_id As Long) As List
	Return m_repository.GetGroupedTasks(group_id)
End Sub

Public Sub GetUngroupedTasks() As List
	Return m_repository.GetUngroupedTasks()
End Sub

Public Sub FindTasksByTitle(group_id As Long, query As String, ascending As Boolean) As List
	Return m_repository.FindTasksByTitle(group_id, query, ascending)
End Sub

Public Sub FindTasksByNotes(group_id As Long, query As String, ascending As Boolean) As List
	Return m_repository.FindTasksByNotes(group_id, query, ascending)
End Sub

Public Sub FindTasksByPriority(group_id As Long, query As Int, ascending As Boolean) As List
	Return m_repository.FindTasksByPriority(group_id, query, ascending)
End Sub

Public Sub FindTasksByDueDate(group_id As Long, tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
	Return m_repository.FindTasksByDueDate(group_id, tickBegin, tickEnd, ascending)
End Sub

' repeat - Expects a list of 7 boolean values.
Public Sub FindTasksByRepeat(group_id As Long, repeat As List, ascending As Boolean) As List
	Dim tasks As List = m_repository.GetTasksSortedById(group_id, ascending)
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