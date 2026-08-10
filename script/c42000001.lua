-- Sample Power Card #1: Arcane Order
-- Generic test effect. Power Cost: 1.
function c42000001.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetOperation(c42000001.operation)
	c:RegisterEffect(e1)
end
function c42000001.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(tp, 1, REASON_EFFECT)
end
