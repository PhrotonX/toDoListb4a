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
	Dim result As List = m_database.TaskDao().GetTasks("SELECT * FROM task", "", "WHERE task_id = " & id, "")
	If result.Size > 0 Then
		Return result.Get(0)
	End If
	
	Return Null
End Sub

Public Sub GetTasks(query As TaskQuery) As List
	Return m_database.TaskDao().GetTasks(query.GetSelectClause(), query.GetJoinQuery(True), _ 
	query.GetSearchingQuery(False), query.GetSortingQuery)
End Sub

Public Sub GetAllTasks() As List
	Return m_database.TaskDao().GetTasks("SELECT * from task", "", "", "ORDER BY done ASC")
End Sub

Public Sub GetGroupedTasks(query As TaskQuery) As List
	Return m_database.TaskDao().GetGroupedTasks(query.GetSelectClause(), query.GetGroupID, _ 
	query.GetSearchingQuery(True), query.GetSortingQuery())
End Sub

Public Sub GetUngroupedTasks(query As TaskQuery) As List
	Return m_database.TaskDao().GetUngroupedTasks(query.GetSelectClause(), _ 
	query.GetSearchingQuery(True), query.GetSortingQuery())
End Sub

Public Sub GetSortedTasks(query As TaskQuery) As List
	Dim group_id As Long = query.GetGroupID
	
	If group_id == TASKS_DEFAULT Then
		Return m_database.TaskDao().GetTasks(query.GetSelectClause(), query.GetJoinQuery(True), _ 
		query.GetSearchingQuery(False), query.GetSortingQuery())
	Else If group_id == TASKS_NO_GROUP Then
		Return m_database.TaskDao().GetUngroupedTasks(query.GetSelectClause(), " AND " & _ 
		query.GetSearchingQuery(True), query.GetSortingQuery())
	Else
		Return m_database.TaskDao().GetGroupedTasks(query.GetSelectClause(), group_id, " AND " & _ 
		query.GetSearchingQuery(True), query.GetSortingQuery())
	End If
End Sub

'Public Sub FindTasksByTitle(group_id As Long, query As String, ascending As Boolean) As List
'	Return FindTasks(group_id, query, ascending, "title")
'End Sub

'Public Sub FindTasksByNotes(group_id As Long, query As String, ascending As Boolean) As List
'	Return FindTasks(group_id, query, ascending, "notes")
'End Sub

'Public Sub FindTasksByPriority(group_id As Long, query As Int, ascending As Boolean) As List
'	Return FindTasks(group_id, query, ascending, "priority")
'End Sub

'Public Sub FindTasksByDueDate(group_id As Long, tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
'	If group_id == TASKS_DEFAULT Then
'		Return m_database.TaskDao().GetTasks("SELECT * FROM task", "", "WHERE due_date >= " & tickBegin & _ 
'		 " AND due_date <= " & tickEnd, "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
'	Else If group_id == TASKS_NO_GROUP Then
'		Return m_database.TaskDao().GetUngroupedTasks("SELECT * FROM task", "WHERE due_date >= " & tickBegin & _ 
'		" AND due_date <= " & tickEnd, "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
'	Else
'		Return m_database.TaskDao().GetGroupedTasks("SELECT * FROM task", group_id, "WHERE due_date >= " & _ 
'		tickBegin & " AND due_date <= " & tickEnd, "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
'	End If
'End Sub

'Private Sub FindTasks(group_id As Long, query As String, ascending As Boolean, field As String) As List
'	If group_id == TASKS_DEFAULT Then
'		Return m_database.TaskDao().GetTasks("SELECT * FROM task", "", "WHERE "&field&" LIKE '%"&query&"%'", _ 
'		"ORDER BY " & field & " " & DatabaseUtils.IsAscending(ascending))
'	Else If group_id == TASKS_NO_GROUP Then
'		Return m_database.TaskDao().GetUngroupedTasks("SELECT * FROM task", "WHERE "&field&" LIKE '%"&query&"%'", _ 
'		"ORDER BY "&field&" " & DatabaseUtils.IsAscending(ascending))
'	Else
'		Return m_database.TaskDao().GetGroupedTasks("SELECT * FROM task", group_id, "WHERE "&field&" LIKE '%"& _ 
'		query&"%'", "ORDER BY "&field&" " & DatabaseUtils.IsAscending(ascending))
'	End If
'End Sub