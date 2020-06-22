--曾经的猫与老鼠
function c55678900.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_SINGLE)
	e19:SetCode(EFFECT_SPSUMMON_CONDITION)
	e19:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e19:SetValue(aux.synlimit)
	c:RegisterEffect(e19)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_UPDATE_DEFENSE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetValue(c55678900.atkval)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e13)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_SINGLE)
	e33:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e33:SetCode(EFFECT_UPDATE_ATTACK)
	e33:SetRange(LOCATION_MZONE)
	e33:SetCondition(c55678900.atkcon)
	e33:SetValue(4000)
	c:RegisterEffect(e33)
end

function c55678900.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*250
end
function c55678900.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaa0) and c:IsType(TYPE_SYNCHRO)
end
function c55678900.atkcon(e)
	return Duel.GetMatchingGroupCount(c55678900.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)>=4
end

