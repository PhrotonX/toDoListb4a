﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private editNotes As EditText
	Private editTitle As EditText
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("EditorLayout")
	
	Dim mode As String
	
	' Retrieve the data to check the editor mode.
	mode = Starter.InstanceState.Get(Starter.EDITOR_MODE)
	
	' Check the editor mode to set the appropriate EditorActivity functionalities.
	If mode == Starter.EXTRA_EDITOR_CREATE Then
		MsgboxAsync("Current editor mode is create mode." & CRLF & _
		 mode , "Alert")
	Else If mode == Starter.EXTRA_EDITOR_EDIT Then
		MsgboxAsync("Current editor mode is edit mode." & CRLF & _
		 mode , "Alert")
	End If
	
	' Remove the key into the bundle to avoid some potential application state-related bugs.
	Starter.InstanceState.Remove(Starter.EDITOR_MODE)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub btnSave_Click
	' Add the current editor result into the instance state.
	Starter.InstanceState.Put(Starter.EDITOR_RESULT, Starter.EXTRA_EDITOR_RESULT_SAVE)
	
	
	
	' Close the activity after saving
	Activity.Finish
End Sub

Private Sub btnPriorityClear_Click
	
End Sub

Private Sub btnCancel_Click
	' Add the current editor result into the instance state.
	Starter.InstanceState.Put(Starter.EDITOR_RESULT, Starter.EXTRA_EDITOR_RESULT_CANCEL)
	
	' @TODO: Add code for cancelling...
	
	' Close the activity after cancelling
	Activity.Finish
End Sub

Private Sub checkRepeatWed_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub checkRepeatTue_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub checkRepeatThu_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub checkRepeatSun_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub checkRepeatSat_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub checkRepeatMon_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub checkRepeatFri_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub radioPriorityMedium_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub radioPriorityLow_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub radioPriorityHigh_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub radioPriorityCritical_CheckedChange(Checked As Boolean)
	
End Sub