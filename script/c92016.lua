--军火库
function c92016.initial_effect(c)
	c:EnableCounterPermit(0x34)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c92016.target)
	e2:SetOperation(c92016.operation)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c92016.negcost)
	e1:SetTarget(c92016.target2)
	e1:SetOperation(c92016.activate2)
	c:RegisterEffect(e1)
end
function c92016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c92016.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x34,3,c) end
	c:AddCounter(0x34,3)
	if Duel.GetTurnPlayer()==tp and c:IsCanRemoveCounter(tp,0x34,1,REASON_EFFECT)
		and Duel.IsExistingTarget(c92016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.SelectYesNo(tp,aux.Stringid(92016,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		Duel.SelectTarget(tp,c92016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		c:RegisterFlagEffect(92016,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	else
		e:SetProperty(0)
	end
end
function c92016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsCanRemoveCounter(tp,0x34,1,REASON_EFFECT) and tc:IsCanAddCounter(0x34,1) then
		c:RemoveCounter(tp,0x34,1,REASON_EFFECT)
		tc:AddCounter(0x34,1)
	end
end
function c92016.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34,1) and c:IsCode(92016)
end


function c92016.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c92016.filter2(c,e,sp)
	return c:IsCode(92011,92020,92023) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c92016.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(c92016.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(92016,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end
function c92016.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x34,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x34,3,REASON_COST)
end