B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class is a similar to a query builder that is passed into TaskViewHolder and
' Then used by the TaskRepository to be procedded by TaskDao in order to retrieve specific
' List of Tasks in an SQL language that is compatible with SQLite.

Sub Class_Globals
	Private m_order As String
	Private m_searchQuery As String
	Private m_sortQuery As String
	Private m_selectedQuery As String
	
	Private Const EQ As String = " = "
	Private Const GTE As String = " >= "
	Private Const LTE As String = " <= "
	Public Const FIELD_DONE  As String = "done" ' Order by "done" field by default. Used to split
	' completed and incomplete tasks.
	Public Const FIELD_TASK_ID As String = "task_id"
	Public Const FIELD_TITLE As String = "title"
	Public Const FIELD_NOTES As String = "notes"
	'Public Const FIELD_ATTACHMENT_FILENAME As String = "filename"
	'Public Const FIELD_REPEAT As String = "repeat" ' Only used for m_selectedQuery
	Public Const FIELD_DUE_DATE As String = "due_date"
	Public Const FIELD_CREATED_AT As String = "created_at"
	Public Const FIELD_PRIORITY As String = "priority"
	Public Const FIELD_IS_DELETED As String = "is_deleted"
	Public Const FIELD_REMINDER As String = "reminder"
	Public Const FIELD_IS_REMINDER_ENABLED As String = "is_reminder_enabled"
	
	Private const SEARCH_QUERY_ITEM_TASK_ID As Int = 0
	Private const SEARCH_QUERY_ITEM_TITLE As Int = 1
	Private const SEARCH_QUERY_ITEM_NOTES As Int = 2
	Private const SEARCH_QUERY_ITEM_DUE_DATE_RANGE As Int = 3
	Private const SEARCH_QUERY_ITEM_PRIORITY As Int = 4
	Private const SEARCH_QUERY_ITEM_IS_DELETED As Int = 5
	Private const SEARCH_QUERY_ITEM_REMINDER As Int = 6
	Private const SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED As Int = 7
	Private const SEARCH_QUERY_ITEM_ARRAY_SIZE As Int = 8
	
	Public Const ORDER_NONE As String = "NONE"
	Public Const ORDER_ASC As String = "ASC"
	Public Const ORDER_DESC As String = "DESC"
	
	' Adds data into the SQL query.
	Public m_searchQueryItem(SEARCH_QUERY_ITEM_ARRAY_SIZE) As String
	
	Private m_groupId As Long
	Private m_searchRepeat(7) As Boolean
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize()
	m_order = ORDER_NONE
	m_sortQuery = FIELD_TASK_ID
	
	For Each item In m_searchRepeat
		item = False
	Next
	
	SetSearchIsDeleted(False)
End Sub

'Public Sub AppendAndSearch()
'	m_searchQuery = m_searchQuery & " AND "
'End Sub

'Public Sub AppendAndSort()
'	m_sortQuery = m_sortQuery & " AND "
'End Sub

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
	m_searchQueryItem(SEARCH_QUERY_ITEM_TITLE) = FIELD_TITLE & EQ & query
	m_selectedQuery = FIELD_TITLE
End Sub

Public Sub SetSearchNotes(query As String)
	m_searchQueryItem(SEARCH_QUERY_ITEM_NOTES) = FIELD_NOTES & EQ & query
	m_selectedQuery = FIELD_NOTES
End Sub

' @NOTE: Incomplete implementation.
'Public Sub SetSearchAttachmentFileName(query As String)
'	m_searchQuery = m_searchQuery & " " & query
'	m_selectedQuery = FIELD_ATTACHMENT_FILENAME
'End Sub
Public Sub SetSearchIsDeleted(value As Boolean)
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_DELETED) = FIELD_IS_DELETED & EQ & DatabaseUtils.BoolToInt(value)
	m_selectedQuery = FIELD_IS_DELETED
End Sub

Public Sub SetSearchIsReminderEnabled(value As Boolean)
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED) = FIELD_IS_REMINDER_ENABLED & EQ & DatabaseUtils.BoolToInt(value)
	m_selectedQuery = FIELD_IS_REMINDER_ENABLED
End Sub

Public Sub SetSearchReminder(value As Long)
	m_searchQueryItem(SEARCH_QUERY_ITEM_REMINDER) = FIELD_REMINDER & EQ & value
	m_selectedQuery = FIELD_REMINDER
End Sub

Public Sub SetSearchPriority(value As Int)
	m_searchQueryItem(SEARCH_QUERY_ITEM_PRIORITY) = FIELD_PRIORITY & EQ & value
	m_selectedQuery = FIELD_PRIORITY
End Sub

' Does not support SQL query
Public Sub SetSearchRepeat(dayOfTheWeek As Int, value As Boolean)
	m_searchRepeat(dayOfTheWeek) = value
	'm_selectedQuery = FIELD_REPEAT
End Sub

' Set Specific Due Date.
Public Sub SetSearchDueDate(dateObj As Date)
	Dim unixTime As Long = dateObj.GetUnixTime()
	SetSearchDueDateRange(unixTime, unixTime + dateObj.DAY_LENGTH)
End Sub

Public Sub SetSearchDueDateRange(tickBegin As Long, tickEnd As Long)
	m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = FIELD_DUE_DATE & GTE & tickBegin & " AND " & FIELD_DUE_DATE & LTE & tickEnd
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

Public Sub GetSearchingQuery(removeWhereClause As Boolean) As String
	Dim query As String = ""
	If removeWhereClause == False Then
		query = "WHERE "
	End If
	Log("TaskQuery: " & query & OnBuildSearchingQuery)
	Return query & OnBuildSearchingQuery
End Sub

' Returns no field name.
'Public Sub GetSearchingAttachmentTitle() As String
'	Return m_searchQuery
'End Sub

Private Sub OnBuildSearchingQuery() As String
	Dim query As String
	
	Dim itr As Int = 0
	For Each item As String In m_searchQueryItem
		
		If item <> "" Then
			If itr >= 1 And query <> "" Then
				query = query & " AND "
			End If
			
			query = query & " " & item
		End If
		
		itr = itr + 1
	Next
	
	Return query
End Sub

Public Sub UnsetTaskId()
	m_searchQueryItem(SEARCH_QUERY_ITEM_TASK_ID) = ""
End Sub

Public Sub UnsetSearchTitle()
	m_searchQueryItem(SEARCH_QUERY_ITEM_TITLE) = ""
End Sub

Public Sub UnsetSearchNotes()
	m_searchQueryItem(SEARCH_QUERY_ITEM_NOTES) = ""
End Sub

Public Sub UnsetSearchDueDateRange()
	m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = ""
End Sub

Public Sub UnsetSearchIsDeleted()
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_DELETED) = ""
End Sub

Public Sub UnsetSearchIsReminderEnabled()
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED) = ""
End Sub

Public Sub UnsetSearchReminder()
	m_searchQueryItem(SEARCH_QUERY_ITEM_REMINDER) = ""
End Sub

Public Sub UnsetSearchPriority()
	m_searchQueryItem(SEARCH_QUERY_ITEM_PRIORITY) = ""
End Sub