--黯炼装勇士·钨臧
function c99900102.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99900102,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,99900102)
	e1:SetTarget(c99900102.thtg)
	e1:SetOperation(c99900102.thop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c99900102.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--f.t.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,89900102)
	e3:SetTarget(c99900102.target)
	e3:SetOperation(c99900102.activate)
	c:RegisterEffect(e3)
	--special summon(p)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,88900102)
	e4:SetCondition(c99900102.pspcon)
	e4:SetCost(c99900102.pspcost)
	e4:SetTarget(c99900102.psptg)
	e4:SetOperation(c99900102.pspop)
	c:RegisterEffect(e4)
end
function c99900102.pspfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0xe1)
end
function c99900102.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99900102.pspfilter,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xe1)
end
function c99900102.pspcfilter(c)
	return c:IsSetCard(0xe1) and c:IsAbleToGraveAsCost()
end
function c99900102.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900102.pspcfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99900102.pspcfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c99900102.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99900102.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and
		 Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(99900102,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c99900102.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe1) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
	and not c:IsCode(99900102)
end
function c99900102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900102.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c99900102.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99900102.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99900102.tglimit(e,c)
	return c:IsSetCard(0xe1) and c~=e:GetHandler()
end
function c99900102.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xe1)
end
function c99900102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99900102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99900102.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99900102.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99900102.mgfilter1(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99900102.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and not c:IsType(TYPE_FUSION) and c:IsSetCard(0xe1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99900102.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	if Duel.Destroy(tc,REASON_EFFECT)~=0
		and not (Duel.GetLocationCount(tp,LOCATION_MZONE)<1
		or Duel.GetUsableMZoneCount(tp)<1 or Duel.IsPlayerAffectedByEffect(tp,59822133)) 
		and Duel.IsExistingMatchingCard(c99900102.mgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c99900102.mgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.SelectYesNo(tp,aux.Stringid(99900102,1))
		Duel.BreakEffect()
		local g1=Duel.SelectMatchingCard(tp,c99900102.mgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			  g2=Duel.SelectMatchingCard(tp,c99900102.mgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			  g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
