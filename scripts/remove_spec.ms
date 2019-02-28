-- Very simple script to remove all specular levels from scene materials

 fn echo msg =
(
	format "%\n" (msg) to:listener
)

fn clearSpecular workingMaterial = 
(
	workingMaterial.specularLevel = 0
)

fn clearGloss workingMaterial = 
(
	workingMaterial.glossiness = 0
)


for workingMaterial in scenematerials do
(
	echo ("Processing Material " + (workingMaterial as string))
	
	if classof(workingMaterial) == Multimaterial do
	(
		echo ("Material count? " + (workingMaterial.materialList.count as string))
			
		for i = 1 to (workingMaterial.materialList.count) do
		(
			if classof(workingMaterial.materialList[i]) == StandardMaterial do
			(
				clearGloss workingMaterial.materialList[i]
				clearSpecular workingMaterial.materialList[i]
			)
		)
	)
	
	if classof(workingMaterial) == StandardMaterial do
	(
		clearGloss workingMaterial
		clearSpecular workingMaterial
	)
)