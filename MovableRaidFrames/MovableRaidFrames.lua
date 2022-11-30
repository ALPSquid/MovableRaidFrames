--
-- Part of the Movable Raid Frames AddOn
-- https://github.com/ALPSquid/MovableRaidFrames
--

local _, ns = ...

local MovableRaidFrames =
{
	-- Names of each frame to add a draggable handle to.
	-- Obtained with /framestack
	targetFrameNames =
	{
		"CompactRaidFrameContainer",
		"CompactPartyFrame"
	},
	dragHandles = {}
}
ns.MovableRaidFrames = MovableRaidFrames

-- AddOn Events
MovableRaidFrames.eventFrame = CreateFrame("frame")
MovableRaidFrames.eventFrame:RegisterEvent("PLAYER_LOGIN")
MovableRaidFrames.eventFrame:SetScript("OnEvent", function(frame, event, ...)
	if event == "PLAYER_LOGIN" then
		MovableRaidFrames:OnLoad()
	end
end)


-- Called when the AddOn is loaded and the player logs in/reloads.
function MovableRaidFrames:OnLoad()
	for _, frameName in pairs(self.targetFrameNames) do
		self:HookFrame(_G[frameName])
	end
end

-- Creates a draggable handle in the top left corner of the specified frame.
function MovableRaidFrames:HookFrame(frame)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)

    -- Create handle if we haven't already.
	local dragHandle = self.dragHandles[frame]
    if dragHandle == nil then
        dragHandle = CreateFrame("Button", nil, frame)
        local height = 12
        dragHandle:SetSize(32, height)
        dragHandle:SetPoint("TOPLEFT", 0, height)
        dragHandle:EnableMouse(true)
        dragHandle:SetNormalTexture("Interface\\RAIDFRAME\\Raid-Move-Up.PNG");
        dragHandle:SetFrameLevel(99)
    end
    dragHandle:SetShown(true)
	
    -- Drag events
    dragHandle:RegisterForDrag("LeftButton")
    dragHandle:SetScript("OnDragStart", function()
        if EditModeManagerFrame.editModeActive then
            return
        end
        frame:StartMoving()
    end)
    dragHandle:SetScript("OnDragStop", function()
        if EditModeManagerFrame.editModeActive then
            return
        end
        frame:StopMovingOrSizing()
    end)
end
