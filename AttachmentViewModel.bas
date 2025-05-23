﻿B4A=true
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
' item - The attachment to be added.
' task_id - The ID of the task associated with the attachment.
' Returns true if the insertion succeeded.
Public Sub InsertAttachment(item As Attachment, task_id As Long) As Boolean
	Try
		m_fileRepository.SaveAttachment(item)
		m_dbRepository.InsertAttachment(item, task_id)
		Return True
	Catch
		Log(LastException)
	End Try
	
	Return False
End Sub

Public Sub GetAttachment(attachment_id As Long) As Attachment
	Return m_dbRepository.GetAttachment(attachment_id)
End Sub

Public Sub GetAttachmentFilePath(attachment_id As Long) As String
	Log("Shared Folder: " & Starter.Provider.SharedFolder & m_fileRepository.DIRECTORY)
	For Each item As String In File.ListFiles(Starter.Provider.SharedFolder & m_fileRepository.DIRECTORY)
		Log("File from Shared Folder: " & item)
	Next
	
	Return File.Combine(Starter.Provider.SharedFolder & m_fileRepository.DIRECTORY, GetAttachment(attachment_id).GetFilename)
End Sub

Public Sub GetAttachmentsFromUri(FileUri As String) As Attachment
	Return m_fileRepository.GetAttachmentsFromUri(FileUri).Get(0)
End Sub

Public Sub GetSearchedAttachments(task_id As Long, query As String) As List
	Return m_dbRepository.GetSearchedAttachments(task_id, query)
End Sub

Public Sub GetTaskAttachments(task_id As Long) As List
	Return m_dbRepository.GetTaskAttachments(task_id)
End Sub

' Returns true if the insertion succeeded.
Public Sub OpenAttachment(attachment_id As Long) As Boolean
	Try
		Dim filePath As String = GetAttachmentFilePath(attachment_id)
		Dim attachmentObj As Attachment = GetAttachment(attachment_id)
		Dim fileName As String = attachmentObj.GetFilename
	
		Log("filePath: " & filePath)
		Log("fileName: " & fileName)
		Log("MIME Type: " & attachmentObj.GetMimeType())
	
		Dim intentObj As Intent
		intentObj.Initialize(intentObj.ACTION_VIEW, "")
		Starter.Provider.SetFileUriAsIntentData(intentObj, m_fileRepository.DIRECTORY & fileName)
		'Dim data As String = intentObj.GetData ' This variable is for debugging only
		intentObj.SetType(attachmentObj.GetMimeType())
		intentObj.Flags = Bit.Or(1, 2) ' FLAG_GRANT_READ_URI_PERMISSION
		StartActivity(intentObj)
		
		Return True
	Catch
		Log(LastException)
	End Try
	
	Return False
End Sub

Public Sub UpdateAttachment(item As Attachment)
	m_dbRepository.UpdateAttachment(item)
End Sub

Public Sub DeleteAttachment(item As Attachment) As Boolean
	m_dbRepository.DeleteAttachment(item)
	Return m_fileRepository.RemoveAttachment(item)
End Sub

Public Sub DropAttachmentsFromFS() As Boolean
	Return m_fileRepository.DropAttachments()
End Sub