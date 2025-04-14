B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_database As ToDoDatabase
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(database As ToDoDatabase)
	m_database = database
End Sub

Public Sub InsertGroup(item As Group)
	m_database.GroupDao().InsertGroup(item)
End Sub

Public Sub GetGroup(group_id As Long) As Group
	Return m_database.GroupDao().GetGroups("WHERE group_id = " & group_id, "ORDER BY title ASC").Get(0)
End Sub

Public Sub GetGroups() As List
	Return m_database.GroupDao().GetGroups("", "ORDER BY title ASC")
End Sub

Public Sub GetGroupOnTaskId(task_id As Long) As Group
	Return m_database.GroupDao().GetGroupFromTaskId(task_id)
End Sub

Public Sub DeleteGroup(group_id As Long)
	m_database.GroupDao().DeleteGroup(group_id)
End Sub

Public Sub UpdateGroup(item As Group)
	m_database.GroupDao().UpdateGroup(item)
End Sub