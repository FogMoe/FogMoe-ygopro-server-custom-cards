--灰 烬 骑 士  零 一 
function c14370019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14370019+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--act in set turn
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c14370019.actcon)
	c:RegisterEffect(e4)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14370019,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c14370019.thtg)
	e2:SetOperation(c14370019.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14370019,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,14370020)
	e3:SetCondition(c14370019.spcon)
	e3:SetTarget(c14370019.sptg)
	e3:SetOperation(c14370019.spop)
	c:RegisterEffect(e3)
end
--e4
function c14370019.actcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil,TYPE_SPELL)
end
--e2
function c14370019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c14370019.thop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local tg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if ((opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP))) and tc:IsSetCard(0x1437) and tc:IsAbleToHand() then
		   tg:AddCard(tc)
		end
	end
	if tg:GetCount()>0 then
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end
	Duel.ShuffleDeck(tp)
end
--e3
function c14370019.spfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x1437)
end
function c14370019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14370019.spfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c14370019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,14370019,0x1437,0x11,1500,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14370019.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1437) and not c:IsSetCard(0x1438)
end
function c14370019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,14370019,0x1437,0x11,1500,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_NORMAL)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c14370019.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(14370019,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end