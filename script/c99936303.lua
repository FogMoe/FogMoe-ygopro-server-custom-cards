--傀蚀书之因库
function c99936303.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99936303+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99936303,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99936303.setcon)
	e2:SetTarget(c99936303.settg)
	e2:SetOperation(c99936303.setop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99936303,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99936303.spcon)
	e3:SetCost(c99936303.cost)
	e3:SetTarget(c99936303.target)
	e3:SetOperation(c99936303.activate)
	c:RegisterEffect(e3)
end
function c99936303.filter1(c)
	return c:IsFacedown() or not c:IsSetCard(0x363)
end
function c99936303.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99936303.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99936303.cfilter(c)
	return c:IsSetCard(0x363) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSSetable() and not c:IsCode(99936303)
end
function c99936303.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c99936303.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c99936303.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c99936303.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,LOCATION_GRAVE+LOCATION_REMOVED,g,1,0,0)
end
function c99936303.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end
function c99936303.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
end
function c99936303.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99936303.filter2,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c99936303.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c99936303.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
		and (c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) or c:IsFaceup())
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP)
end
function c99936303.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsExistingMatchingCard(c99936303.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,99936303,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE)
end
function c99936303.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,99936303,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK)) then return end
	local g=Duel.GetMatchingGroup(c99936303.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
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