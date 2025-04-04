B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private sql As SQL
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	' Create a database file based on SQLite
	sql.Initialize(File.DirInternal, "todo_db.db", True)
	
	CreateTable
End Sub

' Creates tables for Database in SQL syntax, not MySQL.
Public Sub CreateTable	
	' Query for creating the task table
	Dim query_task As String = "CREATE TABLE IF NOT EXISTS task( " & CRLF & _
	"task_id INTEGER PRIMARY KEY AUTOINCREMENT," & CRLF & _
	"title VARCHAR(255) NOT NULL," & CRLF & _
	"notes TEXT," & CRLF & _
	"priority INTEGER NOT NULL," & CRLF & _
	"due_date DATE," & CRLF & _
	"done BOOLEAN NOT NULL DEFAULT 0" & CRLF & _
	"is_deleted BOOLEAN NOT NULL DEFAULT 0" & CRLF & _
	"created_at LONG NOT NULL DEFAULT 0" & CRLF & _
	"updated_at LONG NOT NULL DEFAULT 0" & CRLF & _
	"deleted_at LONG NOT NULL DEFAULT 0" & CRLF & _
	");"
	
	' Query for creating the days_of_the_week table.
	Dim query_days_of_the_week As String = "CREATE TABLE IF NOT EXISTS days_of_the_week(" & CRLF & _
	"day_id TINYINT NOT NULL," & CRLF & _
	"day_of_the_week VARCHAR(10) NOT NULL," & CRLF & _
	"PRIMARY KEY(day_id)" & CRLF & _
	");"
	
	' Query for creating the task_repeat table.
	Dim query_task_repeat As String = "CREATE TABLE IF NOT EXISTS task_repeat(" & CRLF & _
	"task_id INTEGER NOT NULL," & CRLF & _
	"day_id TINYINT NOT NULL," & CRLF & _
	"enabled BOOLEAN NOT NULL," & CRLF & _
	"PRIMARY KEY(task_id, day_id)" & CRLF & _
	");"
	
	' Query for populating the days_of_the_week table with data.
	Dim query_populate_days As String = "INSERT INTO days_of_the_week (day_of_the_week, day_id)" & CRLF & _
	"SELECT 'Sunday', 0 UNION ALL" & CRLF & _
	"SELECT 'Monday', 1 UNION ALL" & CRLF & _
	"SELECT 'Tuesday', 2 UNION ALL" & CRLF & _
	"SELECT 'Wednesday', 3 UNION ALL" & CRLF & _
	"SELECT 'Thursday', 4 UNION ALL" & CRLF & _
	"SELECT 'Friday', 5 UNION ALL" & CRLF & _ 
	"SELECT 'Saturday', 6" & CRLF & _
	"WHERE NOT EXISTS (SELECT 1 FROM days_of_the_week);"
	
	' Mark the beginning of SQL transaction.
	sql.BeginTransaction
	Try
		' Execute the queries.
		sql.ExecNonQuery(query_task)
		sql.ExecNonQuery(query_days_of_the_week)
		sql.ExecNonQuery(query_task_repeat)
		' Check if task table is empty
		If sql.ExecQuerySingleResult("SELECT COUNT(*) FROM days_of_the_week") == "0" Then
			sql.ExecNonQuery(query_populate_days)
		End If
		
		' Tell to the database that the SQL transaction is successful.
		sql.TransactionSuccessful
	Catch
		Log(LastException.Message)
	End Try
	' Mark the end of SQL Transaction
	sql.EndTransaction
End Sub

' Inserts task into the database.
Public Sub InsertTask(item As ToDo)
	sql.BeginTransaction
	' Exception handling to catch errors for debuggings, if possible.
	Try		
		' Get the current date and time in ticks.
		Dim currentDateAndTime As Long = DateTime.Now
		
		' Insert the task without the repeat data.
		sql.ExecNonQuery("INSERT INTO task(title, notes, priority, due_date, done, created_at, deleted_at)" & CRLF & _
		"VALUES('"&item.GetTitle&"', '"&item.GetNotes&"', "&item.GetPriority&", "&item.GetDueDate.GetUnixTime& CRLF & _
		", "&BoolToInt(item.Done)&", "&currentDateAndTime&", "&currentDateAndTime&");")
		
		' Get the ID if the last inserted row.In this case, it is the previous INSERT INTO TASK.
		Dim id As Int = sql.ExecQuerySingleResult("SELECT last_insert_rowid();")
		
		' Insert each item's repeat value
		Dim i As Int = 0
		For Each repeat As Boolean In item.GetRepeat
			' Insert the task without the repeat data.
			sql.ExecNonQuery("INSERT INTO task_repeat(task_id, day_id, enabled)" & CRLF & _
			"VALUES("&id&", '"&i&"', "&BoolToInt(repeat)&");")
			i = i + 1
		Next
		sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	sql.EndTransaction
End Sub

Public Sub DeleteTask(item As ToDo)
	sql.BeginTransaction
	Try
		' Delete a specific item.
		sql.ExecNonQuery("DELETE FROM task WHERE task_id = " & item.GetId & ";")
		
		' Delete all associated task_repeat items from the deleted task.
		sql.ExecNonQuery("DELETE FROM task_repeat WHERE task_id = " & item.GetId & ";")
		
		sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	sql.EndTransaction
End Sub

' Updates task from the database
Public Sub UpdateTask(item As ToDo)
	sql.BeginTransaction
	Try
		' Update a specific item and takes their new values into the query.
		sql.ExecNonQuery("UPDATE task SET title = '"&item.GetTitle& "', " & CRLF & _ 
		"notes = '" & item.GetNotes & "', " & CRLF & _
		"priority = " & item.GetPriority & ", " & CRLF & _
		"done = " & BoolToInt(item.Done) & ", " & CRLF & _ 
		"due_date = " & item.GetDueDate.GetUnixTime & CRLF & _
		"updated_at = " & DateTime.Now & CRLF & _
		"WHERE task_id = " & item.GetId & CRLF & _
		";")
		
		' Update each repeat value of the item iteratively.
		Dim repeatItr As Int = 0
		For Each repeat As Boolean In item.GetRepeat
			' The SQL code that updates the table.
			sql.ExecNonQuery("UPDATE task_repeat SET " & CRLF & _
			"enabled = " & BoolToInt(repeat) & CRLF & _
			"WHERE task_id = " & item.GetId & " " & CRLF & _
			"AND day_id = " & repeatItr & ";")
			
			' Iterate the day IDs from 0 to 6.
			repeatItr = repeatItr + 1
		Next
		
		sql.TransactionSuccessful
	Catch
		Log(LastException)
	End Try
	sql.EndTransaction
End Sub

' Retrieves a single task.
Public Sub GetTask(id As Long) As ToDo
	Dim item As ToDo
	sql.BeginTransaction
	Try
		' Call the constructor
		item.Initialize
		
		' Obtain items 1 by 1 since SQL library in B4A does not support multiple columns
		item.SetId(sql.ExecQuerySingleResult("SELECT task_id FROM task WHERE task_id = " & id))
		item.SetTitle(sql.ExecQuerySingleResult("SELECT title FROM task WHERE task_id = " & id))
		item.SetNotes(sql.ExecQuerySingleResult("SELECT notes FROM task WHERE task_id = " & id))
		item.SetPriority(sql.ExecQuerySingleResult("SELECT priority FROM task WHERE task_id = " & id))
		' The database due_date of type DATE field requires date value in UNIX time.
		item.GetDueDate.SetUnixTime(sql.ExecQuerySingleResult("SELECT due_date FROM task WHERE task_id = " & id))
		item.GetCreatedAt.SetUnixTime(sql.ExecQuerySingleResult("SELECT created_at FROM task WHERE task_id = " & id))
		item.GetUpdatedAt.SetUnixTime(sql.ExecQuerySingleResult("SELECT updated_at FROM task WHERE task_id = " & id))
		item.GetDeletedAt.SetUnixTime(sql.ExecQuerySingleResult("SELECT deleted_at FROM task WHERE task_id = " & id))
		
		item.Done = IntToBool(sql.ExecQuerySingleResult("SELECT done FROM task WHERE task_id = " & id))
		item.SetDeleted(IntToBool(sql.ExecQuerySingleResult("SELECT is_deleted FROM task WHERE is_deleted = " & id)))
		
		RetrieveRepeatValues(item)
				
		sql.TransactionSuccessful
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
	
	Return item
End Sub

' Retrieves multiple tasks.
' sortingQuery - Requires an SQL syntax that begins with ORDER BY clause.
Public Sub GetAllTasks(sortingQuery As String) As List
	Dim list As List
	list.Initialize
	
	' Add space into sortingQuery if it is not empty.
	If sortingQuery <> "" Then
		sortingQuery = " " & sortingQuery
	End If
	
	sql.BeginTransaction
	Try
		' Iterate over all tasks and add it into the list.
		Dim cursorTask As Cursor
		cursorTask = sql.ExecQuery("SELECT * FROM task" & sortingQuery)
		For i = 0 To cursorTask.RowCount - 1
			cursorTask.Position = i
			
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
			item.Done = cursorTask.GetInt("done")
			item.SetDeleted(IntToBool(cursorTask.GetInt("is_deleted")))
			
			RetrieveRepeatValues(item)
			
			' Add the item into the list
			list.Add(item)
		Next
		sql.TransactionSuccessful
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
	
	Return list
End Sub

Public Sub RetrieveRepeatValues(item As ToDo)
	' Get all values for task_repeat. This code uses cursor that represents a specific row
	' from a database view.
	Dim Cursor As Cursor
	Cursor = sql.ExecQuery("SELECT * FROM task_repeat WHERE task_id = " & item.GetId)
		
	' Iterate the cursor or each rows. This iteration checks if days Sunday to Saturday have
	' thier repeat option enabled.
	For i = 0 To Cursor.RowCount - 1
		Cursor.Position = i
		If Cursor.GetInt("enabled") == 1 Then
			item.SetRepeat(i, True)
		Else
			item.SetRepeat(i, False)
		End If
	Next
End Sub

' Closes the database
Public Sub CloseDatabase()
	sql.Close
End Sub

' Converts boolean into numeric value since inserting the boolean value directly
' into the database results into an error.
Private Sub BoolToInt(value As Boolean) As Int
	If value == True Then
		Return 1
	Else
		Return 0
	End If
End Sub

' Converts numeric into boolean value.
Private Sub IntToBool(value As Int) As Boolean
	If value == 1 Then
		Return True
	Else
		Return False
	End If
End Sub

' Drops all table from the database.
Public Sub DropTable
	Dim query_task As String = "DROP TABLE IF EXISTS task;"
	Dim query_days_of_the_week As String = "DROP TABLE IF EXISTS days_of_the_week;"
	Dim query_task_repeat As String = "DROP TABLE IF EXISTS task_repeat;"
	Dim query_populate_days_of_the_week As String = "DROP PROCEDURE IF EXISTS PopulateDaysOfTheWeek;"
	
	sql.BeginTransaction
	Try
		sql.ExecNonQuery(query_task)
		sql.ExecNonQuery(query_days_of_the_week)
		sql.ExecNonQuery(query_task_repeat)
		sql.ExecNonQuery(query_populate_days_of_the_week)
		sql.TransactionSuccessful
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
End Sub

' FOR TESTING ONLY! REMOVE LATER
' Copies the database into the Downloads directory.
Public Sub CopyDatabase()
	
	Dim source As String = File.DirInternal & "/todo_db.db"
	Dim dest As String = File.Combine(File.DirDefaultExternal, "todo_db.db")

	If File.Exists(source, "") Then
		File.Copy(source, "", dest, "")
		ToastMessageShow("Database copied to /Download/", True)
	Else
		ToastMessageShow("Database not found!", True)
	End If
End Sub