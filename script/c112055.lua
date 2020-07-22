--湮灭的The One
function c112055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112048)
	e1:SetCondition(c112055.accon)
	e1:SetOperation(c112055.activate)
	c:RegisterEffect(e1)	   
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11204899)
	e2:SetCost(c112055.aucost)
	e2:SetTarget(c112055.autg)
	e2:SetOperation(c112055.auop)
	c:RegisterEffect(e2)
end
function c112055.thfilter(c)
	return c:IsSetCard(0xa007) and c:IsAbleToHand()
end
function c112055.accon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c112055.thfilter,tp,LOCATION_DECK,0,nil)
	return g:GetCount()>0
end
function c112055.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c112055.thfilter,tp,LOCATION_DECK,0,nil)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c112055.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end 
function c112055.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c112055.cofil(c)
	return c:IsAbleToGraveAsCost()
end
function c112055.aucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112055.cofil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c112055.cofil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c112055.autg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsSetCard(0xa007) end
end
function c112055.auop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xa007)
	local tc=g:GetFirst()
	while tc do 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
end







