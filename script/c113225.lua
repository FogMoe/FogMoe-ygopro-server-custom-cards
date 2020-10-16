local m=113225
local cm=_G["c"..m]
cm.name="鲨鱼娘 水之王-零尔"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	c:RegisterEffect(e3)
	--duel.buff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,113225+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(cm.buffcon)
	e4:SetOperation(cm.buffop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.negcon)
	e5:SetTarget(cm.negtg)
	e5:SetOperation(cm.negop)
	c:RegisterEffect(e5)
end
function cm.sprfilter(c)
	return c:IsSetCard(0xcad) and c:IsAbleToDeckAsCost()
end
function cm.sprcodefilter(c,cg,tp)
	return c:IsSetCard(0xcad) and c:IsAbleToDeckAsCost() and (cg:GetCount()==0 or not cg:IsExists(Card.IsCode,1,nil,c:GetCode()))
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=9 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local ag=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_GRAVE,0,nil)
	local x=0
	local g=Group.CreateGroup()
	while x<9 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local ac=Duel.SelectMatchingCard(tp,cm.sprcodefilter,tp,LOCATION_GRAVE,0,1,1,nil,g,tp):GetFirst()
		x=x+1
		g:AddCard(ac)
	end
	while ag:IsExists(cm.sprcodefilter,1,nil,g,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local ac=Duel.SelectMatchingCard(tp,cm.sprcodefilter,tp,LOCATION_GRAVE,0,1,1,nil,g,tp):GetFirst()
		g:AddCard(ac)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
end
function cm.buffcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.buffop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,113225,RESET_EVENT+0x1fe0000,0,99)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0xcad) and c:IsAbleToDeck()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
			if tc:IsFacedown() or not tc:IsPublic() then
				Duel.ConfirmCards(1-tp,tc)
			end
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end