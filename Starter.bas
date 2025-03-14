B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=9.9
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
	' Global varialbe for the package name that corresponds into Java packages.
	Public Const PACKAGE_NAME As String = "com.cm.todolist"

	' Global DataMap to mimic Android's Bundles for Intents in Java/Kotlin.
	Public InstanceState As Map
	
	' Global variables used for passing extras into EditorActivity.
	Public Const EDITOR_MODE As String = "EDITOR_MODE"
	Public Const EXTRA_EDITOR_EDIT As String = PACKAGE_NAME & ".EXTRA_EDITOR_EDIT"
	Public Const EXTRA_EDITOR_CREATE As String = PACKAGE_NAME & ".EXTRA_EDITOR_CREATE"
	
	' Global variables used for passing extras as a result of EditorActivity.
	Public Const EDITOR_RESULT As String = "EDITOR_RESULT"
	Public Const EXTRA_EDITOR_RESULT_SAVE As String = PACKAGE_NAME & ".EXTRA_EDITOR_RESULT_SAVE"
	Public Const EXTRA_EDITOR_RESULT_CANCEL As String = PACKAGE_NAME & ".EXTRA_EDITOR_RESULT_CANCEL"
End Sub

Sub Service_Create
	'This is the program entry point.
	'This is a good place to load resources that are not specific to a single activity.

	InstanceState.Initialize
End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground 'Starter service can start in the foreground state in some edge cases.
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy

End Sub
