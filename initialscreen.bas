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

	Private ImageView1 As ImageView
	Private Panel1 As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("loading")
	iconAnim
	Sleep(2000)
	exitAnim
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub iconAnim
	Dim anim As Animation
	anim.InitializeAlpha("anim", 0, 1)
	anim.Duration = 1000  ' Duration in milliseconds
	anim.Start(ImageView1)
End Sub

Sub exitAnim
	
	ImageView1.SetVisibleAnimated(1000, False)
	Sleep(1000)
	Activity.SetVisibleAnimated(20, False)
	Activity.Finish
End Sub
