B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_fileSystem As ToDoFileSystem
	
	' Directory with forward slash as the beginning character
	Public Const DIRECTORY As String = "/attachments/"
	' Directory without forward slash as the beginning character
	Public Const DIRECTORY_2 As String = "attachments/"
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(fileSystem As ToDoFileSystem)
	m_fileSystem = fileSystem
	
	File.MakeDir(Starter.Permissions.GetSafeDirDefaultExternal(""), DIRECTORY_2)
End Sub

' This function currently only supports a single file.
Public Sub GetAttachmentsFromUri(FileUri As String) As List
	Dim result As List
	result.Initialize
	
	Dim cur As Cursor = m_fileSystem.GetCursorFromUri(FileUri)
	
	Try
		' Create an entity for the item and save the information into the database, including the modified
		' filename.
		' This will also require a cursor since a resolver query returns a cursor that navigates results
		' like an SQL query.
		For i = 0 To cur.RowCount - 1
			cur.Position = i
			Dim item As Attachment
			item.Initialize(0)
			
			item.SetFilename(DateTime.Now & "_" & cur.GetString("_display_name"))
			item.SetMimeType(cur.GetString("mime_type"))
			item.SetSize(cur.GetString("_size"))
			item.GetUpdatedAt.SetUnixTime(cur.GetString("last_modified"))
			' Currently limited to 1 file URI.
			item.SetFileUri(FileUri)
		
			result.Add(item)
		Next
	Catch
		Log(LastException)
	End Try
		
	' Close the cursor to release resorces allocated by it.
	' Close the cursor to release resorces allocated by it.
	cur.Close()
	
	Return result
End Sub

Public Sub SaveAttachment(item As Attachment)
	Try
		m_fileSystem.CopyFileFromUriToInternal(item.GetFilename(), m_fileSystem.DIRECTORY, item.GetFileUri(), _
		DIRECTORY)
	Catch
		Log(LastException)
	End Try
End Sub

Public Sub RemoveAttachment(item As Attachment) As Boolean
	Try
		Return m_fileSystem.RemoveFile(item.GetFilename, DIRECTORY)
	Catch
		Log(LastException)
	End Try
	
	Return False
End Sub