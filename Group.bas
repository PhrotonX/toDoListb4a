B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_id As Long
	Private m_title As String
	Private m_description As String
	Private m_color As Int ' Colors are stored as Int in B4X.
	Private m_icon As String
	Private m_createdAt As DateAndTime
	Private m_updatedAt As DateAndTime
	Public SpecialGroup As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(id As Long)
	m_id = id
	
	SpecialGroup = False
	
	m_createdAt.Initialize
	m_updatedAt.Initialize
End Sub

Public Sub GetTitle As String
	Return m_title
End Sub

Public Sub GetDescription As String
	Return m_description
End Sub

Public Sub GetID As Long
	Return m_id
End Sub

Public Sub GetIcon As String
	Return m_icon
End Sub

Public Sub GetColor As Int
	Return m_color
End Sub

Public Sub CreatedAt() As DateAndTime
	Return m_createdAt
End Sub

Public Sub UpdatedAt() As DateAndTime
	Return m_updatedAt
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

Public Sub SetIcon(icon As String)
	m_icon = icon
End Sub