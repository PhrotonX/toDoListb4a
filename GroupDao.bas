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

Private Sub CheckForDuplicates(item As Group) As Boolean
	If m_sql.ExecQuerySingleResult("SELECT count(*) FROM groups WHERE title = " & item.GetTitle) >= 1 Then
		Return True
	Else
		Return False
	End If
End Sub

Public Sub InsertGroup(item As Group) As Boolean
	Dim result As Boolean
	
	m_sql.BeginTransaction
	Try
		If CheckForDuplicates(item) Then
			result = False
		Else
			m_sql.ExecNonQuery("INSERT INTO groups(title, description, color, icon, created_at, updated_at) VALUES(" & CRLF & _
			item.GetTitle & "," & CRLF & _
			item.GetDescription & "," & CRLF & _
			item.GetColor & "," & CRLF & _
			item.GetIcon & "," & CRLF & _
			 DateTime.Now & "," & CRLF & _
			DateTime.Now & CRLF & _
			");" )
			
			m_sql.TransactionSuccessful
			
			result = True
		End If
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub

Public Sub InsertTaskGroup(task_id As Long, group_id As Long)
	' If the task group is set to none, cancel the insert operation.
	If group_id == 0 Then
		Return
	End If
	
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("INSERT INTO task_group(task_id, group_id) VALUES(" & CRLF & _
		task_id & "," & CRLF & _
		group_id & CRLF & _
		");" )
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

Public Sub GetGroupFromTaskId(task_id As Long) As Group
	Dim result As Group
	m_sql.BeginTransaction
	Try
		Dim Cursor As Cursor
		Cursor = m_sql.ExecQuery("SELECT * FROM groups JOIN task_group ON task_group.group_id = " & _ 
		"groups.group_id" & CRLF & _
		"WHERE task_id = " & task_id)
		For i = 0 To Cursor.RowCount - 1
			Cursor.Position = i
			result = OnGetGroup(Cursor)
			
			' Stop the iteration. Only 1 item is needed.
			i = Cursor.RowCount + 1
		Next
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
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
			
			results.Add(OnGetGroup(Cursor))
		Next
		
		Cursor.Close
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return results
End Sub

Public Sub OnGetGroup(Cursor As Cursor) As Group
	Dim item As Group
			
	item.Initialize(Cursor.GetInt("group_id"))
	item.SetTitle(Cursor.GetString("title"))
	item.SetDescription(Cursor.GetString("description"))
	item.SetColor(Cursor.GetInt("color"))
	item.CreatedAt().SetUnixTime(Cursor.GetLong("created_at"))
	item.UpdatedAt().SetUnixTime(Cursor.GetLong("updated_at"))
	
	Return item
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

Public Sub DeleteTaskGroup(task_id As Long, group_id As Long)
	' If the task group is set to 0, then cancel the delete operation.
	If group_id == 0 Then
		Return
	End If
	
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("DELETE FROM task_group WHERE" & CRLF & _
		"task_id = " & task_id & " AND " & CRLF & _
		"group_id = " & group_id & CRLF & _
		";" )
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

Public Sub UpdateGroup(item As Group) As Boolean	
	Dim Result As Boolean
	m_sql.BeginTransaction
	Try
		If CheckForDuplicates(item) Then
			Result = False
		Else
			m_sql.ExecNonQuery("UPDATE groups SET " & CRLF & _
			"title = " & item.GetTitle() & "," & CRLF & _
			"description = " & item.GetDescription() & "," & CRLF & _
			"color = " & item.GetColor() & "," & CRLF & _
			"icon = " & item.GetIcon() & ", " & CRLF & _
			"updated_at = " & DateTime.Now & "" & CRLF & _
			"WHERE group_id = " & item.GetID & CRLF & _
			";" )
			
			m_sql.TransactionSuccessful			
			
			Result = True
		End If
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return Result
End Sub

Public Sub UpdateTaskGroup(task_id As Long, old_group_id As Long, new_group_id As Long)
	' If the task no has group set to 0, then delete task group id instead and cancel the update operation.
	If new_group_id <= 0 Then
		DeleteTaskGroup(task_id, old_group_id)
		Return
	End If
	
	' If the task previously did not have any group, then insert task group id instead and cancel the update operation.
	If old_group_id == 0 Then
		InsertTaskGroup(task_id, new_group_id)
		Return
	End If
	
	m_sql.BeginTransaction
	Try
		m_sql.ExecNonQuery("UPDATE task_group SET" & CRLF & _
		"group_id = " & new_group_id & CRLF & _
		"WHERE task_id = " & task_id & CRLF & _
		"AND group_id = " & old_group_id & CRLF & _
		";" )
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub
