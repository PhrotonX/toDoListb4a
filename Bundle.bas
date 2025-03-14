B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	' Global DataMap to mimic Android's Bundles for Intents in Java/Kotlin.
	Private DataMap As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	' Initialize the DataMap
	DataMap.Initialize
End Sub

' Encapsulates Map.Put() function
Public Sub Put(key As Object, value As Object)
	' Check if the Map already has the existing key to avoid duplicate data.
	If DataMap.ContainsKey(key) Then
		DataMap.key
	Else
		DataMap.Put(key, value)
	End If
End Sub

' Encapsulates Map.Get() function
Public Sub Get(key As Object) As Object
	If DataMap.ContainsKey(key) Then
		Return DataMap.Get(key)
	Else
		MsgboxAsync("Key " & key & " not found on DataMap", "Fatal error")
		
		Return Null
		
		ExitApplication
	End If
	
End Sub

' Returns the DataMap instance.
Public Sub GetMap As Map
	Return DataMap
End Sub