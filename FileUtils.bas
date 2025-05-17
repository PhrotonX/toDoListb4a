B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.1
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

'Sub GetFileInfoByIndex(column As String, uri As String) As String
'	
'	Dim results As String
'	Dim Cur As Cursor
'	Dim Uri1 As Uri
'	Dim cr As ContentResolver
'	cr.Initialize("")

'	'if viewing by gallery
'	If uri.StartsWith("content://media/") Then
'		Dim i As Int = uri.LastIndexOf("/")
'		Dim id As String = uri.SubString(i + 1)
'		Uri1.Parse(uri)
'		Cur = cr.Query(Uri1, Null, "_id = ?", Array As String(id), Null)
'		Cur.Position = 0
'		If Cur.RowCount <> 0 Then
''			For i = 0 To Cur.ColumnCount - 1
'				If Cur.GetColumnName(i) <> Null Then
'					If Cur.GetColumnName(i) = column Then
'						results = Cur.GetString2(i)
'						Exit
'					End If
'				End If
'			Next
'		End If
'	Else
'		Uri1.Parse(uri)
'		Cur = cr.Query(Uri1, Null, Null, Null, Null)
'		Cur.Position = 0
'		If Cur.RowCount <> 0 Then
'			For i = 0 To Cur.ColumnCount - 1
'				If Cur.GetColumnName(i) <> Null Then
'					If Cur.GetColumnName(i) = column Then
'						results = Cur.GetString2(i)
'						Exit
'					End If
'				End If
'			Next
'		End If
'	End If
'	
'	Cur.Close
'	
'	Return results
'	
'End Sub