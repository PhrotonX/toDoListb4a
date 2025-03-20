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
	' 0 represents the least critical task while 3 represents most critical task.
	Private m_priority As Int
	' Index 0 represents Sunday while index 6 represents Saturday.
	Private m_repeat(7) As Boolean
	Public Done As Boolean
	
	Public Const PRIORITY_LOW As Int = 0
	Public Const PRIORITY_MEDIUM As Int = 1
	Public Const PRIORITY_HIGH As Int = 2
	Public Const PRIORITY_CRITICAL As Int = 3
	
	Public Const REPEAT_SUNDAY As Int = 0
	Public Const REPEAT_MONDAY As Int = 1
	Public Const REPEAT_TUESDAY As Int = 2
	Public Const REPEAT_WEDNESDAY As Int = 3
	Public Const REPEAT_THURSDAY As Int = 4
	Public Const REPEAT_FRIDAY As Int = 5
	Public Const REPEAT_SATURDAY As Int = 6
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	For Each REPEAT As Boolean In m_repeat
		REPEAT = False
	Next
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

' Encapsulate repeat value
Public Sub GetRepeat As Boolean(7)
	Return m_repeat
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

Public Sub SetRepeat(day As Int, repeat As Boolean)
	m_repeat(day) = repeat
End Sub

Public Sub SetPriority(priority As Int)
	m_priority = priority
End Sub