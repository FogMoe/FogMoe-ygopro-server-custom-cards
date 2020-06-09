--澪舞台的导士·柃
function c99933305.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,99933305)
	e1:SetCondition(c99933305.sprcon)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933305,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,89933305)
	e2:SetCondition(c99933305.condition)
	e2:SetTarget(c99933305.target)
	e2:SetOperation(c99933305.operation)
	c:RegisterEffect(e2)
end
function c99933305.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x333)
end
function c99933305.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99933305.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99933305.cfilter(c)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933305.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99933305.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c99933305.filter(c,e,tp)
	return c:IsSetCard(0x333) and c:IsAbleToGrave()
end
function c99933305.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933305.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c99933305.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99933305.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,3,nil)
	if g:GetCount()>0 then
		ct=Duel.SendtoGrave(g,REASON_EFFECT)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,ct*800,REASON_EFFECT)
		end
	end
end