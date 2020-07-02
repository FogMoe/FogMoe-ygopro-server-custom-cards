--千年遗物-积木
function c88976545.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88976545+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88976545.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c88976545.atkvalue)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(88976545,0))
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTarget(c88976545.lptg)
	e12:SetOperation(c88976545.lpop)
	c:RegisterEffect(e12)
end
function c88976545.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x580) and c:IsAbleToHand() and not c:IsCode(88976545)
end
function c88976545.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c88976545.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88976545,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c88976545.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function c88976545.atkvalue(e,c)
	local g=Duel.GetMatchingGroup(c88976545.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetRace)
	return ct*200
end
function c88976545.lpfilter(c)
	return c:IsSetCard(0x580)
end
function c88976545.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c88976545.lpfilter,1,nil) end
end
function c88976545.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Recover(tp,500,REASON_EFFECT)
end
