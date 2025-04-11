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
	Private m_primaryColor As Int
	Private m_foregroundColor As Int
	Private m_textColor As Int
End Sub

Public Sub SetUp(darkMode As Boolean)
	If darkMode Then
		m_primaryColor = Colors.ARGB(255, 73, 93, 143)
		m_textColor = Colors.ARGB(255, 73, 93, 143)
		m_foregroundColor = Colors.ARGB(255, 224, 234, 255)
	Else
		
	End If
	
End Sub

Public Sub ForegroundColor As Int
	Return m_foregroundColor
End Sub

Public Sub PrimaryColor As Int
	Return m_primaryColor
End Sub

Public Sub TextColor As Int
	Return m_textColor
End Sub

