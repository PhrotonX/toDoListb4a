B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_database As ToDoDatabase
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	m_database.Initialize
End Sub

Public Sub GetInstance() As ToDoDatabase
	Return m_database
End Sub

Public Sub CloseDatabase()
	m_database.CloseDatabase()
End Sub

Public Sub ResetDatabase()
	m_database.DropTables()
	m_database.CreateTable()
End Sub