B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class handles the database and separates SQL-related code from the ViewModel.

Sub Class_Globals
	Private database As ToDoDatabase
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	database.Initialize
End Sub

Public Sub InsertTask(item As ToDo)
	database.TaskDao().InsertTask(item)
End Sub

Public Sub DeleteTask(item As ToDo)
	database.TaskDao().DeleteTask(item)
End Sub

Public Sub UpdateTask(Item As ToDo)
	database.TaskDao().UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return database.TaskDao().GetTasks("WHERE task_id = " & id, "").Get(0)
End Sub

Public Sub GetAllTasks() As List
	Return database.TaskDao().GetTasks("", "")
End Sub

Public Sub GetAllTasksSortedById(ascending As Boolean) As List
	Return database.TaskDao().GetTasks("", "ORDER BY task_id " & DatabaseUtils.IsAscending(ascending))
End Sub

Public Sub GetTasksSortedByCreatedAt(ascending As Boolean) As List
	Return database.TaskDao().GetTasks("", "ORDER BY created_at " & DatabaseUtils.IsAscending(ascending))
End Sub

Public Sub GetTasksSortedByTitle(ascending As Boolean) As List
	Return database.TaskDao().GetTasks("", "ORDER BY title " & DatabaseUtils.IsAscending(ascending))
End Sub

Public Sub GetTasksSortedByDueDate(ascending As Boolean) As List
	Return database.TaskDao().GetTasks("", "ORDER BY due_date " & DatabaseUtils.IsAscending(ascending))
End Sub

Public Sub GetTasksSortedByPriority(ascending As Boolean) As List
	Return database.TaskDao().GetTasks("", "ORDER BY priority " & DatabaseUtils.IsAscending(ascending))
End Sub

Public Sub FindTasksByTitle(query As String, ascending As Boolean) As List
	Return FindTasks(query, ascending, "title")
End Sub

Public Sub FindTasksByNotes(query As String, ascending As Boolean) As List
	Return FindTasks(query, ascending, "notes")
End Sub

Public Sub FindTasksByPriority(query As Int, ascending As Boolean) As List
	Return FindTasks(query, ascending, "priority")
End Sub

Public Sub FindTasksByDueDate(tickBegin As Long, tickEnd As Long, ascending As Boolean) As List
	Return database.TaskDao().GetTasks("WHERE due_date >= " & tickBegin & " AND due_date <= " & tickEnd, "ORDER BY due_date " & _
	DatabaseUtils.IsAscending(ascending))
End Sub

Private Sub FindTasks(query As String, ascending As Boolean, field As String) As List
	Return database.TaskDao().GetTasks("WHERE "&field&" LIKE '%"&query&"%'", "ORDER BY "&field&" " & DatabaseUtils.IsAscending(ascending))
End Sub

' Calls closure of database,
Public Sub Release
	database.CloseDatabase
End Sub