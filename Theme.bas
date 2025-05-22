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
	Private m_primaryColor As Int = Colors.RGB(73, 93, 143)
	Private m_foregroundColor As Int = Colors.RGB(224, 234, 255)
	Private m_textColor As Int = Colors.RGB(73, 93, 143)
	Private m_darkMode As Boolean = False
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
	'If darkMode == False Then
	'	m_primaryColor
	'	m_textColor
	'	m_foregroundColor 
	'Else
	'	m_primaryColor = Colors.RGB(50, 60, 90)
	'	m_textColor = Colors.RGB(50, 60, 90)
	'	m_foregroundColor = Colors.RGB(17,17,18)
	'End If
	
	m_darkMode = darkMode
	
End Sub

Public Sub ForegroundColor As Int
	Return m_foregroundColor
End Sub

Public Sub DarkbackgroundColor As Int
	Return Colors.RGB(17,17,18)
End Sub

Public Sub PrimaryColor As Int
	Return m_primaryColor
End Sub

Public Sub TextColor As Int
	Return m_textColor
End Sub

Public Sub ForegroundText As Int
	Return Colors.RGB(232,232,234)
End Sub

Public Sub RootColor As Int
	Return Colors.RGB(27,28,28)
End Sub


Public Sub btnRootColor As ColorDrawable
	Dim cd As ColorDrawable
	cd.Initialize(Colors.RGB(27,28,28), 20)
	
	Return cd
End Sub


Public Sub GetPrimaryColor(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.rgb(244, 67, 54)
		Case COLOR_BLUE:
			Return Colors.rgb(33, 150, 243)
		Case COLOR_GREEN:
			Return Colors.rgb(76, 175, 80)
		Case COLOR_PINK:
			Return Colors.rgb(233, 30, 99)
		Case COLOR_ORANGE:
			Return Colors.rgb(255, 152, 0)
		Case COLOR_BROWN:
			If m_darkMode Then
				Return Colors.rgb(255, 235, 59)
			Else
				Return Colors.rgb(121, 85, 72)
			End If
			
		Case Else, COLOR_INDIGO:
			Return Colors.RGB(73, 93, 143)
	End Select
End Sub

Public Sub GetTextColor(colorIndex As Int) As Int
	Select colorIndex
		Case COLOR_RED:
			Return Colors.RGB(255, 80, 80)      ' Bright red
		Case COLOR_BLUE:
			Return Colors.RGB(80, 140, 255)     ' Bright blue
		Case COLOR_GREEN:
			Return Colors.RGB(0, 200, 100)      ' Bright green
		Case COLOR_PINK:
			Return Colors.RGB(255, 85, 160)     ' Bright pink
		Case COLOR_ORANGE:
			Return Colors.RGB(255, 140, 50)     ' Bright orange
		Case COLOR_BROWN:
			If m_darkMode Then
				Return Colors.RGB(190, 190, 80)
			Else
				Return Colors.RGB(190, 120, 80)     ' Bright brown (strong tan)
			End If
			
		Case Else, COLOR_INDIGO:
			Return Colors.RGB(120, 150, 255)    ' Bright indigo/blue
	End Select
End Sub


Public Sub GetBackgroundColor(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.RGB(255, 235, 238)   ' Red Tone ~95
		Case COLOR_BLUE:
			Return Colors.RGB(227, 242, 253)   ' Blue Tone ~95
		Case COLOR_GREEN:
			Return Colors.RGB(232, 245, 233)   ' Green Tone ~95
		Case COLOR_PINK:
			Return Colors.RGB(252, 228, 236)   ' Pink Tone ~95
		Case COLOR_ORANGE:
			Return Colors.RGB(255, 243, 224)   ' Orange Tone ~95
		Case COLOR_BROWN:
			If m_darkMode Then
				Return Colors.rgb(255, 235, 59) ' Yellow for dark mode
			Else
				Return Colors.RGB(239, 235, 233) ' Brown Tone ~95
			End If
			   
		Case Else, COLOR_INDIGO:
			Return Colors.rgb(232, 234, 246)   ' Indigo Tone ~95
	End Select
End Sub

Public Sub GetBackgroundColor2(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.RGB(255, 205, 210)   ' Red Tone ~95
		Case COLOR_BLUE:
			Return Colors.RGB(187, 222, 251)   ' Blue Tone ~95
		Case COLOR_GREEN:
			Return Colors.RGB(200, 230, 201)   ' Green Tone ~95
		Case COLOR_PINK:
			Return Colors.RGB(248, 187, 208)   ' Pink Tone ~95
		Case COLOR_ORANGE:
			Return Colors.rgb(255, 224, 178)   ' Orange Tone ~95
		Case COLOR_BROWN:
			If m_darkMode Then
				Return Colors.rgb(255, 253, 231)	' Yellow
			Else
				Return Colors.rgb(215, 204, 200)   ' Brown Tone ~95
			End If
			
		Case Else, COLOR_INDIGO:
			Return Colors.rgb(197, 202, 233)   ' Indigo Tone ~95
	End Select
End Sub

Public Sub GetBackgroundColor3(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.rgb(239, 154, 154)
		Case COLOR_BLUE:
			Return Colors.rgb(144, 202, 249)
		Case COLOR_GREEN:
			Return Colors.rgb(165, 214, 167)
		Case COLOR_PINK:
			Return Colors.rgb(244, 143, 177)
		Case COLOR_ORANGE:
			Return Colors.rgb(255, 204, 128)
		Case COLOR_BROWN:
			If m_darkMode Then
				Return Colors.rgb(255, 245, 157) ' Yellow
			Else
				Return Colors.rgb(188, 170, 164) ' Brown
			End If
			
		Case Else, COLOR_INDIGO:
			Return Colors.rgb(159, 168, 218)   ' Indigo Tone ~95
	End Select
End Sub


Public Sub GetDarkPrimaryColor(colorIndex As Int) As Int
	Select colorIndex:
		Case COLOR_RED:
			Return Colors.RGB(140, 30, 30)      ' Darker red
		Case COLOR_BLUE:
			Return Colors.RGB(30, 60, 130)      ' Darker blue
		Case COLOR_GREEN:
			Return Colors.RGB(0, 80, 40)        ' Dark green
		Case COLOR_PINK:
			Return Colors.RGB(120, 30, 75)      ' Dark pink
		Case COLOR_ORANGE:
			Return Colors.RGB(140, 60, 10)      ' Dark orange
		Case COLOR_BROWN:
			If m_darkMode Then
				Return Colors.RGB(70, 70, 35)       ' Dark yellow
			Else
				Return Colors.RGB(70, 50, 35)       ' Dark brown
			End If
		Case Else, COLOR_INDIGO:
			Return Colors.RGB(50, 60, 90)       ' Dark indigo
	End Select
End Sub