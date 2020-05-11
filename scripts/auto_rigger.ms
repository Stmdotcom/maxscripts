 fn echo msg =
(
	format "%\n" (msg) to:listener
)

fn getCurrentIkName =
(
	return "IK Chain00" + (ikCount as string)
)

fn addIkLimbChain parent child =
(
	ikCount = ikCount + 1;
	IKSys.ikChain parent child "IKLimb"
)

fn addLegRig legNodeNames =
(
	-- Get parent and child IK nodes
	local thigh = getNodeByName legNodeNames[1]
	local ankle = getNodeByName legNodeNames[2]

	-- Add IK for to left leg
	addIkLimbChain thigh ankle

	-- Create foot handle
	meshSelected = torus()
	meshSelected.radius1 = (3.5 * helperMultiplier)
	meshSelected.radius2 = (.5 * helperMultiplier)
	meshSelected.pos.x = ankle.pos.x
	meshSelected.pos.y = ankle.pos.y
	meshSelected.pos.z = ankle.pos.z

	-- Rotate foot to handle
	orientation = Orientation_Constraint()
	ankle.rotation.controller.available.controller = orientation
	orientation.appendtarget meshSelected 100
	orientation.relative = true

	-- Move foot to handle
	position = Position_Constraint()
	local ikname = getCurrentIkName()
	echo(getCurrentIkName)
	legIkChain = getNodeByName ikname
	legIkChain.pos.controller = position
	position.appendtarget meshSelected 100
)

(
	-- helperMultiplier can be set to shrink or grow size of the rig helpers
	global helperMultiplier = 1
	global ikCount = 0

	-- Left leg nodes (Upper thigh, to ankle)
	local leftLegNodes = #("Left_Hip", "Right_Foot")
	local rightLegNodes = #("Right_Hip", "Right_Foot")

	addLegRig leftLegNodes
	addLegRig rightLegNodes
)