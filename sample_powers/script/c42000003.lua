-- Sample Power Card #3: Temporal Shifter
-- Generic test effect. Power Cost: 3.
function c42000003.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(3)
	e1:SetOperation(c42000003.operation)
	c:RegisterEffect(e1)
end
function c42000003.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Recover(tp, 4000, REASON_EFFECT)
end
