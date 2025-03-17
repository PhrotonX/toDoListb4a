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
	
	Create_Table
End Sub

Public Sub CreateTable
	Dim query_todo As String = "CREATE TABLE IF NOT EXISTS todo( " & CRLF & _
	"todo_id LONG NOT NULL AUTO_INCREMENT," & CRLF & _
	"title VARCHAR(255) NOT NULL," & CRLF & _
	"notes VARCHAR(255)," & CRLF & _
	"priority VARCHAR(25) NOT NULL," & CRLF & _
	"due_date DATE," & CRLF & _
	"PRIMARY KEY(todo_id)" & CRLF &  _
	");"
	
	Dim query_repeat As String = "CREATE TABLE IF NOT EXISTS repeat_table(" & CRLF & _
	"day_id LONG Not Null AUTO_INCREMENT," & CRLF & _
	"days_of_the_week VARCHAR(10)," & CRLF & _
	"PRIMARY KEY(day_id)" & CRLF & _
	");"
	
	Dim query_todo_repeat As String = "CREATE TABLE IF NOT EXISTS todo_repeat(" & CRLF & _
	"todo_id LONG Not Null," & CRLF & _
	"days_of_the_week LONG Not Null," & CRLF & _
	"PRIMARY KEY(todo_id, days_of_the_week)" & CRLF & _
	");"
	
	sql.BeginTransaction
	Try
		sql.ExecNonQuery(query_todo)
		sql.ExecNonQuery(query_repeat)
		sql.ExecNonQuery(query_todo_repeat)
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
End Sub

Public Sub DropTable
	Dim query_todo As String = "DROP TABLE IF EXISTS todo;"
	Dim query_repeat As String = "DROP TABLE IF EXISTS repeat;"
	Dim query_todo_repeat As String = "DROP TABLE IF EXISTS todo_repeat;"
	
	sql.BeginTransaction
	Try
		sql.ExecNonQuery(query_todo)
		sql.ExecNonQuery(query_repeat)
		sql.ExecNonQuery(query_todo_repeat)
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
End Sub