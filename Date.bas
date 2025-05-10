B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class is designed to work with the EditorActivity due date fields

Sub Class_Globals
	Private m_month As Int
	Private m_day As Int
	Private m_year As Int
	
	' A single day in UNIX time is equal to 86,400,000 milliseconds.
	Public Const DAY_LENGTH As Long = 86400000
	
	Public Const DATE_A_LONG_TIME_AGO As String = "A long time ago"
	Public Const DATE_EARLIER As String = "Earlier"
	Public Const DATE_LAST_WEEK As String = "Last week"
	Public Const DATE_EARLIER_THIS_WEEK As String = "Earlier this week"
	Public Const DATE_YESTERDAY As String = "Yesterday"
	Public Const DATE_TODAY As String = "Today"
	Public Const DATE_TOMORROW As String = "Tomorrow"
	Public Const DATE_THIS_WEEK As String = "This week"
	Public Const DATE_NEXT_WEEK As String = "Next week"
	Public Const DATE_LATER As String = "Later"
	Public Const DATE_A_LONG_TIME_FROM_NOW As String = "A long time from now"
End Sub

'Initializes the object.
' month data shall be "January" - "December"
' day data shall be "1" to "31" such that "1" to "9" does not have leading zeroes.
Public Sub Initialize(month As Int, DAY As Int, year As Int)
	m_month = month
	m_day = DAY
	m_year = year
End Sub

' Identifies date if it is a long time ago, earlier, last week, earlier this week, yesterday, today, tomorrow,
' this week, next, week, later, or a long time from now in a string data type.
' This function compares dates relatively.
Public Sub IdentifyDate() As String
	Dim ticksSaved As Long = GetUnixTime
	'Dim ticksNow As Long = DateTime.Now
	Dim ticksNowRaw As Long = DateTime.Now
	Dim ticksNow As Long = ticksNowRaw - (ticksNowRaw Mod DAY_LENGTH)
	
	' Compare the current UNIX tick to the saved UNIX tick. The multipled day length are d - 1.
	' E.g. day 0 is today and day 1 is tomorrow.
	If ticksSaved <= (ticksNow - (DAY_LENGTH * 364)) Then
		Return DATE_A_LONG_TIME_AGO
	Else If (ticksNow - (DAY_LENGTH * 364)) < ticksSaved And ticksSaved < (ticksNow - (DAY_LENGTH * 11)) Then
		Return DATE_EARLIER
	Else If (ticksNow - (DAY_LENGTH * 11)) < ticksSaved And ticksSaved < (ticksNow - (DAY_LENGTH * 4)) Then
		Return DATE_LAST_WEEK
	Else If (ticksNow - (DAY_LENGTH * 4)) < ticksSaved And ticksSaved < (ticksNow - (DAY_LENGTH * 2)) Then
		Return DATE_EARLIER_THIS_WEEK
	Else If (ticksNow - (DAY_LENGTH * 2)) < ticksSaved And ticksSaved < (ticksNow - DAY_LENGTH) Then
		Return DATE_YESTERDAY
	Else If ticksNow >= ticksSaved And ticksSaved < (ticksNow + DAY_LENGTH) Then
		Return DATE_TODAY
	Else If ticksNow < ticksSaved And ticksSaved < (ticksNow + (DAY_LENGTH  * 2)) Then
		Return DATE_TOMORROW
	Else If ticksNow < ticksSaved And ticksSaved < (ticksNow + (DAY_LENGTH  * 4)) Then
		Return DATE_THIS_WEEK
	Else If ticksNow < ticksSaved And ticksSaved < (ticksNow + (DAY_LENGTH  * 11)) Then
		Return DATE_NEXT_WEEK
	Else If ticksNow < ticksSaved And ticksSaved < (ticksNow + (DAY_LENGTH  * 364)) Then
		Return DATE_LATER
	Else If (ticksNow + (DAY_LENGTH * 364)) < ticksSaved Then
		Return DATE_A_LONG_TIME_FROM_NOW
	End If
	
	Return "Error"
	
	
	
End Sub
 
' Returns the UNIX variant of the date values set into this object. May result into an error
' if the date is less than January 1, 1970 or greater than January 19, 2038.
Public Sub GetUnixTime() As Long
	Dim processedDate As String = GetFormattedDate2
	
	Return DateTime.DateParse(processedDate)
End Sub

' Gets the numeric value of months, in which the m_month is stored as String.
Public Sub GetNumericMonth(month As String) As Int
	Select month
		Case "January":
			Return 1
		Case "February":
			Return 2
		Case "March":
			Return 3
		Case "April":
			Return 4
		Case "May":
			Return 5
		Case "June":
			Return 6
		Case "July":
			Return 7
		Case "August":
			Return 8
		Case "September":
			Return 9
		Case "October":
			Return 10
		Case "November":
			Return 11
		Case "December":
			Return 12
		Case Else:
			Return 0
	End Select
End Sub

' Returns month value with leading zero as a string based on the month value set
' into this object.
Private Sub GetMonthWithLeadingZero As String
	Select m_month
		Case 1:
			Return "01"
		Case 2:
			Return "02"
		Case 3:
			Return "03"
		Case 4:
			Return "04"
		Case 5:
			Return "05"
		Case 6:
			Return "06"
		Case 7:
			Return "07"
		Case 8:
			Return "08"
		Case 9:
			Return "09"
		Case 10:
			Return "10"
		Case 11:
			Return "11"
		Case 12:
			Return "12"
		Case Else:
			Return "00"
	End Select
End Sub

' Returns a String of nomnth with leading zeroes.
Private Sub GetNumericDayStr As String
	Select m_day
		Case "1":
			Return "01"
		Case "2":
			Return "02"
		Case "3":
			Return "03"
		Case "4":
			Return "04"
		Case "5":
			Return "05"
		Case "6":
			Return "06"
		Case "7":
			Return "07"
		Case "8":
			Return "08"
		Case "9":
			Return "09"
		Case Else:
			Return m_day
	End Select
End Sub

' Returns a String of months January to December.
Public Sub GetMonthFromNum(month As Int) As String
	Select month
		Case 1:
			Return "January"
		Case 2:
			Return "February"
		Case 3:
			Return "March"
		Case 4:
			Return "April"
		Case 5:
			Return "May"
		Case 6:
			Return "June"
		Case 7:
			Return "July"
		Case 8:
			Return "August"
		Case 9:
			Return "September"
		Case 10:
			Return "October"
		Case 11:
			Return "November"
		Case 12:
			Return "December"
		Case Else:
			Return ""
	End Select
End Sub

' Returns the date with the "Month DD, YYYY" format as a String based
' on the values set on this date object.
Public Sub GetFormattedDate As String
	Return GetMonthFromNum(m_month) & " " & m_day & ", " & m_year
End Sub

' Returns the date with the "mm/dd/YYYY" format as a String based
' on the values set on this date object.
Public Sub GetFormattedDate2 As String
	Return GetMonthWithLeadingZero & "/" & GetNumericDayStr & "/" & m_year
End Sub

Public Sub GetDateNoTime(ticks As Long) As Long
	Return ticks - (ticks Mod DAY_LENGTH)
End Sub

' Returns the day set into this object.
Public Sub GetDay As Int
	Return m_day
End Sub

' Returns the month of type int set into this object.
Public Sub GetMonth As Int
	Return m_month
End Sub

' Returns the year set into this object.
Public Sub GetYear As Int
	Return m_year
End Sub

' Checks if the date is validly ranging from January 1, 1970 until January 19, 2038.
' This Is used to make sure that the date is conformant to UNIX time.
Public Sub IsRangeValid As Boolean
	' Check the years if valid.
	If m_year < 1970 Or m_year > 2038 Then
		' Return false if the year is not valid.
		Return False
	Else
		' If the year is valid but months exceed January while on year 2038,
		' return false to delimit the supported months.
		If m_month > 1 And m_year >= 2038 Then
			Return False
		Else 
			' If the year and month  is valid but the day exceed January 19 while on year 2038,
			' return false to delimit the supported days.
			If m_day > 19 And m_month >= 1 And m_year >= 2038 Then
				Return False
			End If
		End If
	End If
	
	' Return true if the date range is valid.
	Return True
End Sub

' Checks whether the input date is valid. This prevents submitting invalid date such
' as February 31 or February 29 on a non-leap year. This funciton is important since
' the spinners on EditorActivity does not disable the days 29-31 depending on the
' month and the leap year.
Public Sub IsDateValid As Boolean
	' If day is a 0 or negative value, then return false.
	If m_day <= 0  Then
		Return False
	End If
	
	' Check the date based on months.
	Select m_month
		Case 1, 3, 5, 7, 8, 10, 12:
			' If the month is up to day 31 and the day is set to > 31, then return false.
			If m_day > 31 Then
				Return False
			End If
		Case 4, 6, 9, 11:
			' If the month is up to day 30 and the day is set to > 30, then return false.
			If m_day > 30 Then
				Return False
			End If
		Case 2:
			' If the month is Febuary, then check if the month is a leap year and then compare
			' if the day is either set to > 28 or > 29.
			If IsLeapYear Then
				If m_day > 29 Then
					Return False
				End If
			Else
				If m_day > 28 Then
					Return False
				End If
			End If
		Case Else:
			' Return falsse if the month number is not valid.
			Return False
	End Select
	
	' Return true if the date is valid.
	Return True
End Sub

' Checks is the currently set year is a leap year.
Public Sub IsLeapYear As Boolean
	' First, check if the year is divisible by 100.
	If (m_year Mod 100) == 0 Then
		' If it is divisible, and then check if the year is divisble by 400. If true, then
		' return true.
		If (m_year Mod 400) == 0 Then
			Return True
		End If
		Return False
	End If
	
	' If the year is not divsible by 100, and then check if the year is a leap year by
	' checking if it is divisible by 4, and then return true if it is divisible by 4.
	If (m_year Mod 4) == 0 Then
		Return True
	End If
	
	' If all the checks failed, then the year is not a leap year and return false.
	Return False
End Sub

' Checks if the date is set into zeroes. This function is used for null value checking.
Public Sub IsUnset() As Boolean
	If m_day == 0 And m_month == 0 And m_year == 0 Then
		Return True
	End If
	Return False
End Sub

Public Sub SetDay(day As Int)
	m_day = day
End Sub

Public Sub SetMonth(month As Int)
	m_month = month
End Sub

' Sets the day, month, and year values based on the UNIX time.
Public Sub SetUnixTime(time As Long)
	m_month = DateTime.GetMonth(time)
	m_day = DateTime.GetDayOfMonth(time)
	m_year = DateTime.GetYear(time)
End Sub

Public Sub SetYear(year As Int)
	m_year = year
End Sub

' Sets the date as unset.
Public Sub Unset()
	m_month = 0
	m_day = 0
	m_year = 0
End Sub