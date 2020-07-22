--SCP-096
function c789654330.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,789654320,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),1,true,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(789654330,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c789654330.destg)
	e3:SetOperation(c789654330.desop)
	c:RegisterEffect(e3)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetOperation(c789654330.disop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c789654330.efilter1)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_SINGLE)
	e33:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e33:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e33:SetRange(LOCATION_MZONE)
	e33:SetValue(c789654330.efilter2)
	c:RegisterEffect(e33)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(789654330,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c789654330.postg)
	e3:SetOperation(c789654330.posop)
	c:RegisterEffect(e3)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e22)
end
function c789654330.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and d:IsControler(1-tp) and d:IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function c789654330.posop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() then
		Duel.ChangePosition(d,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c789654330.ffilter(c)
	return c:IsFusionType(TYPE_SYNCHRO) and not c:IsFusionType(TYPE_EFFECT)
end
function c789654330.efilter1(e,re,rp)
	return re:IsActiveType(TYPE_EFFECT)
end
function c789654330.efilter2(e,re)
	return re:IsActiveType(TYPE_EFFECT)
end
function c789654330.desfilter(c,g)
	return g:IsContains(c)
end
function c789654330.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c789654330.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c789654330.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c789654330.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c789654330.disop(e,tp)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD)
end
