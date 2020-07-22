--SCP-173
function c789654325.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,789654320,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),1,true,true)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(789654325,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,789654325)
	e4:SetCondition(c789654325.seqcon)
	e4:SetTarget(c789654325.seqtg)
	e4:SetOperation(c789654325.seqop)
	c:RegisterEffect(e4)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(c789654325.rdcon)
	e3:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e3)
end
function c789654325.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<5
end
function c789654325.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
	local pseq=c:GetSequence()
	if pseq>seq then pseq,seq=seq,pseq end
	local dg=Group.CreateGroup()
	local g=nil
	local exg=nil
	for i=pseq,seq do
		g=Duel.GetMatchingGroup(c789654325.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp,i)
		dg:Merge(g)
		if i==1 or i==3 then
			exg=Duel.GetMatchingGroup(c789654325.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,tp,i)
			dg:Merge(exg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c789654325.seqfilter(c,tp,seq)
	if c:IsControler(tp) then
		return c:GetSequence()==seq
	else
		return c:GetSequence()==4-seq
	end
end
function c789654325.exfilter(c,tp,seq)
	if seq==1 then seq=5 end
	if seq==3 then seq=6 end
	if c:IsControler(tp) then
		return c:GetSequence()==seq
	else
		return c:GetSequence()==11-seq
	end
end
function c789654325.seqop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or not Duel.CheckLocation(tp,LOCATION_MZONE,seq) then return end
	local pseq=c:GetSequence()
	if pseq>4 then return end
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		if pseq>seq then pseq,seq=seq,pseq end
		local dg=Group.CreateGroup()
		local g=nil
		local exg=nil
		for i=pseq,seq do
			g=Duel.GetMatchingGroup(c789654325.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp,i)
			dg:Merge(g)
			if i==1 or i==3 then
				exg=Duel.GetMatchingGroup(c789654325.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,tp,i)
				dg:Merge(exg)
			end
		end
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c789654325.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
