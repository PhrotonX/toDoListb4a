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
	Private aboutBack As Button

	Private svAbout As ScrollView
	Private aboutLabel As Label
	Private aboutContact As Label
	Private aboutDev As Label
	Private aboutWhat As Label
	Private membersLbl As Label
	Private paraContact As Label
	Private paraDev As Label
	Private paraWhat As Label
	Private lblAppTitle As Label
	Private leaderLbl As Label
	Private name1Lbl As Label
	Private name2Lbl As Label
	Private name3Lbl As Label
	Private name4Lbl As Label
	Private name5Lbl As Label
	Private imgAppIcon As ImageView
	Private Panel1 As Panel
	Private pnlContact As Panel
	Private pnlWhat As Panel
	Private pnlAbout As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	
	Activity.LoadLayout("settingsabout")
	svAbout.Panel.LoadLayout("aboutItems")
	CenterView(Activity)
	
	OnLoadText
End Sub

Sub Activity_Resume
	Darkmode
End Sub

Sub aboutBack_Click
	Activity.Finish
End Sub

Private Sub Darkmode
	If Starter.SettingsViewModelInstance.IsDarkModeEnabled() = False Then
		aboutWhat.TextColor = Colors.Black
		paraWhat.TextColor = Colors.Black
		aboutContact.TextColor = Colors.Black
		paraContact.TextColor = Colors.Black
		aboutDev.TextColor = Colors.Black
		paraDev.TextColor = Colors.Black
		lblAppTitle.TextColor = Colors.Black
		leaderLbl.TextColor = Colors.Black
		name1Lbl.TextColor = Colors.Black
		membersLbl.TextColor = Colors.Black
		name2Lbl.TextColor = Colors.Black
		name3Lbl.TextColor = Colors.Black
		name4Lbl.TextColor = Colors.Black
		name5Lbl.TextColor = Colors.Black
	
		pnlWhat.Color = Colors.White
		pnlContact.Color = Colors.White
		Panel1.Color = Colors.White
	
		svAbout.Color = Colors.RGB(241,241,241)

		pnlAbout.Color = Colors.RGB(241,241,241)
		aboutLabel.TextColor = Colors.Black
		aboutBack.TextColor = Colors.RGB(67,67,67)
	Else
		aboutWhat.TextColor = Theme.ForegroundText
		paraWhat.TextColor = Theme.ForegroundText
		aboutContact.TextColor = Theme.ForegroundText
		paraContact.TextColor = Theme.ForegroundText
		aboutDev.TextColor = Theme.ForegroundText
		paraDev.TextColor = Theme.ForegroundText
		lblAppTitle.TextColor = Theme.ForegroundText
		leaderLbl.TextColor = Theme.ForegroundText
		name1Lbl.TextColor = Theme.ForegroundText
		membersLbl.TextColor = Theme.ForegroundText
		name2Lbl.TextColor = Theme.ForegroundText
		name3Lbl.TextColor = Theme.ForegroundText
		name4Lbl.TextColor = Theme.ForegroundText
		name5Lbl.TextColor = Theme.ForegroundText
	
		pnlWhat.Color = Theme.RootColor
		pnlContact.Color = Theme.RootColor
		Panel1.Color = Theme.RootColor
	
		svAbout.Color = Theme.DarkbackgroundColor

		pnlAbout.Color = Colors.RGB(28,28,28)
		aboutLabel.TextColor = Theme.ForegroundText
		aboutBack.TextColor = Theme.ForegroundText
	End If
	
End Sub

Private Sub OnLoadText
	aboutLabel.Text = Starter.Lang.Get("about")
	aboutWhat.Text = Starter.Lang.Get("about_what")
	aboutContact.Text = Starter.Lang.Get("faq")
	aboutDev.Text = Starter.Lang.Get("about_dev")
	paraWhat.Text = Starter.Lang.Get("paragraph_what")
	paraContact.Text = Starter.Lang.Get("paragraph_faq")
	paraDev.Text = Starter.Lang.Get("para_dev")
	lblAppTitle.Text = Starter.Lang.Get("app_title")
	membersLbl.Text = Starter.Lang.Get("members")
End Sub

Sub CenterView(parent As Panel)
	imgAppIcon.Left = (parent.Width - imgAppIcon.Width) / 2
	lblAppTitle.Left = (parent.Width - lblAppTitle.Width) / 2
	'view.Top = (parent.Height - view.Height) / 2
End Sub
