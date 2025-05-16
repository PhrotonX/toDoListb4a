B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_settings As SettingsViewModel
	
	Private m_json As JSONParser
	
	Private m_words As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(settingsObj As SettingsViewModel)
	m_settings = settingsObj
	m_words.Initialize
	
	m_json.Initialize(File.ReadString(File.DirAssets, m_settings.GetLanguage & ".json"))
	m_words = m_json.NextObject
End Sub

Public Sub GetWord(property As String) As String
	Return m_words.Get(property)
End Sub