B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
' This class is designed to work with the EditorActivity due date fields,
' thus requiring date input in String format.

Sub Class_Globals
	Private m_month As String
	Private m_day As String
	Private m_year As String
End Sub

'Initializes the object.
' month data shall be "January" - "December"
' day data shall be "1" to "31" such that "1" to "9" does not have leading zeroes.
Public Sub Initialize(month As String, day As String, year As String)
	m_month = month
	m_day = day
	m_year = year
End Sub

Public Sub GetUnixTime() As Long
	Dim processedDate As String = GetNumericMonthStr & "/" & GetNumericDayStr & "/" & m_year
	
	Return DateTime.DateParse(processedDate)
End Sub

Private Sub GetNumericMonthStr As String
	Select m_month
		Case "January":
			Return "01"
		Case "February":
			Return "02"
		Case "March":
			Return "03"
		Case "April":
			Return "04"
		Case "May":
			Return "05"
		Case "June":
			Return "06"
		Case "July":
			Return "07"
		Case "August":
			Return "08"
		Case "September":
			Return "09"
		Case "October":
			Return "10"
		Case "November":
			Return "11"
		Case "December":
			Return "12"
		Case Else:
			Return "00"
	End Select
End Sub

' Adds leading 
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