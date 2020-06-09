--军火基地-控制战略要点
function c92021.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,92020,92019,92018,92021,92011,92022,92023,92024),2,2)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x34)
	c:SetCounterLimit(0x34,5)
	--self destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetCondition(c92021.sdcon)
	c:RegisterEffect(e9)


	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c92021.drcon)
	e3:SetTarget(c92021.addct)
	e3:SetOperation(c92021.addc)
	c:RegisterEffect(e3)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e1:SetCondition(c92021.effcon)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c92021.effcon)
	c:RegisterEffect(e2)
	
end
function c92021.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
c92021.counter_add_list={0x34}
function c92021.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x34)
end
function c92021.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34,3)
	end
end

function c92021.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x34)>2
end
function c92021.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x9201)
end

function c92021.sdcon(e)
	return Duel.IsExistingMatchingCard(c92021.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
