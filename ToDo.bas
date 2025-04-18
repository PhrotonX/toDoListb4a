B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_id As Long
	Private m_title As String
	Private m_notes As String
	Private m_priority As Int
	Private m_dueDate As Date
	Private m_createdAt As DateAndTime
	Private m_updatedAt As DateAndTime
	Private m_deletedAt As DateAndTime
	Private m_isDeleted As Boolean
	Public Done As Boolean
	
	Public Const PRIORITY_LOW As Int = 0
	Public Const PRIORITY_MEDIUM As Int = 1
	Public Const PRIORITY_HIGH As Int = 2
	Public Const PRIORITY_CRITICAL As Int = 3
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	m_id = 0
	
	' Initialize the due date with empty date since the constructor requires it.
	m_dueDate.Initialize(0, 0, 0)
	
	m_createdAt.Initialize
	m_deletedAt.Initialize
	m_updatedAt.Initialize
End Sub

Public Sub GetCreatedAt As DateAndTime
	Return m_createdAt
End Sub

Public Sub GetDeletedAt As DateAndTime
	Return m_deletedAt
End Sub

' Retrieves the glance information to be displayed on TaskItemLayout.
' repeat - The repeat information from Repeat object.
Public Sub GetGlance(repeat As String) As String
	Dim dueDate As String = m_dueDate.GetFormattedDate2
	'Dim repeat As String = GetRepeatInfo
	
	' Separate variable for hyphen is used to toggle it if either repeat is not
	' available.
	Dim hyphen As String = " - "
	
	' Remove hyphen for if repeat information is not available.
	If repeat == "" Then
		hyphen = ""
	End If
	
	
	Return dueDate & hyphen & repeat
End Sub

Public Sub GetDueDate As Date
	Return m_dueDate
End Sub

Public Sub GetId As Long
	Return m_id
End Sub

' Encapsulate title value
Public Sub GetTitle As String
	Return m_title
End Sub

' Encapsulate notes value
Public Sub GetNotes As String
	Return m_notes
End Sub

' Encapsulate priority value
Public Sub GetPriority As Int
	Return m_priority
End Sub

Public Sub GetPriorityInfo As String
	Select GetPriority
		Case PRIORITY_CRITICAL:
			Return "Critical"
		Case PRIORITY_HIGH:
			Return "High"
		Case PRIORITY_MEDIUM:
			Return "Medium"
		Case PRIORITY_LOW:
			Return "Low"
		Case Else:
			Return "Error retrieving task priority"
	End Select
End Sub

Public Sub GetUpdatedAt As DateAndTime
	Return m_updatedAt
End Sub

Public Sub IsDeleted As Boolean
	Return m_isDeleted
End Sub

Public Sub SetDeleted(value As Boolean)
	m_isDeleted = value
End Sub

Public Sub SetDueDate(dueDate As Date)
	m_dueDate = dueDate
End Sub

Public Sub SetId(id As String)
	m_id = id
End Sub

Public Sub SetTitle(title As String)
	m_title = title
End Sub

Public Sub SetNotes(notes As String)
	m_notes = notes
End Sub

Public Sub SetPriority(priority As Int)
	m_priority = priority
End Sub