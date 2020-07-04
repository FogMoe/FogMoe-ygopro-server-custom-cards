local m=94010
local cm=_G["c"..m]
cm.name="真理之门"
function cm.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c94010.spcon)
	e1:SetCost(c94010.negcost)
	e1:SetOperation(c94010.spop)
	e1:SetTarget(c94010.thtg)
	c:RegisterEffect(e1)
end

function c94010.spfilter1(c,tp)
	return c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c94010.spfilter2(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9400)
end
function c94010.thfilter(c,tp)
	return c:IsCode(94030)
end
function c94010.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c94010.spfilter1,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c94010.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,3,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c94010.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,3-g1:GetCount(),3-g1:GetCount(),g1)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST) 
end
function c94010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94010.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c94010.spcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c94010.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c) and Duel.CheckReleaseGroupEx(tp,c94010.spfilter1,3,nil) 
end
function c94010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c94010.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Card.AddCounter(tc,0x9404,1)
		end 
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		c:CancelToGrave()
	Duel.SendtoDeck(e:GetHandler(),tp,1,REASON_EFFECT)
	end
end
function c94010.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	 if c:IsRelateToEffect(e) then 
		c:CancelToGrave()
		Duel.SendtoDeck(c,tp,1,REASON_EFFECT) 
	end 
end

