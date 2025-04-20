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
		
		' Insert the task with the data from item object.
		m_sql.ExecNonQuery("INSERT INTO task(title, notes, priority, due_date, done, created_at, updated_at, " & CRLF & _
		"is_reminder_enabled, reminder, snooze)" & CRLF & _
		"VALUES('"&item.GetTitle&"', '"&item.GetNotes&"', "&item.GetPriority&", "&item.GetDueDate.GetUnixTime& CRLF & _
		", "&DatabaseUtils.BoolToInt(item.Done)&", "&currentDateAndTime&", "&currentDateAndTime & ", " & CRLF & _
		DatabaseUtils.BoolToInt(item.IsReminderEnabled) & ", " & item.Reminder.GetUnixTime & ", " & _
		item.Snooze.GetSnooze & ");")
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
		"is_reminder_enabled = " & DatabaseUtils.BoolToInt(item.IsReminderEnabled) & ", " & CRLF & _
		"reminder = " & item.Reminder.GetUnixTime & ", " & CRLF & _
		"snooze = " & item.Snooze.GetSnooze & ", " & CRLF & _
		"updated_at = " & DateTime.Now & CRLF & _
		"WHERE task_id = " & item.GetId & CRLF & _
		";")
		
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
	"ON task_group.task_id = task.task_id WHERE group_id IS NULL " & searchingQuery & " " & sortingQuery)
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
	item.SetReminderEnabled(DatabaseUtils.IntToBool("is_reminder_enabled"))
	item.Reminder.SetUnixTime(cursorTask.GetLong("reminder"))
	item.Snooze.SetSnooze(cursorTask.GetLong("snooze"))
	item.GetCreatedAt.SetUnixTime(cursorTask.GetLong("created_at"))
	item.GetDeletedAt.SetUnixTime(cursorTask.GetLong("deleted_at"))
	item.GetUpdatedAt.SetUnixTime(cursorTask.GetLong("updated_at"))
	item.Done = DatabaseUtils.IntToBool(cursorTask.GetInt("done"))
	item.SetDeleted(DatabaseUtils.IntToBool(cursorTask.GetInt("is_deleted")))
			
	Return item
End Sub