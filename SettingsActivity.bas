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
	Private btnBack, help, about As Button

	Private switchDarkMode As B4XSwitch
	Private DebugMode As ToggleButton
	Private ExportDataBase As Button
	Private ImportDataBase As Button
	Private TaskCompletion As ToggleButton
	Private pnlSettingsBar As Panel
	Private Switch1 As Switch
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("settingslayout")
	svMain.Panel.LoadLayout("sviewlayout")
	
	LoadSettings
	
	button_design
	
End Sub

Sub LoadSettings
	switchDarkMode.Value = Starter.SettingsViewModelInstance.IsDarkModeEnabled()
	'DebugMode.Checked = Starter.SettingsViewModelInstance.IsDebugModeEnabled()
	TaskCompletion.Checked = Starter.SettingsViewModelInstance.IsTaskCompetionSoundEnabled()
End Sub

Sub button_design
	pnlSettingsBar.Elevation = 10
	

	
End Sub

Sub btnBack_Click
	Activity.Finish
End Sub

Sub help_Click
	StartActivity(SettingsHelp)
End Sub	

Sub about_Click
	StartActivity(SettingsAbout)
End Sub


Private Sub ResetApp_Click
	ProgressDialogShow("Resetting...")
	Try
		If Starter.ToDoDatabaseViewModelInstance.ResetDatabase() Then
			Starter.AttachmentViewModelInstance.DropAttachmentsFromFS()
		End If
		
		Starter.SettingsViewModelInstance.LoadDefaults()
		
		LoadSettings
		
		MsgboxAsync("Application has been successfully reset! You may need to restart your application for changes " & _
		"to take effect.", "Alert")
	Catch
		Log(LastException)
		
		If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
			MsgboxAsync(LastException.Message, "Error")
		Else
			MsgboxAsync("Failed to reset application", "Error")
		End If
		
	End Try
	
	ProgressDialogHide
End Sub

Private Sub ImportDatabase_Click
	
End Sub

Private Sub ExportDatabase_Click
	
End Sub

Private Sub DebugMode_CheckedChange(Checked As Boolean)
	Starter.SettingsViewModelInstance.SetDebugMode(Checked)
End Sub

Private Sub DarkMode_CheckedChange(Checked As Boolean)
	Starter.SettingsViewModelInstance.SetDarkMode(Checked)
End Sub

Private Sub TaskCompletion_CheckedChange(Checked As Boolean)
	Starter.SettingsViewModelInstance.SetTaskCompletionSound(Checked)
	
End Sub