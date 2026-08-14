-- Power Card #12: Mind Shatter
-- Power Cost: 4. Discard 2 random cards from your opponent's hand.
function c42000012.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(4)
	e1:SetTarget(c42000012.target)
	e1:SetOperation(c42000012.operation)
	c:RegisterEffect(e1)
end
function c42000012.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND) >= 2 end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, 1 - tp, 2)
end
function c42000012.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
	if #g >= 2 then
		local sg = g:RandomSelect(tp, 2)
		Duel.SendtoGrave(sg, REASON_EFFECT + REASON_DISCARD)
	end
end
