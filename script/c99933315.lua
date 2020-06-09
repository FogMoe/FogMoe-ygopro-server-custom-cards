--铃树社的大巫师·莱利
function c99933315.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c99933315.matfilter1,nil,nil,aux.NonTuner(c99933315.matfilter2),1,99)
	c:EnableReviveLimit()
	--add turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99933315)
	e1:SetCondition(c99933315.condition)
	e1:SetTarget(c99933315.target)
	e1:SetOperation(c99933315.operation)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933315,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,89933315)
	e2:SetCondition(c99933315.tkcon)
	e2:SetCost(c99933315.tkcost)
	e2:SetTarget(c99933315.tktg)
	e2:SetOperation(c99933315.tkop)
	c:RegisterEffect(e2)
end
function c99933315.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsCode(99933304))
end
function c99933315.matfilter2(c)
	return c:IsSetCard(0x333) or (c:IsCode(99933399)) or (c:IsCode(99933398))
end
function c99933315.cfilter1(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933315.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99933315.cfilter1,tp,LOCATION_GRAVE,0,3,nil,tp)
end
function c99933315.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x333) and not c:IsType(TYPE_TUNER)
end
function c99933315.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99933315.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99933315.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99933315.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99933315.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c99933315.cfilter2(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x333) and c:IsType(TYPE_MONSTER)
end
function c99933315.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99933315.cfilter2,1,nil,tp)
end
function c99933315.cfilter3(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsAbleToRemoveAsCost()
end
function c99933315.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c99933315.cfilter3,tp,LOCATION_GRAVE,0,1,tp) end
	local maxc=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft<2 then maxc=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99933315.cfilter3,tp,LOCATION_GRAVE,0,1,maxc,nil,tp)
	ac=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(ac)
end
function c99933315.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c99933398,0x27,0x4011,1000,1000,2,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ac,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ac,0,0)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ac*800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ac*800)
end
function c99933315.tkop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft<e:GetLabel() then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,c99933398,0,0x4011,1000,1000,2,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP) then
		for i=1,e:GetLabel() do
			local token=Duel.CreateToken(tp,c99933398)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end