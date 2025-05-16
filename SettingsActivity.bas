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
	Private switchTaskCompletion As B4XSwitch
	Private lbl24hrFormat As Label
	Private lblDarkMode As Label
	Private lblDetailedDueDate As Label
	Private lblLanguage As Label
	Private lblTaskCompletionSound As Label
	Private switchDetailedDueDate As B4XSwitch
	Private switchHourFormat24 As B4XSwitch
	Private lblAdvancedSettings As Label
	Private pnlAdvancedSettings As Panel
	Private lblGeneralSettings As Label
	Private spnLanguage As Spinner
	Private lblSettings As Label
	Private lblTaskSettings As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("settingslayout")
	svMain.Panel.LoadLayout("sviewlayout")
	
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_ENGLISH)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_TAGALOG)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_KAPAMPANGAN)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_ESPANOL)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_HANYU)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_AL_LOGHA_AL_3ARABIYAH)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_RUSSKIY)
	spnLanguage.Add(Starter.SettingsViewModelInstance.SETTING_LANG_BAHASA_INDONESIA)
	
	button_design
	
	lbl24hrFormat.Text = Starter.Lang.Get("24_hour_format")
	lblAdvancedSettings.Text = Starter.Lang.Get("advanced_settings")
	lblDarkMode.Text = Starter.Lang.Get("dark_mode")
	lblDetailedDueDate.Text = Starter.Lang.Get("detailed_due_date")
	lblGeneralSettings.Text = Starter.Lang.Get("general_settings")
	lblLanguage.Text = Starter.Lang.Get("language")
	lblSettings.Text = Starter.Lang.Get("settings")
	lblTaskCompletionSound.Text = Starter.Lang.Get("task_completion_sound")
	lblTaskSettings.Text = Starter.Lang.Get("task_settings")
End Sub

Sub Activity_Resume
	LoadSettings
End Sub

Sub LoadSettings
	switchDarkMode.Value = Starter.SettingsViewModelInstance.IsDarkModeEnabled()
	'DebugMode.Checked = Starter.SettingsViewModelInstance.IsDebugModeEnabled()
	switchTaskCompletion.Value = Starter.SettingsViewModelInstance.IsTaskCompetionSoundEnabled()
	switchHourFormat24.Value = Starter.SettingsViewModelInstance.Is24HourFormatEnabled()

	spnLanguage.SelectedIndex = spnLanguage.IndexOf(Starter.SettingsViewModelInstance.GetLanguage)
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

Private Sub lblTaskCompletionSound_Click
	If switchTaskCompletion.Value = True Then
		switchTaskCompletion.Value = False
		Starter.SettingsViewModelInstance.SetTaskCompletionSound(False)

	Else
		switchTaskCompletion.Value = True
		Starter.SettingsViewModelInstance.SetTaskCompletionSound(True)
	End If
End Sub


Private Sub lblDetailedDueDate_Click
	If switchDetailedDueDate.Value = True Then
		switchDetailedDueDate.Value = False
		Starter.SettingsViewModelInstance.SetDetailedDueDate(False)
	Else
		switchDetailedDueDate.Value = True
		Starter.SettingsViewModelInstance.SetDetailedDueDate(True)
	End If
End Sub

Private Sub lblDarkMode_Click
	If switchDarkMode.Value = True Then
		switchDarkMode.Value = False
		Starter.SettingsViewModelInstance.SetDarkMode(False)

	Else
		switchDarkMode.Value = True
		Starter.SettingsViewModelInstance.SetDarkMode(True)
	End If
End Sub

Private Sub lbl24hrFormat_Click
	If switchHourFormat24.Value = True Then
		switchHourFormat24.Value = False
		Starter.SettingsViewModelInstance.Set24HourFormat(False)

	Else
		switchHourFormat24.Value = True
		Starter.SettingsViewModelInstance.Set24HourFormat(True)
	End If
End Sub

Private Sub lblAdvancedSettings_Click
	pnlAdvancedSettings.SetColorAnimated(250, Colors.White, Colors.LightGray)
	pnlAdvancedSettings.SetColorAnimated(250, Colors.LightGray, Colors.White)
	StartActivity(AdvancedSettingsActivity)
End Sub

Private Sub switchTaskCompletion_ValueChanged (Value As Boolean)
	
End Sub

Private Sub switchHourFormat24_ValueChanged (Value As Boolean)
	
End Sub

Private Sub switchDetailedDueDate_ValueChanged (Value As Boolean)
	
End Sub

Private Sub switchDarkMode_ValueChanged (Value As Boolean)
	
End Sub

Private Sub spnLanguage_ItemClick (Position As Int, Value As Object)
	Msgbox2Async(Starter.Lang.Get("language_question_info") & CRLF & Starter.Lang.Get("language_question_info_2"), _ 
	Starter.Lang.Get("language_question"), Starter.Lang.Get("yes"), Starter.Lang.Get("cancel"), _ 
	Starter.Lang.Get("no"), Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		ToastMessageShow(Value, True)
		Starter.SettingsViewModelInstance.SetLanguage(Value)
		Starter.Lang.Initialize(Starter.SettingsViewModelInstance)
	End If
	
End Sub