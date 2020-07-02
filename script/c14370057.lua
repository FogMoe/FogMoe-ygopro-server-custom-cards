--灰 烬 皇  巴 耶 力 
function c14370057.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c14370057.ovfilter,aux.Stringid(14370057,2))
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c14370057.spcost)
	e2:SetTarget(c14370057.sptg)
	e2:SetOperation(c14370057.spop)
	c:RegisterEffect(e2)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c14370057.indcon)
	e4:SetValue(aux.indoval)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c14370057.aclimit1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_NEGATED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c14370057.aclimit2)
	c:RegisterEffect(e6)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetCondition(c14370057.econ)
	e8:SetValue(c14370057.elimit)
	c:RegisterEffect(e8)
end
--XYZ
function c14370057.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1437) and c:IsRank(4) and c:IsType(TYPE_XYZ)
end
--e2
function c14370057.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14370057.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and not c:IsCode(14370057) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14370057.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14370057.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c14370057.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c14370057.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e4
function c14370057.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
--e5/6/8
function c14370057.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(14370057,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c14370057.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(14370057)
end
function c14370057.econ(e)
	return e:GetHandler():GetFlagEffect(14370057)~=0
end
function c14370057.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end