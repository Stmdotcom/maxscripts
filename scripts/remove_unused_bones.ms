(
	local weightThresh = 0.0001
	
	local objs = selection as array
	for obj in objs do (
		select obj
		
		for m in obj.modifiers where classof m == Skin do (
			modPanel.setCurrentObject m
			
			local vertCount = skinOps.GetNumberVertices m
			local bonesCount = skinOps.GetNumberBones m
			local unusedBones = #{1..bonesCount}
			
			for v = 1 to vertCount do (
				local vertWeightCount = skinOps.GetVertexWeightCount m v
				
				for i = 1 to vertWeightCount do (
					local weight = skinOps.GetVertexWeight m v i
					if weight >= weightThresh then (
						local boneID = skinOps.GetVertexWeightBoneID m v i
						unusedBones[boneID] = false
					)
				)
			)
			
			for i = bonesCount to 1 by -1 where unusedBones[i] do (
				skinOps.SelectBone m i
				skinOps.RemoveBone m
			)
			
			format "% Bones where removed from %.%
" unusedBones.numberSet obj.name m.name
		)
	)
)