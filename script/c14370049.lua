--灰 烬 皇  盖 提 亚 
function c14370049.initial_effect(c)
	c:SetSPSummonOnce(14370049)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c14370049.lcheck)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99936323,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,14370049)
	e1:SetCondition(c14370049.thcon)
	e1:SetTarget(c14370049.thtg)
	e1:SetOperation(c14370049.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c14370049.regcon)
	e2:SetOperation(c14370049.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c14370049.regcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14370049,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CUSTOM+14370049)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c14370049.sptg)
	e4:SetOperation(c14370049.spop)
	c:RegisterEffect(e4)
end
function c14370049.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_MACHINE)
end
--e1
function c14370049.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c14370049.thfilter(c)
	return c:IsCode(14370001) and c:IsAbleToHand()
end
function c14370049.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14370049.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14370049.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14370049.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e4
function c14370049.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c14370049.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14370049.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c14370049.cfilter2(c,tp,zone)
	return not c:IsReason(REASON_BATTLE) and c14370049.cfilter(c,tp,zone)
end
function c14370049.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14370049.cfilter2,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c14370049.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+14370049,e,0,tp,0,0)
end
function c14370049.spfilter1(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14370049.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14370049.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c14370049.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c14370049.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c14370049.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local ea=Effect.CreateEffect(c)
		ea:SetType(EFFECT_TYPE_SINGLE)
		ea:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		ea:SetValue(1)
		ea:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(ea)
	end
	Duel.SpecialSummonComplete()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c14370049.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c14370049.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end