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

Public Sub InsertAttachment(item As Attachment)
	m_sql.BeginTransaction
	Try
		' Insert the attachment.
		m_sql.ExecNonQuery("INSERT INTO attachment(filepath, created_at, updated_at) VALUES(" & CRLF & _
		"'"&item.GetFilepath&"', "&DateTime.Now&", "&DateTime.Now&");")
		
		' Obtain the last ID of a task insert into the tasks table.
		Dim task_id As Long = m_sql.ExecQuerySingleResult("SELECT task_id FROM task ORDER BY task_id DESC LIMIT 1")
		
		' Insert the attachment ID and the task ID into the associative table.
		m_sql.ExecQuerySingleResult("INSERT INTO task_attachment(task_id, attachment_id) VALUES(" & CRLF & _
		task_id & ", " & item.GetID() & ");")
		
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
		"filepath = " & item.GetFilepath & CRLF & _ 
		"updated_at = " & DateTime.Now & CRLF & _
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
Public Sub GetAttachments(searchingQuery As String, sortingQuery As String) As ResumableSub
	Dim result As List
	
	m_sql.BeginTransaction
	Try
		Dim SenderFilter As Object = m_sql.ExecQueryAsync("SQL", "SELECT * FROM attachment " _
		& CRLF & searchingQuery & CRLF & sortingQuery, Null)
		
		Wait For (SenderFilter) SQL_QueryComplete (Success As Boolean, rs As ResultSet)
		If Success Then
			Do While rs.NextRow
				Dim item As Attachment
				
				item.Initialize(rs.GetInt("attachment_id"))
				item.SetFilepath(rs.GetString("filepath"))
				item.GetCreatedAt().SetUnixTime(rs.GetLong("created_at"))
				item.GetUpdatedAt().SetUnixTime(rs.GetLong("updated_at"))
				
				result.Add(item)
			Loop
			rs.Close
		Else
			Log(LastException)
		End If
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
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