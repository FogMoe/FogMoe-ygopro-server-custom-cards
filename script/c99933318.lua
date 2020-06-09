--铃树社的通灵术
function c99933318.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99933318,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c99933318.condition1)
	e1:SetCountLimit(1,99933318+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99933318.tdtg)
	e1:SetOperation(c99933318.tdop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,89933318)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c99933318.target)
	e2:SetCondition(c99933318.condition2)
	e2:SetOperation(c99933318.activate)
	c:RegisterEffect(e2)
end
function c99933318.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933318.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99933318.cfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c99933318.tdfilter(c)
	return c:IsSetCard(0x333) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end
function c99933318.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99933318.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99933318.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c99933318.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99933318.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x333) and c:IsAbleToGrave()
end
function c99933318.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99933318.thfilter),tp,LOCATION_REMOVED,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99933318,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,3,nil)
			Duel.SendtoGrave(sg,nil,REASON_EFFECT)
		end
	end
end
function c99933318.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933318.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99933318.cfilter,tp,LOCATION_FZONE,0,1,nil) and aux.exccon(e)
end
function c99933318.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x333) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
		and Duel.IsExistingMatchingCard(c99933318.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
end
function c99933318.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c99933318.filter3,tp,LOCATION_GRAVE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsSetCard(0x333) and c:IsAbleToRemove()
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63)
end
function c99933318.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x333) and c:IsAbleToRemove()
end
function c99933318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c99933318.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99933318.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c99933318.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c99933318.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c99933318.filter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
		g1:GetFirst():CompleteProcedure()
end

