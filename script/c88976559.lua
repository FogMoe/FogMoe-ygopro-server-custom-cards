--大！邪！神！-佐克！！1
function c88976559.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88976559.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e22:SetCode(EFFECT_CANNOT_ACTIVATE)
	e22:SetRange(LOCATION_MZONE)
	e22:SetTargetRange(1,1)
	e22:SetValue(c88976559.aclimit)
	c:RegisterEffect(e22)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88976559,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	--e4:SetCondition(c88976559.atkcon)
	e4:SetOperation(c88976559.atkop)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e12)
	local e44=Effect.CreateEffect(c)
	e44:SetType(EFFECT_TYPE_SINGLE)
	e44:SetCode(EFFECT_IMMUNE_EFFECT)
	e44:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e44:SetRange(LOCATION_MZONE)
	e44:SetValue(c88976559.efilter)
	c:RegisterEffect(e44)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	
end
function c88976559.spfilter(c)
	return c:IsSetCard(0x580) and (not c:IsOnField() or c:IsFaceup())
end
function c88976559.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c88976559.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==12
end
function c88976559.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function c88976559.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return (loc==LOCATION_GRAVE or loc==LOCATION_REMOVED) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c88976559.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end