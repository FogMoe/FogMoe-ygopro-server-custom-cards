--The Next
function c112048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_FZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,112048999)
	e5:SetCost(c112048.spcost)
	e5:SetTarget(c112048.sptg)
	e5:SetOperation(c112048.spop)
	c:RegisterEffect(e5) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4230620,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,11204899999)
	e2:SetCondition(c112048.atkcon)
	e2:SetTarget(c112048.atktg)
	e2:SetOperation(c112048.atkop)
	c:RegisterEffect(e2)
end
function c112048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c112048.spfilter4(c,e,tp)
	return c:IsSetCard(0xa007) and c:IsSummonable(true,nil)
end
function c112048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c112048.spfilter4,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c112048.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112048.spfilter4,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
end
function c112048.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return c:IsOnField() and c:IsSetCard(0xa007)
end
function c112048.filter(c)
	return c:IsSetCard(0xa007) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c112048.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c112048.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c112048.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c112048.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SSet(tp,tc)
end




