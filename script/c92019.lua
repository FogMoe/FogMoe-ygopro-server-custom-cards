--军火载具-飞航式空袭兵器
function c92019.initial_effect(c)
		--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c92019.matfilter,1,1)
	c:EnableCounterPermit(0x34)
	c:SetCounterLimit(0x34,3)

	--self destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetCondition(c92019.sdcon)
	c:RegisterEffect(e9)

--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c92019.drcon)
	e1:SetTarget(c92019.addct)
	e1:SetOperation(c92019.addc)
	c:RegisterEffect(e1)

	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(92019,0))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c92019.descost)
	e7:SetTarget(c92019.destg)
	e7:SetOperation(c92019.desop)
	c:RegisterEffect(e7)

	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92019,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c92019.cost)
	e2:SetTarget(c92019.tdtg)
	e2:SetOperation(c92019.tdop)
	c:RegisterEffect(e2)
end
function c92019.matfilter(c,lc,sumtype,tp)
	return c:IsCode(92011,92020,92023,92024)
end
function c92019.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
c92019.counter_add_list={0x34}
function c92019.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x34)
end
function c92019.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34,1)
	end
end

function c92019.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x34,3,REASON_COST)
end
function c92019.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c92019.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end



function c92019.tdfilter(c)
	return c:GetSequence()<5 and c:IsAbleToHand()
end
function c92019.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c92019.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c92019.tdfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c92019.tdfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c92019.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,2,REASON_EFFECT)
	end
end
function c92019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x34,1,REASON_COST)
end


function c92019.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x9201)
end

function c92019.sdcon(e)
	return Duel.IsExistingMatchingCard(c92019.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end