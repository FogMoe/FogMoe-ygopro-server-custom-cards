--犬与老鼠-Spike and Jerry
function c88576000.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xaa0),1)
	c:EnableReviveLimit()
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88576000,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,88576000)
	e2:SetCondition(c88576000.atkcon)
	e2:SetTarget(c88576000.atktg)
	e2:SetOperation(c88576000.atkop)
	c:RegisterEffect(e2)
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e22:SetProperty(EFFECT_FLAG_DELAY)
	e22:SetCode(EVENT_DESTROYED)
	e22:SetCountLimit(1,88576000)
	e22:SetCondition(c88576000.thcon)
	e22:SetTarget(c88576000.thtg)
	e22:SetOperation(c88576000.thop)
	c:RegisterEffect(e22)
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EFFECT_CANNOT_RELEASE)
	e21:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e21:SetTargetRange(1,1)
	c:RegisterEffect(e21)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c88576000.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return Duel.GetAttacker()==c and aux.bdgcon(e,tp,eg,ep,ev,re,r,rp) and bc:IsType(TYPE_EFFECT)
end
function c88576000.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
end
function c88576000.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToBattle() and c:IsFaceup() then
		if tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e3)
	end
end
function c88576000.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function c88576000.thfilter(c)
	return c:IsSetCard(0xaa0) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c88576000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88576000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88576000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88576000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

