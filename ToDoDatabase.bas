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
	
	sql.BeginTransaction
	Try
		sql.ExecNonQuery("")
	Catch
		Log(LastException.Message)
	End Try
	sql.EndTransaction
End Sub