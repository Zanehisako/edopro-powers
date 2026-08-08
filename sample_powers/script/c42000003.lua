-- Sample Power Card #3: Temporal Shifter
-- Install reference script/c42000003.lua
function c42000003.initial_effect(c)
	local e = Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_QUICK_O)
	e:SetCode(EVENT_CHAIN_ACTIVATING)
	e:SetRange(LOCATION_EXTRA)
	e:SetTarget(c42000003.target)
	e:SetOperation(c42000003.operation)
	c:RegisterEffect(e)
end
function c42000003.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local re_ev = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
		return re_ev and re_ev:GetHandler():IsOnField()
	end
	return true
end
function c42000003.operation(e, tp, eg, ep, ev, re, r, rp)
	local info = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
	if info then
		local tc = info:GetHandler()
		Duel.SendtoDeck(tc, tc:GetControler(), SEQ_DECKSHUFFLE, REASON_EFFECT)
	end
end