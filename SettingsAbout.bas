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
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	
	Activity.LoadLayout("settingsabout")
	svAbout.Panel.LoadLayout("aboutItems")
	button_design
	
	OnLoadText
End Sub

Sub aboutBack_Click
	Activity.Finish
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

Sub button_design
	Dim transparentBg As ColorDrawable
	transparentBg.Initialize(Colors.Transparent, 0)
	aboutBack.Background = transparentBg
	
	Dim c As Canvas
	c.Initialize(aboutLabel)
	Dim borderColor As Int = Colors.RGB(209, 209, 209)
	Dim borderHeight As Int = 1dip

	
	c.DrawLine(0, aboutLabel.Height - borderHeight / 2, aboutLabel.Width, aboutLabel.Height - borderHeight / 2, borderColor, borderHeight)

	aboutLabel.Invalidate
End Sub
