B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_sql As SQL
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(sql As SQL)
	m_sql = sql
End Sub

' item - The attachment to be added.
' task_id - The ID of the task associated with the attachment.
Public Sub InsertAttachment(item As Attachment, task_id As Long)
	m_sql.BeginTransaction
	Try
		' Insert the attachment.
		m_sql.ExecNonQuery("INSERT INTO attachment(filename, created_at, updated_at, mime_type, size)" & CRLF & _
		"VALUES(" & CRLF & _
		"'"&item.GetFilename&"', "&DateTime.Now&", "&item.GetUpdatedAt.GetDay.GetUnixTime& CRLF & _
		", '"&item.GetMimeType&"', "&item.GetSize&");")
		
		Dim attachment_id As Long = m_sql.ExecQuerySingleResult("SELECT last_insert_rowid();")
		
		' Change the value of task_id if it is less than zero.
		If task_id <= 0 Then
			' Obtain the last ID of a task insert into the tasks table.
			task_id = m_sql.ExecQuerySingleResult("SELECT task_id FROM task ORDER BY task_id DESC LIMIT 1")
		End If
		
		' Insert the attachment ID and the task ID into the associative table.
		m_sql.ExecQuerySingleResult("INSERT INTO task_attachment(task_id, attachment_id) VALUES(" & CRLF & _
		task_id & ", " & attachment_id & ");")
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

Public Sub UpdateAttachment(item As Attachment)
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("UPDATE attachment SET" & CRLF & _
		"filename = '" & item.GetFilename & "'," & CRLF & _ 
		"mimeType = '" & item.GetMimeType & "'," & CRLF & _ 
		"size = " & item.GetSize & "," & CRLF & _ 
		"updated_at = " & item.GetUpdatedAt.GetDay.GetUnixTime & "," & CRLF & _ 
		"WHERE attachment_id = " & item.GetID & CRLF & _
		";")
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

' Retrieves multiple attachments.
' searchingQuery - Requires an SQL syntax that begins with WHERE table_name LIKE clause.
' sortingQuery - Requires an SQL syntax that begins with ORDER BY clause.
Public Sub GetAttachments(searchingQuery As String, sortingQuery As String) As List
	Dim result As List
	
	m_sql.BeginTransaction
	Try
		Dim cur As Cursor = m_sql.ExecQuery("SELECT * FROM attachment " & CRLF & searchingQuery & CRLF & sortingQuery)
		
		For i = 0 To cur.RowCount - 1
			result.Add(OnGetAttachment(cur))
		Next
		
		cur.Close
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub

Public Sub GetTaskAttachments(task_id As Long) As List
	Dim result As List
	result.Initialize()
	
	m_sql.BeginTransaction
	Try
		Dim Cursor As Cursor
		Cursor = m_sql.ExecQuery("SELECT * FROM attachment " & CRLF & _
		"JOIN task_attachment" & CRLF & _
		"WHERE task_attachment.task_id = " & task_id)
		For i = 0 To Cursor.RowCount - 1
			Cursor.Position = i
			result.Add(OnGetAttachment(Cursor))
			
			Log("======== task_id: " & task_id & " =========")
			Log("attachment_id: " & Cursor.GetInt("attachment_id"))
			Log("task_id: " & Cursor.GetInt("task_id"))
		Next
		
		Cursor.Close
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub

Private Sub OnGetAttachment(rs As Cursor) As Attachment
	Dim item As Attachment
				
	item.Initialize(rs.GetInt("attachment_id"))
	item.SetFilename(rs.GetString("filename"))
	item.SetMimeType(rs.GetString("mime_type"))
	item.SetSize(rs.GetLong("size"))
	item.GetCreatedAt().SetUnixTime(rs.GetLong("created_at"))
	item.GetUpdatedAt().SetUnixTime(rs.GetLong("updated_at"))
	
	Return item
End Sub

Public Sub DeleteAttachment(item As Attachment)
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("DELETE FROM attachment WHERE attachment_id = " & item.GetID)
		' Delete from associative table as well.
		m_sql.ExecNonQuery("DELETE FROM task_attachment WHERE attachment_id = " & item.GetID) 
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub