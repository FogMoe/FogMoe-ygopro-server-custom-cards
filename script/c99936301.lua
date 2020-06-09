--傀蚀书之梅茵塔
function c99936301.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99936301+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99936301,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99936301.thcon)
	e2:SetTarget(c99936301.thtg)
	e2:SetOperation(c99936301.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99936301,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99936301.spcon)
	e3:SetCost(c99936301.cost)
	e3:SetTarget(c99936301.target)
	e3:SetOperation(c99936301.activate)
	c:RegisterEffect(e3)
end
function c99936301.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x363)
end
function c99936301.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99936301.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99936301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99936301.thfilter(c)
	return c:IsSetCard(0x363) and c:IsAbleToHand()
end
function c99936301.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 and g:IsExists(c99936301.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(99936301,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c99936301.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		Duel.ShuffleHand(p)
	end
	Duel.ShuffleDeck(p)
end
function c99936301.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
end
function c99936301.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99936301.filter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c99936301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c99936301.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x363)
		and (c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) or c:IsFaceup())
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP)
end
function c99936301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsExistingMatchingCard(c99936301.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,99936301,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE)
end
function c99936301.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,99936301,0x363,0x11,1800,1800,4,RACE_FIEND,ATTRIBUTE_DARK)) then return end
	local g=Duel.GetMatchingGroup(c99936301.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
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