B4A=true
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

	Private Label1 As Label
	Private svMain As ScrollView
	Private btnBack, help, about, helpArrow, aboutArrow As Button

End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	
	Activity.LoadLayout("settingslayout")
	svMain.Panel.LoadLayout("sviewlayout")
	button_design
End Sub

Sub button_design
	'Makes the bg, border of the buttons transparent
	
	Dim transparentBg As ColorDrawable
	transparentBg.Initialize(Colors.Transparent, 0)
	
	btnBack.Background = transparentBg
	helpArrow.Background = transparentBg
	aboutArrow.Background = transparentBg
End Sub

Sub btnBack_Click
	Activity.Finish
End Sub



Sub aboutArrow_Click
	StartActivity(SettingsAbout)
End Sub

Sub helpArrow_Click
	
	StartActivity(SettingsHelp)
End Sub

Sub help_Click
	StartActivity(SettingsHelp)
End Sub

Sub about_Click
	StartActivity(SettingsAbout)
End Sub
