-- Power Card #17: Tactical Mulligan
-- Power Cost: 1. Shuffle up to 3 cards from your hand into the Deck, then draw that same number of cards + 1.
function c42000017.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetTarget(c42000017.target)
	e1:SetOperation(c42000017.operation)
	c:RegisterEffect(e1)
end
function c42000017.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, LOCATION_HAND, 0, 1, nil)
		and Duel.IsPlayerCanDraw(tp, 2) end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_HAND)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end
function c42000017.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsAbleToDeck, tp, LOCATION_HAND, 0, nil)
	if #g == 0 then return end
	local maxc = math.min(3, #g)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local sg = g:Select(tp, 1, maxc, nil)
	if #sg > 0 then
		local ct = Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		if ct > 0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp, ct + 1, REASON_EFFECT)
		end
	end
end
