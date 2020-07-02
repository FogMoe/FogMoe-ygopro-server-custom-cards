local m=94180
local cm=_G["c"..m]
cm.name="逆转炼成阵"
function cm.initial_effect(c)
		--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.chcon)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsSetCard(0x9400) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-tp
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(1-tp,cm.cfilter,1,1,nil)
	Duel.Release(g,REASON_EFFECT)
end