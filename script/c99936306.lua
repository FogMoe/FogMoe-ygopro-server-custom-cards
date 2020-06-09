--傀蚀书之傀造
function c99936306.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99936306+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99936306,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99936306.spcon1)
	e2:SetCost(c99936306.spcost)
	e2:SetTarget(c99936306.sptg)
	e2:SetOperation(c99936306.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99936306,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99936306.spcon)
	e3:SetCost(c99936306.cost)
	e3:SetTarget(c99936306.target)
	e3:SetOperation(c99936306.activate)
	c:RegisterEffect(e3)
end
function c99936306.filter(c)
	return c:IsFacedown() or not c:IsRace(RACE_FIEND)
end
function c99936306.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99936306.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c99936306.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function c99936306.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99936306.costfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99936306.costfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c99936306.filter1(c,ft,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_DARK)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c99936306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c99936306.filter1,tp,LOCATION_DECK,0,1,nil,ft,e,tp)
	end
end
function c99936306.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SelectMatchingCard(tp,c99936306.filter1,tp,LOCATION_DECK,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99936306.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99936306.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c99936306.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
end
function c99936306.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99936306.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c99936306.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c99936306.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
		and (c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) or c:IsFaceup())
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP)
end
function c99936306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsExistingMatchingCard(c99936306.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,99936306,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE)
end
function c99936306.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,99936306,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK)) then return end
	local g=Duel.GetMatchingGroup(c99936306.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
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