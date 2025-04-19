B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_dtRepository As SettingsRepository
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	m_dtRepository.Initialize()
End Sub

Public Sub Close
	m_dtRepository.Close()
End Sub

Public Sub GetDebugMode() As Boolean
	Return m_dtRepository.GetDebugMode()
End Sub

Public Sub GetDarkMode() As Boolean
	Return m_dtRepository.GetDarkMode()
End Sub

Public Sub GetExperimentalMode() As Boolean
	Return m_dtRepository.GetExperimentalMode()
End Sub

Public Sub GetLanguage() As String
	Return m_dtRepository.GetLanguage()
End Sub

Public Sub GetTaskCompetionSound() As Boolean
	Return m_dtRepository.GetTaskCompetionSound()
End Sub

Public Sub LoadDefaults()
	m_dtRepository.LoadDefaults()
End Sub

Public Sub SetDebugMode(value As Boolean)
	m_dtRepository.SetDebugMode(value)
End Sub

Public Sub SetDarkMode(value As Boolean)
	m_dtRepository.SetDarkMode(value)
End Sub

Public Sub SetExperimentalMode(value As Boolean)
	m_dtRepository.SetExperimentalMode(value)
End Sub

' Supports the following values: en_us (English), tl (Tagalog), ar, zh, pam
Public Sub SetLanguage(value As String)
	m_dtRepository.SetLanguage(value)
End Sub

Public Sub SetTaskCompletionSound(value As Boolean)
	m_dtRepository.SetTaskCompletionSound(value)
End Sub