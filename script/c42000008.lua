-- Power Card #8: Titan's Might
-- Power Cost: 1. Target 1 face-up monster on the field; it gains 1500 ATK until the end of this turn.
function c42000008.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c42000008.target)
	e1:SetOperation(c42000008.operation)
	c:RegisterEffect(e1)
end
function c42000008.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
end
function c42000008.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
	end
end
