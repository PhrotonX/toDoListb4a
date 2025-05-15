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
	Private btnBack As Button
	Private lblAdvancedSettings As Label
	Private lblDebug As Label
	Private lblExperimental As Label
	Private lblExportDatabase As Label
	Private switchDebug As B4XSwitch
	Private switchExperimental As B4XSwitch
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("AdvancedSettingsLayout")

End Sub

Sub Activity_Resume
	switchDebug.Value = Starter.SettingsViewModelInstance.IsDebugModeEnabled()
	switchExperimental.Value = Starter.SettingsViewModelInstance.IsExperimentalModeEnabled()
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub btnBack_Click
	Activity.Finish
End Sub

Private Sub lblResetApp_Click
	pnlResetApp.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlResetApp.SetColorAnimated(150, Colors.LightGray, Colors.White)
	Msgbox2("Resetting will erase all data, including settings and saved information. This action cannot be undone." & CRLF, "Reset app?", "YES", "CANCEL", "NO", Null)
End Sub

Private Sub lblImport_Click
	pnlImport.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlImport.SetColorAnimated(150, Colors.LightGray, Colors.White)
End Sub

Private Sub lblExportDatabase_Click
	pnlExport.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlExport.SetColorAnimated(150, Colors.LightGray, Colors.White)
End Sub

Private Sub switchExperimental_ValueChanged (Value As Boolean)
	Starter.SettingsViewModelInstance.SetExperimentalMode(Value)
End Sub

Private Sub switchDebug_ValueChanged (Value As Boolean)
	Starter.SettingsViewModelInstance.SetDebugMode(Value)
End Sub

Private Sub lblExperimental_Click
	If switchExperimental.Value = True Then
		switchExperimental.Value = False
		Starter.SettingsViewModelInstance.SetExperimentalMode(False)
	Else
		switchExperimental.Value = True
		Starter.SettingsViewModelInstance.SetExperimentalMode(True)
	End If
End Sub

Private Sub lblDebug_Click
	If switchDebug.Value = True Then
		switchDebug.Value = False
		Starter.SettingsViewModelInstance.SetDebugMode(False)

	Else
		switchDebug.Value = True
		Starter.SettingsViewModelInstance.SetDebugMode(True)
	End If
End Sub

Private Sub lblAdvancedSettings_Click
	
End Sub