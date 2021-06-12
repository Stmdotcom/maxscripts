-- Simple auto rigger script, assume model is facing with X+ axis and rises with Z+ axis (Y+ to the left of the model)

fn echo msg =
(
	format "%\n" (msg) to:listener
)

fn addIkLimbChain parent child =
(
	local IkHandle = IKSys.ikChain parent child "IKLimb"
	if IkHandle == undefined then (
		local exceptionMessage = "Could not create IK between nodes " + parent.name + " and " + child.name
		throw exceptionMessage
	)

	return IkHandle
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

fn addLegRig legNodeNames legType =
(
	-- Get parent and child IK nodes
	local thigh = safeGetNodeByName legNodeNames[1]
	local knee = safeGetNodeByName legNodeNames[2]
	local ankle = safeGetNodeByName legNodeNames[3]

	-- Add IK for leg
	local legIkChain = addIkLimbChain thigh ankle

	-- Create foot handle
	local legHelper = torus()
	legHelper.radius1 = (3.5 * helperMultiplier)
	legHelper.radius2 = (.5 * helperMultiplier)
	legHelper.pos.x = ankle.pos.x
	legHelper.pos.y = ankle.pos.y
	legHelper.pos.z = ankle.pos.z

	-- Rotate foot to handle
	orientation = Orientation_Constraint()
	ankle.rotation.controller = orientation
	orientation.appendtarget legHelper 100
	orientation.relative = true

	-- Move foot to handle
	position = Position_Constraint()
	legIkChain.name = ("IK_Leg_" + legType)
	legIkChain.pos.controller = position
	position.appendtarget legHelper 100

	-- Create Ik pivot
	local legIkTarget = sphere()
	legIkTarget.radius = (2 * helperMultiplier)
	legIkTarget.pos.x = knee.pos.x + (20 * helperMultiplier)
	legIkTarget.pos.y = knee.pos.y
	legIkTarget.pos.z = knee.pos.z
	legIkTarget.name = ("Helper_Leg_" + legType)

	legIkChain.transform.controller.VHTarget = legIkTarget
)

fn addArmRig armNodeNames armType =
(
	-- Get parent and child IK nodes
	local shoulder = safeGetNodeByName armNodeNames[1]
	local elbow = safeGetNodeByName armNodeNames[2]
	local wrist = safeGetNodeByName armNodeNames[3]

	-- Add IK for arm
	local armIkChain = addIkLimbChain shoulder wrist

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
	wrist.rotation.controller = orientation
	orientation.appendtarget armHelper 100
	orientation.relative = true

	-- Move foot to handle
	position = Position_Constraint()
	armIkChain.name = ("IK_Arm_" + armType)
	armIkChain.pos.controller = position
	position.appendtarget armHelper 100

	-- Create Ik pivot
	local armIkTarget = sphere()
	armIkTarget.radius = (2 * helperMultiplier)
	armIkTarget.pos.x = elbow.pos.x - (20 * helperMultiplier)
	armIkTarget.pos.y = elbow.pos.y
	armIkTarget.pos.z = elbow.pos.z
	armIkTarget.name = ("Helper_Arm_" + armType)

	armIkChain.transform.controller.VHTarget = armIkTarget
)

fn addEyeRig eyeNodeNames =
(
	local eyeLeft = safeGetNodeByName eyeNodeNames[1]
	local eyeRight = safeGetNodeByName eyeNodeNames[2]
	local head = safeGetNodeByName eyeNodeNames[3]

	local eyeTarget = sphere()
	eyeTarget.radius = (.2 * helperMultiplier)
	eyeTarget.pos.z = eyeLeft.pos.z
	eyeTarget.pos.x = (30 + helperMultiplier)

	-- Position eye targets
	local eyeLeftTarget = torus()
	eyeLeftTarget.radius1 = (1 * helperMultiplier)
	eyeLeftTarget.radius2 = (.1 * helperMultiplier)
	eyeLeftTarget.rotation = eulerAngles 0 90 0
	eyeLeftTarget.pos.x = (30 + helperMultiplier)
	eyeLeftTarget.pos.z = eyeLeft.pos.z
	eyeLeftTarget.pos.y = eyeLeft.pos.y

	local eyeRightTarget = torus()
	eyeRightTarget.radius1 = (1 * helperMultiplier)
	eyeRightTarget.radius2 = (.1 * helperMultiplier)
	eyeRightTarget.rotation = eulerAngles 0 90 0
	eyeRightTarget.pos.x = (30 + helperMultiplier)
	eyeRightTarget.pos.z = eyeRight.pos.z
	eyeRightTarget.pos.y = eyeRight.pos.y

	-- make eye targets follow head
	eyeRightTarget.parent = eyeTarget
	eyeLeftTarget.parent = eyeTarget
	eyeTarget.parent = head

	-- Make eyes follow eye targets
	lookOrientationEyeRight = LookAt_Constraint()
	lookOrientationEyeRight.appendtarget eyeRightTarget 100
	eyeRight.rotation.controller = lookOrientationEyeRight
	lookOrientationEyeRight.relative = true

	lookOrientationEyeLeft = LookAt_Constraint()
	lookOrientationEyeLeft.appendtarget eyeLeftTarget 100
	eyeLeft.rotation.controller = lookOrientationEyeLeft
	lookOrientationEyeLeft.relative = true
)

(
	-- helperMultiplier can be set to shrink or grow size of the rig helpers
	global helperMultiplier = 1
	-- helperWristOffset can be set to change the angle of the wrist helper depending on arm angle from t-pose
	global helperWristOffset = 10

	-- Leg nodes (Upper thigh, knee, to ankle)
	local leftLegNodes = #("Left_Hip", "Left_Knee", "Left_Foot")
	local rightLegNodes = #("Right_Hip", "Right_Knee", "Right_Foot")

	-- Arm nodes (Shoulder, elbow, to wrist)
	local leftArmNodes = #("Left_Shoulder", "Left_Elbow", "Left_Wrist")
	local rightArmNodes = #("Right_Shoulder", "Right_Elbow", "Right_Wrist")

	-- Eye nodes (left eye, right eye, head)
	local eyeNodes = #("Eye_Left", "Eye_Right", "Head")

	echo "Rigging Left Leg"
	addLegRig leftLegNodes "left"

	echo "Rigging Right Leg"
	addLegRig rightLegNodes "right"

	echo "Rigging Left Arm"
	addArmRig leftArmNodes "left"

	echo "Rigging Right Arm"
	addArmRig rightArmNodes "right"

	echo "Rigging Eyes"
	addEyeRig eyeNodes
)