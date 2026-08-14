-- Power Card #3: Temporal Shifter
-- Power Cost: 3. Gain 4000 LP.
function c42000003.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(3)
	e1:SetTarget(c42000003.target)
	e1:SetOperation(c42000003.operation)
	c:RegisterEffect(e1)
end
function c42000003.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 4000)
end
function c42000003.operation(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Recover(p, d, REASON_EFFECT)
end
