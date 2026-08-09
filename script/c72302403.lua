-- Swords of Revealing Light (72302403)
-- Normal Spell: All monsters your opponent controls are flipped face-up Defense Position.
-- They cannot declare an attack. Destroy this card during your 2nd Standby Phase after activation.
function c72302403.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c72302403.activate)
	c:RegisterEffect(e1)
end
function c72302403.activate(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
	Duel.ChangePosition(g, POS_FACEUP_DEFENSE)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetTargetRange(0, 1)
	e1:SetTarget(c72302403.atkfilter)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	Duel.RegisterEffect(e1, tp)
	c:RegisterFlagEffect(72302403, RESET_EVENT + RESETS_STANDARD, 0, 0)
	c:SetTurnCounter(0)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE_START)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1, 0)
	e2:SetCountLimit(1)
	e2:SetOperation(c72302403.turnop)
	e2:SetReset(RESET_PHASE + PHASE_END, 2)
	c:RegisterEffect(e2)
end
function c72302403.atkfilter(e, c)
	return c:IsFaceup()
end
function c72302403.turnop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ct = c:GetTurnCounter()
	ct = ct + 1
	c:SetTurnCounter(ct)
	if ct >= 2 then
		Duel.Destroy(c, REASON_EFFECT)
	end
end
