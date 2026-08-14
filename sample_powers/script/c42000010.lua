-- Power Card #10: Omega Cataclysm
-- Power Cost: 5. Destroy all cards on the field, and if you do, inflict 1000 damage to your opponent.
function c42000010.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY + CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(5)
	e1:SetTarget(c42000010.target)
	e1:SetOperation(c42000010.operation)
	c:RegisterEffect(e1)
end
function c42000010.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 1000)
end
function c42000010.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	if #g > 0 and Duel.Destroy(g, REASON_EFFECT) > 0 then
		Duel.Damage(1 - tp, 1000, REASON_EFFECT)
	end
end
