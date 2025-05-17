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
	Private Const BACKGROUND_COLOR_OLD As Int = Colors.RGB(244, 241, 248)
	
	' Color indexes based on the color selector 
	Public Const COLOR_RED As Int = 0
	Public Const COLOR_ORANGE As Int = 1
	Public Const COLOR_BROWN As Int = 2
	Public Const COLOR_GREEN As Int = 3
	Public Const COLOR_BLUE As Int = 4
	Public Const COLOR_INDIGO As Int = 5
	Public Const COLOR_DEFAULT As Int = 5
	Public Const COLOR_PINK As Int = 6
End Sub

Public Sub SetUp(darkMode As Boolean)
	If darkMode == False Then
		m_primaryColor = Colors.RGB(73, 93, 143)
		m_textColor = Colors.RGB(73, 93, 143)
		m_foregroundColor = Colors.RGB(224, 234, 255)
	Else
		m_primaryColor = Colors.RGB(36, 36, 36)
		m_textColor = Colors.RGB(255, 255, 255)
		m_foregroundColor = Colors.RGB(53, 53, 53)
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

Public Sub GetPrimaryColor(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.RGB(244, 67, 54)
		Case COLOR_BLUE:
			Return Colors.RGB(33, 150, 243)
		Case COLOR_GREEN:
			Return Colors.RGB(76, 175, 80)
		Case COLOR_PINK:
			Return Colors.RGB(233, 30, 99)
		Case COLOR_ORANGE:
			Return Colors.RGB(255, 87, 34)
		Case COLOR_BROWN:
			Return Colors.RGB(121, 85, 72)
		Case Else, COLOR_INDIGO:
			Return Colors.RGB(73, 93, 143)
	End Select
End Sub

Public Sub GetBackgroundColor(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.RGB(255, 235, 238)
		Case COLOR_BLUE:
			Return Colors.RGB(227, 242, 253)
		Case COLOR_GREEN:
			Return Colors.RGB(232, 245, 233)
		Case COLOR_PINK:
			Return Colors.RGB(252, 228, 236)
		Case COLOR_ORANGE:
			Return Colors.RGB(255, 243, 224)
		Case COLOR_BROWN:
			Return Colors.RGB(239, 235, 233)
		Case Else, COLOR_INDIGO:
			Return Colors.RGB(232, 234, 246)
	End Select
End Sub

