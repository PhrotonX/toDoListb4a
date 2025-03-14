B4A=true
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
	
	' @TODO: Add code for saving...
	
	' Close the activity after saving
	Activity.Finish
End Sub

Private Sub btnPriorityClear_Click
	
End Sub

Private Sub btnCancel_Click
	' Add the current editor result into the instance state.
	Starter.InstanceState.Put(Starter.EDITOR_RESULT, Starter.EXTRA_EDITOR_RESULT_CANCEL)
	
	' @TODO: Add code for saving...
	
	' Close the activity after saving
	Activity.Finish
End Sub