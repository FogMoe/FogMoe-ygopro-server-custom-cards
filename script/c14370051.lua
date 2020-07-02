--灰 烬 骑 士  出 战 ！
function c14370051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c14370051.settg)
	e3:SetOperation(c14370051.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c14370051.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetOperation(c14370051.regop2)
	c:RegisterEffect(e5)
	--special summon
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ea:SetCode(EVENT_SPSUMMON_SUCCESS)
	ea:SetRange(LOCATION_SZONE)
	ea:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ea:SetTarget(c14370051.tktg1)
	ea:SetOperation(c14370051.tkop1)
	c:RegisterEffect(ea) 
	local eb=ea:Clone()
	eb:SetTarget(c14370051.tktg)
	eb:SetOperation(c14370051.tkop)
	eb:SetCountLimit(1)
	--c:RegisterEffect(eb) 
end
--e4
function c14370051.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x1437) and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(14370051)
		if flag then
			c:SetFlagEffectLabel(14370051,flag+1)
		else
			c:RegisterFlagEffect(14370051,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
end
function c14370051.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x1437) and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(14370051)
		if flag and flag>0 then
			c:SetFlagEffectLabel(14370051,flag-1)
		end
	end
end
function c14370051.setfilter(c)
	return c:IsSetCard(0x1437) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable() and not c:IsCode(14370051)
end
function c14370051.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(14370051)
	if chk==0 then return ct and ct>0 and Duel.IsExistingMatchingCard(c14370051.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c14370051.gselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and aux.dncheck(g) and #g-fc<=ft
end
function c14370051.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c14370051.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=e:GetHandler():GetFlagEffectLabel(14370051) or 0
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #g==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,c14370051.gselect,false,1,math.min(ct,ft+1),ft)
	if Duel.SSet(tp,tg)==0 then return end
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
--ea/b
function c14370051.atkfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0x1437)
end
function c14370051.tktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c14370051.atkfilter1(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c14370051.atkfilter1,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
	if eg:GetCount()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=eg:FilterSelect(tp,c14370051.atkfilter1,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
	end
end
function c14370051.tkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c14370051.atkfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and not c:IsSetCard(0x1437)
end
function c14370051.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c14370051.atkfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c14370051.atkfilter,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
	if eg:GetCount()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=eg:FilterSelect(tp,c14370051.atkfilter,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
	end
end
function c14370051.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end