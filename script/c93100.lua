--突变终止
function c93100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,93100)
	e1:SetTarget(c93100.target)
	e1:SetOperation(c93100.activate)
	c:RegisterEffect(e1)

		--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c93100.handcon)
	c:RegisterEffect(e2)
end
function c93100.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x9202) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c93100.ofilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c93100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c93100.ofilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c93100.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c93100.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c93100.ofilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c93100.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

-----
function c93100.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9202) and c:IsType(TYPE_PENDULUM)
end
function c93100.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return 
	 Duel.IsExistingMatchingCard(c93100.exfilter,tp,LOCATION_EXTRA,0,5,nil)
end
--------------------