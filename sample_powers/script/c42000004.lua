-- Power Card #4: Solar Flare
-- Power Cost: 4. Destroy all monsters your opponent controls.
function c42000004.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(4)
	e1:SetTarget(c42000004.target)
	e1:SetOperation(c42000004.operation)
	c:RegisterEffect(e1)
end
function c42000004.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end
function c42000004.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
	if #g > 0 then
		Duel.Destroy(g, REASON_EFFECT)
	end
end
