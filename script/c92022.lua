--军火基地-指挥中心
function c92022.initial_effect(c)
	   --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,92020,92019,92018,92021,92011,92022,92023,92024),2,3)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x34)
	c:SetCounterLimit(0x34,5)

	--self destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetCondition(c92022.sdcon)
	c:RegisterEffect(e9)

	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c92022.drcon)
	e3:SetTarget(c92022.addct)
	e3:SetOperation(c92022.addc)
	c:RegisterEffect(e3)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c92022.negcost)
	e2:SetTarget(c92022.rmtg)
	e2:SetOperation(c92022.rmop)
	c:RegisterEffect(e2)
end
function c92022.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
c92022.counter_add_list={0x34}
function c92022.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x34)
end
function c92022.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34,3)
	end
end

function c92022.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x34,2,REASON_COST)
end

function c92022.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c92022.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end


function c92022.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x9201)
end

function c92022.sdcon(e)
	return Duel.IsExistingMatchingCard(c92022.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end