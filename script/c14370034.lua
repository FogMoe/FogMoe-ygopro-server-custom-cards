--真 灰 烬 皇  所 罗 门 
function c14370034.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1437),4,2,nil,nil,5)
	c:EnableReviveLimit()
	--
	local ek=Effect.CreateEffect(c)
	ek:SetType(EFFECT_TYPE_SINGLE)
	ek:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ek:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	ek:SetValue(1)
	c:RegisterEffect(ek)
	--remove material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14370034,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c14370034.rmcon)
	e1:SetOperation(c14370034.rmop)
	c:RegisterEffect(e1)
	--atkchange
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	eb:SetCode(EFFECT_UPDATE_ATTACK)
	eb:SetRange(LOCATION_MZONE)
	eb:SetCondition(c14370034.effcon)
	eb:SetLabel(2)
	eb:SetValue(2500)
	c:RegisterEffect(eb)
	local es=eb:Clone()
	es:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(es)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c14370034.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(4)
	e3:SetCondition(c14370034.damcon)
	e3:SetTarget(c14370034.damtg)
	e3:SetOperation(c14370034.damop)
	c:RegisterEffect(e3)
	--disable
	local eg=Effect.CreateEffect(c)
	eg:SetType(EFFECT_TYPE_FIELD)
	eg:SetRange(LOCATION_MZONE)
	eg:SetTargetRange(0,LOCATION_MZONE)
	eg:SetCode(EFFECT_DISABLE)
	eg:SetLabel(4)
	eg:SetCondition(c14370034.effcon)
	c:RegisterEffect(eg)
	--immune
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_IMMUNE_EFFECT)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetValue(c14370034.efilter)
	ea:SetCondition(c14370034.effcon)
	ea:SetLabel(3)
	c:RegisterEffect(ea)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(aux.indoval)
	e9:SetCondition(c14370034.effcon)
	e9:SetLabel(3)
	c:RegisterEffect(e9)
	--negate
	local ec=Effect.CreateEffect(c)
	ec:SetDescription(aux.Stringid(14370034,1))
	ec:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	ec:SetType(EFFECT_TYPE_QUICK_O)
	ec:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ec:SetCode(EVENT_CHAINING)
	ec:SetRange(LOCATION_MZONE)
	ec:SetLabel(1)
	ec:SetCondition(c14370034.negcon)
	ec:SetCost(c14370034.negcost)
	ec:SetTarget(c14370034.negtg)
	ec:SetOperation(c14370034.negop)
	local ed=ec:Clone()
	ed:SetCondition(c14370034.effcon)
	c:RegisterEffect(ed)
	--remove
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(14370034,0))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetLabel(5)
	e8:SetCondition(c14370034.effcon)
	e8:SetTarget(c14370034.rmtg2)
	e8:SetOperation(c14370034.rmop2)
	c:RegisterEffect(e8)
	--cannot release
	local ew=Effect.CreateEffect(c)
	ew:SetType(EFFECT_TYPE_SINGLE)
	ew:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ew:SetRange(LOCATION_MZONE)
	ew:SetCode(EFFECT_UNRELEASABLE_SUM)
	ew:SetValue(1)
	ew:SetLabel(3)
	ew:SetCondition(c14370034.effcon)
	c:RegisterEffect(ew)
	local ex=ew:Clone()
	ex:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(ex)
end
--ea
function c14370034.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
--e1
function c14370034.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c14370034.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
--eb
function c14370034.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
--e2
function c14370034.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>=e:GetLabel() and ep~=tp and c:GetFlagEffect(14370034)~=0
end
function c14370034.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(14370034,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c14370034.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>=0 end
	Duel.SetTargetPlayer(1-tp)
	local dam=ct*200
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c14370034.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*200
	Duel.Hint(HINT_CARD,0,14370034)
	Duel.Damage(p,dam,REASON_EFFECT)
end
--ec
function c14370034.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c14370034.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14370034.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c14370034.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--e8
function c14370034.rmfilter(c)
	return c:IsAbleToGrave()
end
function c14370034.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(14370034)==0
		and Duel.IsExistingMatchingCard(c14370034.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c14370034.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14370034.matfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanOverlay()
end
function c14370034.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c14370034.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup():Filter(c14370034.matfilter,nil)
		if og:GetCount()>0 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=og:Select(tp,1,1,nil)
			Duel.Overlay(c,sg)
		end
	end
end