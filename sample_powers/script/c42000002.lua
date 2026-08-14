-- Power Card #2: Void Surge
-- Power Cost: 2. Draw 2 cards.
function c42000002.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(2)
	e1:SetTarget(c42000002.target)
	e1:SetOperation(c42000002.operation)
	c:RegisterEffect(e1)
end
function c42000002.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsPlayerCanDraw(tp, 2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end
function c42000002.operation(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
end
