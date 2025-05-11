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
		m_primaryColor = Colors.RGB(73, 93, 143)
		m_textColor = Colors.RGB(73, 93, 143)
		m_foregroundColor = Colors.RGB(224, 234, 255)
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

Public Sub GetGroupPrimaryColor(groupObj As Group) As Int
	If groupObj.IsInitialized Then
		Select groupObj.GetColor():
			Case groupObj.COLOR_RED:
				Return Colors.RGB(244, 67, 54)
			Case groupObj.COLOR_BLUE:
				Return Colors.RGB(33, 150, 243)
			Case groupObj.COLOR_GREEN:
				Return Colors.RGB(76, 175, 80)
			Case groupObj.COLOR_PINK:
				Return Colors.RGB(233, 30, 99)
			Case groupObj.COLOR_ORANGE:
				Return Colors.RGB(255, 87, 34)
			Case groupObj.COLOR_BROWN:
				Return Colors.RGB(121, 85, 72)
			Case Else, groupObj.COLOR_INDIGO:
				Return Colors.RGB(73, 93, 143)
		End Select
	End If
	
	Return Colors.RGB(73, 93, 143)
End Sub

