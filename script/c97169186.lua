-- Smashing Ground (97169186)
-- Normal Spell: Destroy the 1 face-up monster your opponent controls with the highest DEF.
function c97169186.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c97169186.target)
	e1:SetOperation(c97169186.operation)
	c:RegisterEffect(e1)
end
function c97169186.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(c97169186.filter, tp, 0, LOCATION_MZONE, 1, nil)
	end
	return true
end
function c97169186.filter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsDestructable()
end
function c97169186.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(c97169186.filter, tp, 0, LOCATION_MZONE, nil)
	if #g <= 0 then
		return
	end
	local tc = g:GetMaxGroup(Card.GetDefense):GetFirst()
	if tc then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end
