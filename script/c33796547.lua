--海豚僵尸
function c33796547.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x650),2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c33796547.atkcon)
	e1:SetTarget(c33796547.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--untarget
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(33796547,0))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_BATTLE_START)
	e11:SetCountLimit(1)
	e11:SetTarget(c33796547.thtg)
	e11:SetOperation(c33796547.thop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c33796547.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c33796547.atktg(e,c)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return c==e:GetHandler() or g:IsContains(c)
end
function c33796547.tgtg(e,c)
	return c~=e:GetHandler()
end
function c33796547.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c33796547.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
