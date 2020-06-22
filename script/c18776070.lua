--猫与鼠的追逐战
function c18776070.initial_effect(c)
	c:EnableCounterPermit(0x66a)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c18776070.acop)
	c:RegisterEffect(e2)
	--atkup
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD)
	e33:SetCode(EFFECT_UPDATE_ATTACK)
	e33:SetRange(LOCATION_SZONE)
	e33:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e33:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaa0))
	e33:SetValue(c18776070.atkval)
	c:RegisterEffect(e33)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c18776070.desreptg)
	e4:SetOperation(c18776070.desrepop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18776070,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c18776070.thtg)
	e3:SetOperation(c18776070.thop)
	c:RegisterEffect(e3)
end
function c18776070.thfilter(c)
	return c:IsSetCard(0xaa0) and c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsAbleToHand()
end
function c18776070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18776070.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18776070.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18776070.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18776070.atkval(e,c)
	return e:GetHandler():GetCounter(0x66a)*100
end
function c18776070.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_DECK and c:GetPreviousControler()==tp
end
function c18776070.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c18776070.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x66a,1)
	end
end
function c18776070.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x66a)>=3 end
	return true
end
function c18776070.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x66a,3,REASON_EFFECT)
end
