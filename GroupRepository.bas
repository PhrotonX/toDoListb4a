﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_database As ToDoDatabase
	
	Public Const CHECK_ON_INSERT As Int = 1
	Public Const CHECK_ON_UPDATE As Int = 2
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(database As ToDoDatabase)
	m_database = database
End Sub

Public Sub CheckForDuplicates(item As String, count As Int) As Boolean
	Return m_database.GroupDao().CheckForDuplicates(item, count)
End Sub

Public Sub InsertGroup(item As Group) As Boolean
	Return m_database.GroupDao().InsertGroup(item)
End Sub

Public Sub InsertTaskGroup(task_id As Long, group_id As Long)
	m_database.GroupDao().InsertTaskGroup(task_id, group_id)
End Sub

Public Sub GetGroup(group_id As Long) As Group
	Dim result As List = m_database.GroupDao().GetGroups("WHERE group_id = " & group_id, "")
	
	If result.IsInitialized Then
		Return result.Get(0)
	End If
	
	Return Null
End Sub

Public Sub GetGroupByTitle(title As String) As Group
	Dim result As List = m_database.GroupDao().GetGroups("WHERE title = '" & title & "'", "")
	
	If result.IsInitialized Then
		Return result.Get(0)
	End If
	
	Return Null
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

Public Sub DeleteTaskGroup(task_id As Long, group_id As Long)
	m_database.GroupDao().DeleteTaskGroup(task_id, group_id)
End Sub

Public Sub UpdateGroup(item As Group)
	m_database.GroupDao().UpdateGroup(item)
End Sub

Public Sub UpdateTaskGroup(task_id As Long, old_group_id As Long, new_group_id As Long)
	m_database.GroupDao().UpdateTaskGroup(task_id, old_group_id, new_group_id)
End Sub