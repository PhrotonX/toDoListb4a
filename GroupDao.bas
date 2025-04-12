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

Public Sub InsertGroup(item As Group)
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("INSERT INTO groups SET" & CRLF & _
		"title = " & item.GetTitle & "," & CRLF & _
		"description = " & item.GetDescription & "," & CRLF & _
		"color = " & item.GetColor & "," & CRLF & _
		"created_at = " & DateTime.Now & "," & CRLF & _
		"updated_at = " & DateTime.Now & "" & CRLF & _
		";" )
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

' Returns a List of Group entities.
' searchingQuery - Requires an SQL syntax that begins with WHERE table_name LIKE clause.
' sortingQuery - Requires an SQL syntax that begins with ORDER BY clause.
Public Sub GetGroups(searchQuery As String, sortingQuery As String) As List
	Dim results As List
	
	results.Initialize
	
	m_sql.BeginTransaction
	Try
		Dim Cursor As Cursor
		Cursor = m_sql.ExecQuery("SELECT * FROM groups " & searchQuery & " " & sortingQuery)
		For i = 0 To Cursor.RowCount - 1
			Cursor.Position = i
			
			Dim item As Group
			
			item.Initialize(Cursor.GetInt("group_id"))
			item.SetTitle(Cursor.GetString("title"))
			item.SetDescription(Cursor.GetString("description"))
			item.SetColor(Cursor.GetInt("color"))
			item.CreatedAt().SetUnixTime(Cursor.GetLong("created_at"))
			item.UpdatedAt().SetUnixTime(Cursor.GetLong("updated_at"))
			
			results.Add(item)
		Next
		
		Cursor.Close
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return results
End Sub

Public Sub DeleteGroup(group_id As Long)
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("DELETE FROM groups WHERE group_id = " & group_id)
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

Public Sub UpdateGroup(item As Group)
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("UPDATE groups SET " & CRLF & _
		"title = " & item.GetTitle() & "," & CRLF & _
		"description = " & item.GetDescription() & "," & CRLF & _
		"color = " & item.GetColor() & "," & CRLF & _
		"updated_at = " & DateTime.Now & "" & CRLF & _
		"WHERE group_id = " & item.GetID & CRLF & _
		";" )
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub