B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_title As String
	Private m_description As String
	Private m_color As Int ' Colors are stored as Int in B4X.
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub GetTitle As String
	Return m_title
End Sub

Public Sub GetDescription As String
	Return m_description
End Sub

Public Sub GetColor As Int
	Return m_color
End Sub

Public Sub SetTitle(title As String)
	m_title = title
End Sub

Public Sub SetDescription(description As String)
	m_description = description
End Sub

Public Sub SetColor(color As Int)
	m_color = color
End Sub