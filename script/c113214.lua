--奔跑鲨鱼
function c113214.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(113214,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c113214.exscon)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(c113214.exstg)
	c:RegisterEffect(e1) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,113214)
	e2:SetTarget(c113214.reptg)
	e2:SetValue(c113214.repval)
	e2:SetOperation(c113214.repop)
	c:RegisterEffect(e2)
end
function c113214.exscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4
end
function c113214.exstg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(2)
end
function c113214.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and e:GetHandler():GetSequence()==2 and eg:IsContains(e:GetHandler()) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c113214.repval(e,c)
	return e:GetHandler()
end
function c113214.thfil(c)
	return c:IsSetCard(0xcad) and c:IsAbleToHand()
end
function c113214.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT+REASON_REPLACE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c113214.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(c113214.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(113214,1)) then
	local g=Duel.SelectMatchingCard(tp,c113214.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end
function c113214.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and not c:IsAttribute(ATTRIBUTE_WATER)
end








