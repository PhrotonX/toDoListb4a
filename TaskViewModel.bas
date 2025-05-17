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
	
	
	Private m_completeTaskCtr As Int = 0
	Private m_incompleteTaskCtr As Int = 0
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

' Note: If the item.Done value has been changed, it is required to call RepeatViewModel.CalculateSchedule()
' to refresh the notifications.
Public Sub UpdateTask(Item As ToDo)
	m_repository.UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return m_repository.GetTask(id)
End Sub

Public Sub GetTasks(query As TaskQuery) As List
	Return m_repository.GetTasks(query)
End Sub

Private Sub GetAllTasks() As List
	Return m_repository.GetAllTasks
End Sub

Public Sub GetAllTasksSorted(query As TaskQuery) As List
		Return GetSortedTasks(query)
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
		tasks = GetTasks(query)
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
			
			m_incompleteTaskCtr = m_incompleteTaskCtr + 1
		End If
	Next
	
	Return results
End Sub

' Move logic to repository.
Public Sub GetTasksPlanned(query As TaskQuery) As List
	m_completeTaskCtr = 0
	m_incompleteTaskCtr = 0
	
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
			
			m_incompleteTaskCtr = m_incompleteTaskCtr + 1
		End If
	Next
	
	Return results
End Sub

' Move logic to repository.
' This clears the search query and then replaces it with FIELD_IS_DELETED set to true.
Public Sub GetDeletedTasks(query As TaskQuery) As List
	Dim tasks As List
	Dim results As List
	results.Initialize()
	
	' Avoid updating the referenced TaskQuery.
	Dim queryCopy As TaskQuery = query
	
	'The query system needs to be fixed before using this functions.
	queryCopy.SetSearchIsDeleted(True)
	
	tasks = GetAllTasksSorted(queryCopy)
	For Each item As ToDo In tasks
		If item.IsDeleted == True Then
			results.Add(item)
		End If
	Next
	
	Return results
End Sub

Public Sub GetGroupedTasks(query As TaskQuery) As List
	Return m_repository.GetGroupedTasks(query)
End Sub

Public Sub GetUngroupedTasks(query As TaskQuery) As List
	Return m_repository.GetUngroupedTasks(query)
End Sub

' Used for completed tasks.
Public Sub LastCountedCompleteTasks
	Return m_completeTaskCtr
End Sub

' Used for planned tasks.
Public Sub LastCountedIncompleteTasks
	Return m_incompleteTaskCtr
End Sub

' Expects Starter.SettingsViewModelInstance to be initialized.
Public Sub PlayTaskCompletionSound
	If Starter.SettingsViewModelInstance.IsTaskCompetionSoundEnabled Then
		Dim mp As MediaPlayer
		mp.Initialize
		mp.Load(File.DirAssets, "done_sound.mp3")
		mp.Play
	End If
End Sub