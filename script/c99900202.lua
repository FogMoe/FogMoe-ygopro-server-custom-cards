--毛绒动物·猪
function c99900202.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99900202)
	e1:SetCondition(c99900202.condition)
	e1:SetCost(c99900202.cost)
	e1:SetTarget(c99900202.target)
	e1:SetOperation(c99900202.activate)
	c:RegisterEffect(e1)
end
function c99900202.regfilter(c,tp)
	return (c:IsSetCard(0xc3) or c:IsSetCard(0xa9)) and not c:IsCode(99900202) and c:IsControler(tp) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c99900202.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99900202.regfilter,1,nil,tp)
end
function c99900202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(99900202)==0 end
	c:RegisterFlagEffect(99900202,RESET_CHAIN,0,1)
end
function c99900202.filter(c,tp)
	return (c:IsCode(70245411) or c:IsCode(101101074))
	and c:GetActivateEffect():IsActivatable(tp)
end
function c99900202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c99900202.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c99900202.spfilter(c,e,tp)
	return c:IsSetCard(0xa9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c99900202.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99900202,3))
	local tc=Duel.SelectMatchingCard(tp,c99900202.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	and Duel.IsExistingMatchingCard(c99900202.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(99900202,2)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c99900202.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
end