--灰 烬 骑 士  基 尔 德 
function c14370022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14370022+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14370022,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,14370022)
	e2:SetTarget(c14370022.target)
	e2:SetOperation(c14370022.operation)
	c:RegisterEffect(e2)
	--act in set turn
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c14370022.actcon)
	c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14370022,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,14370023)
	e3:SetCondition(c14370022.spcon)
	e3:SetTarget(c14370022.sptg)
	e3:SetOperation(c14370022.spop)
	c:RegisterEffect(e3)
end
--e4
function c14370022.actcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil,TYPE_SPELL)
end
--e2
function c14370022.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c14370022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and c14370022.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14370022.cfilter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14370022,2))
	local g=Duel.SelectTarget(tp,c14370022.cfilter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	g:GetFirst():RegisterFlagEffect(14370023,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,cid)
end
function c14370022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) and tc:GetFlagEffectLabel(14370023)==cid then
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		c:ResetFlagEffect(14370022)
		tc:ResetFlagEffect(14370022)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(14370022,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(14370022,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e1:SetLabelObject(tc)
		e1:SetCondition(c14370022.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		--End of e1
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e2:SetLabel(fid)
		e2:SetLabelObject(e1)
		e2:SetCondition(c14370022.rstcon)
		e2:SetOperation(c14370022.rstop)
		Duel.RegisterEffect(e2,tp)
		--send to grave
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c14370022.agcon)
		e3:SetOperation(c14370022.agop)
		Duel.RegisterEffect(e3,1-tp)
		--activate check
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_CHAINING)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e4:SetLabel(fid)
		e4:SetLabelObject(e3)
		e4:SetOperation(c14370022.rstop2)
		Duel.RegisterEffect(e4,tp)
	end
end
function c14370022.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandler():GetFlagEffect(14370022)~=0
end
function c14370022.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffectLabel(14370022)==e:GetLabel()
		and c:GetFlagEffectLabel(14370022)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function c14370022.rstop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
end
function c14370022.agcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(14370022)==e:GetLabel()
		and c:GetFlagEffectLabel(14370022)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function c14370022.agop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_RULE)
end
function c14370022.rstop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffectLabel(14370022)~=e:GetLabel() then return end
	local c=e:GetHandler()
	c:CancelCardTarget(tc)
	local te=e:GetLabelObject()
	tc:ResetFlagEffect(14370022)
	if te then te:Reset() end
end
--e3
function c14370022.spfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x1437)
end
function c14370022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14370022.spfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c14370022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,14370022,0x1437,0x11,1500,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14370022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1437) and not c:IsSetCard(0x1438)
end
function c14370022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,14370022,0x1437,0x11,1500,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c14370022.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(14370022,5)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end