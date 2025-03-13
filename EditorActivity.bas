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
	
	If Activity.GetStartingIntent.Action = "com.cm.todolist.EXTRA_CREATE" Then
		MsgboxAsync("Extra Received: " & CRLF & _
		 "com.cm.todolist.EXTRA_CREATE" , "Alert")
	End If
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub btnSave_Click
	
End Sub

Private Sub btnPriorityClear_Click
	
End Sub

Private Sub btnCancel_Click
	
End Sub