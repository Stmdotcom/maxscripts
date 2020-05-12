-- Simple auto rigger script, assume model is facing with X+ axis and rises with Z+ axis (Y+ to the left of the model)

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

fn safeGetNodeByName nodeName =
(
	local workingNode = getNodeByName nodeName

	if workingNode == undefined then (
		local exceptionMessage = "Could not find node with name " + nodeName
		throw exceptionMessage
	)

	return workingNode
)

fn addLegRig legNodeNames =
(
	-- Get parent and child IK nodes
	local thigh = safeGetNodeByName legNodeNames[1]
	local ankle = safeGetNodeByName legNodeNames[2]

	-- Add IK for leg
	addIkLimbChain thigh ankle

	-- Create foot handle
	local legHelper = torus()
	legHelper.radius1 = (3.5 * helperMultiplier)
	legHelper.radius2 = (.5 * helperMultiplier)
	legHelper.pos.x = ankle.pos.x
	legHelper.pos.y = ankle.pos.y
	legHelper.pos.z = ankle.pos.z

	-- Rotate foot to handle
	orientation = Orientation_Constraint()
	ankle.rotation.controller.available.controller = orientation
	orientation.appendtarget legHelper 100
	orientation.relative = true

	-- Move foot to handle
	position = Position_Constraint()
	local ikname = getCurrentIkName()
	legIkChain = getNodeByName ikname
	legIkChain.pos.controller = position
	position.appendtarget legHelper 100
)

fn addArmRig armNodeNames armType =
(
	-- Get parent and child IK nodes
	local shoulder = safeGetNodeByName armNodeNames[1]
	local wrist = safeGetNodeByName armNodeNames[2]

	-- Add IK for arm
	addIkLimbChain shoulder wrist

	-- Create wrist handle
	local armHelper = torus()
	armHelper.radius1 = (3.5 * helperMultiplier)
	armHelper.radius2 = (.5 * helperMultiplier)
	if armType == "left" then (
		local newRotation = (360 - (helperWristOffset + 180))
		armHelper.rotation = eulerAngles newRotation 0 0
	) else (
		local newRotation = helperWristOffset + 180
		armHelper.rotation = eulerAngles newRotation 0 0
	)
	armHelper.pos.x = wrist.pos.x
	armHelper.pos.y = wrist.pos.y
	armHelper.pos.z = wrist.pos.z

	-- Rotate foot to handle
	orientation = Orientation_Constraint()
	wrist.rotation.controller.available.controller = orientation
	orientation.appendtarget armHelper 100
	orientation.relative = true

	-- Move foot to handle
	position = Position_Constraint()
	local ikname = getCurrentIkName()
	armIkChain = getNodeByName ikname
	armIkChain.pos.controller = position
	position.appendtarget armHelper 100
)

(
	-- helperMultiplier can be set to shrink or grow size of the rig helpers
	global helperMultiplier = 1
	-- helperWristOffset can be set to change the angle of the wrist helper depending on arm angle from t-pose
	global helperWristOffset = 10

	-- Internal use
	global ikCount = 0

	-- Leg nodes (Upper thigh, to ankle)
	local leftLegNodes = #("Left_Hip", "Right_Foot")
	local rightLegNodes = #("Right_Hip", "Right_Foot")
	--local leftLegNodes = #("HM_Hip_Left_Jnt", "HM_Belly004_Jnt")
	--local rightLegNodes = #("HM_Hip_Right_Jnt", "HM_Foot_Left002_Jnt")

	-- Arm nodes (Shoulder, to wrist)
	local leftArmNodes = #("Left_Shoulder", "Left_Wrist")
	local rightArmNodes = #("Right_Shoulder", "Right_Wrist")
	--local leftArmNodes = #("HM_Arm_Left_Jnt", "HM_Wrist_Left_Jnt")
	--local rightArmNodes = #("HM_Arm_Right_Jnt", "HM_Wrist_Right_Jnt")

	echo "Rigging Left Leg"
	addLegRig leftLegNodes

	echo "Rigging Right Leg"
	addLegRig rightLegNodes

	echo "Rigging Left Arm"
	addArmRig leftArmNodes "left"

	echo "Rigging Right Arm"
	addArmRig rightArmNodes "right"
)