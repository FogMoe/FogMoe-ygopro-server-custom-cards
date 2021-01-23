--变异毒株温床
function c93180.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,93180+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c93180.target)
	e1:SetOperation(c93180.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93180,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c93180.starget)
	e2:SetOperation(c93180.soperation)
	c:RegisterEffect(e2)
-------
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93180,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c93180.destg)
	e3:SetOperation(c93180.desop)
	c:RegisterEffect(e3)

	--Activate4
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(93180,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,93180+EFFECT_COUNT_CODE_DUEL)
	e4:SetTarget(c93180.ftarget)
	e4:SetOperation(c93180.factivate)
	c:RegisterEffect(e4)
	
end
function c93180.filter(c)
	return c:IsSetCard(0x9202) and c:IsType(TYPE_MONSTER+TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c93180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93180.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c93180.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
	local g=Duel.SelectMatchingCard(tp,c93180.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		
	end
end

---

function c93180.sfilter(c,e,sp)
	return c:IsSetCard(0x9202) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c93180.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c93180.sfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	if Duel.GetLocationCountFromEx(tp)~=0
	then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
	else Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c93180.soperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.GetLocationCountFromEx(tp)~=0
	then  g=Duel.SelectMatchingCard(tp,c93180.sfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	else  g=Duel.SelectMatchingCard(tp,c93180.sfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
---------------------------------
function c93180.thfilter(c)
	return c:IsSetCard(0x9202) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c93180.tofilter(c)
	return c:IsSetCard(0x9202) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c93180.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c93180.tofilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c93180.tofilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c93180.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c93180.tofilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c93180.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c93180.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end



-------

function c93180.ffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0x9202)
	 and c:IsFaceup()
end
function c93180.ftarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c93180.ffilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c93180.ffilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c93180.ffilter,tp,LOCATION_EXTRA,0,3,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c93180.factivate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct>=3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
