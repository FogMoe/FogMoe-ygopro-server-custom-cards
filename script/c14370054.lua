--灰 烬 皇 的 复 活 
function c14370054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,14370054+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c14370054.activate)
	c:RegisterEffect(e1)
	if c14370054.counter==nil then
		c14370054.counter=true
		c14370054[0]=0
		c14370054[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c14370054.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(c14370054.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetOperation(c14370054.addcount)
		Duel.RegisterEffect(e4,0)
	end
	--to hand
	local ea=Effect.CreateEffect(c)
	ea:SetCategory(CATEGORY_TOHAND)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ea:SetCode(EVENT_PHASE+PHASE_END)
	ea:SetCountLimit(1,14370054)
	ea:SetRange(LOCATION_GRAVE)
	ea:SetCondition(c14370054.thcon)
	ea:SetTarget(c14370054.thtg)
	ea:SetOperation(c14370054.thop)
	--c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCondition(aux.exccon)
	c:RegisterEffect(eb)
end
--Activate
function c14370054.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c14370054[0]=0
	c14370054[1]=0
end
function c14370054.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_ONFIELD and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1437) then
			local p=tc:GetControler()
			c14370054[p]=c14370054[p]+1
		elseif pl==LOCATION_HAND and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1437) then
			local p=tc:GetControler()
			c14370054[p]=c14370054[p]+1
		elseif pl==LOCATION_GRAVE and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1437) then
			local p=tc:GetControler()
			c14370054[p]=c14370054[p]+1
		elseif pl==LOCATION_REMOVED and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1437) then
			local p=tc:GetControler()
			c14370054[p]=c14370054[p]+1
		elseif pl==LOCATION_MZONE and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1437) then
			local p=tc:GetPreviousControler()
			c14370054[p]=c14370054[p]+1
		end
		tc=eg:GetNext()
	end
end
function c14370054.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c14370054.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c14370054.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,14370054)
	Duel.Draw(tp,c14370054[tp],REASON_RULE)
	Duel.ShuffleHand(p)
end
--ea
function c14370054.rccfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x1437)
end
function c14370054.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c14370054.rccfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c14370054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c14370054.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
