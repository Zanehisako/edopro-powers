-- Power Card #11: Dimensional Banish
-- Power Cost: 3. Target 1 card on the field; banish it.
function c42000011.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(3)
	e1:SetTarget(c42000011.target)
	e1:SetOperation(c42000011.operation)
	c:RegisterEffect(e1)
end
function c42000011.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToRemove, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end
function c42000011.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc, POS_FACEUP, REASON_EFFECT)
	end
end
