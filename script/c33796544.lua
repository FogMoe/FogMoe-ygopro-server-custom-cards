--铁桶僵尸
function c33796544.initial_effect(c) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33796544,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,33796544)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c33796544.sptg)
	e1:SetOperation(c33796544.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e11:SetCountLimit(1)
	e11:SetValue(c33796544.valcon)
	c:RegisterEffect(e1)
end
function c33796544.spfilter(c,e,tp)
	return c:IsSetCard(0x650) and not c:IsCode(33796544) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33796544.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33796544.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33796544.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33796544.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33796544.valcon(e,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0 and e:GetHandler():IsAttackPos()
end