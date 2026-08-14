-- Power Card #16: Equilibrium Burst
-- Power Cost: 3. If opponent controls more cards than you: Target 2 cards opponent controls; destroy them, then draw 1 card.
function c42000016.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(3)
	e1:SetCondition(c42000016.condition)
	e1:SetTarget(c42000016.target)
	e1:SetOperation(c42000016.operation)
	c:RegisterEffect(e1)
end
function c42000016.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetFieldGroupCount(tp, 0, LOCATION_ONFIELD) > Duel.GetFieldGroupCount(tp, LOCATION_ONFIELD, 0)
end
function c42000016.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1 - tp) end
	if chk == 0 then return Duel.IsExistingTarget(nil, tp, 0, LOCATION_ONFIELD, 2, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, nil, tp, 0, LOCATION_ONFIELD, 2, 2, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 2, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end
function c42000016.operation(e, tp, eg, ep, ev, re, r, rp)
	local tg = Duel.GetTargetCards(e)
	if #tg > 0 and Duel.Destroy(tg, REASON_EFFECT) > 0 then
		Duel.BreakEffect()
		Duel.Draw(tp, 1, REASON_EFFECT)
	end
end
