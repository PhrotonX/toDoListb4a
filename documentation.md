# Documentation Format


## For Functions
```vb
' parameterName - The purpose of the parameter
' parameterName2 - The purpose of the parameter
' return value - The possible value of the function
Public Sub FunctionName(parameterName As Int, parameterName2 As Int) As Boolean
  ' Comments describing each code
End Sub
```

```vb
' a - The first number to be added.
' b - The second number to be added.
' return value - The possible value of the function
Public Sub Sum(a As Int, b As Int) As Boolean
  ' Calculates the sum of variables a and b.
  Dim result As Int = a + b

  ' Returns the resulting sum
  Return result
End Sub
```

## For Classes, Code Modules, Activities, Services, and Receivers
On the top most or the line 1 of the file OR before the #Region code block.
```vb
' Describe the contents, uses, and functionality of the class
```

## For variables
Example:
```vb
Sub Class_Globals
  ' The root view
	Private Root As B4XView
  ' The icon for warnign sign behind a task.
	Private warning As Bitmap
  ' The custom list view instance for the task list.
	Private CLV As CustomListView
  ' The file provider instance used for providing file URIs of specified file.
	Private Provider As FileProvider
End Sub
```
