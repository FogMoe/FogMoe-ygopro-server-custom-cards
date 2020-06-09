--军火专家
function c92011.initial_effect(c)
	 c:EnableCounterPermit(0x34)
	 c:SetCounterLimit(0x34,3)

	--self destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetCondition(c92011.sdcon)
	c:RegisterEffect(e9)


	



	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(92011,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c92011.mtcon)
	e6:SetOperation(c92011.mtop)
	c:RegisterEffect(e6)

--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92011,4))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c92011.addct)
	e1:SetOperation(c92011.addc)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92011,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c92011.negcon)
	e2:SetTarget(c92011.negtg)
	e2:SetCost(c92011.negcost)
	e2:SetOperation(c92011.negop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(92011,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,92011)
	e4:SetCost(c92011.thcost)
	e4:SetTarget(c92011.thtg)
	e4:SetOperation(c92011.thop)
	c:RegisterEffect(e4)
end
c92011.counter_add_list={0x34}
function c92011.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x34)
end
function c92011.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34,3)
	end
end

function c92011.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c92011.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c92011.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c92011.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x34,1,REASON_COST)
end
function c92011.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c92011.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
	end
end
function c92011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,1,REASON_COST) and Duel.GetFlagEffect(tp,92011)==0 end
   Duel.RegisterFlagEffect(tp,92011,RESET_CHAIN,0,1)
	Duel.RemoveCounter(tp,1,0,0x34,1,REASON_COST)   
end
function c92011.thfilter(c,tp)
	return c:IsCode(92012,92013,92014,92015) and c:GetType()==0x10002
		and (c:GetActivateEffect():IsActivatable(tp)) and c:IsSSetable(tp)
end
function c92011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92011.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c92011.thop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,c92011.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		
		local b2=tc:GetActivateEffect():IsActivatable(tp)
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			Duel.ConfirmCards(1-tp,g)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	
end


function c92011.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c92011.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsCanRemoveCounter(tp,1,0,0x34,1,REASON_COST) then
		Duel.RemoveCounter(tp,1,0,0x34,1,REASON_COST)
	else
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	end
end


function c92011.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x9201)
end

function c92011.sdcon(e)
	return Duel.IsExistingMatchingCard(c92011.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end




