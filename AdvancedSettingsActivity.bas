B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
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

	Private lblResetApp As Label
	Private pnlImport As Panel
	Private pnlResetApp As Panel
	Private pnlExport As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("AdvancedSettingsLayout")
	'Activity.LoadLayout("emptytasks")
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub btnBack_Click
	Activity.Finish
End Sub

Private Sub lblResetApp_Click
	pnlResetApp.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlResetApp.SetColorAnimated(150, Colors.LightGray, Colors.White)
End Sub

Private Sub lblImport_Click
	pnlImport.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlImport.SetColorAnimated(150, Colors.LightGray, Colors.White)
End Sub

Private Sub lblExportDatabase_Click
	pnlExport.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlExport.SetColorAnimated(150, Colors.LightGray, Colors.White)
End Sub