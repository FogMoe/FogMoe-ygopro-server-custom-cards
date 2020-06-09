--铃树社的舞灵·澪
function c99933316.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x333),2,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99933316,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c99933316.lvcon)
	e1:SetTarget(c99933316.lvtg)
	e1:SetOperation(c99933316.lvop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933316,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99933316)
	e2:SetTarget(c99933316.sptg)
	e2:SetCost(c99933316.spcost)
	e2:SetOperation(c99933316.spop)
	c:RegisterEffect(e2)
end
function c99933316.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c99933316.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933316.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c99933316.cfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c99933316.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99933316.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99933316.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99933316.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:IsLevel(1) then op=Duel.SelectOption(tp,aux.Stringid(99933316,2))
	else op=Duel.SelectOption(tp,aux.Stringid(99933316,2),aux.Stringid(99933316,3)) end
	e:SetLabel(op)
end
function c99933316.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c99933316.spfilter1(c,e,lg,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x333) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and lg and lg:IsContains(c)
		and c:IsCanBeEffectTarget(e)
		and lv>0 and Duel.IsExistingMatchingCard(c99933316.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,lv)
end
function c99933316.spfilter2(c,e,tp,lv)
	return c:GetLevel()<lv and c:IsSetCard(0x333) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99933316.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99933316.spfilter1(chkc,e,lg,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c99933316.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,lg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99933316.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,lg,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99933316.cfilter1(c)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
end
function c99933316.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933316.cfilter1,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99933316.cfilter1,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c99933316.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99933316.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end