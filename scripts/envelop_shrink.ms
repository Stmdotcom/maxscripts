-- Srinks and normalises all envelops on selected geometry

-- Config these as needed
global offsetEnvelopStart = [0,0.01,0]
global offsetEnvelopEnd = [0,-0.01,0]
global envelopInnerRadius = 0.005
global envelopOuterRadius = 0.01
global standardQuat = quat 0 0 0 1
global standardScale = quat 0 0 0 1
global bonePosFix = false


 fn echo msg =
(
	format "%\n" (msg) to:listener
)

fn setNodeWorldRotation theNode theRot =
(
	in coordsys (transmatrix theNode.transform.pos)
	theNode.rotation = theRot
	theNode.scale = [1,1,1]
)

fn getBoneFromSkin theSkin boneID=
(
	local boneArray=for o in objects where (refs.dependencyLoopTest theSkin o) collect o
	local boneName=(skinOps.GetBoneName theSkin boneID 1)
	local notFound=true
	local i=0
	while notFound and i<boneArray.count do
	(
		i+=1
		if boneArray[i].name==boneName then
		(			
			notFound=false
		)
	)
	if notFound then 
	(
		undefined 
	)
	else 
	(
		boneArray[i]
	)
)

echo "KILL ENVELOP SCRIPT START"

 for obj in selection do
 (
	chrSkin = obj.modifiers[#Skin]
	chrBoneCount = skinOps.GetNumberBones chrSkin

	if bonePosFix then 
	(
		chrSkin.always_deform = false
	)
	 
	echo ("Start Geo" + (obj.name as string))

	for cBone=1 to chrBoneCount do
	(
		boneName = skinOps.GetBoneName chrSkin cBone 1
		echo ("Processing Bone " + (boneName as string))
		
							
		if bonePosFix then 
		(
			aBone = getBoneFromSkin chrSkin cBone 
			if aBone.rotation != standardQuat then
			(
				echo ("Attempting to Fix Bone" + (boneName as string))
				children = undefined
				if aBone.children.count > 0 then
				(
					children = for obj in aBone.children collect obj
					children.parent = undefined
				)
				setNodeWorldRotation aBone standardQuat
				if children != undefined then
				(
					(children as array).parent = aBone
				)
			)
		)

		skinOps.SetStartPoint  chrSkin cBone offsetEnvelopStart
		skinOps.SetEndPoint  chrSkin cBone offsetEnvelopEnd
		numCross = skinOps.getNumberCrossSections chrSkin cBone

	
		for c=1 to numCross do
		(
			skinops.setInnerRadius chrSkin cBone c envelopInnerRadius
			skinops.setOuterRadius chrSkin cBone c envelopOuterRadius
		)
		
	)
	
	if bonePosFix then 
	(
		chrSkin.always_deform = true
	)
	echo ("Done Geo" + (obj.name as string))
)

echo "KILL ENVELOP SCRIPT DONE"