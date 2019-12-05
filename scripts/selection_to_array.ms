-- Dump selected nodes as a MaxScript Array nodes to another set

 fn echo msg =
(
	format "%\n" (msg) to:listener
)

(
	objs = selection as array
	objsNames = #()
	
	for obj in objs do (	
		objsNames = append objsNames obj.name
	)
	
	echo (objsNames as string)
)