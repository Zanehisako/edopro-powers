-- Sample Power Card #1: Arcane Order
-- Install as script/c42000001.lua in an EDOPro build that supports Power Cards.
-- Power Cards are played via the engine's declared-chain mechanism; this script
-- provides the card's activation effect (draw 1) for the sample.
function c42000001.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c42000001.operation)
	c:RegisterEffect(e1)
end
function c42000001.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(tp, 1, REASON_EFFECT)
end