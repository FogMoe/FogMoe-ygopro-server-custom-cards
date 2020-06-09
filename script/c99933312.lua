--铃树社的大剑师·龙铭
function c99933312.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c99933312.matfilter1,nil,nil,aux.NonTuner(c99933312.matfilter2),1,99)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1 :SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99933312)
	e1:SetCondition(c99933312.condition)
	e1:SetTarget(c99933312.target)
	e1:SetOperation(c99933312.activate)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99933312,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99933312.atkcon)
	e2:SetCost(c99933312.atkcost)
	e2:SetOperation(c99933312.atkop)
	c:RegisterEffect(e2)
end
function c99933312.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsCode(99933304))
end
function c99933312.matfilter2(c)
	return c:IsSetCard(0x333) or (c:IsCode(99933399)) or (c:IsCode(99933398))
end
function c99933312.cfilter1(c,tp)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD)
end
function c99933312.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99933312.cfilter1,tp,LOCATION_GRAVE,0,3,nil,tp)
end
function c99933312.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99933312.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c99933312.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c99933312.cfilter2(c)
	return c:IsSetCard(0x333) and c:IsType(TYPE_FIELD) and c:IsAbleToRemoveAsCost()
end
function c99933312.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99933312.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99933312.cfilter2,tp,LOCATION_GRAVE,0,1,60,e:GetHandler())
	ac=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(ac)
end
function c99933312.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local ct=e:GetLabel()
		local sc=g:GetFirst()
		local c=e:GetHandler()
		local d=math.floor(ct/2)
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*-800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_EXTRA_ATTACK)
			e3:SetValue(d)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
		end
	end
end
