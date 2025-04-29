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
End Sub

Sub Globals
	Private tiles(7) As Panel
	Private icons(7) As Panel
	Private selectedTileIndex As Int = -1
	Private selectedIconsIndex As Int = -1
	Private pnlColorBlue As Panel
	Private pnlColorGreen As Panel
	Private pnlColorIndigo As Panel
	Private pnlColorOrange As Panel
	Private pnlColorRed As Panel
	Private pnlColorPink As Panel
	Private pnlColorYellow As Panel
	Private svAddGrpBody As ScrollView
	Private pnlAddGrpBody As Panel
	Private pnlIcon1 As Panel
	Private pnlIcon2 As Panel
	Private pnlIcon3 As Panel
	Private pnlIcon4 As Panel
	Private pnlIcon5 As Panel
	Private pnlIcon6 As Panel
	Private pnlIcon7 As Panel
	
	Private pnlAddGrpBar As Panel
	Private btnAddGrpCancel As Button
	Private btnAddGrpSave As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("groupTasksLayout")
	svAddGrpBody.Panel.LoadLayout("groupTasksSVLayout")
	pnlAddGrpBar.Elevation = 10

	' Assign panels and tags (color names)
	tiles(0) = pnlColorRed : tiles(0).Tag = "RED"
	tiles(1) = pnlColorOrange : tiles(1).Tag = "ORANGE"
	tiles(2) = pnlColorYellow : tiles(2).Tag = "YELLOW"
	tiles(3) = pnlColorGreen : tiles(3).Tag = "GREEN"
	tiles(4) = pnlColorBlue : tiles(4).Tag = "BLUE"
	tiles(5) = pnlColorIndigo : tiles(5).Tag = "INDIGO"
	tiles(6) = pnlColorPink : tiles(6).Tag = "PINK"
	
	icons(0) = pnlIcon1 : icons(0).Tag = "icon0"
	icons(1) = pnlIcon2 : icons(1).Tag = "icon1"
	icons(2) = pnlIcon3 : icons(2).Tag = "icon2"
	icons(3) = pnlIcon4 : icons(3).Tag = "icon3"
	icons(4) = pnlIcon5 : icons(4).Tag = "icon4"
	icons(5) = pnlIcon6 : icons(5).Tag = "icon5"
	icons(6) = pnlIcon7 : icons(6).Tag = "icon6"
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Sub btnAddGrpCancel_Click
	Activity.Finish
End Sub

Sub btnAddGrpSave_Click
	Activity.Finish
End Sub


Sub pnlColor_Click
	Dim pnl As Panel = Sender


	Dim clickedIndex As Int = -1
	For i = 0 To tiles.Length - 1
		If tiles(i) = pnl Then
			clickedIndex = i
			Exit
		End If
	Next

	If clickedIndex = -1 Then Return 


	If selectedTileIndex = clickedIndex Then Return


	If selectedTileIndex > -1 Then
		UpdateTileImage(tiles(selectedTileIndex), False)
	End If


	selectedTileIndex = clickedIndex
	UpdateTileImage(pnl, True)


	Log("Selected index: " & clickedIndex) '0 = red, 1 = orange, 2 = yellow, 3 = green, 4 = blue, 5 = indigo, 6 = pink
	
End Sub


Sub UpdateTileImage(pnl As Panel, isSelected As Boolean)
	Dim colorName As String = pnl.Tag
	Dim imageName As String
	If isSelected Then
		imageName = colorName & "-SELECTED.png"
	Else
		imageName = colorName & ".png"
	End If


	Dim iv As ImageView = GetImageViewFromPanel(pnl)
	If iv.IsInitialized Then
		iv.Bitmap = LoadBitmap(File.DirAssets, imageName)
	End If
End Sub


Sub GetImageViewFromPanel(pnl As Panel) As ImageView
	For i = 0 To pnl.NumberOfViews - 1
		If pnl.GetView(i) Is ImageView Then
			Return pnl.GetView(i)
		End If
	Next
	Return Null
End Sub

Sub pnlicon_Click
	Dim pnl As Panel = Sender

	Dim clickedIndex As Int = -1
	For i = 0 To icons.Length - 1
		If icons(i) = pnl Then
			clickedIndex = i
			Exit
		End If
	Next

	If clickedIndex = -1 Then Return

	' If same as currently selected, do nothing
	If selectedIconsIndex = clickedIndex Then Return

	' Reset previous panel's color
	If selectedIconsIndex > -1 Then
		Dim previousPanel As Panel = icons(selectedIconsIndex)
		previousPanel.Color = Colors.Transparent
	End If

	' Highlight current panel
	pnl.Color = Colors.LightGray
	selectedIconsIndex = clickedIndex

	Log("Selected index: " & clickedIndex)
End Sub
