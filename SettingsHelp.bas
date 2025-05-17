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
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	Activity.LoadLayout("settingshelp")
	svHelp.Panel.LoadLayout("helpItems")
	button_design

	OnLoadText
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

Sub button_design
	Dim transparentBg As ColorDrawable
	transparentBg.Initialize(Colors.Transparent, 0)
	helpBack.Background = transparentBg
	
	
	Dim c As Canvas
	c.Initialize(helpLabel)
	Dim borderColor As Int = Colors.RGB(209, 209, 209)
	Dim borderHeight As Int = 1dip

	
	c.DrawLine(0, helpLabel.Height - borderHeight / 2, helpLabel.Width, helpLabel.Height - borderHeight / 2, borderColor, borderHeight)

	helpLabel.Invalidate
End Sub

Sub helpBack_Click
	Activity.Finish
End Sub