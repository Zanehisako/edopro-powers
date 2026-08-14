-- Power Card #19: Absolute Lockdown
-- Power Cost: 3. Change all face-up monsters your opponent controls to face-down Defense Position; positions cannot be changed this turn.
function c42000019.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(3)
	e1:SetTarget(c42000019.target)
	e1:SetOperation(c42000019.operation)
	c:RegisterEffect(e1)
end
function c42000019.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c42000019.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(c42000019.filter, tp, 0, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(c42000019.filter, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, #g, 0, 0)
end
function c42000019.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(c42000019.filter, tp, 0, LOCATION_MZONE, nil)
	if #g > 0 then
		Duel.ChangePosition(g, POS_FACEDOWN_DEFENSE)
		for tc in aux.Next(g) do
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
