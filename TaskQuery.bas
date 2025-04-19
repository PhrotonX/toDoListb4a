﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class is a similar to a query builder that is passed into TaskViewHolder and
' Then used by the TaskRepository to be procedded by TaskDao in order to retrieve specific
' List of Tasks in an SQL language that is compatible with SQLite.

Sub Class_Globals
	Private m_groupId As Long
	Private m_order As String
	Private m_searchQuery As String
	Private m_sortQuery As String
	Private m_repeat(7) As Boolean
	
	Private m_selectedQuery As String
	
	Private Const EQ As String = " = "
	Private Const GTE As String = " >= "
	Private Const LTE As String = " <= "
	Public Const FIELD_DONE  As String = "done" ' Order by "done" field by default. Used to split
	' completed and incomplete tasks.
	Public Const FIELD_TASK_ID As String = "task_id"
	Public Const FIELD_TITLE As String = "title"
	Public Const FIELD_NOTES As String = "notes"
	Public Const FIELD_ATTACHMENT_FILENAME As String = "filename"
	Public Const FIELD_REPEAT As String = "repeat" ' Only used for m_selectedQuery
	Public Const FIELD_DUE_DATE As String = "due_date"
	Public Const FIELD_CREATED_AT As String = "created_at"
	Public Const FIELD_PRIORITY As String = "priority"
	
	Public Const ORDER_NONE As String = "NONE"
	Public Const ORDER_ASC As String = "ASC"
	Public Const ORDER_DESC As String = "DESC"
	
	'Public Const QUERY_TYPE_SEARCH As Byte = 0
	'Public Const QUERY_TYPE_SORT As Byte = 1
	
	Private m_oneSearchField As Boolean = False
	Private m_oneSortField As Boolean = False
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize()
	m_order = ORDER_NONE
	m_sortQuery = FIELD_TASK_ID
	
	For Each item In m_repeat
		item = False
	Next
End Sub

Public Sub IsSortingEnabled() As Boolean
	If m_order == ORDER_NONE Then
		Return False
	End If
	
	Return True
End Sub

Public Sub SetGroupID(query As Long)
	m_groupId = query
End Sub

' order - Supported values: ASC, DESC, and NONE.
Public Sub SetSortOrder(order As String)
	m_order = order
End Sub

' field - Supported values: none, created_at, title, priority, due_date
Public Sub SetSortField(field As String)
	m_sortQuery = field
End Sub

Public Sub SetSearchTitle(query As String)
	m_searchQuery = FIELD_TITLE & EQ & query
	m_selectedQuery = FIELD_TITLE
End Sub

Public Sub SetSearchNotes(query As String)
	m_searchQuery = FIELD_NOTES & EQ & query
	m_selectedQuery = FIELD_NOTES
End Sub

Public Sub SetSearchAttachmentFileName(query As String)
	m_searchQuery = query
	m_selectedQuery = FIELD_ATTACHMENT_FILENAME
End Sub

' Does not support SQL query
Public Sub SetSearchRepeat(dayOfTheWeek As Int, value As Boolean)
	m_repeat(dayOfTheWeek) = value
	'm_selectedQuery = FIELD_REPEAT
End Sub

' Set Specific Due Date.
Public Sub SetSearchDueDate(dateObj As Date)
	Dim unixTime As Long = dateObj.GetUnixTime()
	SetSearchDueDateRange(unixTime, unixTime + dateObj.DAY_LENGTH)
End Sub

Public Sub SetSearchDueDateRange(tickBegin As Long, tickEnd As Long)
	m_searchQuery = FIELD_DUE_DATE & GTE & tickBegin & " AND " & FIELD_DUE_DATE & LTE & tickEnd
	'm_selectedQuery = DUE_DATE
End Sub

Public Sub GetGroupID() As Long
	Return m_groupId
End Sub

Public Sub GetSortingQuery() As String
	If m_order == ORDER_NONE Then
		Return "ORDER BY " & FIELD_DONE & " " & ORDER_ASC
	Else
		Return "ORDER BY " & m_sortQuery & " " & m_order
	End If
End Sub

Public Sub GetSearchingQuery() As String
	Return "WHERE " & m_searchQuery
End Sub

' Returns no field name.
Public Sub GetSearchingAttachmentTitle() As String
	Return m_searchQuery
End Sub