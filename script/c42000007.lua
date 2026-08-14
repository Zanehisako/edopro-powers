-- Power Card #7: Aegis Barrier
-- Power Cost: 1. Until the end of this turn, you take no damage, also monsters you control cannot be destroyed by battle.
function c42000007.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetPowerCost(1)
	e1:SetOperation(c42000007.operation)
	c:RegisterEffect(e1)
end
function c42000007.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- No damage to player
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2, tp)
	-- Monsters cannot be destroyed by battle
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e3, tp)
end
