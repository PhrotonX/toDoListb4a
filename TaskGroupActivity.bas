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
	Public LastSavedGroup As Group
End Sub

Sub Globals
	Private m_group As Group
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
	Private editAddGrpTitle As EditText
	Private editNotes As EditText
	Private icon1 As Label
	Private icon2 As Label
	Private icon3 As Label
	Private icon4 As Label
	Private icon5 As Label
	Private icon6 As Label
	Private icon7 As Label
	Private ivBlue As ImageView
	Private ivGreen As ImageView
	Private ivIndigo As ImageView
	Private ivOrange As ImageView
	Private ivPink As ImageView
	Private ivRed As ImageView
	Private ivYellow As ImageView
	Private lblColor As Label
	Private lblCreatedAt As Label
	Private lblUpdatedAt As Label
	Private btnAddGrpCancel As Button
	Private btnAddGrpSave As Button
	Private lblAddGrp As Label
	
	Private pnlAddGrpBar As Panel
	Private btnAddGrpCancel As Button
	Private btnAddGrpSave As Button
	Private btnGrpDelete As Button
	Private lblIcons As Label
	Private lblNotes As Label
	Private lblTitle As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("groupTasksLayout")
	svAddGrpBody.Panel.LoadLayout("groupTasksSVLayout")
	pnlAddGrpBar.Elevation = 10

	OnLoadText

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
	
	Dim cd As ColorDrawable
	cd.Initialize(Colors.Transparent, 0)
	editAddGrpTitle.background = cd
	editNotes.Background = cd
	
	' Create the group object.
	Select Starter.InstanceState.Get(Starter.EXTRA_TASK_GROUP_EDITOR_MODE):
		Case Starter.TASK_GROUP_EDITOR_MODE_CREATE:
			lblAddGrp.Text = Starter.Lang.Get("new_group")

			If m_group.IsInitialized == False Then
				' Initialize the group object.
				m_group.Initialize(0)
				
				' Set the default indigo color.
				m_group.SetColor(Theme.COLOR_INDIGO)
				UpdateTileImage(tiles(Theme.COLOR_INDIGO), True)
				
				' Hide the delete button if the page is in creating mode.
				btnGrpDelete.Visible = False
				
				' Hide certain elements if the page is in creating mode.
				lblCreatedAt.Visible = False
				lblUpdatedAt.Visible = False
			End If
			
		Case Starter.TASK_GROUP_EDITOR_MODE_EDIT:
			Main.SavedSmartList = Main.SMART_LIST_NONE
			
			If m_group.IsInitialized == False Then
				' Retrieve the group.
				m_group = Starter.GroupViewModelInstance.GetGroup(Starter.InstanceState.Get(Starter.EXTRA_EDITOR_GROUP_ID))
				
				' Change the title
				lblAddGrp.Text = Starter.Lang.Get("edit_group")
			End If
			
		Case Else:
			MsgboxAsync(Starter.Lang.Get("error_opening_task_group_editor"), Starter.Lang.Get("error"))
			OnCloseActivity
	End Select
End Sub

Sub Activity_Resume
	' Turn color brown option into yellow if dark mode is enabled.
	If Starter.SettingsViewModelInstance.IsDarkModeEnabled Then
		tiles(Theme.COLOR_BROWN).Tag = "YELLOW"
	Else
		tiles(Theme.COLOR_BROWN).Tag = "BROWN"
	End If
	UpdateTileImage(tiles(Theme.COLOR_BROWN), False)
	
	Log(Starter.InstanceState.Get(Starter.EXTRA_TASK_GROUP_EDITOR_MODE))

	' Load title and notes.
	editAddGrpTitle.Text = m_group.GetTitle()
	editNotes.Text = m_group.GetDescription()
	
	' Load the default color.
	UpdateTileImage(tiles(m_group.GetColor()), True)
	
	Log("Load: m_group.GetIconPos: " & m_group.GetIconPos)
	
	' Mark the loaded group icon as selected.
	icons(OnLoadGroupIcon(m_group.GetIconPos)).Color = Colors.LightGray
	
	lblCreatedAt.Text = Starter.Lang.Get("created_at") & ": " & m_group.CreatedAt.GetFormattedDateAndTime( _
		Starter.SettingsViewModelInstance.Is24HourFormatEnabled)
	lblUpdatedAt.Text = Starter.Lang.Get("updated_at") & ": " & m_group.UpdatedAt.GetFormattedDateAndTime( _
		Starter.SettingsViewModelInstance.Is24HourFormatEnabled)

	Log("TaskGroupActivity.Activity_Resume Color" & m_group.GetColor)
	Log("TaskGroupActivity.Activity_Resume Icon" & m_group.GetIcon)

End Sub

Sub Activity_Pause (UserClosed As Boolean)
	OnSaveGroup
End Sub

Private Sub OnLoadText
	lblTitle.Text = Starter.Lang.Get("title") & "*"
	lblNotes.Text = Starter.Lang.Get("notes")
	lblIcons.Text = Starter.Lang.Get("icon")
	lblColor.Text = Starter.Lang.Get("color")
	btnAddGrpSave.Text = Starter.Lang.Get("save_uppercase")
	editAddGrpTitle.Hint = Starter.Lang.Get("title_hint")
	editNotes.Hint = Starter.Lang.Get("notes_hint")
End Sub

Sub btnAddGrpCancel_Click
	Select Starter.InstanceState.Get(Starter.EXTRA_TASK_GROUP_EDITOR_MODE):
		Case Starter.TASK_GROUP_EDITOR_MODE_EDIT:
			LastSavedGroup = m_group
		Case Else:
			' Do nothing.
	End Select
		
	ToastMessageShow(Starter.Lang.Get("editing_cancelled"), False)
		
	OnCloseActivity
End Sub

Sub btnAddGrpSave_Click
	
	' Validation
	If editAddGrpTitle.Text == "" Then
		MsgboxAsync(Starter.Lang.Get("validation_error_title_empty"), Starter.Lang.Get("error"))
		Return
	End If
	
	If editAddGrpTitle.Text.Length > 50 Then
		MsgboxAsync(Starter.Lang.Get("validation_error_title_50"), Starter.Lang.Get("error"))
		Return
	End If
	
	Select Starter.InstanceState.Get(Starter.EXTRA_TASK_GROUP_EDITOR_MODE):
		Case Starter.TASK_GROUP_EDITOR_MODE_EDIT:
			If Starter.GroupViewModelInstance.CheckForDuplicateOnUpdate(editAddGrpTitle.Text) == True Then
				MsgboxAsync(Starter.Lang.Get("validation_error_title_duplicate"), Starter.Lang.Get("error"))
				Return
			End If
		Case Starter.TASK_GROUP_EDITOR_MODE_CREATE:
			If Starter.GroupViewModelInstance.CheckForDuplicateOnInsert(editAddGrpTitle.Text) == True Then
				MsgboxAsync(Starter.Lang.Get("validation_error_title_duplicate"), Starter.Lang.Get("error"))
				Return
			End If
		Case Else:
			MsgboxAsync(Starter.Lang.Get("validation_failed"), Starter.Lang.Get("error"))
			Return
	End Select
	
	If editNotes.Text.Length > 255 Then
		MsgboxAsync(Starter.Lang.Get("validation_error_notes_255"), Starter.Lang.Get("error"))
		Return
	End If
	
	If m_group.GetColor > 7 Then
		MsgboxAsync(Starter.Lang.Get("validation_error_color") & CRLF & "Color code: " & m_group.GetColor , Starter.Lang.Get("error"))
		Return
	End If
	
	If m_group.GetIconPos > 7 Then
		MsgboxAsync(Starter.Lang.Get("validation_error_icon") & CRLF & "Icon code: " & m_group.GetIconPos, Starter.Lang.Get("error"))
		Return
	End If
	
	OnSaveGroup
	
	' Save the group, depending if the editor mode is creating or editing a task.
	Try
		Select Starter.InstanceState.Get(Starter.EXTRA_TASK_GROUP_EDITOR_MODE):
			Case Starter.TASK_GROUP_EDITOR_MODE_CREATE:
				Starter.GroupViewModelInstance.InsertGroup(m_group)
			Case Starter.TASK_GROUP_EDITOR_MODE_EDIT:
				Starter.GroupViewModelInstance.UpdateGroup(m_group)
		End Select
		
		ToastMessageShow(Starter.Lang.Get("task_group_saved_successfully") & ": " & m_group.GetTitle, True)
		
		LastSavedGroup = m_group
		
		OnCloseActivity
	Catch
		ToastMessageShow(Starter.Lang.Get("failed_to_save_task_group") & ": " & m_group.GetTitle, True)
		
		Log(LastException)
	End Try
End Sub


Sub pnlColor_Click
	Dim pnl As Panel = Sender


	Dim clickedIndex As Int = -1
	For i = 0 To tiles.Length - 1
		If tiles(i) = pnl Then
			clickedIndex = i
			
			m_group.SetColor(clickedIndex)
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


	'Log("Selected index: " & clickedIndex) '0 = red, 1 = orange, 2 = yellow, 3 = green, 4 = blue, 5 = indigo, 6 = pink
	
	' Update the color value of the m_group variable.
	m_group.SetColor(clickedIndex)
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

Private Sub OnCloseActivity
	Activity.Finish
End Sub

' Returns the index of the icon data.
Private Sub OnLoadGroupIcon(icon As Int) As Int
	Dim itr As Int = 0
	
	For Each item As Panel In icons
		If itr == icon Then
			item.Color = Colors.LightGray
			Return itr
		End If
		
		'ToastMessageShow("Selected Icon Index: " & icon, False)
		
		itr = itr + 1
	Next
	
	MsgboxAsync(Starter.Lang.Get("failed_to_retrieve_group_icon") & ": " & itr, Starter.Lang.Get("error"))
	
	Return 0
End Sub

Public Sub OnSaveGroup
	' Set the title and description.
	m_group.SetTitle(editAddGrpTitle.Text)
	m_group.SetDescription(editNotes.Text)
	
	' Colors and icons are already set by pnlColor_Click and pnlIcon_Click events.
End Sub

Sub pnlicon_Click
	Dim pnl As Panel = Sender

	Dim clickedIndex As Int = -1
	For i = 0 To icons.Length - 1
		If icons(i) = pnl Then
			clickedIndex = i
			Dim currentText As Label = pnl.GetView(0)
			Log("View of i = " & i & ": " & currentText.Text)
			
			m_group.SetIconPos(i)
			
			Log("Save: m_group.GetIconPos(): " & m_group.GetIconPos)
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

	'Log("Selected index: " & clickedIndex)

	
	
End Sub

Private Sub btnGrpDelete_Click
	Msgbox2Async(Starter.Lang.Get("task_group_delete_question"), Starter.Lang.Get("question"), _ 
		Starter.Lang.Get("yes"), Starter.Lang.Get("cancel"), Starter.Lang.Get("no"), Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.POSITIVE Then
		Try
			Starter.GroupViewModelInstance.DeleteGroup(m_group.GetID)
			ToastMessageShow(Starter.Lang.Get("task_group_deleted_successfully") & ": " & m_group.GetTitle, True)
			Main.SavedSmartList = Main.SMART_LIST_MY_DAY
			OnCloseActivity
		Catch
			ToastMessageShow(Starter.Lang.Get("failed_to_delete_task_group") & ": " & m_group.GetTitle, True)
			Log(LastException)
		End Try
	End If
End Sub