--灰 烬 少 女  林 
function c14370016.initial_effect(c)
	--SPSUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14370016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,14370017)
	e1:SetTarget(c14370016.sptg)
	e1:SetOperation(c14370016.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	 --special summon2
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(14370016,1))
	ea:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	ea:SetCountLimit(1,14370018)
	ea:SetCondition(c14370016.spcon1)
	ea:SetTarget(c14370016.sptg1)
	ea:SetOperation(c14370016.spop1)
	c:RegisterEffect(ea)
	local e4=ea:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
--ea
function c14370016.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1437)
end
function c14370016.spfilter1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x1437) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14370016.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14370016.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c14370016.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14370016.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c14370016.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
--e1
function c14370016.spfilter(c,e,tp)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x1437)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x1437,0x11,1500,2000,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP)
end
function c14370016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c14370016.spfilter,tp,LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14370016.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c14370016.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tg=sg:GetFirst()
		if Duel.IsPlayerCanSpecialSummonMonster(tp,0,0x1437,0x11,1500,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) then
			tg:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
			Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c14370016.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	 end
end