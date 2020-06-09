--铃树社的社祀·米提奥尔
function c99933301.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99933301,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99933301)
	e1:SetCost(c99933301.spcost)
	e1:SetTarget(c99933301.sptg)
	e1:SetOperation(c99933301.spop)
	c:RegisterEffect(e1)
		--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x333))
	e2:SetValue(c99933301.atkval)
	c:RegisterEffect(e2)
		--def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c99933301.defval)
	c:RegisterEffect(e3)
end
function c99933301.cfilter(c)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
end
function c99933301.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933301.cfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99933301.cfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c99933301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99933301.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99933301.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x333)) and c:IsType(TYPE_FIELD)
end
function c99933301.atkval(e,c)
	return Duel.GetMatchingGroupCount(c99933301.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_FZONE,0,nil)*200
end
function c99933301.deffilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x333)) and c:IsType(TYPE_FIELD)
end
function c99933301.defval(e,c)
	return Duel.GetMatchingGroupCount(c99933301.deffilter,c:GetControler(),LOCATION_GRAVE+LOCATION_FZONE,0,nil)*200
end