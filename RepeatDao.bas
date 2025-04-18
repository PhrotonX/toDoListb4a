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

Public Sub InsertTaskRepeat(task_id As Long, item As Repeat) As Boolean
	Dim result As Boolean = False
	m_sql.BeginTransaction
	Try
		' Insert each item's repeat value
		Dim i As Int = 0
		For Each repeat As Boolean In item.IsEnabled
			' Insert the repeat data
			m_sql.ExecNonQuery("INSERT INTO repeat(day_id, schedule, enabled)" & CRLF & _
			"VALUES("&task_id&", '"&item.&"', "&DatabaseUtils.BoolToInt(repeat)&");")
			i = i + 1
			
			' Get the ID if the last inserted row.In this case, it is the previous INSERT INTO TASK.
			Dim repeatId As Int = m_sql.ExecQuerySingleResult("SELECT last_insert_rowid();")
			
			' Insert the task_repeat data.
			m_sql.ExecNonQuery("INSERT INTO task_repeat(task_id, repeat_id) VALUES("& CRLF & _
			task_id & ", " & repeatId & ");")
		Next
		
		m_sql.TransactionSuccessful
		
		result = True
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub

Public Sub GetTaskRepeat(task_id As Long) As Repeat
	Dim item As Repeat
	
	m_sql.BeginTransaction
	Try
		' Get all values for task_repeat. This code uses cursor that represents a specific row
		' from a database view.
		Dim Cursor As Cursor
		Cursor = m_sql.ExecQuery("SELECT * FROM repeat JOIN task_repeat " & CRLF & _
		" ON task_repeat.repeat_id = repeat.repeat_id " & CRLF & _
		" WHERE task_repeat.task_id = " & task_id)
		
		' Iterate the cursor or each rows. This iteration checks if days Sunday to Saturday have
		' thier repeat option enabled.
		For i = 0 To Cursor.RowCount - 1
			Cursor.Position = i
			
			item.SetID(i, Cursor.GetLong("repeat_id"))
			item.SetEnabled(i, DatabaseUtils.IntToBool(Cursor.GetInt("enabled")))
			item.SetSchedule(i, Cursor.GetLong("schedule"))
		Next
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return item
End Sub

Public Sub UpdateRepeat(item As Repeat)
	Dim result As Boolean = False
	
	m_sql.BeginTransaction
	Try
		' Update each repeat value of the item iteratively.
		Dim repeatItr As Int = 0
		For Each repeat As Boolean In item.IsEnabled
			' The SQL code that updates the table.
			m_sql.ExecNonQuery("UPDATE repeat SET " & CRLF & _
			"enabled = " & DatabaseUtils.BoolToInt(repeat) & ", " & CRLF & _
			"WHERE repeat_id = " & item.GetID(repeatItr) & " " & CRLF & _
			"AND day_id = " & repeatItr & ";")
			
			' Iterate the day IDs from 0 to 6.
			repeatItr = repeatItr + 1
		Next
		
		m_sql.TransactionSuccessful
		
		result = True
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub

Public Sub DeleteRepeat(item As Repeat)
	Dim result As Boolean = False
	
	m_sql.BeginTransaction
	Try
		' Update each repeat value of the item iteratively.
		Dim repeatItr As Int = 0
		For Each Repeat As Boolean In item.IsEnabled
			' The SQL code that updates the table.
			m_sql.ExecNonQuery("UPDATE repeat SET " & CRLF & _
			"enabled = " & DatabaseUtils.BoolToInt(Repeat) & ", " & CRLF & _
			"WHERE repeat_id = " & item.GetID(repeatItr) & " " & CRLF & _
			"AND day_id = " & repeatItr & ";")
			
			' Iterate the day IDs from 0 to 6.
			repeatItr = repeatItr + 1
		Next
		
		m_sql.TransactionSuccessful
		
		result = True
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub