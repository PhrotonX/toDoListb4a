B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private sql As SQL
	
	Private m_taskDao As TaskDao
	Private m_attachmentDao As AttachmentDao
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	' Create a database file based on SQLite
	sql.Initialize(File.DirInternal, "todo_db.db", True)
	
	CreateTable
	
	' Initialize data access objects.
	m_taskDao.Initialize(sql)
	m_attachmentDao.Initialize(sql)
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
	"done BOOLEAN NOT NULL DEFAULT 0," & CRLF & _
	"is_deleted BOOLEAN NOT NULL DEFAULT 0," & CRLF & _
	"created_at LONG NOT NULL DEFAULT 0," & CRLF & _
	"updated_at LONG NOT NULL DEFAULT 0," & CRLF & _
	"deleted_at LONG NOT NULL DEFAULT 0" & CRLF & _
	");"
	
	' Query for creating the days_of_the_week table.
	Dim query_days_of_the_week As String = "CREATE TABLE IF NOT EXISTS days_of_the_week(" & CRLF & _
	"day_id TINYINT NOT NULL," & CRLF & _
	"day_of_the_week VARCHAR(10) NOT NULL," & CRLF & _
	"PRIMARY KEY(day_id)" & CRLF & _
	");"
	
	' Query for creating the associative task_repeat table.
	Dim query_task_repeat As String = "CREATE TABLE IF NOT EXISTS task_repeat(" & CRLF & _
	"task_id INTEGER NOT NULL," & CRLF & _
	"day_id TINYINT NOT NULL," & CRLF & _
	"enabled BOOLEAN NOT NULL," & CRLF & _
	"PRIMARY KEY(task_id, day_id)" & CRLF & _
	");"
	
	' Query for creating the attachment table.
	Dim query_attachment As String = "CREATE TABLE IF NOT EXISTS attachment(" & CRLF & _
	"attachment_id INTEGER NOT NULL," & CRLF & _
	"filepath TEXT NOT NULL," & CRLF & _
	"mime_type VARCHAR(255)," & CRLF & _
	"size LONG," & CRLF & _
	"created_at LONG NOT NULL DEFAULT 0," & CRLF & _
	"updated_at LONG NOT NULL DEFAULT 0," & CRLF & _
	"PRIMARY KEY(attachment_id)" & CRLF & _
	");"
	
	' Query for creating the associative task_attachment table.
	Dim query_task_attachment As String = "CREATE TABLE IF NOT EXISTS task_attachment(" & CRLF & _
	"task_id INTEGER NOT NULL," & CRLF & _
	"attachment_id INTEGER NOT NULL," & CRLF & _
	"PRIMARY KEY(task_id, attachment_id)" & CRLF & _
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
		sql.ExecNonQuery(query_attachment)
		sql.ExecNonQuery(query_task_attachment)
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

Public Sub TaskDao() As TaskDao
	Return m_taskDao
End Sub

Public Sub AttachmentDao() As AttachmentDao
	Return m_attachmentDao
End Sub

' Closes the database
Public Sub CloseDatabase()
	sql.Close
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