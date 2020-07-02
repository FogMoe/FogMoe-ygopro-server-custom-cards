--灰 烬 皇  巴 巴 托 斯 
function c14370037.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c14370037.ovfilter,aux.Stringid(14370037,2))
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c14370037.immval)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14370037,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,14370037)
	e3:SetCost(c14370037.atkcost)
	e3:SetOperation(c14370037.atkop)
	c:RegisterEffect(e3)
	--Activate(summon)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(14370037,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE,TIMING_DRAW_PHASE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,14370038)
	e6:SetCost(c14370037.cost)
	e6:SetOperation(c14370037.spop)
	c:RegisterEffect(e6) 
end
--XYZ
function c14370037.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1437) and c:IsRank(4) and c:IsType(TYPE_XYZ)
end
--e2
function c14370037.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and te:GetOwner():GetAttack()<=e:GetHandler():GetAttack() and te:IsActivated()
end
--e3
function c14370037.cfilter(c)
	return c:IsSetCard(0x1437) and c:IsAbleToRemoveAsCost()
end
function c14370037.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14370037.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c14370037.cfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14370037.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
--e6
function c14370037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c14370037.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c14370037.actlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	--local e4=e3:Clone()
	--e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e4:SetValue(c14370037.actlimit1)
	--Duel.RegisterEffect(e4,tp)
end
function c14370037.actlimit(e,c)
	return c:IsAttackBelow(e:GetHandler():GetAttack())
end
--function c14370037.actlimit1(e,re,tp)
--  return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
--end