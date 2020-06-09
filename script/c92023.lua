--军火后勤
function c92023.initial_effect(c)
	c:EnableCounterPermit(0x34)
	c:SetCounterLimit(0x34,3)

	--self destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetCondition(c92023.sdcon)
	c:RegisterEffect(e9)

	--summon success
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c92023.addct)
	e1:SetOperation(c92023.addc)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92023,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c92023.cost)
	e2:SetTarget(c92023.thtg)
	e2:SetOperation(c92023.thop)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c92023.sptg)
	e4:SetOperation(c92023.spop)
	c:RegisterEffect(e4)
end
c92023.counter_add_list={0x34}
function c92023.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x34)
end
function c92023.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34,1)
	end
end

function c92023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c92023.thfilter(c)
	return c:IsCode(92023,92011,92020) 
end
function c92023.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 and g:IsExists(c92023.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(92023,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(p,c92023.thfilter,1,1,nil)
		Duel.SpecialSummon(sg,SpecialSummon,tp,tp,false,false,POS_FACEUP_DEFENSE)
		
		
	end
	Duel.ShuffleDeck(p)
end

function c92023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x34,1,REASON_COST)
end


function c92023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,92024,nil,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c92023.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(1-tp,92024,nil,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,92024)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end


function c92023.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x9201)
end

function c92023.sdcon(e)
	return Duel.IsExistingMatchingCard(c92023.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end