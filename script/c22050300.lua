--悲叹的孵化者
function c22050300.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22050300.matfilter,1,1)
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22050300,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22050300)
	e5:SetTarget(c22050300.target)
	e5:SetOperation(c22050300.operation)
	c:RegisterEffect(e5)
end
function c22050300.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsSetCard(0xff8)
end
function c22050300.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1ff8) and c:IsCanBeFusionMaterial()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c22050300.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c22050300.spfilter(c,e,tp,tc)
	return aux.IsMaterialListCode(c,tc:GetCode()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c22050300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22050300.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22050300.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22050300.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22050300.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c22050300.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end