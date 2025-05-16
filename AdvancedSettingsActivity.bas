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
	Private lblImport As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("AdvancedSettingsLayout")

	lblAdvancedSettings.Text = Starter.Lang.Get("advanced_settings")
	lblDebug.Text = Starter.Lang.Get("debug_mode")
	lblExperimental.Text = Starter.Lang.Get("experimental_mode")
	lblExportDatabase.Text = Starter.Lang.Get("export_database")
	lblImport.Text = Starter.Lang.Get("import_database")
	lblResetApp.Text = Starter.Lang.Get("reset_app")
End Sub

Sub Activity_Resume
	LoadSettings
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub LoadSettings
	switchDebug.Value = Starter.SettingsViewModelInstance.IsDebugModeEnabled()
	switchExperimental.Value = Starter.SettingsViewModelInstance.IsExperimentalModeEnabled()
End Sub

Private Sub btnBack_Click
	Activity.Finish
End Sub

Private Sub lblResetApp_Click
	pnlResetApp.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlResetApp.SetColorAnimated(150, Colors.LightGray, Colors.White)
	Dim result As Int
	result = Msgbox2(Starter.Lang.Get("reset_app_warning"), Starter.Lang.Get("reset_app") & "?", Starter.Lang.Get("yes"), _ 
		Starter.Lang.Get("cancel"), Starter.Lang.Get("no"), Null)
		
	If result == DialogResponse.POSITIVE Then
		ProgressDialogShow(Starter.Lang.Get("resetting") & "...")
		Try
			If Starter.ToDoDatabaseViewModelInstance.ResetDatabase() Then
				Starter.AttachmentViewModelInstance.DropAttachmentsFromFS()
			End If
		
			Starter.SettingsViewModelInstance.LoadDefaults()
		
			LoadSettings
		
			MsgboxAsync(Starter.Lang.Get("reset_complete"), Starter.Lang.Get("alert"))
		Catch
			Log(LastException)
		
			If Starter.SettingsViewModelInstance.IsDebugModeEnabled Then
				MsgboxAsync(LastException.Message, Starter.Lang.Get("error"))
			Else
				MsgboxAsync(Starter.Lang.Get("reset_failed"), Starter.Lang.Get("error"))
			End If
		
		End Try
	
		ProgressDialogHide
	End If
End Sub

Private Sub lblImport_Click
	pnlImport.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlImport.SetColorAnimated(150, Colors.LightGray, Colors.White)
	
	Msgbox2Async(Starter.Lang.Get("import_question_info") & CRLF & CRLF & _
	Starter.Lang.Get("import_question_info_2") & CRLF & CRLF & _
	Starter.Lang.Get("import_question_info_3"), _ 
	Starter.Lang.Get("import_question"), _ 
	Starter.Lang.Get("continue"), Starter.Lang.Get("cancel"),"", Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		
	End If
End Sub

Private Sub lblExportDatabase_Click
	pnlExport.SetColorAnimated(50, Colors.White, Colors.LightGray)
	pnlExport.SetColorAnimated(150, Colors.LightGray, Colors.White)
End Sub

Private Sub switchExperimental_ValueChanged (Value As Boolean)
	OnSwitchExperimentalMode(Value)
End Sub

Private Sub switchDebug_ValueChanged (Value As Boolean)
	OnSwitchDebugMode(Value)
End Sub

Private Sub lblExperimental_Click
	If switchExperimental.Value = True Then
		switchExperimental.Value = False
		OnSwitchExperimentalMode(False)
	Else
		switchExperimental.Value = True
		OnSwitchExperimentalMode(True)
	End If
End Sub

Private Sub lblDebug_Click
	If switchDebug.Value = True Then
		switchDebug.Value = False
		OnSwitchDebugMode(False)
	Else
		switchDebug.Value = True
		OnSwitchDebugMode(True)
	End If
End Sub

Private Sub lblAdvancedSettings_Click
	
End Sub

Private Sub OnSwitchDebugMode(Value As Boolean)
	If Value Then
		Msgbox2Async(Starter.Lang.Get("debug_mode_question_info") & CRLF & CRLF & _
		Starter.Lang.Get("debug_mode_question_info_2") & CRLF & CRLF & _
		Starter.Lang.Get("debug_mode_question_info_3"), _ 
		Starter.Lang.Get("debug_mode_question"), _ 
		Starter.Lang.Get("continue"), Starter.Lang.Get("cancel"),"", Null, False)
		Wait For Msgbox_Result (Result As Int)
		If Result = DialogResponse.POSITIVE Then
			Starter.SettingsViewModelInstance.SetDebugMode(Value)
			switchDebug.Value = Value
		Else
			switchDebug.Value = False
		End If
	Else
		Starter.SettingsViewModelInstance.SetDebugMode(Value)
	End If
End Sub

Private Sub OnSwitchExperimentalMode(Value As Boolean)
	If Value Then
		Msgbox2Async(Starter.Lang.Get("experimental_mode_question_info") & CRLF & CRLF & _
		Starter.Lang.Get("experimental_mode_question_info_2") & CRLF & CRLF & _
		Starter.Lang.Get("experimental_mode_question_info_3"), _ 
		Starter.Lang.Get("experimental_mode_question"), _ 
		Starter.Lang.Get("continue"), Starter.Lang.Get("cancel"),"", Null, False)
		Wait For Msgbox_Result (Result As Int)
		If Result = DialogResponse.POSITIVE Then
			Starter.SettingsViewModelInstance.SetExperimentalMode(Value)
			switchExperimental.Value = Value
		Else
			switchExperimental.Value = False
		End If
	Else
		Starter.SettingsViewModelInstance.SetExperimentalMode(Value)
	End If
End Sub