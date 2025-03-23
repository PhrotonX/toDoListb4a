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
	Private helpBack As Button
	Private svHelp As ScrollView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	Activity.LoadLayout("settingshelp")
	svHelp.Panel.LoadLayout("helpItems")
	button_design


End Sub

Sub button_design
	Dim transparentBg As ColorDrawable
	transparentBg.Initialize(Colors.Transparent, 0)
	helpBack.Background = transparentBg
End Sub

Sub helpBack_Click
	Activity.Finish
End Sub