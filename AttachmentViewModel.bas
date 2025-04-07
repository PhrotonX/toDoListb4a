B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_repository As AttachmentRepository
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(repository As AttachmentRepository)
	m_repository = repository
End Sub

Public Sub InsertAttachment(item As Attachment)
	m_repository.InsertAttachment(item)
End Sub

Public Sub GetAttachment(attachment_id As Long) As ResumableSub
	Wait For (m_repository.GetAttachment(attachment_id)) Complete (Result As Attachment)
	
	Return Result
End Sub

Public Sub GetTaskAttachments(task_id As Long) As ResumableSub
	Return m_repository.GetTaskAttachments(task_id)
End Sub

Public Sub UpdateAttachment(item As Attachment)
	m_repository.UpdateAttachment(item)
End Sub

Public Sub DeleteAttachment(item As Attachment)
	m_repository.DeleteAttachment(item)
End Sub