-- Power Card #6: Astral Rebirth
-- Power Cost: 3. Target 1 monster in either player's GY; Special Summon it to your field.
function c42000006.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(3)
	e1:SetTarget(c42000006.target)
	e1:SetOperation(c42000006.operation)
	c:RegisterEffect(e1)
end
function c42000006.filter(c, e, tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c42000006.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c42000006.filter(chkc, e, tp) end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingTarget(c42000006.filter, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, c42000006.filter, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end
function c42000006.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
	end
end
