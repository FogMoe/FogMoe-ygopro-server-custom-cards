--军火-烟幕弹
function c92014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetCountLimit(1,92014+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c92014.condition)
	e1:SetTarget(c92014.target)
	e1:SetOperation(c92014.activate)
	c:RegisterEffect(e1)
end
function c92014.cfilter(c)
	return c:IsFaceup() and c:IsCode(92011,92018,92019,92020,92021,92022,92023,92024) 
end
function c92014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c92014.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c92014.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c92014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c92014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c92014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c92014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c92014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
