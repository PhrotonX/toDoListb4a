B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_kvs As KeyValueStore
	
	Private Const SETTINGS_FILENAME As String = "settings.dat"

	Private Const SETTINGS_KEY_APP_TITLE As String = "app_title"
	Private Const SETTINGS_KEY_DARK_MODE As String = "dark_mode"
	Private Const SETTINGS_KEY_DEBUG_MODE As String = "debug_mode"
	Private Const SETTINGS_KEY_DETAILED_DUE_DATE As String = "detailed_due_date"
	Private Const SETTINGS_KEY_EXPERIMENTAL_MODE As String = "experimental_mode"
	Private Const SETTINGS_KEY_LANGUAGE As String = "language"
	Private Const SETTINGS_KEY_TASK_COMPLETION_SOUND As String = "task_completion_sound"
	Private Const SETTINGS_KEY_24_HOUR_FORMAT As String = "24_hour_format"
	Private Const 
	
	Private Const LANGUAGE_ARABIC As String = "ar"
	Private Const LANGUAGE_ENGLISH As String = "en_us"
	Private Const LANGUAGE_TAGALOG As String = "tl"
	Private Const LANGUAGE_KAPAMPANGAN As String = "pam"
	Private Const LANGUAGE_ESPANOL As String = "es"
	Private Const LANGUAGE_HANYU As String = "zh"
	
	Private Const DEFAULT_LANGUAGE As String = "en_us"
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	m_kvs.Initialize(File.DirInternal, SETTINGS_FILENAME)
	
	PopulateKeys
End Sub

Public Sub Close()
	m_kvs.Close()
End Sub

Public Sub LoadDefaults()
	m_kvs.Put(SETTINGS_KEY_APP_TITLE, "To Do List")
	
	SetDarkMode(False)
	SetDebugMode(False)
	SetDetailedDueDate(False)
	SetLanguage(DEFAULT_LANGUAGE)
	SetTaskCompletionSound(True)
	SetExperimentalMode(False)
	Set24HourFormat(False)
End Sub

Public Sub IsDebugModeEnabled() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_DEBUG_MODE)
End Sub

Public Sub IsDetailedDueDateEnabled() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_DETAILED_DUE_DATE)
End Sub

Public Sub IsDarkModeEnabled() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_DARK_MODE)
End Sub

Public Sub IsExperimentalModeEnabled() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_EXPERIMENTAL_MODE)
End Sub

Public Sub GetLanguage() As String
	Return m_kvs.Get(SETTINGS_KEY_EXPERIMENTAL_MODE)
End Sub

Public Sub IsTaskCompetionSoundEnabled() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_TASK_COMPLETION_SOUND)
End Sub

Public Sub Is24HourFormatEnabled() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_24_HOUR_FORMAT)
End Sub

Public Sub ResetSettings() As Boolean
	Dim result As Boolean = False
	Try
		m_kvs.DeleteAll()
		m_kvs.Vacuum()
	
		PopulateKeys
		
		result = True
	Catch
		Log(LastException)
	End Try
	
	Return result
End Sub

Public Sub PopulateKeys()
	' If one of the keys are missing, then re-populate the whole settings.
	' Missing settings could indicate corruption, malformation, or
	' has not been initialized.
	If m_kvs.ContainsKey(SETTINGS_KEY_APP_TITLE) == False Then
		LoadDefaults
	End If
End Sub

Public Sub SetDebugMode(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_DEBUG_MODE, value)
End Sub

Public Sub SetDetailedDueDate(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_DETAILED_DUE_DATE, value)
End Sub

Public Sub SetDarkMode(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_DARK_MODE, value)
End Sub

Public Sub SetExperimentalMode(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_EXPERIMENTAL_MODE, value)
End Sub

Public Sub SetLanguage(value As String)
	m_kvs.Put(SETTINGS_KEY_LANGUAGE, value)
End Sub

Public Sub SetTaskCompletionSound(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_TASK_COMPLETION_SOUND, value)
End Sub

Public Sub Set24HourFormat(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_24_HOUR_FORMAT, value)
End Sub