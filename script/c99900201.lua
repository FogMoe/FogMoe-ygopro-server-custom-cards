--锋利小鬼·伪装天使
function c99900201.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,99900201)
	e1:SetTarget(c99900201.chtg)
	e1:SetOperation(c99900201.chop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--SEARCH
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99900201,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,89900201)
	e3:SetCost(c99900201.srcost)
	e3:SetTarget(c99900201.srtg)
	e3:SetOperation(c99900201.srop)
	c:RegisterEffect(e3)
end
function c99900201.tgfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xc3) or c:IsSetCard(0xa9)) and Duel.IsExistingMatchingCard(c99900201.cfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c99900201.cfilter(c,tc)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FIEND) and not c:IsCode(tc:GetLinkCode())
end
function c99900201.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99900201.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c99900201.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99900201.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c99900201.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c99900201.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local ec=cg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(ec:GetCode())
	tc:RegisterEffect(e1)
end
function c99900201.costfilter(c)
	return c:IsSetCard(0xad) and (c:IsType(TYPE_MONSTER) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())) and c:IsAbleToRemoveAsCost()
end
function c99900201.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900201.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99900201.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99900201.filter(c)
	return c:IsSetCard(0xc3) and c:IsType(TYPE_MONSTER) and not c:IsCode(99900201) and c:IsAbleToHand()
end
function c99900201.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900201.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99900201.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99900201.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
