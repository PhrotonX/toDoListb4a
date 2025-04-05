B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class handles the database.

Sub Class_Globals
	Private database As ToDoDatabase
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	database.Initialize
End Sub

Public Sub InsertTask(item As ToDo)
	database.InsertTask(item)
End Sub

Public Sub DeleteTask(item As ToDo)
	database.DeleteTask(item)
End Sub

Public Sub UpdateTask(Item As ToDo)
	database.UpdateTask(Item)
End Sub

Public Sub GetTask(id As Long) As ToDo
	Return database.GetTasks("", "WHERE task_id = " & id).Get(0)
End Sub

Public Sub GetAllTasks() As List
	Return database.GetTasks("", "")
End Sub

Public Sub GetAllTasksSortedById(ascending As Boolean) As List
	Return database.GetTasks("", "ORDER BY task_id " & IsAscending(ascending))
End Sub

Public Sub GetTasksSortedByCreatedAt(ascending As Boolean) As List
	Return database.GetTasks("ORDER BY created_at " & IsAscending(ascending), "")
End Sub

Public Sub GetTasksSortedByTitle(ascending As Boolean) As List
	Return database.GetTasks("ORDER BY title " & IsAscending(ascending), "")
End Sub

Public Sub GetTasksSortedByDueDate(ascending As Boolean) As List
	Return database.GetTasks("ORDER BY due_date " & IsAscending(ascending), "")
End Sub

Public Sub GetTasksSortedByPriority(ascending As Boolean) As List
	Return database.GetTasks("ORDER BY priority " & IsAscending(ascending), "")
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
	Return database.GetTasks("ORDER BY due_date " & IsAscending(ascending), "WHERE due_date > " & tickBegin & " < " & tickEnd)
End Sub

Public Sub FindTasks(query As String, ascending As Boolean, field As String) As List
	Return database.GetTasks("ORDER BY "&field&" " & IsAscending(ascending), "WHERE "&field&" LIKE %"&query&"%")
End Sub

' Determines whether the ascending value is true or false, and then returns the
' corresponding SQL keyword for querying.
' Requires space before (and after if needed) concatenating within a query.
Private Sub IsAscending(ascending As Boolean) As String
	If ascending == True Then
		Return "ASC"
	Else
		Return "DESC"
	End If
End Sub

' Calls closure of database,
Public Sub Release
	database.CloseDatabase
End Sub