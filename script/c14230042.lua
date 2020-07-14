local m=14230042
local cm=_G["c"..m]
cm.name="苍风圣妖 一目连"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,14230002,cm.sprfilter2,4,false,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5aaf))
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e90=Effect.CreateEffect(c)
	e90:SetType(EFFECT_TYPE_FIELD)
	e90:SetCode(EFFECT_CANNOT_RELEASE)
	e90:SetRange(LOCATION_MZONE)
	e90:SetTargetRange(LOCATION_MZONE,0)
	e90:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5aaf))
	e90:SetValue(1)
	c:RegisterEffect(e90)
	local e91=Effect.CreateEffect(c)
	e91:SetType(EFFECT_TYPE_FIELD)
	e91:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e91:SetRange(LOCATION_MZONE)
	e91:SetTargetRange(LOCATION_MZONE,0)
	e91:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5aaf))
	e91:SetValue(1)
	c:RegisterEffect(e91)
	local e81=Effect.CreateEffect(c)
	e81:SetType(EFFECT_TYPE_SINGLE)
	e81:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e81:SetCode(EFFECT_SPSUMMON_CONDITION)
	e81:SetValue(aux.fuslimit)
	c:RegisterEffect(e81)
	local e82=Effect.CreateEffect(c)
	e82:SetType(EFFECT_TYPE_FIELD)
	e82:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e82:SetCode(EFFECT_SPSUMMON_PROC)
	e82:SetRange(LOCATION_EXTRA)
	e82:SetDescription(aux.Stringid(m,0))
	e82:SetCondition(cm.sprcon)
	e82:SetOperation(cm.sprop)
	c:RegisterEffect(e82)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.necondition)
	e2:SetTarget(cm.netarget)
	e2:SetOperation(cm.neoperation)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
end
function cm.necondition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function cm.netarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.neoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_ONFIELD,0,nil) end
	local g=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.ctfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local e1=Effect.CreateEffect(g)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		g:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		g:RegisterEffect(e2)
	end
end
function cm.sprfilter1(c,sc)
	return c:IsCode(14230002)
end
function cm.sprfilter2(c,tp,sc)
	return c:IsSetCard(0x5aaf) and c:IsFusionType(TYPE_SYNCHRO) and not c:IsFusionCode(m)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil,c)
		and Duel.IsExistingMatchingCard(cm.sprfilter2,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,4,nil,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter2,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,4,4,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end