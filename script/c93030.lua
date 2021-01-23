--变异毒株 因俘鲁恩泽
function c93030.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c93030.ffilter,4,true)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
	--spsum
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c93030.spcon)
	e1:SetTarget(c93030.sptg)
	e1:SetOperation(c93030.spop)
	c:RegisterEffect(e1)

	--SEARCH FROM EXTRA
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c93030.target)
	e2:SetOperation(c93030.operation)
	c:RegisterEffect(e2)
end
------------------------------------
function c93030.ffilter(c)
	return c:IsSetCard(0x9202) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end
-----------------------------------
function c93030.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c93030.spfilter(c,e,tp,code)
	return c:IsSetCard(0x9202) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c93030.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93030.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
---------------------------

function c93030.filter2(c,sc,cd)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
		and c:IsSetCard(0x9202)
end
function c93030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93030.filter2,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end

function c93030.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,c93030.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	
	Duel.SendtoHand(Group.FromCards(tc1),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
end

