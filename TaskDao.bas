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

' Inserts task into the database.
Public Sub InsertTask(item As ToDo)
	m_sql.BeginTransaction
	' Exception handling to catch errors for debuggings, if possible.
	Try
		' Get the current date and time in ticks.
		Dim currentDateAndTime As Long = DateTime.Now
		
		' Insert the task without the repeat data.
		m_sql.ExecNonQuery("INSERT INTO task(title, notes, priority, due_date, done, created_at, updated_at)" & CRLF & _
		"VALUES('"&item.GetTitle&"', '"&item.GetNotes&"', "&item.GetPriority&", "&item.GetDueDate.GetUnixTime& CRLF & _
		", "&DatabaseUtils.BoolToInt(item.Done)&", "&currentDateAndTime&", "&currentDateAndTime&");")
		
		' Get the ID if the last inserted row.In this case, it is the previous INSERT INTO TASK.
		Dim id As Int = m_sql.ExecQuerySingleResult("SELECT last_insert_rowid();")
		
		' Insert each item's repeat value
		Dim i As Int = 0
		For Each repeat As Boolean In item.GetRepeat
			' Insert the task without the repeat data.
			m_sql.ExecNonQuery("INSERT INTO task_repeat(task_id, day_id, enabled)" & CRLF & _
			"VALUES("&id&", '"&i&"', "&DatabaseUtils.BoolToInt(repeat)&");")
			i = i + 1
		Next
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

Public Sub DeleteTask(item As ToDo)
	m_sql.BeginTransaction
	Try
		' Delete a specific item.
		m_sql.ExecNonQuery("DELETE FROM task WHERE task_id = " & item.GetId & ";")
		
		' Delete all associated task_repeat items from the deleted task.
		m_sql.ExecNonQuery("DELETE FROM task_repeat WHERE task_id = " & item.GetId & ";")
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

' Updates task from the database
Public Sub UpdateTask(item As ToDo)
	m_sql.BeginTransaction
	Try
		' Update a specific item and takes their new values into the query.
		m_sql.ExecNonQuery("UPDATE task SET title = '"&item.GetTitle& "', " & CRLF & _
		"notes = '" & item.GetNotes & "', " & CRLF & _
		"priority = " & item.GetPriority & ", " & CRLF & _
		"done = " & DatabaseUtils.BoolToInt(item.Done) & ", " & CRLF & _ 
		"due_date = " & item.GetDueDate.GetUnixTime & ", " & CRLF & _
		"updated_at = " & DateTime.Now & CRLF & _
		"WHERE task_id = " & item.GetId & CRLF & _
		";")
		
		' Update each repeat value of the item iteratively.
		Dim repeatItr As Int = 0
		For Each repeat As Boolean In item.GetRepeat
			' The SQL code that updates the table.
			m_sql.ExecNonQuery("UPDATE task_repeat SET " & CRLF & _
			"enabled = " & DatabaseUtils.BoolToInt(repeat) & CRLF & _
			"WHERE task_id = " & item.GetId & " " & CRLF & _
			"AND day_id = " & repeatItr & ";")
			
			' Iterate the day IDs from 0 to 6.
			repeatItr = repeatItr + 1
		Next
		
		m_sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	m_sql.EndTransaction
End Sub

' Retrieves multiple tasks.
' sortingQuery - Requires an SQL syntax that begins with ORDER BY clause.
' searchingQuery - Requires an SQL syntax that begins with WHERE table_name LIKE clause.
Public Sub GetTasks(searchingQuery As String, sortingQuery As String) As List
	Return OnGetTask("SELECT * FROM task " & searchingQuery & " " & sortingQuery)
End Sub

' Retrieves multiple tasks based on a task group
' sortingQuery - Requires an SQL syntax that begins with ORDER BY clause.
' searchingQuery - Requires an SQL syntax that begins with WHERE table_name LIKE clause.
Public Sub GetGroupedTasks(group_id As Long, searchingQuery As String, sortingQuery As String) As List
	Return OnGetTask("SELECT * FROM task JOIN task_group " & CRLF & _ 
	"ON task_group.task_id = task.task_id WHERE group_id = " & group_id & " " & searchingQuery & " " & sortingQuery)
End Sub

' Retrieves multiple tasks based on a task group
' sortingQuery - Requires an SQL syntax that begins with ORDER BY clause.
' searchingQuery - Requires an SQL syntax that begins with WHERE table_name LIKE clause.
Public Sub GetUngroupedTasks(searchingQuery As String, sortingQuery As String) As List
	Return OnGetTask("SELECT * FROM task LEFT JOIN task_group " & CRLF & _ 
	"ON task_group.task_id = task.task_id WHERE group_id IS NULL")
End Sub

Private Sub OnGetTask(query As String) As List
	Dim list As List
	list.Initialize
	
	m_sql.BeginTransaction
	Try
		' Iterate over all tasks and add it into the list.
		Dim cursorTask As Cursor
		cursorTask = m_sql.ExecQuery(query)
		For i = 0 To cursorTask.RowCount - 1
			cursorTask.Position = i
			
			Dim item As ToDo = OnBuildTask(cursorTask)
			
			' Add the item into the list
			list.Add(item)
		Next
		cursorTask.Close
		m_sql.TransactionSuccessful
	Catch
		Log(LastException.Message)
	End Try
	m_sql.EndTransaction
	
	Return list
End Sub

Private Sub OnBuildTask(cursorTask As Cursor) As ToDo
	' Declare and initialize the item.
	Dim item As ToDo
	item.Initialize
			
	' Get all values for task.
	item.SetId(cursorTask.GetLong("task_id"))
	item.SetTitle(cursorTask.GetString("title"))
	item.SetNotes(cursorTask.GetString("notes"))
	item.SetPriority(cursorTask.GetInt("priority"))
	item.GetDueDate.SetUnixTime(cursorTask.GetLong("due_date"))
	item.GetCreatedAt.SetUnixTime(cursorTask.GetLong("created_at"))
	item.GetDeletedAt.SetUnixTime(cursorTask.GetLong("deleted_at"))
	item.GetUpdatedAt.SetUnixTime(cursorTask.GetLong("updated_at"))
	item.Done = DatabaseUtils.IntToBool(cursorTask.GetInt("done"))
	item.SetDeleted(DatabaseUtils.IntToBool(cursorTask.GetInt("is_deleted")))
			
	RetrieveRepeatValues(item)
	
	Return item
End Sub

Public Sub RetrieveRepeatValues(item As ToDo)
	' Get all values for task_repeat. This code uses cursor that represents a specific row
	' from a database view.
	Dim Cursor As Cursor
	Cursor = m_sql.ExecQuery("SELECT * FROM task_repeat WHERE task_id = " & item.GetId)
		
	' Iterate the cursor or each rows. This iteration checks if days Sunday to Saturday have
	' thier repeat option enabled.
	For i = 0 To Cursor.RowCount - 1
		Cursor.Position = i
		item.SetRepeat(i, DatabaseUtils.IntToBool(Cursor.GetInt("enabled")))
	Next
End Sub