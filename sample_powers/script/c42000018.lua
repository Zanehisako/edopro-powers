-- Power Card #18: Gravity Singularity
-- Power Cost: 2. Send 1 monster your opponent controls to the GY, and inflict damage equal to half its original ATK.
function c42000018.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(2)
	e1:SetTarget(c42000018.target)
	e1:SetOperation(c42000018.operation)
	c:RegisterEffect(e1)
end
function c42000018.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave, tp, 0, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g, 1, 0, 0)
end
function c42000018.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, Card.IsAbleToGrave, tp, 0, LOCATION_MZONE, 1, 1, nil)
	local tc = g:GetFirst()
	if tc then
		local atk = math.floor(tc:GetBaseAttack() / 2)
		if atk < 0 then atk = 0 end
		if Duel.SendtoGrave(tc, REASON_EFFECT) > 0 and tc:IsLocation(LOCATION_GRAVE) and atk > 0 then
			Duel.Damage(1 - tp, atk, REASON_EFFECT)
		end
	end
end
