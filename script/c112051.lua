--即使燃烧生命也要继续战斗！
function c112051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112051,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,112051)
	e2:SetCost(c112051.cost)
	e2:SetTarget(c112051.tg)
	e2:SetOperation(c112051.op)
	c:RegisterEffect(e2)
end
function c112051.cofil(c)
	return c:IsAbleToGraveAsCost()
end
function c112051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsExistingMatchingCard(c112051.cofil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c112051.cofil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.PayLPCost(tp,800)
end
function c112051.filter1(c)
	return c:IsSetCard(0xa007) and c:IsAbleToHand()
end
function c112051.filter2(c)
	return c:IsSetCard(0xa007) and c:IsSSetable() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c112051.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return end
	end
	local b1=Duel.IsExistingMatchingCard(c112051.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c112051.filter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(112051,0),aux.Stringid(112051,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(112051,0))  
	else
		op=Duel.SelectOption(tp,aux.Stringid(112051,1))+1 
	end 
	e:SetLabel(op)
	local tc=0
	if op==0 then
	tc=Duel.SelectMatchingCard(tp,c112051.filter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetTargetCard(tc)
	elseif op==1 then 
	tc=Duel.SelectMatchingCard(tp,c112051.filter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
	else
	end
end
function c112051.op(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c112051.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	local tc1=Duel.GetFirstTarget()
	local op=e:GetLabel()
	if op==0 then
	Duel.SendtoHand(tc1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
	elseif op==1 then
	Duel.SSet(tp,tc1)
	end
end
function c112051.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end



