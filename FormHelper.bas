B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.1
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

	Public Const SPINNER_DUE_DATE_DAY_HINT_TEXT As String = "Select day here..."
	Public Const SPINNER_DUE_DATE_MONTH_HINT_TEXT As String = "Select month here..."
	
	Public Const DEFAULT_TASK_NAME As String = "Tasks"
End Sub

' Fill items into the date Spinners.
Public Sub PopulateDate(spnMonth As Spinner, spnDay As Spinner)
	Dim dateObj As Date
	dateObj.Initialize(0, 0, 0)
	
	' Clear the spinner items to prevent potential item duplication bug.
	spnDay.Clear
	spnMonth.Clear
	
	' Populate with months. Include the 0 value or null.
	For i = 0 To 12
		' If i is equal to 0, then add a hint text as an option
		If i == 0 Then
			spnMonth.Add(Starter.Lang.Get("select_month_here"))
			Continue
		End If
		' Retrieves the month name based on the iteration value and add it to the spinner.
		spnMonth.Add(Starter.Lang.Get(dateObj.GetMonthFromNum(i)))
	Next
	
	' Populate with days. Include the 0 value or null.
	For i = 0 To 31
		' If i is equal to 0, then add a hint text as an option
		If i == 0 Then
			spnDay.Add(Starter.Lang.Get("select_day_here"))
			Continue
		End If
		' Sets the current iteration value as a day.
		spnDay.Add(i)
	Next
End Sub

Public Sub PopulateDateRange(spnDateRange As Spinner)
	Dim dateObj As Date
	dateObj.Initialize(0, 0, 0)
	
	spnDateRange.Clear
	
	spnDateRange.Add(Starter.Lang.Get("select_date_range"))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_A_LONG_TIME_AGO))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_EARLIER))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_LAST_WEEK))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_EARLIER_THIS_WEEK))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_YESTERDAY))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_TODAY))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_TOMORROW))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_THIS_WEEK))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_NEXT_WEEK))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_LATER))
	spnDateRange.Add(Starter.Lang.Get(dateObj.DATE_A_LONG_TIME_FROM_NOW))
End Sub

Public Sub PopulateTime(spnHour As Spinner, spnMinute As Spinner, spnMarker As Spinner, pnlMarker As Panel)
	' Make a time object
	Dim timeObj As Time
	timeObj.Initialize(0, 0, 0)
	
	' Clear the items before adding new items.
	spnHour.Clear
	spnMinute.Clear
	spnMarker.Clear
	
	' Populate the hour field, depending if 24-hour format setting is used.
	If Starter.SettingsViewModelInstance.Is24HourFormatEnabled() == True Then
		For i = 0 To 23
			spnHour.Add(timeObj.GetNumWithLeadingZero(i))
		Next
		
		' Hide the time marker field if the 24-hour format setting is enabled.
		spnMarker.Visible = False
		pnlMarker.Visible = False
	Else
		' Add items 1 to 12 into the spinner.
		For i = 1 To 12
			spnHour.Add(timeObj.GetNumWithLeadingZero(i))
		Next
		
		spnMarker.Add("AM")
		spnMarker.Add("PM")
		
	End If
	
	For i = 0 To 59
		spnMinute.Add(timeObj.GetNumWithLeadingZero(i))
	Next
End Sub

' Populates snooze spinner.
Public Sub PopulateSnooze(spnSnooze As Spinner)
	Dim snoozeObj As Snooze
	snoozeObj.Initialize
	
	' Clear the items before adding new items.
	spnSnooze.Clear
	
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_OFF)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_1_MINUTE)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_3_MINUTES)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_5_MINUTES)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_10_MINUTES)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_15_MINUTES)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_20_MINUTES)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_30_MINUTES)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_1_HOUR)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_2_HOURS)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_5_HOURS)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_12_HOURS)))
	spnSnooze.Add(Starter.Lang.Get(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_1_DAY)))
End Sub

' Populates the task group spinner based on the database contents.
' Expects Starter.GroupViewModelInstance to be initialized.
Public Sub PopulateTaskGroups(spntaskGroup As Spinner)
	Dim groups As List = Starter.GroupViewModelInstance.GetGroups()
	
	' Has index of 0 by default
	spntaskGroup.Add(DEFAULT_TASK_NAME)
	
	If groups.IsInitialized Then
		For Each item As Group In groups
			spntaskGroup.Add(item.GetTitle)
		Next
	End If
End Sub

Public Sub SetMonthValue(spnMonth As Spinner, dateObj As Date, Position As Int)
	' Retrieve the item as string from the Spinner.
	Dim monthStr As String = spnMonth.GetItem(Position)
	
	If monthStr ==  Starter.Lang.Get("select_month_here") Then
		' If the month value that is clicked is invalid, then clear the month
		' value that is set into m-task.
		dateObj.SetMonth(0)
	Else
		' Convert the month String retrieved from the spinner into an int.
		'Dim month As Int = dateObj.GetNumericMonth(monthStr)
		Dim month As Int = Position
		
		' Set the month value into the task based on the month item that is
		' clicked from the spinner.
		dateObj.SetMonth(month)
	End If
End Sub

Public Sub SetDayValue(spnDay As Spinner, dateObj As Date, Position As Int)
	Dim day As String = spnDay.GetItem(Position)
	
	If day == Starter.Lang.Get("select_day_here") Then
		' If the day value that is clicked is invalid, then clear the day
		' value that is set into m-task.
		dateObj.SetDay(0)
	Else
		' Set the day value into the task based on the day item that is
		' clicked from the spinner.
		dateObj.SetDay(day)
	End If
	
End Sub

' Validation to check if editTitle is empty.
Public Sub ValidateTitle(taskObj As ToDo, editTitle As EditText) As Boolean
	If editTitle.Text == "" Then
		MsgboxAsync(Starter.Lang.Get("validation_error_title_empty"), Starter.Lang.Get("error"))
		Return False
	End If
	
	If editTitle.Text.Length >= 255 Then
		MsgboxAsync(Starter.Lang.Get("validation_error_title_255"), Starter.Lang.Get("error"))
		Return False
	End If
	Return True
End Sub

' Returns true if succeeded and false if not.
Public Sub ValidatePriority(rdCritical As RadioButton, rdHigh As RadioButton, rdMedium As RadioButton, _
	rdLow As RadioButton) As Boolean
	If rdCritical.Checked == False And rdHigh.Checked == False _
	And rdMedium.Checked == False And rdLow.Checked == False Then
		MsgboxAsync(Starter.Lang.Get("validation_error_priority_empty"), Starter.Lang.Get("error"))
		Return False
	End If
	
	Return True
End Sub

' Returns true if succeeded and false if not.
Public Sub ValidateDate(dateObj As Date, editYear As EditText) As Boolean
	' Primarily validate the due date year field if null before taking another validation if
	' the date is a valid date.
	If editYear.Text.Trim = "" Then
		MsgboxAsync(Starter.Lang.Get("validation_error_due_date_empty"), Starter.Lang.Get("error"))
		Return False
	Else
		' Save the due date year value.
		dateObj.SetYear(editYear.Text)
	End If
	
	' Second step validation.
	Return OnValidateDate(dateObj)
End Sub

' Validates if the date input is valid, ranging from January 1, 1970 until February 18, 2038.
' and is not unset.
Private Sub OnValidateDate(dateObj As Date) As Boolean
	' Check if the date is unset. Unset values cannot be valid.
	If dateObj.IsUnset Then
		MsgboxAsync(Starter.Lang.Get("validation_error_due_date_empty"), Starter.Lang.Get("error"))
		Return False
	End If
	
	' Check if the year input is valid. The input only supports from years 1970 until 2038.
	If dateObj.IsRangeValid() == False Then
		MsgboxAsync(Starter.Lang.Get("validation_error_due_date_supported_range") & ": " & CRLF & _ 
		Starter.Lang.Get("validation_error_due_date_supported_range_2"), Starter.Lang.Get("error"))	
		Return False
	End If
	
	' Check for malformations within the date. The date could be on the valid range 1970 to 2038
	' but malformed date such as January -20, 2023 or February 29, 2025.
	If dateObj.IsDateValid() == False Then
		MsgboxAsync(Starter.Lang.Get("validation_error_due_date_not_valid"), Starter.Lang.Get("error"))
		Return False
	End If
	
	Return True
End Sub

' Expects Starter.SettingsViewModelInstance to be initialized
Public Sub GetSelectedTime(timeObj As Time, spnHour As Spinner, spnMin As Spinner, _
	spnMarkAs As Spinner)
	
	' Get the selected reminder.
	If Starter.SettingsViewModelInstance.Is24HourFormatEnabled Then
		timeObj.SetHour(spnHour.SelectedItem)
	Else
		If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
			Log("FormHelper.SaveTime(): selected reminder marker " & spnMarkAs.SelectedItem)
		End If
		timeObj.SetHour12HourFormat(spnHour.SelectedItem, spnMarkAs.SelectedItem)
	End If
	timeObj.SetMinute(spnMin.SelectedItem)
	timeObj.SetSecond(0)
	
	If Starter.SettingsViewModelInstance.IsDebugModeEnabled() == True Then
		Log("FormHelper.SaveTime(): Saved reminder " & timeObj.GetFormattedTime( _
		Starter.SettingsViewModelInstance.Is24HourFormatEnabled()))
	End If
End Sub

' Returns the title of the string except if the default group title is selected.
Public Sub GetSelectedGroup(spnGroup As Spinner) As String
	If spnGroup.SelectedIndex > 0 Then
		Return spnGroup.SelectedItem
	End If
	
	Return ""
End Sub