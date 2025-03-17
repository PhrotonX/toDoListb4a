B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Public Enabled As Boolean(7)
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	For Each status As Boolean In Enabled
		status = False
	Next
End Sub

Public Sub SetRepeat(day As Int, value as Enabled