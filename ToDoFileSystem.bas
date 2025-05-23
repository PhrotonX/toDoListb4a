﻿B4A=true
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
Public Sub CopyFileFromUriToInternal(FileName As String, Dir As String, FileUri As String, Location As String)
	Try
		Dim input As InputStream = File.OpenInput(Dir, FileUri)
		Dim output As OutputStream = File.OpenOutput(Location, FileName, False)
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

' Removes file from external storage
' Returns true if succeeded.
Public Sub RemoveFile(FileName As String, Location As String) As Boolean
	Return File.Delete(Location, FileName)
End Sub

' Removes files from a directory in external storage
' Returns true if succeeded.
Public Sub RemoveFiles(Location As String) As Boolean
	Dim result As Boolean = False
	Try
		For Each item As String In File.ListFiles(Location)
			File.Delete(Location, item)
		Next
		
		result = True
	Catch
		Log(LastException)
	End Try
	
	Return result
End Sub
