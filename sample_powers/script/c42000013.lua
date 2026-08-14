-- Power Card #13: Summoner's Surge
-- Power Cost: 1. You can conduct 2 Normal Summons/Sets this turn, not just 1.
function c42000013.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetOperation(c42000013.operation)
	c:RegisterEffect(e1)
end
function c42000013.operation(e, tp, eg, ep, ev, re, r, rp)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end
