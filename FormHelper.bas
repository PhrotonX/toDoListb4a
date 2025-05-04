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
			spnMonth.Add(SPINNER_DUE_DATE_MONTH_HINT_TEXT)
			Continue
		End If
		' Retrieves the month name based on the iteration value and add it to the spinner.
		spnMonth.Add(dateObj.GetMonthFromNum(i))
	Next
	
	' Populate with days. Include the 0 value or null.
	For i = 0 To 31
		' If i is equal to 0, then add a hint text as an option
		If i == 0 Then
			spnDay.Add(SPINNER_DUE_DATE_DAY_HINT_TEXT)
			Continue
		End If
		' Sets the current iteration value as a day.
		spnDay.Add(i)
	Next
End Sub

Public Sub PopulateTime(spnHour As Spinner, spnMinute As Spinner, spnMarker As Spinner)
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
	Else
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
	
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_OFF))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_1_MINUTE))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_3_MINUTES))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_5_MINUTES))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_10_MINUTES))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_15_MINUTES))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_20_MINUTES))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_30_MINUTES))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_1_HOUR))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_2_HOURS))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_5_HOURS))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_12_HOURS))
	spnSnooze.Add(snoozeObj.GetSnoozeText(snoozeObj.SNOOZE_1_DAY))
End Sub

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

' Validation to check if editTitle is empty and set the title into the task object.
Public Sub ValidateTitle(taskObj As ToDo, editTitle As EditText) As Boolean
	If editTitle.Text == "" Then
		MsgboxAsync("Title cannot be empty!", "Error")
		Return False
	End If
	
	If editTitle.Text.Length >= 255 Then
		MsgboxAsync("Title cannot be larger than 255!", "Error")
		Return False
	End If
	
	taskObj.SetTitle(editTitle.Text)
	Return True
End Sub

' Returns true if succeeded and false if not.
Public Sub ValidatePriority(rdCritical As RadioButton, rdHigh As RadioButton, rdMedium As RadioButton, _
	rdLow As RadioButton) As Boolean
	If rdCritical.Checked == False And rdHigh.Checked == False _
	And rdMedium.Checked == False And rdLow.Checked == False Then
		MsgboxAsync("Priority cannot be empty!", "Error")
		Return False
	End If
	
	Return True
End Sub

' Returns true if succeeded and false if not.
Public Sub ValidateDate(dateObj As Date, editYear As EditText) As Boolean
	' Primarily validate the due date year field if null before taking another validation if
	' the date is a valid date.
	If editYear.Text.Trim = "" Then
		MsgboxAsync("Due date field cannot be empty!", "Error")
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
		MsgboxAsync("Due date cannot be empty", "Error")
		Return False
	End If
	
	' Check if the year input is valid. The input only supports from years 1970 until 2038.
	If dateObj.IsRangeValid() == False Then
		MsgboxAsync("Due date is beyond the supported range: " & CRLF & _
		"January 1, 1970 to January 19, 2038", "Error")	
		Return False
	End If
	
	' Check for malformations within the date. The date could be on the valid range 1970 to 2038
	' but malformed date such as January -20, 2023 or February 29, 2025.
	If dateObj.IsDateValid() == False Then
		MsgboxAsync("Due date is not valid", "Error")
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