--魁武馆的休整
function c99933311.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933311,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99933311)
	e2:SetCondition(c99933311.condition1)
	e2:SetTarget(c99933311.target)
	e2:SetOperation(c99933311.activate)
	c:RegisterEffect(e2)
	--Hatsudo
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99933311,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,89933311)
	e3:SetCost(c99933311.cost)
	e3:SetTarget(c99933311.target1)
	e3:SetOperation(c99933311.operation)
	c:RegisterEffect(e3)
end
function c99933311.filter(c,e,tp,re)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_GRAVE)
		and c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsReason(REASON_COST) 
end
function c99933311.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99933311.filter,1,nil,e,tp,re)
end
function c99933311.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c99933311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c99933311.cfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99933311.cfilter1,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c99933311.cfilter1,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99933311.cfilter2(c)
	return c:IsSetCard(0x333) and c:IsAbleToGrave()
end
function c99933311.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99933311.cfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		local g=Duel.SelectMatchingCard(tp,c99933311.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
		end
	end
end
function c99933311.vfilter(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp)
end
function c99933311.cfilter3(c)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c99933311.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c99933311.cfilter3,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99933311.cfilter3,tp,LOCATION_FZONE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c99933311.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933311.vfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99933311.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99933311.vfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		 local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		 if fc then
			 Duel.SendtoGrave(fc,REASON_RULE)
			 Duel.BreakEffect()
		 end
			 Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c99933311.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99933311.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x333) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsImmuneToEffect(e)
end