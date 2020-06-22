--灰 烬 骑 士 A.S.H
function c14370004.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c14370004.mfilter,2,2,c14370004.lcheck)
	c:EnableReviveLimit()
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,14370004)
	e2:SetCondition(c14370004.spcon)
	e2:SetTarget(c14370004.sptg)
	e2:SetOperation(c14370004.spop)
	c:RegisterEffect(e2)
	--set
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ea:SetCode(EVENT_CHAINING)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCountLimit(1,14370005)
	ea:SetCondition(c14370004.setcon)
	ea:SetOperation(c14370004.setop)
	c:RegisterEffect(ea)
end
function c14370004.mfilter(c)
	return c:IsLevelAbove(1)
end
function c14370004.lcheck(g,lc)
	return g:GetClassCount(Card.GetLevel)==1
end
--e2
function c14370004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c14370004.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14370004.fselect(g,tp)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and g:GetClassCount(Card.GetLevel)==1
		and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,g,2,2)
end
function c14370004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c14370004.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and g:CheckSubGroup(c14370004.fselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c14370004.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c14370004.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c14370004.fselect,false,2,2,tp)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		local eb=e1:Clone()
		tc2:RegisterEffect(eb)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc1:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		tc1:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		tc2:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e5:SetValue(1)
		tc2:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end
--e3
function c14370004.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_XYZ) and rc:IsControler(tp)
end
function c14370004.setfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c14370004.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c14370004.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end