--灰 烬 少 女  莉 莉 
function c14370007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,14370007)
	e1:SetCondition(c14370007.sprcon)
	e1:SetOperation(c14370007.sprop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14370007,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,14370008)
	e2:SetOperation(c14370007.activate)
	c:RegisterEffect(e2)
	local ea=e2:Clone()
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(ea)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14370007,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c14370007.drcon)
	e3:SetTarget(c14370007.drtg)
	e3:SetOperation(c14370007.drop)
	c:RegisterEffect(e3) 
end
--e1
function c14370007.spcfilter(c)
	return c:IsSetCard(0x1437) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and not c:IsPublic()
end
function c14370007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14370007.spcfilter,tp,LOCATION_HAND,0,1,nil)
end
function c14370007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c14370007.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--e2
function c14370007.filter1(c,tp)
	return c:IsDiscardable() and ((c14370007.filter2(c) and c:IsAbleToGraveAsCost())
		or Duel.IsExistingMatchingCard(c14370007.filter2,tp,LOCATION_DECK,0,1,c))
end
function c14370007.filter2(c)
	return c:IsSetCard(0x1437) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsType(TYPE_CONTINUOUS)  and c:IsSSetable()
end
function c14370007.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c14370007.filter2),tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c14370007.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c14370007.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
--e3
function c14370007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1437)
end
function c14370007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c14370007.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
end