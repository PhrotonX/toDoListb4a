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
		' Insert each item's repeat value.
		' This i iterator corresponds into day values 0 to 6.
		For i = 0 To 6
			Dim schedule As Long = item.GetSchedule(i)
			
			If item.IsEnabled(i) == False Then
				schedule = 0
			End If
			
			' Insert the repeat data
			m_sql.ExecNonQuery("INSERT INTO repeat(day_id, schedule, enabled) VALUES(" & i & ", " & CRLF & _
			schedule & ", " & DatabaseUtils.BoolToInt(item.IsEnabled(i)) & ");" )
			
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
	Return OnGetTaskRepeat("SELECT * FROM repeat JOIN task_repeat " & CRLF & _
		" ON task_repeat.repeat_id = repeat.repeat_id " & CRLF & _
		" WHERE task_repeat.task_id = " & task_id)
End Sub

' Returns only single repeat item. Indexes 1-6 cannot be accessed other than 0.
Public Sub GetNextTaskRepeat(task_id As Long) As Repeat
	Return OnGetTaskRepeat("SELECT * FROM repeat JOIN task_repeat " & CRLF & _
		" ON task_repeat.repeat_id = repeat.repeat_id " & CRLF & _
		" WHERE task_repeat.task_id = " & task_id & " AND repeat.schedule > 0 ORDER BY schedule Asc LIMIT 1")
End Sub

Public Sub GetTaskIdFromRepeat(repeat_id As Long) As Long
	Dim item As Long
	
	m_sql.BeginTransaction
	Try
		' Get all values for task_repeat. This code uses cursor that represents a specific row
		' from a database view.
		Dim Cursor As Cursor
		Cursor = m_sql.ExecQuery("SELECT task_id FROM task_repeat WHERE repeat_id = " & repeat_id)

		' Iterate the cursor or each rows. This iteration checks if days Sunday to Saturday have
		' thier repeat option enabled.
		For i = 0 To Cursor.RowCount - 1
			Cursor.Position = i
			
			item = Cursor.GetLong("task_id")
		Next
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return item
End Sub

' Returns only single repeat item. Indexes 1-6 cannot be accessed other than 0.
Public Sub GetFirstScheduledRepeat() As Repeat
	Return OnGetTaskRepeat("SELECT * FROM repeat WHERE schedule > 0 ORDER BY schedule ASC LIMIT 1")
End Sub

Public Sub OnGetTaskRepeat(query As String) As Repeat
	Dim item As Repeat
	
	m_sql.BeginTransaction
	Try
		' Get all values for task_repeat. This code uses cursor that represents a specific row
		' from a database view.
		Dim Cursor As Cursor
		Cursor = m_sql.ExecQuery(query)
		
		item.Initialize()
		
		' Iterate the cursor or each rows. This iteration checks if days Sunday to Saturday have
		' thier repeat option enabled.
		For i = 0 To Cursor.RowCount - 1
			Cursor.Position = i
			
			item.SetID(i, Cursor.GetLong("repeat_id"))
			item.SetEnabled(i, DatabaseUtils.IntToBool(Cursor.GetInt("enabled")))
			item.SetSchedule(i, Cursor.GetLong("schedule"))
			item.SetDayID(i, Cursor.GetInt("day_id"))
		Next
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return item
End Sub

Public Sub UpdateRepeat(item As Repeat) As Boolean
	Dim result As Boolean = False
	
	m_sql.BeginTransaction
	Try
		' Update each repeat value of the item iteratively.
		Dim repeatItr As Int = 0
		
		For Each repeat As Boolean In item.IsEnabled
			Dim schedule As Long = item.GetSchedule(repeatItr)
			
			If repeat == False Then
				schedule = 0
			End If
			
			' The SQL code that updates the table.
			m_sql.ExecNonQuery("UPDATE repeat SET " & CRLF & _
			"enabled = " & DatabaseUtils.BoolToInt(repeat) & ", " & CRLF & _
			"schedule = " & schedule & " " & CRLF & _
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

Public Sub UpdateSingleRepeatSchedule(repeat_id As Long, schedule As Long) As Boolean
	Dim result As Boolean = False
	
	m_sql.BeginTransaction
	Try
		' The SQL code that updates the table.
		m_sql.ExecNonQuery("UPDATE repeat SET " & CRLF & _
		"schedule = " & schedule & " " & CRLF & _
		"WHERE repeat_id = " & repeat_id & ";")

		m_sql.TransactionSuccessful
		
		result = True
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub

Public Sub DeleteRepeat(item As Repeat) As Boolean
	Dim result As Boolean = False
	
	m_sql.BeginTransaction
	Try
		' Update each repeat value of the item iteratively.
		For i = 0 To 6
			' The SQL code that updates the table.
			m_sql.ExecNonQuery("DELETE FROM repeat WHERE repeat_id = " & item.GetID(i))
		Next
		
		m_sql.TransactionSuccessful
		
		result = True
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
	
	Return result
End Sub