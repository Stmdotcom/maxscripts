-- Link set of nodes to another set

 fn echo msg =
(
	format "%\n" (msg) to:listener
)

(
	local childenNodes = #("Dummy002","Dummy001")
	local parentNodes = #("Box002","Box001")

	
	local arrayPos = 1
	for childName in childenNodes do (
		childNode = getNodeByName childName
		if childNode != undefined then (
			childNode.parent = getNodeByName parentNodes[arrayPos]
			
			echo ("Attached " + (childName as string) + " to " + (parentNodes[arrayPos] as string))
		) else (
			echo ("!!Could not find node with name...!! " + (childName as string))
		)
		arrayPos = arrayPos + 1
	)
)