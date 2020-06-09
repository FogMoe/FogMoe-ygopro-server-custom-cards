--蟑蠊族·美洲飞镰
function c99932302.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99932302)
	e1:SetCost(c99932302.spcost)
	e1:SetTarget(c99932302.sptg)
	e1:SetOperation(c99932302.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,89932302)
	e2:SetTarget(c99932302.target)
	e2:SetOperation(c99932302.activate)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(99932302,ACTIVITY_SPSUMMON,c99932302.counterfilter)
end
function c99932302.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
function c99932302.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c99932302.spfilter1(c)
	return c:IsFaceup()
end
function c99932302.spfilter2(c,e,tp)
	return c:IsSetCard(0x323) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99932302.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c99932302.spfilter1(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c99932302.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99932302.spfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99932302.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99932302.spop(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.SelectMatchingCard(tp,c99932302.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,nil,REASON_EFFECT)
		end
	end
end
function c99932302.filter1(c)
	return c:IsSetCard(0x323) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99932302.filter2(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToHand() and c:IsDefenseAbove(500)
end
function c99932302.filter3(c,tp)
	return c:IsFaceup() and not c:IsRace(RACE_INSECT)
end
function c99932302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99932302.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c99932302.chlimit)
end
function c99932302.chlimit(e,ep,tp)
	return tp==ep
end
function c99932302.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99932302.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local d=Duel.GetMatchingGroup(c99932302.filter3,tp,LOCATION_MZONE,0,nil,e,tp)
		local g=Duel.GetMatchingGroup(c99932302.filter2,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and d:GetCount()<1 and Duel.SelectYesNo(tp,aux.Stringid(99932302,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local  sc=Duel.SelectMatchingCard(tp,c99932302.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end