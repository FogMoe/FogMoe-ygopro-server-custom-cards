--铩流团的影牢
function c99904007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,99904007)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c99904007.cost)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99904007,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c99904007.setcon)
	e2:SetCost(c99904007.setcost)
	e2:SetTarget(c99904007.settg)
	e2:SetOperation(c99904007.setop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c99904007.condition)
	e3:SetOperation(c99904007.chainop)
	c:RegisterEffect(e3)
end
function c99904007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c99904007.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99904007.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c99904007.setfilter(c)
	return not c:IsCode(99904007) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x343) and c:IsSSetable()
end
function c99904007.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99904007.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c99904007.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c99904007.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function c99904007.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x105) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep==tp then
		Duel.SetChainLimit(c99904007.chainlm)
	end
end
function c99904007.chainlm(e,rp,tp)
	return tp==rp
end
function c99904007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x343)
end
function c99904007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99904007.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end