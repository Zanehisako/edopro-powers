-- Swords of Revealing Light (72302403)
-- Normal Spell: After this card's activation, it remains on the field, but you
-- must destroy it during the End Phase of your opponent's 3rd turn. When this
-- card is activated: If your opponent controls a face-down monster, flip all
-- monsters they control face-up. While this card is face-up on the field, your
-- opponent's monsters cannot declare an attack.
function c72302403.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c72302403.target)
	e1:SetOperation(c72302403.activate)
	c:RegisterEffect(e1)
	--cannot declare an attack
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0, LOCATION_MZONE)
	c:RegisterEffect(e2)
	--remain on the field after activation
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function c72302403.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	local c = e:GetHandler()
	c:SetTurnCounter(0)
	local sg = Duel.GetMatchingGroup(Card.IsFacedown, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, sg, sg:GetCount(), 0, 0)
	--self destroy during the End Phase of your opponent's 3rd turn
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE + PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c72302403.descon)
	e1:SetOperation(c72302403.desop)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c72302403.activate(e, tp, eg, ep, ev, re, r, rp)
	local sg = Duel.GetMatchingGroup(Card.IsFacedown, tp, 0, LOCATION_MZONE, nil)
	if sg:GetCount() > 0 then
		Duel.ChangePosition(sg, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK, POS_FACEUP_DEFENSE, POS_FACEUP_DEFENSE)
	end
end
function c72302403.descon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() ~= tp
end
function c72302403.desop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ct = c:GetTurnCounter() + 1
	c:SetTurnCounter(ct)
	if ct >= 3 then
		Duel.Destroy(c, REASON_RULE)
	end
end
