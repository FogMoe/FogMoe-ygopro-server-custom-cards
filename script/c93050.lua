--变异毒株 魄利欧
function c93050.initial_effect(c)
				--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c93050.ffilter,3,true)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c93050.tgcon)
	e2:SetValue(c93050.atlimit)
	c:RegisterEffect(e2)
	---
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c93050.negcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
end
------------------------------------
function c93050.ffilter(c)
	return c:IsSetCard(0x9202) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end
-----------------------------------
function c93050.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c93050.atlimit(e,c)
	return c~=e:GetHandler()
end
---
function c93050.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9202) and c:IsType(TYPE_PENDULUM)
end
function c93050.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return 
	 Duel.IsExistingMatchingCard(c93050.exfilter,tp,LOCATION_EXTRA,0,4,nil)
end