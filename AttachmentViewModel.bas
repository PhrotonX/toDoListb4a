B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_fileRepository As AttachmentFileRepository
	Private m_dbRepository As AttachmentRepository
End Sub

' Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(dbRepo As AttachmentRepository, fileRepo As AttachmentFileRepository)
	m_dbRepository = dbRepo
	m_fileRepository = fileRepo
End Sub

' Inserts an attachment into the database and then saves into the file system.
Public Sub InsertAttachment(item As Attachment)
	m_fileRepository.SaveAttachment(item)
	m_dbRepository.InsertAttachment(item)
End Sub

Public Sub GetAttachment(attachment_id As Long) As Attachment
	Return m_dbRepository.GetAttachment(attachment_id)
End Sub

Public Sub GetAttachmentsFromUri(FileUri As String) As Attachment
	Return m_fileRepository.GetAttachmentsFromUri(FileUri).Get(0)
End Sub

Public Sub GetTaskAttachments(task_id As Long) As ResumableSub
	Return m_dbRepository.GetTaskAttachments(task_id)
End Sub

Public Sub UpdateAttachment(item As Attachment)
	m_dbRepository.UpdateAttachment(item)
End Sub

Public Sub DeleteAttachment(item As Attachment)
	m_dbRepository.DeleteAttachment(item)
End Sub