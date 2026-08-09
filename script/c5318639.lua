-- Mystical Space Typhoon (5318639)
-- Quick-Play Spell: Target 1 Spell/Trap on the field; destroy it.
function c5318639.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5318639.target)
	e1:SetOperation(c5318639.operation)
	c:RegisterEffect(e1)
end
function c5318639.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsSpellTrap, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
	end
	Duel.SelectTarget(tp, Card.IsSpellTrap, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
end
function c5318639.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end
