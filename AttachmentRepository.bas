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

' item - The attachment to be added.
' task_id - The ID of the task associated with the attachment.
Public Sub InsertAttachment(item As Attachment, task_id As Long)
	m_database.AttachmentDao().InsertAttachment(item, task_id)
End Sub

Public Sub GetAttachment(attachment_id As Long) As Attachment
	Return m_database.AttachmentDao().GetAttachments("WHERE attachment_id = " & attachment_id, "").Get(0)
End Sub

Public Sub GetAllAttachments() As List
	Return m_database.AttachmentDao().GetAttachments("", "")
End Sub

Public Sub GetTaskAttachments(task_id As Long) As List
	Return m_database.AttachmentDao().GetTaskAttachments(task_id)
End Sub

Public Sub UpdateAttachment(item As Attachment)
	m_database.AttachmentDao().UpdateAttachment(item)
End Sub

Public Sub DeleteAttachment(item As Attachment)
	m_database.AttachmentDao().DeleteAttachment(item)
End Sub