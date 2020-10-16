--鲨鱼乐器
function c113211.initial_effect(c)
	c:EnableCounterPermit(0xcad)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c113211.activate)
	c:RegisterEffect(e1) 
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c113211.splimit)
	c:RegisterEffect(e2)  
	local e0=e2:Clone()
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e0)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c113211.ccon)
	e3:SetOperation(c113211.cop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e5)
	--atk def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca12))
	e6:SetValue(c113211.val)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--counter
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_MOVE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(c113211.ctcon1)
	e8:SetOperation(c113211.ctop1)
	c:RegisterEffect(e8)
end
function c113211.val(e,c,Counter)  
	return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0xcad)*100
end
function c113211.thfilter(c,e,tp)
	return c:IsSetCard(0xcad) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c113211.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c113211.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	if Duel.GetFlagEffect(tp,113211)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(113211,0)) then
	local sg=Duel.SelectMatchingCard(tp,c113211.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,113211,RESET_PHASE+PHASE_END,0,1)
	end
end
function c113211.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c113211.ccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c113211.cop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xcad,1)
end
function c113211.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xca12) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c113211.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c113211.cfilter,1,nil)
end
function c113211.ctop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xcad,1)
end



