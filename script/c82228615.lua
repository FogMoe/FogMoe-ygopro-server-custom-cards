local m=82228615
local cm=_G["c"..m]
cm.name="荒兽·邪灵降世"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetTarget(cm.reptg)  
	e2:SetValue(cm.repval)  
	e2:SetOperation(cm.repop)  
	c:RegisterEffect(e2)  
end  
  
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x2299) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.xyzfilter(c,mg)  
	return c:IsSetCard(0x2299) and c:IsXyzSummonable(mg,2,2)  
end  
function cm.mfilter1(c,mg,exg)  
	return mg:IsExists(cm.mfilter2,1,c,c,exg)  
end  
function cm.mfilter2(c,mc,exg)  
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp)  
	local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)  
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and exg:GetCount()>0
	end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local sg1=mg:FilterSelect(tp,cm.mfilter1,1,1,nil,mg,exg)  
	local tc1=sg1:GetFirst()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local sg2=mg:FilterSelect(tp,cm.mfilter2,1,1,tc1,tc1,exg)  
	sg1:Merge(sg2)  
	Duel.SetTargetCard(sg1)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)  
end  
function cm.filter2(c,e,tp)  
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter2,nil,e,tp)  
	if g:GetCount()<2 then return end  
	local tc=g:GetFirst()  
	while tc do  
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		tc:RegisterEffect(e2)  
		tc=g:GetNext()  
	end  
	Duel.SpecialSummonComplete()  
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)  
	if xyzg:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()  
		Duel.XyzSummon(tp,xyz,g)  
	end  
end  
function cm.repfilter(c,tp)  
	return c:IsFaceup() and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsSetCard(0x2299) 
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(cm.repfilter,1,nil,tp) end  
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)  
end  
function cm.repval(e,c)  
	return cm.repfilter(c,e:GetHandlerPlayer())  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)  
end  