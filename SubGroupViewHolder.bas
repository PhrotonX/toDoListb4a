B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private m_xui As XUI
	
	Public Root As B4XView
	Public Name As Label
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(xuiObj As XUI)
	m_xui = xuiObj
	
	Root = m_xui.CreatePanel("")
	Root.SetLayoutAnimated(200, 0, 0, 100%x, 60dip)
	
	Name.Initialize(Starter.Lang.Get("unknown"))
	Name.TextSize = 18
	Name.TextColor = Colors.Black
End Sub

Public Sub BuildView As B4XView
	Root.AddView(Name, 5dip, 5dip, 100%x, 20dip)
	
	Return Root
End Sub