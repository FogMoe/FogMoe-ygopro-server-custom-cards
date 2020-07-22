--SCP突破收容
function c789654329.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(789654329,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,789654329+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c789654329.target)
	e1:SetOperation(c789654329.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,789654329)
	e2:SetCost(c789654329.thcost)
	e2:SetTarget(c789654329.thtg)
	e2:SetOperation(c789654329.thop)
	c:RegisterEffect(e2)
	--Duel.AddCustomActivityCounter(789654329,ACTIVITY_SPSUMMON,c789654329.counterfilter)
end
function c789654329.spfilter(c,e,tp,check)
	return c:IsSetCard(0x8a79) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (check or c:IsSetCard(0x8a79))
end
function c789654329.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local chk1=Duel.IsExistingMatchingCard(c789654329.filter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c789654329.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,chk1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c789654329.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local chk1=Duel.IsExistingMatchingCard(c789654329.filter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c789654329.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,chk1)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c789654329.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c789654329.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(789654329,tp,ACTIVITY_SPSUMMON)==0
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c789654329.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c789654329.splimit(e,c)
	return not (c:IsSetCard(0x8a79))
end
function c789654329.thfilter(c)
	return c:IsSetCard(0x8a79) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c789654329.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c789654329.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c789654329.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c789654329.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
