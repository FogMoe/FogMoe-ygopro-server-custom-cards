--铃树社的仪舞姬·月伶
function c99933314.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c99933314.matfilter1,nil,nil,aux.NonTuner(c99933314.matfilter2),1,99)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99933314,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(c99933314.desreptg)
	e1:SetValue(c99933314.desrepval)
	e1:SetOperation(c99933314.desrepop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,99933314)
	e2:SetCondition(c99933314.condition)
	e2:SetTarget(c99933314.target)
	e2:SetOperation(c99933314.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,99933314+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c99933314.spcon)
	e3:SetCost(c99933314.spcost)
	e3:SetTarget(c99933314.sptg)
	e3:SetOperation(c99933314.spop)
	c:RegisterEffect(e3)
end
function c99933314.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsCode(99933304))
end
function c99933314.matfilter2(c)
	return c:IsSetCard(0x333) or (c:IsCode(99933399)) or (c:IsCode(99933398))
end
function c99933314.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x333) and c:IsPosition(POS_FACEUP)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c99933314.cfilter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x333) and c:IsAbleToRemoveAsCost()
end
function c99933314.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c99933314.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c99933314.cfilter1,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c99933314.desrepval(e,c)
	return c99933314.repfilter(c,e:GetHandlerPlayer())
end
function c99933314.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99933314.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c99933314.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933314.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c99933314.cfilter2,tp,LOCATION_FZONE,0,1,nil) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c99933314.filter(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c99933314.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933314.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99933314.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99933314.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99933314.cfilter3(c,tp)
	return c:IsSetCard(0x333) and c:IsLevelAbove(5) and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c99933314.cfilter4(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x333) and c:IsAbleToRemoveAsCost()
end
function c99933314.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c99933314.cfilter3,1,nil,tp)
end
function c99933314.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933314.cfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c99933314.cfilter4,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g1=Duel.SelectMatchingCard(tp,c99933314.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		  g2=Duel.SelectMatchingCard(tp,c99933314.cfilter4,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
end
function c99933314.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99933314.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end