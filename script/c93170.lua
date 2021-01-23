--间断平衡
function c93170.initial_effect(c)
			--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c93170.handcon)
	c:RegisterEffect(e2)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c93170.discost)
	e1:SetTarget(c93170.target)
	e1:SetOperation(c93170.activate)
	c:RegisterEffect(e1)

		--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(c93170.tetg)
	e3:SetOperation(c93170.teop)
	c:RegisterEffect(e3)
end
-----
function c93170.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9202) and c:IsType(TYPE_PENDULUM)
end
function c93170.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return 
	 Duel.IsExistingMatchingCard(c93170.exfilter,tp,LOCATION_EXTRA,0,3,nil)
end
--------------------
function c93170.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c93170.costfilter(c,g)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x9202) and c:IsLocation(LOCATION_SZONE) and c:IsAbleToHandAsCost()
end

function c93170.disfilter(c,e)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end


function c93170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c93170.disfilter(chkc) end
	if chk==0 then 
		
	   if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c93170.costfilter,tp,LOCATION_SZONE,0,1,nil)   

	  and Duel.IsExistingTarget(c93170.disfilter,tp,0,LOCATION_MZONE,1,nil)
		
				
		else return false end
		end
	
	 
	


	
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local cg=Duel.SelectMatchingCard(tp,c93170.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoHand(cg,nil,REASON_COST)
	


	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c93170.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c93170.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
--------
function c93170.tefilter(c)
	return c:IsCode(93180)
end
function c93170.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93170.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c93170.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(93170,3))
	local g=Duel.SelectMatchingCard(tp,c93170.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
