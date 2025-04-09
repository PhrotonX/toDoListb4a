B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Public Const DIRECTORY As String = "ContentDir"	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

' Copies file based on FIleUriinto the application's internal storage.
Public Sub CopyFileFromUriToInternal(FileName As String, Dir As String, FileUri As String)
	Try
		Dim input As InputStream = File.OpenInput(Dir, FileUri)
		Dim output As OutputStream = File.OpenOutput(File.DirInternal, FileName, False)
		File.Copy2(input, output)
		input.Close
		output.Close
	Catch
		Log(LastException)
	End Try
End Sub

Public Sub GetCursorFromUri(FileUri As String) As Cursor
	' Parse the filename which is a content:// uri.
	Dim uriObj As Uri
	uriObj.Parse(FileUri)
	
	Try
		' Create a content resolver that helps in querying the file information.
		Dim resolver As ContentResolver
		resolver.Initialize("")
		
		Dim cur As Cursor = resolver.Query(uriObj, Null, Null, Null, Null)
	Catch
		Log(LastException)
	End Try
	
	Return cur
End Sub

' Removes file from File.DirInternal
' Returns true if succeeded.
Public Sub RemoveFile(FileName As String) As Boolean
	Return File.Delete(File.DirInternal, FileName)
End Sub