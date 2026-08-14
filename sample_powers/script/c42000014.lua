-- Power Card #14: Domain of Silence
-- Power Cost: 2. Negate the effects of all face-up monsters your opponent currently controls until the end of this turn.
function c42000014.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(2)
	e1:SetTarget(c42000014.target)
	e1:SetOperation(c42000014.operation)
	c:RegisterEffect(e1)
end
function c42000014.filter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsMonster()
end
function c42000014.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(c42000014.filter, tp, 0, LOCATION_MZONE, 1, nil) end
end
function c42000014.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(c42000014.filter, tp, 0, LOCATION_MZONE, nil)
	for tc in aux.Next(g) do
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e2)
	end
end
