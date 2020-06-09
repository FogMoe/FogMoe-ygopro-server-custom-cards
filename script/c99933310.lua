--澪舞台的阵设
function c99933310.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933310,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99933310)
	e2:SetCondition(c99933310.condition1)
	e2:SetTarget(c99933310.target)
	e2:SetOperation(c99933310.activate)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99933310,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,89933310)
	e3:SetCondition(c99933310.condition2)
	e3:SetCost(c99933310.cost)
	e3:SetOperation(c99933310.operation)
	c:RegisterEffect(e3)
end
function c99933310.filter(c,e,tp,re)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_DECK)
		and c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsReason(REASON_COST) 
end
function c99933310.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99933310.filter,1,nil,e,tp,re)
end
function c99933310.cfilter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99933310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c99933310.cfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99933310.cfilter1,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c99933310.cfilter1,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99933310.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99933310.cfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		if g:GetCount()>0 then Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c99933310.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,5)==nil
end 
function c99933310.vfilter(c,tp)
	return c:IsCode(99933307) and c:IsAbleToHand()
end
function c99933310.cfilter2(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c99933310.vfilter,tp,LOCATION_DECK,1,1,c,tp)
end
function c99933310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c99933310.cfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99933310.cfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c99933310.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstMatchingCard(c99933310.vfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if tc~=nil then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c99933310.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99933310.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x333) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsImmuneToEffect(e)
end