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

Public Sub GetTaskIdFromRepeat(repeat_id As Long) As Long
	Return m_database.RepeatDao().GetTaskIdFromRepeat(repeat_id)
End Sub

' Returns only single repeat item. Indexes 1-6 cannot be accessed other than 0.
Public Sub GetFirstScheduledRepeat() As Repeat
	Return m_database.RepeatDao().GetFirstScheduledRepeat()
End Sub

Public Sub GetNextTaskRepeat(task_id As Long) As Repeat
	Return m_database.RepeatDao().GetNextTaskRepeat(task_id)
End Sub

Public Sub UpdateRepeat(item As Repeat) As Boolean
	Return m_database.RepeatDao().UpdateRepeat(item)
End Sub

Public Sub UpdateSingleRepeatSchedule(repeat_id As Long, schedule As Long) As Boolean
	Return m_database.RepeatDao().UpdateSingleRepeatSchedule(repeat_id, schedule)
End Sub

Public Sub DeleteRepeat(item As Repeat) As Boolean
	Return m_database.RepeatDao().DeleteRepeat(item)
End Sub