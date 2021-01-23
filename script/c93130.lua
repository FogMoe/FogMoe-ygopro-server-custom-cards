--变异毒株 
function c93130.initial_effect(c)
	aux.EnablePendulumAttribute(c)

	--disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93130,2))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,93130)
	e1:SetCondition(c93130.spcon)
	e1:SetTarget(c93130.thtg)
	e1:SetOperation(c93130.thop)
	c:RegisterEffect(e1)
	--selfdestroy
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c93130.condition1)
	e3:SetCode(EFFECT_SELF_DESTROY)
	c:RegisterEffect(e3)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(93130,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,93131)
	e5:SetCondition(c93130.pencon)
	e5:SetTarget(c93130.pentg)
	e5:SetOperation(c93130.penop)
	c:RegisterEffect(e5)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c93130.atkval)
	c:RegisterEffect(e4)
end
----------------------------------------
function c93130.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x9202) and c:IsType(TYPE_PENDULUM)
end
function c93130.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c93130.cfilter,1,nil,tp)
end
-----------------------------------------
function c93130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,3,0,LOCATION_DECK)
end
function c93130.thfilter(c)
	return c:IsSetCard(0x9202) and c:IsAbleToExtra() and c:IsType(TYPE_PENDULUM)
end
function c93130.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 and g:IsExists(c93130.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(93130,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SELF)
		local sg=g:FilterSelect(p,c93130.thfilter,1,3,nil)
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		
	end
	Duel.ShuffleDeck(p)
end
----------------------------------------
function c93130.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
----------------------------------------
function c93130.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsReason(REASON_EFFECT)
end
function c93130.spfilter(c,e,tp,code)
	return c:IsSetCard(0x9202) and not c:IsCode(93130) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93130.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c93130.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93130.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
-----------------------------------------
function c93130.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9202)
end
function c93130.atkval(e,c)
	return Duel.GetMatchingGroupCount(c93130.afilter,c:GetControler(),LOCATION_EXTRA,0,nil)*200
end