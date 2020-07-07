--墓碑
function c33796543.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33796543+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_SZONE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e11:SetCountLimit(1,33796543)   
	e11:SetTarget(c33796543.sptarget)
	e11:SetOperation(c33796543.activate)
	c:RegisterEffect(e11)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c33796543.target)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c33796543.target)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD)
	e33:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e33:SetRange(LOCATION_SZONE)
	e33:SetTargetRange(LOCATION_MZONE,0)
	e33:SetTarget(c33796543.rdtg)
	e33:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e33)
end
function c33796543.filter(c,e,tp)
	return c:IsSetCard(0x650) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c33796543.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33796543.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33796543.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33796543.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33796543.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c33796543.target(e,c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x650)
end
function c33796543.rdtg(e,c)
	return c:IsSetCard(0x650)
end
