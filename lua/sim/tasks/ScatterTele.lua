--*****************************************************************************
--* File: lua/sim/tasks/ScatterTele.lua
--*
--* Dummy task for the ScatterTele button
--*****************************************************************************
local ScriptTask = import("/lua/sim/scripttask.lua").ScriptTask
local TASKSTATUS = import("/lua/sim/scripttask.lua").TASKSTATUS
local AIRESULT = import("/lua/sim/scripttask.lua").AIRESULT

---@class ScatterTele : ScriptTask
ScatterTele = Class(ScriptTask) {

    ---@param self AttackMove
    ---@return integer
    TaskTick = function(self)
        self:SetAIResult(AIRESULT.Success)
        return TASKSTATUS.Done
    end,
}