-- Book of Moon (14087893)
-- Quick-Play Spell: Target 1 face-up monster on the field; change it to face-down Defense Position.
function c14087893.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14087893.target)
	e1:SetOperation(c14087893.operation)
	c:RegisterEffect(e1)
end
function c14087893.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingTarget(c14087893.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	end
	Duel.SelectTarget(tp, c14087893.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
end
function c14087893.filter(c)
	return c:IsFaceup() and c:IsMonster()
end
function c14087893.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc then
		Duel.ChangePosition(tc, POS_FACEDOWN_DEFENSE)
	end
end
