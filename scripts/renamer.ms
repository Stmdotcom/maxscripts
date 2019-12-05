-- Rename a set of nodes

 fn echo msg =
(
	format "%\n" (msg) to:listener
)

(
	local sourceNodeNames = #("aa","bb","cc")
	local replacementNodeNames = #("aaa","cc","bbb")
	local duplicateStopper = "ff_"
	
	local arrayPos = 1
	for sourceName in sourceNodeNames do (
		childNode = getNodeByName sourceName
		if childNode != undefined then (
			childNode.name = duplicateStopper + replacementNodeNames[arrayPos] as string
			
			echo ("Renamed " + (sourceName as string) + " to " + duplicateStopper + (replacementNodeNames[arrayPos] as string))
		) else (
			echo ("!!Could not find node with name...!! " + (sourceName as string))
		)
		
		arrayPos = arrayPos + 1
	)


	local objs  = Execute("$" + duplicateStopper + "* as array")
	
	for obj in objs do (
		obj.name = trimLeft obj.name duplicateStopper as string

		echo ("Trimmed off " + (duplicateStopper as string) + " Now " + (obj.name as string))
	)
)
