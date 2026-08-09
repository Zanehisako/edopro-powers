-- Sakuretsu Armor (56120475)
-- Normal Trap: When an opponent's monster declares an attack, destroy that monster.
function c56120475.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c56120475.condition)
	e1:SetTarget(c56120475.target)
	e1:SetOperation(c56120475.operation)
	c:RegisterEffect(e1)
end
function c56120475.condition(e, tp, eg, ep, ev, re, r, rp)
	return tp ~= Duel.GetTurnPlayer()
end
function c56120475.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local atk = Duel.GetAttacker()
		return atk and atk:GetControler() ~= tp and atk:IsDestructable()
	end
	return true
end
function c56120475.operation(e, tp, eg, ep, ev, re, r, rp)
	local atk = Duel.GetAttacker()
	if atk then
		Duel.Destroy(atk, REASON_EFFECT)
	end
end
