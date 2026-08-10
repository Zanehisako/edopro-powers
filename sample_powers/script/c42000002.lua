-- Sample Power Card #2: Void Surge
-- Generic test effect. Power Cost: 2.
function c42000002.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(2)
	e1:SetOperation(c42000002.operation)
	c:RegisterEffect(e1)
end
function c42000002.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(tp, 2, REASON_EFFECT)
end
