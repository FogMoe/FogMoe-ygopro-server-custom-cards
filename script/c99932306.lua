--蟑蠊族的猛进
function c99932306.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99932306.condition)
	e2:SetOperation(c99932306.operation)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c99932306.damtg)
	e3:SetOperation(c99932306.damop)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c99932306.mtcon)
	e4:SetOperation(c99932306.mtop)
	c:RegisterEffect(e4)
end
function c99932306.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c99932306.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99932306.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end
function c99932306.dfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(2000) and c:IsRace(RACE_INSECT)
end
function c99932306.operation(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c99932306.dfilter,tp,LOCATION_MZONE,0,nil)
	local tc=dg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=dg:GetNext()
	end
end
function c99932306.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323) and c:IsType(TYPE_MONSTER)
end
function c99932306.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99932306.damfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	local dam=Duel.GetMatchingGroupCount(c99932306.damfilter,tp,LOCATION_REMOVED,0,nil,tp)*300
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c99932306.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c99932306.damfilter,tp,LOCATION_REMOVED,0,nil,tp)*300
	Duel.Damage(p,d,REASON_EFFECT)
end
function c99932306.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99932306.cfilter1(c)
	return c:IsRace(RACE_INSECT) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c99932306.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(c99932306.cfilter1,tp,LOCATION_REMOVED,0,nil)
	local sel=1
	if g:GetCount()~=0 then
		sel=Duel.SelectOption(tp,aux.Stringid(99932306,0),aux.Stringid(99932306,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(99932306,1))+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(tg,nil,2,REASON_COST)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
