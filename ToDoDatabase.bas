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
	sql.Initialize(File.DirInternal, "todo_db.db", True)
	
	CreateTable
End Sub

Public Sub CreateTable
	Dim query_task As String = "CREATE TABLE IF NOT EXISTS task( " & CRLF & _
	"task_id BIGINT NOT NULL AUTO_INCREMENT," & CRLF & _
	"title VARCHAR(255) NOT NULL," & CRLF & _
	"notes VARCHAR(255)," & CRLF & _
	"priority INTEGER NOT NULL," & CRLF & _
	"due_date DATE," & CRLF & _
	"done BOOLEAN NOT NULL DEFAULT 0," & CRLF & _
	"PRIMARY KEY(task_id)" & CRLF &  _
	");"
	
	Dim query_days_of_the_week As String = "CREATE TABLE IF NOT EXISTS days_of_the_week(" & CRLF & _
	"day_id TINYINT NOT NULL," & CRLF & _
	"day_of_the_week VARCHAR(10) NOT NULL," & CRLF & _
	"PRIMARY KEY(day_id)" & CRLF & _
	");"
	
	Dim query_task_repeat As String = "CREATE TABLE IF NOT EXISTS task_repeat(" & CRLF & _
	"task_id BIGINT NOT NULL," & CRLF & _
	"day_id TINYINT NOT NULL," & CRLF & _
	"enabled BOOLEAN NOT NULL," & CRLF & _
	"PRIMARY KEY(task_id, day_id)" & CRLF & _
	");"
	
	Dim query_create_procedure As String = "CREATE PROCEDURE IF NOT EXISTS PopulateDaysOfTheWeek" & CRLF & _
	"AS" & CRLF & _
	"IF SELECT COUNT(*) FROM days_of_the_week = 0 THEN" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Sunday', 0);" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Monday', 1);" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Tuesday', 2);" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Wednesday', 3);" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Thursday', 4);" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Friday', 5);" & CRLF & _
	"INSERT INTO days_of_the_week(day_of_the_week, day_id) VALUES('Saturday', 6);" & CRLF & _
	"GO;" & CRLF & _
	"END IF;" & CRLF & _
	"EXEC PopulateDaysOfTheWeek;"
	
	sql.BeginTransaction
	Try
		sql.ExecNonQuery(query_task)
		sql.ExecNonQuery(query_days_of_the_week)
		sql.ExecNonQuery(query_task_repeat)
		sql.ExecNonQuery(query_create_procedure)
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
End Sub

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
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
End Sub

Public Sub InsertTask(item As ToDo)
	sql.BeginTransaction
	Try
		' Insert the task without the repeat data.
		sql.ExecNonQuery("INSERT INTO task(title, notes, priority, done)" & CRLF & _ 
		"VALUES('"&item.GetTitle&"', '"&item.GetNotes&"', "&item.GetPriority&", "&item.Done&");")
		
		' Get the ID if the last inserted row.In this case, it is the previous INSERT INTO TASK.
		Dim id As Long = sql.ExecQuerySingleResult("SELECT last_insert_rowid();")
		
		' Insert each item's repeat value
		Dim i As Int = 0
		For Each repeat As Boolean In item.GetRepeat
			sql.ExecNonQuery("INSERT INTO task_repeat(task_id, day_id, enabled)" & CRLF & _
			"VALUES("&id&", '"&i&"', "&repeat&");")
			i = i + 1
		Next
		
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
	Catch
		Log(LastException)
	End Try
	sql.EndTransaction
End Sub

Public Sub UpdateTask(item As ToDo)
	sql.BeginTransaction
	Try
		' Update a specific item
		sql.ExecNonQuery("UPDATE task SET title = '"&item.GetTitle& "', " & CRLF & _ 
		"notes = '" & item.GetNotes & "', " & CRLF & _
		"priority = " & item.GetPriority & ", " & CRLF & _
		"done = " & item.Done & CRLF & _ 
		"WHERE task_id = " & item.GetId & CRLF & _
		";")
		
		' Update each item's repeat value
		For Each repeat As Boolean In item.GetRepeat
			sql.ExecNonQuery("UPDATE task_repeat SET " & CRLF & _
			"enabled = " & repeat & CRLF & _
			"WHERE task_id = " & item.GetId & ";")
		Next
	Catch
		Log(LastException)
	End Try
	sql.EndTransaction
End Sub

Public Sub GetTask(id As Long) As ToDo
	Dim item As ToDo
	sql.BeginTransaction
	Try
		item.Initialize
		
		' Obtain items 1 by 1 since SQL library in B4A does not support multiple columns
		item.SetId(sql.ExecQuerySingleResult("SELECT task_id FROM task WHERE task_id" = id))
		item.SetTitle(sql.ExecQuerySingleResult("SELECT title FROM task WHERE task_id" = id))
		item.SetNotes(sql.ExecQuerySingleResult("SELECT notes FROM task WHERE task_id" = id))
		item.SetPriority(sql.ExecQuerySingleResult("SELECT priority FROM task WHERE task_id" = id))
		item.Done = sql.ExecQuerySingleResult("SELECT done FROM task WHERE task_id" = id)
		
		

	Catch
		Log(LastException)
	End Try
	sql.EndTransaction
End Sub
