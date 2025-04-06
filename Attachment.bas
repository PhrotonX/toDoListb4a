B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_id As Long
	Private m_filepath As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(id As Long)
	m_id = id
End Sub

Public Sub GetID() As Long
	Return m_id
End Sub

Public Sub GetFilepath() As String
	Return m_filepath
End Sub

Public Sub SetFilepath(filepath As String)
	m_filepath = filepath
End Sub