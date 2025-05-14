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
	
	Public Const JOIN_QUERY_ITEM_REPEAT As Int = 0
	Public Const JOIN_QUERY_ITEM_GROUP As Int = 1
	Public Const JOIN_QUERY_ITEM_ATTACHMENT As Int = 2
	Public Const JOIN_QUERY_ITEM_ARRAY_SIZE As Int = 3
	
	Public const SEARCH_QUERY_ITEM_TASK_ID As Int = 0
	Public const SEARCH_QUERY_ITEM_SEARCH_BY As Int = 1
	Public const SEARCH_QUERY_ITEM_DUE_DATE_RANGE As Int = 2
	Public const SEARCH_QUERY_ITEM_PRIORITY As Int = 3
	Public const SEARCH_QUERY_ITEM_IS_DELETED As Int = 4
	Public const SEARCH_QUERY_ITEM_REMINDER As Int = 5
	Public const SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED As Int = 6
	Public const SEARCH_QUERY_ITEM_REPEAT_QUERY As Int = 7
	Public const SEARCH_QUERY_ITEM_GROUP_ID As Int = 8
	Public const SEARCH_QUERY_ITEM_ARRAY_SIZE As Int = 9
	
	Public Const ORDER_NONE As String = "NONE"
	Public Const ORDER_ASC As String = "ASC"
	Public Const ORDER_DESC As String = "DESC"
	
	' Adds data into the SQL query.
	Public m_searchQueryItem(SEARCH_QUERY_ITEM_ARRAY_SIZE) As String
	Public m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_ARRAY_SIZE) As Boolean
	Public m_joinQueryItem(JOIN_QUERY_ITEM_ARRAY_SIZE) As String
	Public m_joinQueryItemEnabled(JOIN_QUERY_ITEM_ARRAY_SIZE) As Boolean
	
	'Private Const SEARCH_QUERY_ITEM_SEARCH_BY_TITLE As Int = 0
	'Private Const SEARCH_QUERY_ITEM_SEARCH_BY_NOTES As Int = 1
	'Private Const SEARCH_QUERY_ITEM_SEARCH_BY_ATTACHMENT_TITLE As Int = 2
	
	Public Const DUE_DATE_MODE_SEARCH_NONE As Int = -1
	Public Const DUE_DATE_MODE_SEARCH_DEFAULT As Int = 0
	Public Const DUE_DATE_MODE_SEARCH_BY_RANGE As Int = 1
	Public Const DUE_DATE_MODE_SEARCH_BY_GROUP As Int = 2
	
	'Private m_searchBy As Int = SEARCH_QUERY_ITEM_SEARCH_BY
	Private m_searchByField As String = FIELD_TITLE
	
	Private m_groupId As Long = -1
	Private m_searchRepeat(7) As Boolean
	Private m_value(SEARCH_QUERY_ITEM_ARRAY_SIZE) As String
	
	Private m_distinct As Boolean = False
	
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
	
	' Enable searching by title, attachments, and is_deleted by default
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_SEARCH_BY) = True
	m_joinQueryItemEnabled(JOIN_QUERY_ITEM_ATTACHMENT) = True
	
	m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = ""
	
	SetSearchIsDeletedEnabled(True)
	
	SetSearchIsDeleted(False)
	
	
	DateBegin.Initialize(0, 0, 0)
	DateEnd.Initialize(0, 0, 0)
End Sub

Public Sub IsDistinct() As Boolean
	Return m_distinct
End Sub

Public Sub IsJoiningFieldEnabled(field As Int) As Boolean
	Return m_joinQueryItemEnabled(field)
End Sub

Public Sub IsSearchingFieldEnabled(field As Int) As Boolean
	Return m_searchQueryItemEnabled(field)
End Sub

Public Sub IsSortingEnabled() As Boolean
	If m_order == ORDER_NONE Then
		Return False
	End If
	
	Return True
End Sub

Public Sub SetGroupID(query As Long)
	m_groupId = query
	m_value(SEARCH_QUERY_ITEM_GROUP_ID) = query
End Sub

Public Sub SetGroupIDEnabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_GROUP_ID) = value
	m_joinQueryItemEnabled(JOIN_QUERY_ITEM_GROUP) = value
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
Public Sub SetSearchBy(value As String)
	If m_searchByField == FIELD_ATTACHMENT_FILENAME Then
		SetSearchAttachmentFileName(value)
	Else
		m_searchQueryItem(SEARCH_QUERY_ITEM_SEARCH_BY) = m_searchByField & " LIKE '%" & value & "%'"
	End If
	
	m_value(SEARCH_QUERY_ITEM_IS_DELETED) = value
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
	m_value(SEARCH_QUERY_ITEM_IS_DELETED) = value
End Sub

Public Sub SetSearchIsDeletedEnabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_IS_DELETED) = value
End Sub

Public Sub SetSearchIsReminderEnabled(value As Boolean)
	m_searchQueryItem(SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED) = FIELD_IS_REMINDER_ENABLED & EQ & _
	DatabaseUtils.BoolToInt(value)
End Sub

Public Sub SetSearchIsReminderEnabled_Enabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_IS_REMINDER_ENABLED) = value
End Sub

Public Sub SetSearchReminder(value As Long)
	m_searchQueryItem(SEARCH_QUERY_ITEM_REMINDER) = FIELD_REMINDER & EQ & value
	m_value(SEARCH_QUERY_ITEM_REMINDER) = value
End Sub

Public Sub SetSearchReminder_Enabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_REMINDER) = value
End Sub

Public Sub SetSearchPriority(value As Int)
	m_searchQueryItem(SEARCH_QUERY_ITEM_PRIORITY) = FIELD_PRIORITY & EQ & value
	m_value(SEARCH_QUERY_ITEM_PRIORITY) = value
End Sub

Public Sub SetSearchPriorityEnabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_PRIORITY) = value
End Sub

' Does not support SQL query
Public Sub SetSearchRepeat(dayOfTheWeek As Int, value As Boolean)
	m_searchRepeat(dayOfTheWeek) = value
End Sub

Public Sub SetSearchRepeatEnabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_REPEAT_QUERY) = value
	m_joinQueryItemEnabled(JOIN_QUERY_ITEM_REPEAT) = value
	m_distinct = value
End Sub

' Supported values: DUE_DATE_MODE_SEARCH_NONE, DUE_DATE_MODE_SEARCH_DEFAULT, DUE_DATE_MODE_SEARCH_BY_GROUP, 
' and DUE_DATE_MODE_SEARCH_BY_RANGE
Public Sub SetSearchDueDateMode(mode As Int)
	m_searchDateMode = mode
End Sub

Public Sub SetSearchDueDateRange(rangeStr As String)
	Dim dateObj As Date
	dateObj.Initialize(0, 0, 0)
	
	Dim currentDate As Long = dateObj.GetDateNoTime(DateTime.Now)
	
	' The timezone offset in hours.
	Dim offset As Double = DateTime.GetTimeZoneOffsetAt(currentDate)

' 	3,600,000 milliseconds is 1 hour.
	currentDate = currentDate - (3600000 * offset)
	
	Select rangeStr:
		Case dateObj.DATE_A_LONG_TIME_AGO:
			OnSetSearchDueDateRange(0, currentDate - (dateObj.DAY_LENGTH * 364) - 1)
		Case dateObj.DATE_EARLIER:
			OnSetSearchDueDateRange(currentDate - (dateObj.DAY_LENGTH * 364), currentDate - (dateObj.DAY_LENGTH * 11) - 1)
		Case dateObj.DATE_LAST_WEEK:
			OnSetSearchDueDateRange(currentDate - (dateObj.DAY_LENGTH * 11), currentDate - (dateObj.DAY_LENGTH * 4) - 1)
		Case dateObj.DATE_EARLIER_THIS_WEEK:
			OnSetSearchDueDateRange(currentDate - (dateObj.DAY_LENGTH * 4), currentDate - (dateObj.DAY_LENGTH * 2) - 1)
		Case dateObj.DATE_YESTERDAY:
			OnSetSearchDueDateRange(currentDate - (dateObj.DAY_LENGTH * 2), currentDate - (dateObj.DAY_LENGTH - 1))
		Case dateObj.DATE_TODAY:
			OnSetSearchDueDateRange(currentDate, currentDate)
		Case dateObj.DATE_TOMORROW:
			OnSetSearchDueDateRange(currentDate + (dateObj.DAY_LENGTH * 1), currentDate + (dateObj.DAY_LENGTH * 2) - 1)
		Case dateObj.DATE_THIS_WEEK:
			OnSetSearchDueDateRange(currentDate + (dateObj.DAY_LENGTH * 2), currentDate + (dateObj.DAY_LENGTH * 4) - 1)
		Case dateObj.DATE_NEXT_WEEK:
			OnSetSearchDueDateRange(currentDate + (dateObj.DAY_LENGTH * 4), currentDate + (dateObj.DAY_LENGTH * 11) - 1)
		Case dateObj.DATE_LATER:
			OnSetSearchDueDateRange(currentDate + (dateObj.DAY_LENGTH * 11), currentDate + (dateObj.DAY_LENGTH * 364) - 1)
		Case dateObj.DATE_A_LONG_TIME_FROM_NOW:
			OnSetSearchDueDateRange(currentDate + (dateObj.DAY_LENGTH * 364), dateObj.LAST_EPOCH_VALUE)
		Case Else:
			UnsetSearchDueDateRange
	End Select
End Sub

Public Sub SetSearchDueDateEnabled(value As Boolean)
	m_searchQueryItemEnabled(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = value
End Sub

' Set Specific Due Date.
Private Sub SetSearchDueDate(dateObj As Date)
	Dim unixTime As Long = dateObj.GetUnixTime()
	OnSetSearchDueDateRange(unixTime, unixTime + dateObj.DAY_LENGTH)
End Sub

' Builds a date range search SQL query if tickBegin and tickEnd do not match. Else, it builds an SQL query
' for a specific date.
Private Sub OnSetSearchDueDateRange(tickBegin As Long, tickEnd As Long)
	
	If tickBegin <> tickEnd Then
		Log(FIELD_DUE_DATE & GTE & tickBegin & " AND " & FIELD_DUE_DATE & LTE & tickEnd)
	
		m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = FIELD_DUE_DATE & GTE & tickBegin & " AND " & _
		FIELD_DUE_DATE & LTE & tickEnd
	Else
		Log(FIELD_DUE_DATE & EQ & tickBegin)
	
		m_searchQueryItem(SEARCH_QUERY_ITEM_DUE_DATE_RANGE) = FIELD_DUE_DATE & EQ & tickBegin
	End If
	
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

' Returns values ORDER_NONE, ORDER_DESC, and ORDER_ASC.
Public Sub GetSortOrder() As String
	Return m_order
End Sub

Public Sub GetSearchDateMode() As Int
	Return m_searchDateMode
End Sub

Public Sub GetSearchBy() As String
	Return m_searchByField
End Sub

Public Sub SearchRepeat(index As Int) As Boolean
	Return m_searchRepeat(index)
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

' This returns an SQL SELECT clause influenced by 'DISTINCT' value.
Public Sub GetSelectClause() As String
	If IsDistinct Then
		Return "SELECT DISTINCT task.* FROM task"
	Else
		Return "SELECT * FROM task"
	End If
End Sub

' Does not support non-string values
Public Sub GetSearchValue(field As Int) As String
	Return m_value(field)
End Sub

Private Sub OnBuildJoiningQuery() As String
	Dim query As String
	
	Dim itr As Int = 0
	For Each item As String In m_joinQueryItem
		Log("m_joinQueryItem: " & item)
		
		If m_joinQueryItemEnabled(itr) == True Then
			If item <> "" Then
				If itr >= 1 And query <> "" Then
					query = query & " AND "
				End If
				
				query = query & " " & item
			End If
		End If
		
		itr = itr + 1
	Next
	
	Return query
End Sub

Private Sub OnBuildSearchingQuery() As String
	Dim query As String
	
	Log("m_searchDateMode: " & m_searchDateMode)
	
	Dim itr As Int = 0
	Dim ctr As Int = 0
	For Each item As String In m_searchQueryItem
		Log("m_searchQueryItem: " & item)
		
		Select itr:
			Case SEARCH_QUERY_ITEM_DUE_DATE_RANGE:
				OnBuildSearchQueryForDate
			Case SEARCH_QUERY_ITEM_REPEAT_QUERY:
				OnBuildSearchQueryForRepeat
		End Select
		
		If m_searchQueryItemEnabled(itr) == True Then
			If item <> "" Then
				If ctr >= 1 And query <> "" Then
					query = query & " AND "
				End If
				
				query = query & " " & item
			End If
			ctr = ctr + 1
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
			OnSetSearchDueDateRange(DateBegin.GetUnixTime, DateEnd.GetUnixTime)
		Case DUE_DATE_MODE_SEARCH_BY_GROUP:
			If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
				Log("OnBuildSearchQueryForDate() SEARCH_QUERY_ITEM_SEARCH_DUE_DATE_BY_GROUP is not implemented.")
			End If
		Case DUE_DATE_MODE_SEARCH_NONE:
			Return
	End Select
End Sub

Private Sub OnBuildSearchQueryForRepeat()
	' Set the join clause.
	m_joinQueryItem(JOIN_QUERY_ITEM_REPEAT) = " JOIN " & TABLE_TASK_REPEAT & _
		" ON " & TABLE_TASK_REPEAT & "." & FIELD_TASK_ID & EQ _ 
		& TABLE_TASK & "." & FIELD_TASK_ID & _
		" JOIN " & TABLE_REPEAT & _ 
		" ON " & TABLE_TASK_REPEAT & "." & FIELD_REPEAT_ID & EQ _ 
		& TABLE_REPEAT & "." & FIELD_REPEAT_ID
	
	Dim counter As Int = 0
	Dim selectedRepeat As String = "("
	For itr = 0 To 6
		If m_searchRepeat(itr) == True Then
			If counter == 0 Then
				selectedRepeat = selectedRepeat & itr
			Else If counter >= 0 And counter < 6 Then
				selectedRepeat = selectedRepeat & ", " & itr & ")"
			End If
			
			counter = counter + 1
		End If
	Next
	
	If counter <= 1 Then
		selectedRepeat = selectedRepeat & ")"
	End If
	
	' Set the where clause.
	If selectedRepeat <> "()" Then
		m_searchQueryItem(SEARCH_QUERY_ITEM_REPEAT_QUERY) = TABLE_REPEAT & "." & FIELD_REPEAT_DAY_ID & " IN " & _ 
		selectedRepeat & " AND " & TABLE_REPEAT & "." & FIELD_REPEAT_ENABLED & EQ & _ 
		DatabaseUtils.BoolToInt(True)
	Else
		m_searchQueryItem(SEARCH_QUERY_ITEM_REPEAT_QUERY) = TABLE_REPEAT & "." & FIELD_REPEAT_DAY_ID & _ 
		" IN (0, 1, 2, 3, 4, 5, 6) AND " & TABLE_REPEAT & "." & FIELD_REPEAT_ENABLED & EQ & _
		DatabaseUtils.BoolToInt(False)
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
	
	For Each item In m_searchRepeat
		item = False
	Next
End Sub

Public Sub UnsetSearchReminder()
	m_searchQueryItem(SEARCH_QUERY_ITEM_REMINDER) = ""
End Sub

Public Sub UnsetSearchPriority()
	m_searchQueryItem(SEARCH_QUERY_ITEM_PRIORITY) = ""
End Sub