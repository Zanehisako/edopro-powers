-- Power Card #20: Second Wind
-- Power Cost: 1. Target up to 2 cards in your GY; add them to your hand.
function c42000020.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetTarget(c42000020.target)
	e1:SetOperation(c42000020.operation)
	c:RegisterEffect(e1)
end
function c42000020.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToHand, tp, LOCATION_GRAVE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
	local g = Duel.SelectTarget(tp, Card.IsAbleToHand, tp, LOCATION_GRAVE, 0, 1, 2, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, #g, 0, 0)
end
function c42000020.operation(e, tp, eg, ep, ev, re, r, rp)
	local tg = Duel.GetTargetCards(e)
	if #tg > 0 then
		Duel.SendtoHand(tg, nil, REASON_EFFECT)
	end
end
