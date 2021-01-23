--变异毒株 萨科马
function c93150.initial_effect(c)
	c:SetSPSummonOnce(93150)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9202),2,2)
	---
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93150,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c93150.destg)
	e1:SetOperation(c93150.desop)
	c:RegisterEffect(e1)
--------
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c93150.spcon)
	e2:SetTarget(c93150.sptg)
	e2:SetOperation(c93150.spop)
	c:RegisterEffect(e2)


	 --atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c93150.atkval)
	c:RegisterEffect(e4)
end
function c93150.thfilter(c)
	return c:IsSetCard(0x9202) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c93150.tofilter(c)
	return c:IsSetCard(0x9202) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c93150.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c93150.tofilter(chkc) end
	if chk==0 then return 
		 Duel.IsExistingMatchingCard(c93150.thfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingTarget(c93150.tofilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c93150.tofilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c93150.desop(e,tp,eg,ep,ev,re,r,rp)
	-- if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c93150.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
---------------------------------
function c93150.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c93150.spfilter(c,e,tp)
	return c:IsSetCard(0x9202) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93150.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c93150.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c93150.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c93150.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c93150.tdfilter(c)
	return  c:IsAbleToHand()
end
function c93150.spop(e,tp,eg,ep,ev,re,r,rp)
  --  if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		then Duel.BreakEffect()
		if Duel.SelectYesNo(tp,aux.Stringid(93150,0)) then
			
			local g=Duel.GetMatchingGroup(c93150.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHANDD)
			local sg=g:Select(tp,1,1,nil)
			
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)

		  end
	   end
	end
end
--
function c93150.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9202)
end
function c93150.atkval(e,c)
	return Duel.GetMatchingGroupCount(c93150.afilter,c:GetControler(),LOCATION_EXTRA,0,nil)*400
end
