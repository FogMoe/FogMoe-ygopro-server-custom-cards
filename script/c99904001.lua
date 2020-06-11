--铩流团的暴岚 库恩
function c99904001.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99904001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,99904001)
	e2:SetCondition(c99904001.spcon)
	e2:SetTarget(c99904001.sptg)
	e2:SetOperation(c99904001.spop)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99904001,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c99904001.dscost)
	e1:SetTarget(c99904001.dstg)
	e1:SetOperation(c99904001.dsop)
	c:RegisterEffect(e1)
	local e3=e2:Clone()
	e3:SetCondition(c99904001.spcon2)
	c:RegisterEffect(e3)
end
function c99904001.sp1filter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x343) and c:IsAbleToHand()
		and (ft>0 or c:GetSequence()<5)
end
function c99904001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c99904001.sp2filter(c,e,tp)
	return c:IsSetCard(0x343)and not c:IsCode(99904001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99904001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99904001.sp1filter(chkc,ft) end
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(c99904001.sp1filter,tp,LOCATION_MZONE,0,1,c,ft)
		and Duel.IsExistingMatchingCard(c99904001.sp2filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c99904001.sp1filter,tp,LOCATION_MZONE,0,1,1,c,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99904001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c99904001.sp2filter,tp,LOCATION_DECK,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c99904001.sp2filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c99904001.thfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x343) and Duel.IsExistingMatchingCard(c99904001.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c99904001.disfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c99904001.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99904001.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99904001.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c99904001.thfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99904001.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c99904001.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99904001.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc:GetAttack())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c99904001.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,99904011) and Duel.GetTurnPlayer()~=tp and rp==1-tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end