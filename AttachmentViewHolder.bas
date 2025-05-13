B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	' Holds the root view
	Public Root As B4XView
	
	' Holds the ID taken from the database.
	Public ID As Long
	
	' Holds the panel of the item
	Public ItemPanel As Panel
	
	' Holds the icon of the item
	'Public Icon As ImageView
	
	' Holds the filename label of the item
	Public AttachmentLabel As Label
	
	' Holds the open button of the item.
	Public OpenButton As Button
	
	' Holds the delete button of the item.
	Public DeleteButton As Button
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub