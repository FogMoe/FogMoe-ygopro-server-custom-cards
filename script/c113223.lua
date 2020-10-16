local m=113223
local cm=_G["c"..m]
cm.name="鲨鱼娘Mio 炮击"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcad),cm.mtfilter)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.hspcon)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--aaaaaaaaaa
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.atktg)
	e6:SetOperation(cm.atkop)
	c:RegisterEffect(e6)
end
function cm.mtfilter(c)
	return c:GetBaseAttack()>=2000 and c:IsFusionType(TYPE_EFFECT)
end
function cm.hspfilter(c,tp,sc)
	return c:IsSetCard(0xcad) and c:IsType(TYPE_MONSTER) and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0 and c:IsAbleToRemoveAsCost()
end
function cm.hsp2filter(c,tp,sc)
	return c:GetBaseAttack()>=2000 and c:IsType(TYPE_EFFECT) and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0 and c:IsAbleToRemoveAsCost()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local ag=Duel.GetMatchingGroup(cm.hspfilter,c:GetControler(),LOCATION_GRAVE,0,nil,c:GetControler(),c)
	local ac=ag:GetFirst()
	local bg=Duel.GetMatchingGroup(cm.hspfilter,c:GetControler(),LOCATION_GRAVE,0,ac,c:GetControler(),c)
	return ag:GetCount()~=0 and bg:GetCount()~=0
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ag=Duel.SelectMatchingCard(c:GetControler(),cm.hspfilter,c:GetControler(),LOCATION_GRAVE,0,1,1,nil,c:GetControler(),c)
	local ac=ag:GetFirst()
	local bg=Duel.SelectMatchingCard(c:GetControler(),cm.hsp2filter,c:GetControler(),LOCATION_GRAVE,0,1,1,ac,c:GetControler(),c)
	ag:Merge(bg)
	Duel.Remove(ag,POS_FACEUP,REASON_COST)
end
function cm.desfilter(c)
	return c:IsFaceup()
end
function cm.des2filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.tdfilter(c)
	return c:IsSetCard(0xcad) and c:IsAbleToDeck()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()~=0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
	end
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.des2filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.des2filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end