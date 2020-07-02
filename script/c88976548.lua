--千年遗物-眼
function c88976548.initial_effect(c)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e21:SetType(EFFECT_TYPE_ACTIVATE)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetHintTiming(0,TIMING_END_PHASE)
	e21:SetTarget(c88976548.target)
	e21:SetCountLimit(1,88976548)
	e21:SetOperation(c88976548.activate)
	c:RegisterEffect(e21)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88976548,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,88976548)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88976548.settg)
	e2:SetOperation(c88976548.setop)
	c:RegisterEffect(e2)
end
function c88976548.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,88976554,0,0x4011,1900,1800,10,RACE_SPELLCASTER,ATTRIBUTE_DEVINE,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c88976548.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,88976554,0,0x4011,1900,1800,10,RACE_SPELLCASTER,ATTRIBUTE_DEVINE) then
			local token=Duel.CreateToken(tp,88976554)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetRange(LOCATION_MZONE)
			e3:SetAbsoluteRange(tp,1,0)
			e3:SetTarget(c88976548.splimit)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c88976548.atlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88976548.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c88976548.atlimit(e,c)
	return not c:IsCode(88976554)
end
function c88976548.stfilter(c)
	return c:IsSetCard(0x580) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c88976548.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c88976548.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c88976548.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c88976548.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
