--进化
function c112054.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(9212051,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e0)
	--activate (return)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9212051,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c112054.thtg1)
	e1:SetOperation(c112054.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c112054.thtg2)
	c:RegisterEffect(e2)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,112054)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c112054.retg)
	e2:SetOperation(c112054.reop)
	c:RegisterEffect(e2)
end
function c112054.thfilter(c)
	return c:IsSetCard(0xa007)
end
function c112054.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c112054.thfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
	local g=Duel.SelectTarget(tp,c112054.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c112054.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c112054.thfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
	local g=Duel.SelectTarget(tp,c112054.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c112054.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(112054,0),aux.Stringid(112054,1),aux.Stringid(112054,2))
	if op==0 then
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	tc:RegisterEffect(e3)
	elseif op==1 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	else 
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	end
end
function c112054.refil(c)
	return c:IsSetCard(0xa007) and c:IsSSetable() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c112054.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c112054.refil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c112054.refil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c112054.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		if op==0 then
		local op1=0
		local op1=Duel.SelectOption(tp,aux.Stringid(112050,2),aux.Stringid(112050,3))
		if op1==0 then
		Duel.SSet(tp,tc,true)
		else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
		else
		Duel.SSet(tp,tc,true)
		end
end


