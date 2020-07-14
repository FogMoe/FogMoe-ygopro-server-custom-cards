local m=14230031
local cm=_G["c"..m]
cm.name="乘浪而来"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function cm.rfilter(c,tp)
	return c:IsSetCard(0x5aaf) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheckrel,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,aux.mzctcheckrel,false,2,2,tp)
	Duel.Release(g,REASON_COST)
end
function cm.spfilter(c,tc,e,tp)
	return c:IsSetCard(0x5aaf) and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
