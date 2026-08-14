-- Power Card #9: Chrono Freeze
-- Power Cost: 2. Target 1 face-up monster your opponent controls; negate its effects, and its ATK becomes 0.
function c42000009.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE + CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(2)
	e1:SetTarget(c42000009.target)
	e1:SetOperation(c42000009.operation)
	c:RegisterEffect(e1)
end
function c42000009.filter(c)
	return c:IsFaceup() and (not c:IsDisabled() or c:GetAttack() > 0)
end
function c42000009.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) and c42000009.filter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(c42000009.filter, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	Duel.SelectTarget(tp, c42000009.filter, tp, 0, LOCATION_MZONE, 1, 1, nil)
end
function c42000009.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
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
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e3)
	end
end
