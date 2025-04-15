B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class handles the database and separates SQL-related code from the ViewModel.

Sub Class_Globals
	Private m_database As ToDoDatabase
	
	Public Const TASKS_DEFAULT As Long = -1
	Public Const TASKS_NO_GROUP As Long = 0
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(database As ToDoDatabase)
	m_database = database
End Sub

Public Sub InsertTask(item As ToDo)
	m_database.TaskDao().InsertTask(item)
End Sub

Public Sub DeleteTask(item As ToDo)
	m_database.TaskDao().DeleteTask(item)
End Sub

Public Sub UpdateTask(Item As ToDo)
	m_database.TaskDao().UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return m_database.TaskDao().GetTasks("WHERE task_id = " & id, "").Get(0)
End Sub

Public Sub GetAllTasks() As List
	Return m_database.TaskDao().GetTasks("", "ORDER BY done ASC")
End Sub

Public Sub GetGroupedTasks(group_id As Long) As List
	Return m_database.TaskDao().GetGroupedTasks(group_id, "", "ORDER BY done ASC")
End Sub

Public Sub GetUngroupedTasks() As List
	Return m_database.TaskDao().GetUngroupedTasks("", "ORDER BY done ASC")
End Sub

Public Sub GetTasksSortedById(group_id As Long, ascending As Boolean) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("", "ORDER BY task_id " & DatabaseUtils.IsAscending(ascending) & _
		 ", done ASC")
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("", "ORDER BY task_id " & _ 
		DatabaseUtils.IsAscending(ascending) & ", done ASC")
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "", "ORDER BY task_id " & _
		DatabaseUtils.IsAscending(ascending) & ", done ASC")
	End If
End Sub

Public Sub GetTasksSortedByCreatedAt(group_id As Long, ascending As Boolean) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("", "ORDER BY created_at " & DatabaseUtils.IsAscending(ascending))
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("", "ORDER BY created_at " & DatabaseUtils.IsAscending(ascending))
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "", "ORDER BY created_at " & _
		DatabaseUtils.IsAscending(ascending))
	End If
End Sub

Public Sub GetTasksSortedByTitle(group_id As Long, ascending As Boolean) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("", "ORDER BY title " & DatabaseUtils.IsAscending(ascending))
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("", "ORDER BY title " & DatabaseUtils.IsAscending(ascending))
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "", "ORDER BY title " & _ 
		DatabaseUtils.IsAscending(ascending))
	End If
End Sub

Public Sub GetTasksSortedByDueDate(group_id As Long, ascending As Boolean) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("", "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("", "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "", "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
	End If
	
End Sub

Public Sub GetTasksSortedByPriority(group_id As Long, ascending As Boolean) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("", "ORDER BY priority " & DatabaseUtils.IsAscending(ascending))
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("", "ORDER BY priority " & DatabaseUtils.IsAscending(ascending))
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "", "ORDER BY priority " & _
		DatabaseUtils.IsAscending(ascending))
	End If
End Sub

Public Sub FindTasksByTitle(group_id As Long, query As String, ascending As Boolean) As List
	Return FindTasks(group_id, query, ascending, "title")
End Sub

Public Sub FindTasksByNotes(group_id As Long, query As String, ascending As Boolean) As List
	Return FindTasks(group_id, query, ascending, "notes")
End Sub

Public Sub FindTasksByPriority(group_id As Long, query As Int, ascending As Boolean) As List
	Return FindTasks(group_id, query, ascending, "priority")
End Sub

Public Sub FindTasksByDueDate(group_id As Long, tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("WHERE due_date >= " & tickBegin & " AND due_date <= " & tickEnd, _
		"ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("WHERE due_date >= " & tickBegin & " AND due_date <= " & tickEnd, _
		"ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "WHERE due_date >= " & tickBegin & " AND due_date <= " & _ 
		tickEnd, "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
	End If
End Sub

Private Sub FindTasks(group_id As Long, query As String, ascending As Boolean, field As String) As List
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks("WHERE "&field&" LIKE '%"&query&"%'", "ORDER BY "&field&" " _
		& DatabaseUtils.IsAscending(ascending))
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks("WHERE "&field&" LIKE '%"&query&"%'", "ORDER BY "&field&" " _
		& DatabaseUtils.IsAscending(ascending))
	Else
		Return m_database.TaskDao().GetGroupedTasks(group_id, "WHERE "&field&" LIKE '%"&query&"%'", "ORDER BY "&field&" " _
		& DatabaseUtils.IsAscending(ascending))
	End If
End Sub