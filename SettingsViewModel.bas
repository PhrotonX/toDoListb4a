B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_dtRepository As SettingsRepository
	
	Public Const SETTING_LANG_ENGLISH As String = "English"
	Public Const SETTING_LANG_TAGALOG As String = "Tagalog"
	Public Const SETTING_LANG_KAPAMPANGAN As String = "Kapampangan"
	Public Const SETTING_LANG_ESPANOL As String = "Español"
	Public Const SETTING_LANG_HANYU As String = "汉语"
	Public Const SETTING_LANG_AL_LOGHA_AL_3ARABIYAH As String = "اللغة العربية"
	Public Const SETTING_LANG_RUSSKIY As String = "Русский"
	Public Const SETTING_LANG_BAHASA_INDONESIA As String = "Bahasa Indonesia"
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	m_dtRepository.Initialize()
End Sub

Public Sub Close
	m_dtRepository.Close()
End Sub

Public Sub IsDebugModeEnabled() As Boolean
	Return m_dtRepository.IsDebugModeEnabled()
End Sub

Public Sub IsDetailedDueDateEnabled() As Boolean
	Return m_dtRepository.IsDetailedDueDateEnabled()
End Sub

Public Sub IsDarkModeEnabled() As Boolean
	Return m_dtRepository.IsDarkModeEnabled()
End Sub

Public Sub IsExperimentalModeEnabled() As Boolean
	Return m_dtRepository.IsExperimentalModeEnabled()
End Sub

Public Sub GetLanguage() As String
	Select GetLanguageCode
		Case m_dtRepository.LANGUAGE_ENGLISH:
			Return SETTING_LANG_ENGLISH
		Case m_dtRepository.LANGUAGE_TAGALOG:
			Return SETTING_LANG_TAGALOG
		Case m_dtRepository.LANGUAGE_KAPAMPANGAN:
			Return SETTING_LANG_KAPAMPANGAN
		Case m_dtRepository.LANGUAGE_ESPANOL:
			Return SETTING_LANG_ESPANOL
		Case m_dtRepository.LANGUAGE_HANYU:
			Return SETTING_LANG_HANYU
		Case m_dtRepository.LANGUAGE_AL_LOGHA_AL_3ARABIYAH:
			Return SETTING_LANG_AL_LOGHA_AL_3ARABIYAH
		Case m_dtRepository.LANGUAGE_RUSSKIY:
			Return SETTING_LANG_RUSSKIY
		Case m_dtRepository.LANGUAGE_BAHASA_INDONESIA:
			Return SETTING_LANG_BAHASA_INDONESIA
		Case Else, Case m_dtRepository.DEFAULT_LANGUAGE:
			Return SETTING_LANG_ENGLISH
	End Select
End Sub

Public Sub GetLanguageCode() As String
	Return m_dtRepository.GetLanguage()
End Sub

Public Sub IsTaskCompetionSoundEnabled() As Boolean
	Return m_dtRepository.IsTaskCompetionSoundEnabled()
End Sub

Public Sub Is24HourFormatEnabled() As Boolean
	Return m_dtRepository.Is24HourFormatEnabled()
End Sub

Public Sub LoadDefaults()
	m_dtRepository.LoadDefaults()
End Sub

Public Sub SetDebugMode(value As Boolean)
	m_dtRepository.SetDebugMode(value)
End Sub

Public Sub SetDetailedDueDate(value As Boolean)
	m_dtRepository.SetDetailedDueDate(value)
End Sub

Public Sub SetDarkMode(value As Boolean)
	m_dtRepository.SetDarkMode(value)
End Sub

Public Sub SetExperimentalMode(value As Boolean)
	m_dtRepository.SetExperimentalMode(value)
End Sub

Public Sub SetLanguage(value As String)
	Select value:
		Case SETTING_LANG_ENGLISH:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_ENGLISH)
		Case SETTING_LANG_TAGALOG:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_TAGALOG)
		Case SETTING_LANG_KAPAMPANGAN:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_KAPAMPANGAN)
		Case SETTING_LANG_ESPANOL:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_ESPANOL)
		Case SETTING_LANG_HANYU:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_HANYU)
		Case SETTING_LANG_RUSSKIY:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_RUSSKIY)
		Case SETTING_LANG_AL_LOGHA_AL_3ARABIYAH:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_AL_LOGHA_AL_3ARABIYAH)
		Case SETTING_LANG_BAHASA_INDONESIA:
			m_dtRepository.SetLanguage(m_dtRepository.LANGUAGE_BAHASA_INDONESIA)
	End Select
End Sub

Public Sub SetTaskCompletionSound(value As Boolean)
	m_dtRepository.SetTaskCompletionSound(value)
End Sub

Public Sub Set24HourFormat(value As Boolean)
	m_dtRepository.Set24HourFormat(value)
End Sub