local m=82207009
local cm=_G["c"..m]
cm.name="三骑士"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m) 
	--cannot special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	c:RegisterEffect(e1)  
	--disable  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)  
	e2:SetTarget(cm.disable)  
	e2:SetCode(EFFECT_DISABLE)  
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)>2  
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function cm.disable(e,c) 
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT or not c:IsType(TYPE_MONSTER)) and c~=e:GetHandler() and math.abs(ct1-ct2)<=1  
end 