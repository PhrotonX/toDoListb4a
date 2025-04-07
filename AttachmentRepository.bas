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

Public Sub InsertAttachment(item As Attachment)
	m_database.AttachmentDao().InsertAttachment(item)
End Sub

Public Sub GetAttachment(attachment_id As Long) As ResumableSub
	Wait For (m_database.AttachmentDao().GetAttachments("WHERE attachment_id = " & attachment_id, "")) _
	Complete (Result As List)
	
	Return Result.Get(0)
End Sub

Public Sub GetAllAttachments() As ResumableSub
	Return m_database.AttachmentDao().GetAttachments("", "")
End Sub

Public Sub GetTaskAttachments(task_id As Long) As ResumableSub
	Return m_database.AttachmentDao().GetTaskAttachments(task_id)
End Sub

Public Sub UpdateAttachment(item As Attachment)
	m_database.AttachmentDao().UpdateAttachment(item)
End Sub

Public Sub DeleteAttachment(item As Attachment)
	m_database.AttachmentDao().DeleteAttachment(item)
End Sub