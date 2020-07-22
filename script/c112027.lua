--Hollow Knight-小骑士 隐藏的梦
function c112027.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	c:EnableReviveLimit()  
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,112027)
	e1:SetCost(c112027.lzcost)
	e1:SetTarget(c112027.lztg)
	e1:SetOperation(c112027.lzop)
	c:RegisterEffect(e1)		
end
function c112027.thfilter(c)
	return c:IsSetCard(0xa009) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c112027.lzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112013.thfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c112013.thfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c112027.thfilter2(c,e,tp,zone)
	return ((c:IsSetCard(0xa009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone and c:IsType(TYPE_MONSTER))) or (c:IsSetCard(0xa009) and c:IsType(TYPE_LINK) and c:IsLinkBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone))) and not c:IsCode(112019)
end
function c112027.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c112013.thfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112013.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c112027.lzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()

end







