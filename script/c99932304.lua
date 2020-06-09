--蟑蠊族·海岛巨无霸
function c99932304.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99932304)
	e1:SetTarget(c99932304.target)
	e1:SetOperation(c99932304.activate)
	c:RegisterEffect(e1)
	--Hatsudo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,89932304)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c99932304.target1)
	e2:SetOperation(c99932304.operation)
	c:RegisterEffect(e2)
end
function c99932304.filter1(c)
	return c:IsSetCard(0x323) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99932304.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end
function c99932304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99932304.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c99932304.chlimit)
end
function c99932304.chlimit(e,ep,tp)
	return tp==ep
end
function c99932304.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99932304.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c99932304.filter2,tp,0,LOCATION_ONFIELD,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99932304,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local  sc=Duel.SelectMatchingCard(tp,c99932304.filter2,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
			Duel.SendtoDeck(sc,nil,2,REASON_EFFECT)
		end
	end
end
function c99932304.filter3(c,tp)
	return c:IsCode(99932305)
end
function c99932304.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99932304.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99932304.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99932304.filter3,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			 Duel.SendtoGrave(fc,REASON_RULE)
			 Duel.BreakEffect()
		 end
			 Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	 end
end