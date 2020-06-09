--军火教官
function c92020.initial_effect(c)
	 c:EnableCounterPermit(0x34)
	 c:SetCounterLimit(0x34,3)

	--self destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetCondition(c92020.sdcon)
	c:RegisterEffect(e9)


--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c92020.addct)
	e1:SetOperation(c92020.addc)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92020,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c92020.cost)
	e2:SetCountLimit(1)
	e2:SetTarget(c92020.drtg)
	e2:SetOperation(c92020.drop)
	c:RegisterEffect(e2)

	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(92020,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c92020.cost)
	e4:SetTarget(c92020.sptg)
	e4:SetOperation(c92020.spop)
	c:RegisterEffect(e4)

end
c92020.counter_add_list={0x34}
function c92020.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x34)
end
function c92020.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34,2)
	end
end

function c92020.filter(c)
	return c:IsCode(92011,92012,92013,92014,92015,92016,92017,92020,92023) and c:IsDiscardable(REASON_EFFECT)
end
function c92020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c92020.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c92020.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c92020.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


function c92020.thfilter1(c)
	return c:IsFaceup() and c:IsCode(92016) and c:IsAbleToGrave()
end
function c92020.thfilter2(c)
	return c:IsFaceup() and c:IsCode(92016) and c:IsAbleToGrave() and c:GetSequence()<5
end
function c92020.spfilter(c,e,tp)
	return c:IsCode(92011,92020,92018,92019,92021,92022,92023) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c92020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local b=false
		if ft>0 then
			b=Duel.IsExistingTarget(c92020.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		else
			b=Duel.IsExistingTarget(c92020.thfilter2,tp,LOCATION_MZONE,0,1,nil)
		end
		return b and Duel.IsExistingTarget(c92020.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ft>0 then
		g1=Duel.SelectTarget(tp,c92020.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	else
		g1=Duel.SelectTarget(tp,c92020.thfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c92020.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c92020.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0
		and tc1:IsLocation(LOCATION_GRAVE) and tc2:IsRelateToEffect(e)
		and aux.NecroValleyFilter()(tc2) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c92020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x34,1,REASON_COST)
end


function c92020.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x9201)
end

function c92020.sdcon(e)
	return Duel.IsExistingMatchingCard(c92020.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end