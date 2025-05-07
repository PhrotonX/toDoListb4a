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
	'Private m_searchQuery As String
	Private m_sortQuery As String
	
	Private Const EQ As String = " = "
	Private Const GTE As String = " >= "
	Private Const LTE As String = " <= "
	
	Public Const TABLE_TASK As String = "task"
	Public Const TABLE_ATTACHMENT As String = "attachment"
	Public Const TABLE_REPEAT As String = "repeat"
	Public Const TABLE_GROUPS As String = "groups"
	Public Const TABLE_TASK_GROUP As String = "task_group"
	Public Const TABLE_TASK_ATTACHMENT As String = "task_attachment"
	Public Const TABLE_TASK_REPEAT As String = "task_repeat"
	
	Public Const FIELD_DONE  As String = "done" ' Order by "done" field by default. Used to split
	' completed and incomplete tasks.
	Public Const FIELD_TASK_ID As String = "task_id"
	Public Const FIELD_TITLE As String = "title"
	Public Const FIELD_NOTES As String = "notes"
	Public Const FIELD_ATTACHMENT_FILENAME As String = "filename"
	Public Const FIELD_ATTACHMENT_ID As String = "attachment_id"
	'Public Const FIELD_ATTACHMENT_MIMETYPE As String = "mimeType"
	Public Const FIELD_REPEAT_ID As String = "repeat_id"
	Public Const FIELD_REPEAT_DAY_ID As String = "day_id"
	Public Const FIELD_REPEAT_ENABLED As String = "enabled"
	Public Const FIELD_DUE_DATE As String = "due_date"
	Public Const FIELD_CREATED_AT As String = "created_at"
	Public Const FIELD_PRIORITY As String = "priority"
	Public Const FIELD_IS_DELETED As String = "is_deleted"
	Public Const FIELD_REMINDER As String = "reminder"
	Public Const FIELD_IS_REMINDER_ENABLED As String = "is_reminder_enabled"
	
	Private Const JOIN_QUERY_ITEM_REPEAT As Int = 0
	Private Const JOIN_QUERY_ITEM_GROUP As Int = 1
	Private Const JOIN_QUERY_ITEM_ATTACHMENT As Int = 2
	Private Const JOIN_QUERY_ITEM_ARRAY_SIZE As Int = 3
	
	Private const SEARCH_QUERY_ITEM_TASK_ID As Int = 0
	Private const SEARCH_QUERY_ITEM_SEARCH_BY As Int = 1
	Private const SEARCH_QUERY_ITEM_DUE_DATE_RANGE As Int = 2
	Private const SEARCH_QUERY_ITEM_PRIORITY As Int = 3
	Private const SEARCH_QUERY_ITEM_IS_DELETED As Int = 4
	Private const SEARCH_QUERY_ITEM_REMINDER As Int = 5
	Private const SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED As Int = 6
	Private const SEARCH_QUERY_ITEM_REPEAT_QUERY As Int = 7
	Private const SEARCH_QUERY_ITEM_GROUP_ID As Int = 8
	Private const SEARCH_QUERY_ITEM_ARRAY_SIZE As Int = 9
	
	Public Const ORDER_NONE As String = "NONE"
	Public Const ORDER_ASC As String = "ASC"
	Public Const ORDER_DESC As String = "DESC"
	
	' Adds data into the SQL query.
	Public m_searchQueryItem(SEARCH_QUERY_ITEM_ARRAY_SIZE) As String
	Public m_joinQueryItem(JOIN_QUERY_ITEM_ARRAY_SIZE) As String
	
	Private Const SEARCH_QUERY_ITEM_SEARCH_BY_TITLE As Int = 0
	Private Const SEARCH_QUERY_ITEM_SEARCH_BY_NOTES As Int = 1
	Private Const SEARCH_QUERY_ITEM_SEARCH_BY_ATTACHMENT_TITLE As Int = 2
	
	Public Const DUE_DATE_MODE_SEARCH_NONE As Int = -1
	Public Const DUE_DATE_MODE_SEARCH_DEFAULT As Int = 0
	Public Const DUE_DATE_MODE_SEARCH_BY_RANGE As Int = 1
	Public Const DUE_DATE_MODE_SEARCH_BY_GROUP As Int = 2
	
	Private m_searchBy As Int = SEARCH_QUERY_ITEM_SEARCH_BY
	Private m_searchByField As String = FIELD_TITLE
	
	Private m_groupId As Long = -1
	Private m_searchRepeat(7) As Boolean
	
	Public DateBegin As Date
	Public DateEnd As Date
	
	Private m_searchDateMode As Int = DUE_DATE_MODE_SEARCH_NONE
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize()
	m_order = ORDER_NONE
	m_sortQuery = FIELD_TASK_ID
	
	For Each item In m_searchRepeat
		item = False
	Next
	
	SetSearchIsDeleted(False)
	
	DateBegin.Initialize(0, 0, 0)
	DateEnd.Initialize(0, 0, 0)
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

' Supported values: FIELD_TITLE, FIELD_NOTES, FIELD_ATTACHMENT_FILENAME
Public Sub SetSearchBy(query As String)
	If m_searchByField == FIELD_ATTACHMENT_FILENAME Then
		SetSearchAttachmentFileName(query)
	Else
		m_searchQueryItem(SEARCH_QUERY_ITEM_SEARCH_BY) = m_searchByField & " LIKE '%" & query & "%'"
	End If
End Sub

' Supported values: FIELD_TITLE (default) and FIELD_NOTES
Public Sub SetSearchByField(field As String)
	m_searchByField = field
End Sub

Private Sub SetSearchAttachmentFileName(query As String)
 	' Set the join clause.
	m_joinQueryItem(JOIN_QUERY_ITEM_ATTACHMENT) = " JOIN " & TABLE_TASK_ATTACHMENT & _ 
		" ON " & TABLE_TASK_ATTACHMENT & "." & FIELD_TASK_ID & EQ _ 
		& TABLE_TASK & "." & FIELD_TASK_ID & _
		" JOIN " & TABLE_ATTACHMENT & _ 
		" ON " & TABLE_TASK_ATTACHMENT & "." & FIELD_ATTACHMENT_ID & EQ _ 
		& TABLE_ATTACHMENT & "." & FIELD_ATTACHMENT_ID
		
	' Set the where clause.
	m_searchQueryItem(SEARCH_QUERY_ITEM_SEARCH_BY) = TABLE_ATTACHMENT & "." & FIELD_ATTACHMENT_FILENAME & " LIKE " _ 
	& "'%" & query & "%'" 
End Sub

Public Sub SetSearchIsDeleted(value As Boolean)
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_DELETED) = FIELD_IS_DELETED & EQ & DatabaseUtils.BoolToInt(value)
End Sub

Public Sub SetSearchIsReminderEnabled(value As Boolean)
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED) = FIELD_IS_REMINDER_ENABLED & EQ & _
	DatabaseUtils.BoolToInt(value)
End Sub

Public Sub SetSearchReminder(value As Long)
	m_searchQueryItem(SEARCH_QUERY_ITEM_REMINDER) = FIELD_REMINDER & EQ & value
End Sub

Public Sub SetSearchPriority(value As Int)
	m_searchQueryItem(SEARCH_QUERY_ITEM_PRIORITY) = FIELD_PRIORITY & EQ & value
End Sub

' Does not support SQL query
Public Sub SetSearchRepeat(dayOfTheWeek As Int, value As Boolean)
	m_searchRepeat(dayOfTheWeek) = value
End Sub

' Supported values: DUE_DATE_MODE_SEARCH_NONE, DUE_DATE_MODE_SEARCH_DEFAULT, DUE_DATE_MODE_SEARCH_BY_GROUP, 
' and DUE_DATE_MODE_SEARCH_BY_RANGE
Public Sub SetSearchDateMode(mode As Int)
	m_searchDateMode = mode
End Sub

' Set Specific Due Date.
Private Sub SetSearchDueDate(dateObj As Date)
	Dim unixTime As Long = dateObj.GetUnixTime()
	SetSearchDueDateRange(unixTime, unixTime + dateObj.DAY_LENGTH)
End Sub

Private Sub SetSearchDueDateRange(tickBegin As Long, tickEnd As Long)
	Log(FIELD_DUE_DATE & GTE & tickBegin & " AND " & FIELD_DUE_DATE & LTE & tickEnd)
	
	m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = FIELD_DUE_DATE & GTE & tickBegin & " AND " & _
	 FIELD_DUE_DATE & LTE & tickEnd
End Sub

Public Sub GetGroupID() As Long
	Return m_groupId
End Sub

Public Sub GetJoinQuery(removeJoinClause As Boolean) As String
	Dim query As String = ""
	If removeJoinClause == False Then
		query = "JOIN "
	End If
	
	Dim result As String = query & OnBuildJoiningQuery
	
	Log("TaskQuery: " & result)
	
	If result == "JOIN " Then
		Return " "
	Else
		Return query & OnBuildJoiningQuery
	End If
End Sub

Public Sub GetSortingQuery() As String
	If m_order == ORDER_NONE Then
		Return "ORDER BY " & FIELD_DONE & " " & ORDER_ASC
	Else
		Return "ORDER BY " & m_sortQuery & " " & m_order
	End If
End Sub

Public Sub GetSearchDateMode() As Int
	Return m_searchDateMode
End Sub

Public Sub GetSearchingQuery(removeWhereClause As Boolean) As String
	Dim query As String = ""
	If removeWhereClause == False Then
		query = "WHERE "
	End If
	
	Dim result As String = query & OnBuildSearchingQuery
	
	Log("TaskQuery: " & result)
	
	If result == "WHERE " Then
		Return " "
	Else
		Return query & OnBuildSearchingQuery
	End If
End Sub

Private Sub OnBuildJoiningQuery() As String
	Dim query As String
	
	Dim itr As Int = 0
	For Each item As String In m_joinQueryItem
		Log("m_joinQueryItem: " & item)
		
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

Private Sub OnBuildSearchingQuery() As String
	Dim query As String
	
	Log("m_searchDateMode: " & m_searchDateMode)
	
	Dim itr As Int = 0
	For Each item As String In m_searchQueryItem
		Log("m_searchQueryItem: " & item)
		
		Select itr:
			Case SEARCH_QUERY_ITEM_DUE_DATE_RANGE:
				OnBuildSearchQueryForDate
			Case SEARCH_QUERY_ITEM_REPEAT_QUERY:
				OnBuildSearchQueryForRepeat
		End Select
		
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

Private Sub OnBuildSearchQueryForDate()
	Select m_searchDateMode:
		Case DUE_DATE_MODE_SEARCH_DEFAULT:
			SetSearchDueDate(DateBegin)
		Case DUE_DATE_MODE_SEARCH_BY_RANGE:
			SetSearchDueDateRange(DateBegin.GetUnixTime, DateEnd.GetUnixTime)
		Case DUE_DATE_MODE_SEARCH_BY_GROUP:
			If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
				Log("OnBuildSearchQueryForDate() SEARCH_QUERY_ITEM_SEARCH_DUE_DATE_BY_GROUP is not implemented.")
			End If
		Case DUE_DATE_MODE_SEARCH_NONE:
			Return
	End Select
End Sub

Private Sub OnBuildSearchQueryForRepeat()
	Dim searchQuery As String
	
 	' Set the join clause.
	m_joinQueryItem(JOIN_QUERY_ITEM_REPEAT) = " JOIN " & TABLE_TASK_REPEAT & _ 
		" ON " & TABLE_TASK_REPEAT & "." & FIELD_TASK_ID & EQ _ 
		& TABLE_TASK & "." & FIELD_TASK_ID & _
		" JOIN " & TABLE_REPEAT & _ 
		" ON " & TABLE_TASK_REPEAT & "." & FIELD_REPEAT_ID & EQ _ 
		& TABLE_REPEAT & "." & FIELD_REPEAT_ID
		
		
	Dim counter As Int = 0
	Dim andStr As String = ""
	Dim orStr As String = ""
	' Set the where clause.
	For i = 0 To 6
		If m_searchRepeat(i) == True Then
			If counter >= 0 And counter < 6 Then
				orStr = " OR "
			Else
				orStr = ""
			End If
			
			searchQuery = searchQuery & TABLE_REPEAT & "." & FIELD_REPEAT_DAY_ID & EQ & " " & i & orStr
		End If
		
		counter = counter + 1
	Next
	
	If searchQuery <> "" Then
		' Set the query for searching enabled field set to true.
		m_searchQueryItem(SEARCH_QUERY_ITEM_REPEAT_QUERY) = searchQuery & " AND " & TABLE_REPEAT & "." & _
			FIELD_REPEAT_ENABLED & EQ & DatabaseUtils.BoolToInt(True)
	Else
		' Set the query for searching tasks with no repeat values enabled.
		m_searchQueryItem(SEARCH_QUERY_ITEM_REPEAT_QUERY) = TABLE_REPEAT & "." & _
			FIELD_REPEAT_ENABLED & EQ & DatabaseUtils.BoolToInt(False)
	End If
	
End Sub

Public Sub UnsetTaskId()
	m_searchQueryItem(SEARCH_QUERY_ITEM_TASK_ID) = ""
End Sub

Public Sub UnsetSearchAttachmentFilename()
	m_joinQueryItem(JOIN_QUERY_ITEM_ATTACHMENT) = ""
	m_searchQueryItem(SEARCH_QUERY_ITEM_SEARCH_BY) = ""
End Sub

Public Sub UnsetSearchBy()
	m_searchQueryItem(SEARCH_QUERY_ITEM_SEARCH_BY) = ""
End Sub

Public Sub UnsetSearchDueDateRange()
	m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = ""
End Sub

Public Sub UnsetSearchGroupID()
	m_groupId = -1
End Sub

Public Sub UnsetSearchIsDeleted()
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_DELETED) = ""
End Sub

Public Sub UnsetSearchIsReminderEnabled()
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED) = ""
End Sub

Public Sub UnsetSearchRepeat()
	m_joinQueryItem(JOIN_QUERY_ITEM_REPEAT) = ""
	m_searchQueryItem(SEARCH_QUERY_ITEM_REPEAT_QUERY) = ""
End Sub

Public Sub UnsetSearchReminder()
	m_searchQueryItem(SEARCH_QUERY_ITEM_REMINDER) = ""
End Sub

Public Sub UnsetSearchPriority()
	m_searchQueryItem(SEARCH_QUERY_ITEM_PRIORITY) = ""
End Sub