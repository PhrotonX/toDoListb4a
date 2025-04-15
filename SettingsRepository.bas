B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_kvs As KeyValueStore
	
	Private Const SETTINGS_FILENAME As String = "settings.dat"
	
	Private Const SETTINGS_KEY_DARK_MODE As String = "dark_mode"
	Private Const SETTINGS_KEY_DEBUG_MODE As String = "debug_mode"
	Private Const SETTINGS_KEY_EXPERIMENTAL_MODE As String = "experimental_mode"
	Private Const SETTINGS_KEY_LANGUAGE As String = "language"
	Private Const SETTINGS_KEY_TASK_COMPLETION_SOUND As String = "task_completion_sound"
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	m_kvs.Initialize(File.DirInternal, SETTINGS_FILENAME)
End Sub

Public Sub GetDebugMode() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_DEBUG_MODE)
End Sub

Public Sub GetDarkMode() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_DARK_MODE)
End Sub

Public Sub GetExperimentalMode() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_EXPERIMENTAL_MODE)
End Sub

Public Sub GetLanguage() As String
	Return m_kvs.Get(SETTINGS_KEY_EXPERIMENTAL_MODE)
End Sub

Public Sub GetTaskCompetionSound() As Boolean
	Return m_kvs.Get(SETTINGS_KEY_TASK_COMPLETION_SOUND)
End Sub

Public Sub SetDebugMode(value As Boolean)
	m_kvs.Put(SETTINGS_KEY_DEBUG_MODE, value)
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