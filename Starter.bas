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
	
	' Global variable for the package name that corresponds into Java packages.
	' It is a common practice to include the package name into the EXTRAS.
	Public Const PACKAGE_NAME As String = "com.cm.todolist"

	' Global map to mimic Android's Bundles for Intents in Java/Kotlin in which
	' a string or the name of extra is used as the key of the key and value pair.
	Public InstanceState As Map
	
	' Global variables used for passing extras into EditorActivity.
	Public Const EXTRA_EDITOR_MODE As String = "EXTRA_EDITOR_MODE"
	Public Const EDITOR_MODE_EDIT As String = PACKAGE_NAME & ".EDITOR_MODE_EDIT"
	Public Const EDITOR_MODE_CREATE As String = PACKAGE_NAME & ".EDITOR_MODE_CREATE"
	
	' Global variables used for passing extras as a result of EditorActivity.
	Public Const EXTRA_EDITOR_RESULT As String = "EXTRA_EDITOR_RESULT"
	Public Const EDITOR_RESULT_SAVE As String = PACKAGE_NAME & ".EDITOR_RESULT_SAVE"
	Public Const EDITOR_RESULT_CANCEL As String = PACKAGE_NAME & ".EDITOR_RESULT_CANCEL"
	
	' Global variable used for identifying the current item of concern.
	Public Const EXTRA_EDITOR_TASK_ID As String = PACKAGE_NAME & ".EXTRA_EDITOR_TASK_ID"
	Public Const EXTRA_EDITOR_GROUP_ID As String = PACKAGE_NAME & ".EXTRA_EDITOR_GROUP_ID"
	
	'Public ToDoDatabaseInstance As ToDoDatabase
	Public ToDoDatabaseViewModelInstance As ToDoDatabaseViewModel
	Private ToDoFileSystemInstance As ToDoFileSystem
	Private taskRepo As TaskRepository
	Private attachmentRepo As AttachmentRepository
	Private attachmentFileRepo As AttachmentFileRepository
	Private groupRepo As GroupRepository
	
	' Global instance of TaskViewModel where the database can be accessed.
	Public TaskViewModelInstance As TaskViewModel
	Public AttachmentViewModelInstance As AttachmentViewModel
	Public GroupViewModelInstance As GroupViewModel

	Public SettingsViewModelInstance As SettingsViewModel
	
	Public Provider As FileProvider
	Public Permissions As RuntimePermissions
	
End Sub

Sub CheckInstanceState
	' Check for instance states.
	Dim editorResult As String = InstanceState.Get(EXTRA_EDITOR_RESULT)
	
	If editorResult <> Null Then
		' Select statement for error-checking.
		Select editorResult:
			Case Null:
				' Do nothing if no result has been found.
				' Ignore results from SAVE and CANCEL
			Case EDITOR_RESULT_SAVE:
			Case EDITOR_RESULT_CANCEL:
				' Display an error if a result other than SAVE and CANCEL has been received.
			Case Else:
				MsgboxAsync("Invalid result!" & CRLF & _
			InstanceState.Get(EXTRA_EDITOR_RESULT), "Alert!")
		End Select
	
		' Remove the editor result extra from the bundle to avoid application state-related issues.
		InstanceState.Remove(EXTRA_EDITOR_RESULT)
	End If
End Sub

Sub Service_Create
	'This is the program entry point.
	'This is a good place to load resources that are not specific to a single activity.

	' Initialize the variables
	InstanceState.Initialize
	
	ToDoDatabaseViewModelInstance.Initialize
	ToDoFileSystemInstance.Initialize
	
	taskRepo.Initialize(ToDoDatabaseViewModelInstance.GetInstance)
	attachmentRepo.Initialize(ToDoDatabaseViewModelInstance.GetInstance)
	attachmentFileRepo.Initialize(ToDoFileSystemInstance)
	groupRepo.Initialize(ToDoDatabaseViewModelInstance.GetInstance)
	
	TaskViewModelInstance.Initialize(taskRepo)
	AttachmentViewModelInstance.Initialize(attachmentRepo, attachmentFileRepo)
	GroupViewModelInstance.Initialize(groupRepo)
	
	Provider.Initialize

	SettingsViewModelInstance.Initialize()
End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground 'Starter service can start in the foreground state in some edge cases.
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	' Close the database
	ToDoDatabaseViewModelInstance.CloseDatabase
	Return True
End Sub

Sub Service_Destroy
	' Close the database
	ToDoDatabaseViewModelInstance.CloseDatabase
	
	' Close the settings file
	SettingsViewModelInstance.Close()
End Sub
