﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.2
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private aboutBack As Button

	Private svAbout As ScrollView
	Private aboutLabel As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	
	Activity.LoadLayout("settingsabout")
	svAbout.Panel.LoadLayout("aboutItems")
	button_design
End Sub

Sub aboutBack_Click
	Activity.Finish
End Sub

Sub button_design
	Dim transparentBg As ColorDrawable
	transparentBg.Initialize(Colors.Transparent, 0)
	aboutBack.Background = transparentBg
	
	Dim c As Canvas
	c.Initialize(aboutLabel)
	Dim borderColor As Int = Colors.RGB(209, 209, 209)
	Dim borderHeight As Int = 1dip

	
	c.DrawLine(0, aboutLabel.Height - borderHeight / 2, aboutLabel.Width, aboutLabel.Height - borderHeight / 2, borderColor, borderHeight)

	aboutLabel.Invalidate
End Sub
