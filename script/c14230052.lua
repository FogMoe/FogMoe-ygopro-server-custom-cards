local m=14230052
local cm=_G["c"..m]
cm.name="九龙环城 曲"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetProperty(EFFECT_FLAG_ABSOLUTE_TARGET)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(cm.target)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetProperty(EFFECT_FLAG_ABSOLUTE_TARGET)
	e4:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetProperty(EFFECT_FLAG_ABSOLUTE_TARGET)
	e5:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_REMOVE)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetProperty(EFFECT_FLAG_ABSOLUTE_TARGET)
	e6:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	c:RegisterEffect(e6)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,5,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x58f,0x11,2000,2000,8,RACE_MACHINE,ATTRIBUTE_WIND) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x58f,0x11,2000,2000,8,RACE_MACHINE,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end