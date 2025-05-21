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
	Private pnlAdvancedSettingsBar As Panel
	Private pnlTaskSettings As Panel
	
	Private ion As Object
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
	
	LoadExperimentalSettings(Starter.SettingsViewModelInstance.IsExperimentalModeEnabled)
	
End Sub

Sub Activity_Resume
	Darkmode
	LoadSettings
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub LoadSettings
	switchDebug.Value = Starter.SettingsViewModelInstance.IsDebugModeEnabled()
	switchExperimental.Value = Starter.SettingsViewModelInstance.IsExperimentalModeEnabled()
End Sub

Private Sub LoadExperimentalSettings(value As Boolean)
	lblImport.Enabled = value
	lblExportDatabase.Enabled = value
	
	If value == False Then
		lblImport.TextColor = Colors.Gray
		lblExportDatabase.TextColor = Colors.Gray
	Else
		If Starter.SettingsViewModelInstance.IsDarkModeEnabled Then
			lblImport.TextColor = Theme.ForegroundText
			lblExportDatabase.TextColor = Theme.ForegroundText
		Else
			lblImport.TextColor = Colors.Black
			lblExportDatabase.TextColor = Colors.Black
		End If
	End If
End Sub

Private Sub btnBack_Click
	Activity.Finish
End Sub

Private Sub lblResetApp_Click
	pnlResetApp.SetColorAnimated(50, Colors.Transparent, Colors.LightGray)
	pnlResetApp.SetColorAnimated(150, Colors.LightGray, Colors.Transparent)
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
	pnlImport.SetColorAnimated(50, Colors.Transparent, Colors.LightGray)
	pnlImport.SetColorAnimated(150, Colors.LightGray, Colors.Transparent)
	
	Msgbox2Async(Starter.Lang.Get("import_question_info") & CRLF & CRLF & _
	Starter.Lang.Get("import_question_info_2") & CRLF & CRLF & _
	Starter.Lang.Get("import_question_info_3"), _ 
	Starter.Lang.Get("import_question"), _ 
	Starter.Lang.Get("continue"), Starter.Lang.Get("cancel"),"", Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		' Open a file picker.
		Private filepicker As ContentChooser
	
		filepicker.Initialize("filepicker")
		filepicker.Show("application/vnd.sqlite3", "Choose database")
	End If
End Sub

Private Sub filepicker_Result (Success As Boolean, Dir As String, FileName As String)
	If Success Then
		Try
			Starter.ToDoDatabaseViewModelInstance.CloseDatabase
		
			File.Delete(File.DirInternal, "todo_db.db")
			Starter.ToDoFileSystemInstance.CopyFileFromUriToInternal("todo_db.db", Dir, FileName, File.DirInternal)
			
			Starter.ToDoDatabaseViewModelInstance.Initialize(Starter.Lang)
			
			MsgboxAsync(Starter.Lang.Get("reset_complete"), Starter.Lang.Get("import_success"))
		Catch
			Log(LastException)
			
			MsgboxAsync(Starter.Lang.Get(LastException.Message), Starter.Lang.Get("import_failed"))
		End Try
		
	End If
End Sub

Private Sub lblExportDatabase_Click
	pnlExport.SetColorAnimated(50, Colors.Transparent, Colors.LightGray)
	pnlExport.SetColorAnimated(150, Colors.LightGray, Colors.Transparent)
	
	Wait For (SaveAs(File.OpenInput(File.DirInternal, "todo_db.db"), "application/vnd.sqlite3", "todo_db.db")) _ 
		Complete (Success As Boolean)
	
	If Success Then
		MsgboxAsync(Starter.Lang.Get("export_success"), Starter.Lang.Get("alert"))
	Else
		MsgboxAsync(Starter.Lang.Get("export_failed"), Starter.Lang.Get("error"))
	End If
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
			LoadExperimentalSettings(Value)
		Else
			switchExperimental.Value = False
			LoadExperimentalSettings(False)
		End If
	Else
		Starter.SettingsViewModelInstance.SetExperimentalMode(Value)
		LoadExperimentalSettings(False)
	End If
End Sub

Private Sub Darkmode
	If Starter.SettingsViewModelInstance.IsDarkModeEnabled() = False Then
		pnlAdvancedSettingsBar.Color = Colors.RGB(241,241,241)
		btnBack.TextColor = Colors.RGB(67,67,67)
		pnlTaskSettings.Color = Colors.White
		
		lblAdvancedSettings.Textcolor = Colors.Black
		lblDebug.Textcolor = Colors.Black
		lblExperimental.Textcolor = Colors.Black
		lblResetApp.Textcolor = Colors.Black
		Activity.Color = Colors.RGB(241,241,241)
	Else
		pnlAdvancedSettingsBar.Color = Colors.RGB(28,28,28)
		btnBack.TextColor = Theme.ForegroundText
		pnlTaskSettings.Color = Theme.RootColor
		
		lblAdvancedSettings.Textcolor = Theme.ForegroundText
		lblDebug.Textcolor = Theme.ForegroundText
		lblExperimental.Textcolor = Theme.ForegroundText
		lblResetApp.Textcolor = Theme.ForegroundText
		Activity.Color = Theme.DarkbackgroundColor
	End If
	
End Sub

' ===============================================================================================================
' The code below is a part of the SaveAs library from the B4A developer, but this library is not yet compiled into
' an actual library.
' ===============================================================================================================
Sub SaveAs (Source As InputStream, MimeType As String, Title As String) As ResumableSub
	Dim intent As Intent
	intent.Initialize("android.intent.action.CREATE_DOCUMENT", "")
	intent.AddCategory("android.intent.category.OPENABLE")
	intent.PutExtra("android.intent.extra.TITLE", Title)
	intent.SetType(MimeType)
	StartActivityForResult(intent)
	Wait For ion_Event (MethodName As String, Args() As Object)
	If -1 = Args(0) Then 'resultCode = RESULT_OK
		Dim result As Intent = Args(1)
		Dim jo As JavaObject = result
		Dim ctxt As JavaObject
		Dim ContentResolver As JavaObject = ctxt.InitializeContext.RunMethodJO("getContentResolver", Null)
		Dim out As OutputStream = ContentResolver.RunMethod("openOutputStream", Array(jo.RunMethod("getData", Null), "wt")) 'wt = Write+Trim
		File.Copy2(Source, out)
		out.Close
		Return True
	End If
	Return False
End Sub

Sub StartActivityForResult(i As Intent)
	Dim jo As JavaObject = GetBA
	ion = jo.CreateEvent("anywheresoftware.b4a.IOnActivityResult", "ion", Null)
	jo.RunMethod("startActivityForResult", Array(ion, i))
End Sub

Sub GetBA As Object
	Dim jo As JavaObject
	Dim cls As String = Me
	cls = cls.SubString("class ".Length)
	jo.InitializeStatic(cls)
	Return jo.GetField("processBA")
End Sub