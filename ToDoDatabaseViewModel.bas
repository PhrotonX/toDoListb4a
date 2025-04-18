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

Public Sub ResetDatabase() As Boolean
	Try
		Dim result1 As Boolean = False
		Dim result2 As Boolean = False
		result1 = m_database.DropTables()
		result2 = m_database.CreateTable()
	
		If result1 And result2 Then
			Return True
		Else
			Return False
		End If
	Catch
		Log(LastException)
	End Try
	
	Return False
End Sub

Public Sub GetLastInsertedID() As Long
	Return m_database.GetLastInsertedID()
End Sub