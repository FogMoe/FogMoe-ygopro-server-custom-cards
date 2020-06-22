--灰 烬 少 女  艾 莉 丝 
function c14370010.initial_effect(c)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14370010,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,14370011)
	e2:SetOperation(c14370010.activate)
	c:RegisterEffect(e2)
	local ea=e2:Clone()
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(ea)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14370010,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,14370012)
	e1:SetCondition(c14370010.tgcon)
	e1:SetTarget(c14370010.tgtg)
	e1:SetOperation(c14370010.tgop)
	c:RegisterEffect(e1)
end
--e1
function c14370010.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1437)
end
function c14370010.tgfilter(c)
	return c:IsSetCard(0x1437) and c:IsAbleToGrave()
end
function c14370010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14370010.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c14370010.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14370010.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--e2
function c14370010.filter1(c,tp)
	return c:IsDiscardable() and ((c14370010.filter2(c) and c:IsAbleToGraveAsCost())
		or Duel.IsExistingMatchingCard(c14370010.filter2,tp,LOCATION_GRAVE,0,1,c))
end
function c14370010.filter2(c)
	return c:IsSetCard(0x1437) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL))  and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c14370010.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c14370010.filter2),tp,LOCATION_GRAVE,0,1,1,nil)
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
		e2:SetTarget(c14370010.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c14370010.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end