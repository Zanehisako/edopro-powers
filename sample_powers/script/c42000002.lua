-- Sample Power Card #2: Void Surge
-- Install reference script/c42000002.lua
function c42000002.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c42000002.operation)
	c:RegisterEffect(e1)
end
function c42000002.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetFieldGroup(tp, LOCATION_GRAVE, 0)
	if #g > 0 then
		local c = g:Select(tp, 1, 1, false):First()
		if c:IsMonster() then
			Duel.Draw(tp, 1, REASON_EFFECT)
		end
		Duel.Remove(c, POS_FACEDOWN, REASON_EFFECT)
	end
end