--灰 烬 皇  亚 蒙 
function c14370043.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1437),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14370043,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,14370043)
	e1:SetCost(c14370043.thcost)
	e1:SetTarget(c14370043.target)
	e1:SetOperation(c14370043.activate)
	c:RegisterEffect(e1)
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(14370043,2))
	ea:SetCategory(CATEGORY_CONTROL)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCountLimit(1)
	ea:SetCost(c14370043.cost)
	ea:SetTarget(c14370043.ntrtg)
	ea:SetOperation(c14370043.ntrop)
	c:RegisterEffect(ea)
end
--e1
function c14370043.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14370043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c14370043.filter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x1437)
end
function c14370043.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c14370043.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(14370043,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c14370043.filter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,2)
	else Duel.SortDecktop(tp,tp,3) end
end
--ea
function c14370043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c14370043.filter3(c,check)
	return c:IsControlerCanBeChanged(check)
end
function c14370043.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=e:GetLabel()==100
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c14370043.filter3,tp,0,LOCATION_MZONE,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c14370043.filter2(c)
	return c:IsControlerCanBeChanged()
end
function c14370043.ntrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c14370043.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
end
