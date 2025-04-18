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

Public Sub InsertTaskRepeat(task_id As Long, item As Repeat) As Boolean
	Return m_database.RepeatDao().InsertTaskRepeat(task_id, item)
End Sub

Public Sub GetTaskRepeat(task_id As Long) As Repeat
	Return m_database.RepeatDao().GetTaskRepeat(task_id)
End Sub

Public Sub UpdateRepeat(item As Repeat) As Boolean
	Return m_database.RepeatDao().UpdateRepeat(item)
End Sub

Public Sub DeleteRepeat(item As Repeat) As Boolean
	Return m_database.RepeatDao().DeleteRepeat(item)
End Sub