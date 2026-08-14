-- Power Card #5: Mystic Tempest
-- Power Cost: 2. Destroy all Spell and Trap cards your opponent controls.
function c42000005.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(2)
	e1:SetTarget(c42000005.target)
	e1:SetOperation(c42000005.operation)
	c:RegisterEffect(e1)
end
function c42000005.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsSpellTrap, tp, 0, LOCATION_ONFIELD, 1, nil) end
	local g = Duel.GetMatchingGroup(Card.IsSpellTrap, tp, 0, LOCATION_ONFIELD, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end
function c42000005.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsSpellTrap, tp, 0, LOCATION_ONFIELD, nil)
	if #g > 0 then
		Duel.Destroy(g, REASON_EFFECT)
	end
end
