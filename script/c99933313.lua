--铃树社的大教祀·米提奥尔
function c99933313.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c99933313.matfilter1,nil,nil,aux.NonTuner(c99933313.matfilter2),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c99933313.condition)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933313,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c99933313.negcon)
	e2:SetCost(c99933313.negcost)
	e2:SetTarget(c99933313.negtg)
	e2:SetOperation(c99933313.negop)
	c:RegisterEffect(e2)
end
function c99933313.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsCode(99933304))
end
function c99933313.matfilter2(c)
	return c:IsSetCard(0x333) or (c:IsCode(99933398)) or (c:IsCode(99933399))
end
function c99933313.cfilter1(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933313.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99933313.cfilter1,tp,LOCATION_GRAVE,0,3,nil,tp)
end
function c99933313.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c99933313.cfilter2(c,tp)
	return c:IsSetCard(0x333) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c99933313.cfilter3,0,LOCATION_GRAVE,LOCATION_GRAVE,1,c)
end
function c99933313.cfilter3(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsAbleToRemoveAsCost()
end
function c99933313.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933313.cfilter3,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c99933313.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g1=Duel.SelectMatchingCard(tp,c99933313.cfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
		  g2=Duel.SelectMatchingCard(tp,c99933313.cfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
end
function c99933313.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99933313.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end