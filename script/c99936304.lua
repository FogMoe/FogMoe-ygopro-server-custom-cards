--傀蚀书之穆萨瓦
function c99936304.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99936304+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99936304,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99936304.atkcon)
	e2:SetTarget(c99936304.atktg)
	e2:SetOperation(c99936304.atkop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99936304,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99936304.spcon)
	e3:SetCost(c99936304.cost)
	e3:SetTarget(c99936304.target)
	e3:SetOperation(c99936304.activate)
	c:RegisterEffect(e3)
end
function c99936304.filter(c)
	return c:IsFacedown() or not c:IsSetCard(0x363)
end
function c99936304.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99936304.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c99936304.atkfilter(c)
	return c:IsFaceup()
end
function c99936304.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c99936304.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c99936304.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99936304.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c99936304.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
end
function c99936304.atkop(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsRelateToEffect(e) and hc:IsFaceup() then
		local atk=hc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(atk/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		hc:RegisterEffect(e1)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			tc:RegisterEffect(e2)
		end
	end
end
function c99936304.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
end
function c99936304.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99936304.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c99936304.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c99936304.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
		and (c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) or c:IsFaceup())
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP)
end
function c99936304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsExistingMatchingCard(c99936304.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,99936304,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE)
end
function c99936304.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,99936304,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK)) then return end
	local g=Duel.GetMatchingGroup(c99936304.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tg=sg:GetFirst()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,0,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK) then
		tg:AddMonsterAttribute(TYPE_NORMAL)
		c:AddMonsterAttribute(TYPE_NORMAL)
		sg:AddCard(c)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end