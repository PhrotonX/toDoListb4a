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

Private Sub GetAllTasks() As List
	Return m_repository.GetAllTasks
End Sub

Public Sub GetAllTasksSorted(query As TaskQuery) As List
	If query.IsSortingEnabled() Then
		Return GetSortedTasks(query)
	Else
		Return GetAllTasks
	End If
End Sub

Public Sub GetSortedTasks(query As TaskQuery) As List
	Return m_repository.GetSortedTasks(query)
End Sub

Public Sub GetTasksSortedById(group_id As Long, ascending As Boolean) As List
	Dim query As TaskQuery
	query.Initialize()
	query.SetGroupID(group_id)
	query.SetSortField(query.FIELD_TASK_ID)
	If ascending Then
		query.SetSortOrder(query.ORDER_ASC)
	Else
		query.SetSortOrder(query.ORDER_DESC)
	End If
	Return m_repository.GetSortedTasks(query)
End Sub

Public Sub GetTasksSortedByCreatedAt(group_id As Long, ascending As Boolean) As List
	Dim query As TaskQuery
	query.Initialize()
	query.SetGroupID(group_id)
	query.SetSortField(query.FIELD_CREATED_AT)
	If ascending Then
		query.SetSortOrder(query.ORDER_ASC)
	Else
		query.SetSortOrder(query.ORDER_DESC)
	End If
	Return m_repository.GetSortedTasks(query)
End Sub

Public Sub GetTasksSortedByTitle(group_id As Long, ascending As Boolean) As List
	Dim query As TaskQuery
	query.Initialize()
	query.SetGroupID(group_id)
	query.SetSortField(query.FIELD_TITLE)
	If ascending Then
		query.SetSortOrder(query.ORDER_ASC)
	Else
		query.SetSortOrder(query.ORDER_DESC)
	End If
	Return m_repository.GetSortedTasks(query)
End Sub

Public Sub GetTasksSortedByDueDate(group_id As Long, ascending As Boolean) As List
	Dim query As TaskQuery
	query.Initialize()
	query.SetGroupID(group_id)
	query.SetSortField(query.FIELD_DUE_DATE)
	If ascending Then
		query.SetSortOrder(query.ORDER_ASC)
	Else
		query.SetSortOrder(query.ORDER_DESC)
	End If
	Return m_repository.GetSortedTasks(query)
End Sub

Public Sub GetTasksSortedByPriority(group_id As Long, ascending As Boolean) As List
	Dim query As TaskQuery
	query.Initialize()
	query.SetGroupID(group_id)
	query.SetSortField(query.FIELD_PRIORITY)
	If ascending Then
		query.SetSortOrder(query.ORDER_ASC)
	Else
		query.SetSortOrder(query.ORDER_DESC)
	End If
	Return m_repository.GetSortedTasks(query)
End Sub

Public Sub GetTasksToday(query As TaskQuery) As List
	Dim tasks As List
	
	If query.IsSortingEnabled() Then
		tasks = GetSortedTasks(query)
	Else
		tasks = GetAllTasks
	End If
	
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
Public Sub GetTasksCompleted(query As TaskQuery) As List
	Dim tasks As List
	
	If query.IsSortingEnabled() Then
		tasks = GetSortedTasks(query)
	Else
		tasks = GetAllTasks
	End If
	
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
Public Sub GetTasksPlanned(query As TaskQuery) As List
	Dim tasks As List
	
	If query.IsSortingEnabled() Then
		tasks = GetAllTasksSorted(query)
	Else
		tasks = GetTasksSortedByDueDate(TASKS_DEFAULT, False)
	End If
	
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
Public Sub GetDeletedTasks(query As TaskQuery) As List
	Dim tasks As List
	
	' Shall be tasks sorted by deleted_at at default.
	If query.IsSortingEnabled() Then
		tasks = GetAllTasksSorted(query)
	Else
		tasks = GetTasksSortedByDueDate(TASKS_DEFAULT, False)
	End If
	
	Dim results As List
	results.Initialize
	
	For Each item As ToDo In tasks
		If item.IsDeleted == True Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

' @Deprecated
Public Sub GetGroupedTasks(query As TaskQuery) As List
	Return m_repository.GetGroupedTasks(query)
End Sub

' @Deprecated
Public Sub GetUngroupedTasks(query As TaskQuery) As List
	Return m_repository.GetUngroupedTasks(query)
End Sub

' @Deprecated
Public Sub FindTasksByTitle(group_id As Long, query As String, ascending As Boolean) As List
	Return m_repository.FindTasksByTitle(group_id, query, ascending)
End Sub

' @Deprecated
Public Sub FindTasksByNotes(group_id As Long, query As String, ascending As Boolean) As List
	Return m_repository.FindTasksByNotes(group_id, query, ascending)
End Sub

' @Deprecated
Public Sub FindTasksByPriority(group_id As Long, query As Int, ascending As Boolean) As List
	Return m_repository.FindTasksByPriority(group_id, query, ascending)
End Sub

' @Deprecated
Public Sub FindTasksByDueDate(group_id As Long, tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
	Return m_repository.FindTasksByDueDate(group_id, tickBegin, tickEnd, ascending)
End Sub

' repeat - Expects a list of 7 boolean values.
Public Sub FindTasksByRepeat(group_id As Long, repeat As List, ascending As Boolean) As List
	Dim tasks As List = GetTasksSortedById(group_id, ascending)
	
	Dim result As List
	result.Initialize
	
	' Check each task if they consist of correct repeat items.
	For Each task As ToDo In tasks
		' Track an iterator to also compare with the task's repeat information into the
		' queried repeat information. Also the iterator for the day of the week.
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