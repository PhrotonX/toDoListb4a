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
	Private helpBack As Button
	Private svHelp As ScrollView
	Private helpLabel As Label
	Private paragraphFAQ As Label
	Private paragraphHow As Label
	Private paragraphTrouble As Label
	Private titleFAQ As Label
	Private titleHow As Label
	Private titleTroubleshooting As Label
	Private pnlHelp As Panel
	Private pnlFAQ As Panel
	Private pnlHow As Panel
	Private pnlTrouble As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	Activity.LoadLayout("settingshelp")
	svHelp.Panel.LoadLayout("helpItems")
	
	OnLoadText
End Sub

Sub Activity_Resume
	Darkmode
End Sub

Private Sub OnLoadText
	helpLabel.Text = Starter.Lang.Get("help")
	titleHow.Text = Starter.Lang.Get("title_how")
	titleFAQ.Text = Starter.Lang.Get("faq")
	titleTroubleshooting.Text = Starter.Lang.Get("troubleshooting")
	
	paragraphHow.Text = Starter.Lang.Get("paragraph_how_1") & CRLF & _
						Starter.Lang.Get("paragraph_how_2") & CRLF & _
						Starter.Lang.Get("paragraph_how_3") & CRLF & _
						Starter.Lang.Get("paragraph_how_4")
						
	paragraphFAQ.Text = Starter.Lang.Get("faq_1") & CRLF & _
						Starter.Lang.Get("faq_2") & CRLF & _
						Starter.Lang.Get("faq_3") & CRLF & _
						Starter.Lang.Get("faq_4") & CRLF & _
						Starter.Lang.Get("faq_5")
					
	paragraphTrouble.Text = Starter.Lang.Get("troubleshooting_1") & CRLF & _
							Starter.Lang.Get("troubleshooting_2") & CRLF & _
							Starter.Lang.Get("troubleshooting_3") & CRLF & _
							Starter.Lang.Get("troubleshooting_4")
End Sub



Sub helpBack_Click
	Activity.Finish
End Sub

Private Sub Darkmode
	If Starter.SettingsViewModelInstance.IsDarkModeEnabled() = False Then
		titleHow.TextColor = Colors.Black
		paragraphHow.TextColor = Colors.Black
		paragraphTrouble.TextColor = Colors.Black
		titleTroubleshooting.TextColor = Colors.Black
		titleFAQ.TextColor = Colors.Black
		paragraphFAQ.TextColor = Colors.Black
		
		pnlHow.Color = Colors.White
		pnlTrouble.Color = Colors.White
		pnlFAQ.Color = Colors.White
		
		helpLabel.TextColor = Colors.Black
		helpBack.TextColor = Colors.RGB(67,67,67)
		pnlHelp.Color = Colors.RGB(241,241,241)
		svHelp.Color = Colors.RGB(241,241,241)
	Else
		titleHow.TextColor = Theme.ForegroundText
		paragraphHow.TextColor = Theme.ForegroundText
		paragraphTrouble.TextColor = Theme.ForegroundText
		titleTroubleshooting.TextColor = Theme.ForegroundText
		titleFAQ.TextColor = Theme.ForegroundText
		paragraphFAQ.TextColor = Theme.ForegroundText
		
		pnlHow.Color = Theme.RootColor
		pnlTrouble.Color = Theme.RootColor
		pnlFAQ.Color = Theme.RootColor
		
		helpLabel.TextColor = Theme.ForegroundText
		helpBack.TextColor = Theme.ForegroundText
		pnlHelp.Color = Colors.RGB(28,28,28)
		svHelp.Color = Theme.DarkbackgroundColor
	End If
	
End Sub