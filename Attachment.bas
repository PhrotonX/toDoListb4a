B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_id As Long
	Private m_filename As String
	Private m_mimeType As String
	Private m_size As Long
	Private m_createdAt As DateAndTime
	Private m_updatedAt As DateAndTime
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(id As Long)
	m_id = id
	
	m_createdAt.Initialize
	m_updatedAt.Initialize
End Sub

Public Sub GetID() As Long
	Return m_id
End Sub

Public Sub GetFilename() As String
	Return m_filename
End Sub

Public Sub GetMimeType() As String
	Return m_mimeType
End Sub

Public Sub GetCreatedAt As DateAndTime
	Return m_createdAt
End Sub

Public Sub GetSize() As Long
	Return m_size
End Sub

Public Sub GetUpdatedAt As DateAndTime
	Return m_updatedAt
End Sub

Public Sub SetFilename(filename As String)
	m_filename = filename
End Sub

Public Sub SetMimeType(mimeType As String)
	m_mimeType = mimeType
End Sub

Public Sub SetSize(size As Long)
	m_size = size
End Sub