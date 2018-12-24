-- Simple script to remove all specular and gloss levels from all standard scene materials

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
	if classof(workingMaterial) == Multimaterial do
	(	
		for i = 1 to (workingMaterial.materialList.count) do
		(
			if classof(workingMaterial.materialList[i]) == StandardMaterial do
			(
                echo ("Processing Multi-Material " + (workingMaterial.materialList[i] as string))
				clearGloss workingMaterial.materialList[i]
				clearSpecular workingMaterial.materialList[i]
			)
		)
	)
	
	if classof(workingMaterial) == StandardMaterial do
	(
        echo ("Processing Material " + (workingMaterial as string))
		clearGloss workingMaterial
		clearSpecular workingMaterial
	)
)