--巨人僵尸
function c33796548.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x650),3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33796548,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetValue(c33796548.sumval)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e11:SetValue(1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c33796548.immval)
	c:RegisterEffect(e2)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_UPDATE_ATTACK)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e12:SetTarget(c33796548.atktg)
	e12:SetValue(c33796548.atkval)
	c:RegisterEffect(e12)
	--pierce
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e22)
end
function c33796548.sumval(e,c)
	if c:IsControler(e:GetHandlerPlayer()) then
		local sumzone=e:GetHandler():GetLinkedZone()
		local relzone=-bit.lshift(1,e:GetHandler():GetSequence())
		return 0,sumzone,relzone
	else
		local sumzone=e:GetHandler():GetLinkedZone(1-e:GetHandlerPlayer())
		local relzone=-bit.lshift(1,e:GetHandler():GetSequence()+16)
		return 0,sumzone,relzone
	end
end
function c33796548.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and te:GetOwner():GetAttack()<=e:GetHandler():GetAttack() and te:IsActivated()
end
function c33796548.atktg(e,c)
	return c==e:GetHandler()
		or c:IsFaceup() and c:IsSetCard(0x650) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c33796548.atkfilter(c)
	return c:IsSetCard(0x650) and c:IsType(TYPE_MONSTER)
end
function c33796548.atkval(e,c)
	return Duel.GetMatchingGroup(c33796548.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*100
end
