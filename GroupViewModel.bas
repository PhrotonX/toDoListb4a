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

Public Sub InsertGroup(item As Group)
	m_dbRepository.InsertGroup(item)
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

Public Sub DeleteGroup(group_id As Long)
	m_dbRepository.DeleteGroup(group_id)
End Sub

Public Sub UpdateGroup(item As Group)
	m_dbRepository.UpdateGroup(item)
End Sub