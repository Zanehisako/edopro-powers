-- Power Card #15: Vanguard Assault
-- Power Cost: 1. If opponent controls a monster and you control none: Special Summon 1 Level 4 or lower monster from hand or GY.
function c42000015.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetCondition(c42000015.condition)
	e1:SetTarget(c42000015.target)
	e1:SetOperation(c42000015.operation)
	c:RegisterEffect(e1)
end
function c42000015.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0
		and Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE) > 0
end
function c42000015.filter(c, e, tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c42000015.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(c42000015.filter, tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_GRAVE)
end
function c42000015.operation(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, c42000015.filter, tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end
