B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Dim m_dbRepository As GroupRepository
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(dbRepo As GroupRepository)
	m_dbRepository = dbRepo
End Sub

Public Sub InsertGroup(item As Group) As Boolean
	Return m_dbRepository.InsertGroup(item)
End Sub

Public Sub InsertTaskGroup(task_id As Long, group_id As Long)
	m_dbRepository.InsertTaskGroup(task_id, group_id)
End Sub

Public Sub GetGroup(group_id As Long) As Group
	Return m_dbRepository.GetGroup(group_id)
End Sub

Public Sub GetGroups() As List
	Return m_dbRepository.GetGroups()
End Sub

Public Sub GetGroupByTaskId(task_id As Long) As Group
	Return m_dbRepository.GetGroupOnTaskId(task_id)
End Sub

Public Sub GetGroupByTitle(title As String) As Group
	Return m_dbRepository.GetGroupByTitle(title)
End Sub

Public Sub DeleteGroup(group_id As Long)
	m_dbRepository.DeleteGroup(group_id)
End Sub

Public Sub UpdateGroup(item As Group)
	m_dbRepository.UpdateGroup(item)
End Sub

Public Sub DeleteTaskGroup(task_id As Long, group_id As Long)
	m_dbRepository.DeleteTaskGroup(task_id, group_id)
End Sub

Public Sub UpdateTaskGroup(task_id As Long, old_group_id As Long, new_group_id As Long)
	m_dbRepository.UpdateTaskGroup(task_id, old_group_id, new_group_id)
End Sub