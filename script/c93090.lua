--基因重组
function c93090.initial_effect(c)
		--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c93090.handcon)
	c:RegisterEffect(e2)
---
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93090,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_CHAIN_END)
	e3:SetCost(c93090.descost)
	e3:SetOperation(c93090.tgop)
	c:RegisterEffect(e3)
end
-----
function c93090.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9202) and c:IsType(TYPE_PENDULUM)
end
function c93090.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return 
	 Duel.IsExistingMatchingCard(c93090.exfilter,tp,LOCATION_EXTRA,0,3,nil)
end
--------------------
function c93090.cfilter(c)
	return c:IsSetCard(0x9202) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_PENDULUM)
 and c:IsFaceup()
end
function c93090.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93090.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c93090.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

------------


function c93090.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c93090.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,24010610,RESET_PHASE+PHASE_END,0,1)

end
function c93090.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsSetCard(0x9202) then
		Duel.SetChainLimit(c93090.chainlm)
	end
end
function c93090.chainlm(e,rp,tp)
	return tp==rp
end