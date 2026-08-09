-- Trap Hole (04206964)
-- Normal Trap: When your opponent Normal or Flip Summons a monster with 1000 or more ATK: destroy it.
function c4206964.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c4206964.condition)
	e1:SetTarget(c4206964.target)
	e1:SetOperation(c4206964.operation)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c4206964.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() ~= tp
end
function c4206964.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local tc = eg:GetFirst()
	if chk == 0 then
		return tc and tc:IsMonster() and tc:GetAttack() >= 1000 and tc:IsDestructable()
	end
	return true
end
function c4206964.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = eg:GetFirst()
	if tc and tc:IsRelateToChain() then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end
