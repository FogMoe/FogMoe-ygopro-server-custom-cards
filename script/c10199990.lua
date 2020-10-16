--version 20.06.22
if not pcall(function() require("expansions/script/c10199991") end) then require("script/c10199991") end
local m=10199990
local vm=10199991
local Version_Number=20200714
-----------------------"Part_Effect_Base"-----------------------
--Creat "EVENT_SET"
function rsef.CreatEvent_Set()
	if rsef.CreatEvent_Set_Switch then return end
	rsef.CreatEvent_Set_Switch=true 
	local e1=rsef.FC({true,0},EVENT_MSET)
	e1:SetOperation(rsop.CreatEvent_Set)
	local e2=rsef.RegisterClone({true,0},e1,"code",EVENT_SSET)
	local e3=rsef.RegisterClone({true,0},e1,"code",EVENT_SPSUMMON_SUCCESS,"con",rscon.CreatEvent_Set)
	local e4=rsef.RegisterClone({true,0},e3,"code",EVENT_CHANGE_POS)
	return e1,e2,e3,e4
end
function rsop.CreatEvent_Set(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(Card.IsFacedown,nil)
	Duel.RaiseEvent(sg,rscode.Set,re,r,rp,ep,ev)
	for tc in aux.Next(sg) do
		Duel.RaiseSingleEvent(tc,rscode.Set,re,r,rp,ep,ev)
	end
end
function rscon.CreatEvent_Set(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end


--Effect: Get default hint string for Duel.Hint ,use in effect target
function rsef.GetDefaultHintString(cate_list,loc1,loc2,hint_list)
	if hint_list then 
		return type(hint_list)=="table" and aux.Stringid(hint_list[1],hint_list[2]) or hint_list
	end
	local hint=0
	if istarget then hint=HINTMSG_TARGET end 
	if (type(loc1)~="number" or (loc1 and loc1>0)) and (not loc2 or loc2==0) then hint=HINTMSG_SELF end
	if (type(loc2)=="number" and loc2>0) and (not loc1 or loc1==0) then hint=HINTMSG_OPPO end
	local hint_list= { HINTMSG_DESTROY,HINTMSG_RELEASE,HINTMSG_REMOVE,HINTMSG_ATOHAND,HINTMSG_TODECK,
	HINTMSG_TOGRAVE,0,HINTMSG_DISCARD,HINTMSG_SUMMON,HINTMSG_SPSUMMON,
	0,HINTMSG_POSCHANGE,HINTMSG_CONTROL,rshint.dis,0,
	0,0,HINTMSG_EQUIP,0,0,
	rshint.ad,rshint.ad,HINTMSG_FACEUP,0,0, 
	0,HINTMSG_FACEUP,0,0,0,
	rshint.te } 
	for _,cate in pairs(cate_list) do 
		local bool,idx=rsof.Table_List(rscate.catelist,cate) 
		if bool then
			hint=hint_list[idx]>0 and hint_list[idx] or hint
		end
	end 
	-- destroy and remove 
	if rsof.Table_List_OR(cate_list,"des_rm","des,rm") or rsof.Table_List_AND(cate_list,"des","rm") then
		hint=HINTMSG_DESTROY 
	end
	-- return to hand
	if rsof.Table_List(cate_list,"th") and
		((type(loc1)=="number" and loc1&LOCATION_ONFIELD ~=0) or (loc2 and loc2&LOCATION_ONFIELD ~=0)) then
		hint=HINTMSG_RTOHAND 
	end
	-- return to grave
	if rsof.Table_List(cate_list,"tg") and
		((type(loc1)=="number" and loc1&LOCATION_REMOVED  ~=0) or (loc2 and loc2&LOCATION_REMOVED ~=0)) then
		hint=rshint.rtg
	end
	return hint 
end
--Effect: Get reset, for some effect use like "banish it until XXXX"
function rsef.Getreset_ph(self_pl,reset_tct,reset_pl,reset_ph)
	if not reset_ph then reset_ph=PHASE_END end
	local curr_ph=Duel.Getcurr_ph()
	local curr_pl=Duel.GetTurnPlayer()
	local reset=RESET_PHASE+reset_ph 
	if not reset_tct then
		return {0,1,reset_pl}
	end
	if reset_tct==0 then
		return {reset,1,curr_pl}
	end
	if reset_pl then
		if reset_pl==self_pl then reset=reset+RESET_SELF_TURN 
		else reset=reset+RESET_OPPO_TURN 
		end
	end
	if reset_tct==1 then
		if curr_ph<=reset_ph and (not reset_pl or curr_pl==reset_pl) then
			return {reset,2,reset_pl}
		else
			return {reset,1,reset_pl}
		end
	end
	if reset_tct>1 then
		return {reset,reset_tct,reset_pl}
	end
end
--Effect: Get register card
function rsef.GetRegisterCard(reg_list)
	reg_list=type(reg_list)=="table" and reg_list or {reg_list}
	local reg_owner=reg_list[1] 
	local reg_handler=reg_list[2] or reg_list[1]
	local is_ignore=reg_list[3] or false
	return reg_owner,reg_handler,is_ignore
end
--Effect: Get default activate or apply range
function rsef.GetRegisterRange(reg_list)
	local reg_range
	local reg_owner,reg_handler=rsef.GetRegisterCard(reg_list)
	if aux.GetValueType(reg_handler)~="Card" then return nil end
	local type_list={ TYPE_MONSTER,TYPE_PENDULUM,TYPE_FIELD,TYPE_SPELL+TYPE_TRAP }
	local reg_lsit={ LOCATION_MZONE,LOCATION_PZONE,LOCATION_FZONE,LOCATION_SZONE }
	for idx,card_type in pairs(type_list) do
		if reg_handler:IsType(card_type) then 
			reg_range=reg_lsit[idx]
		end
	end
	--after begain duel 
	if Duel.GetTurnCount()>0 then reg_range=reg_handler:GetLocation() end
	return reg_range 
end
--Effect: Get Flag for SetProperty 
function rsef.GetRegisterProperty(flag_param)
	local flag_str_list={"tg","ptg","de","dsp","dcal","ii","sa","ir","sr","bs","uc","cd","cn","ch","lz","at","sp","ep"}
	local value1,table2,table3,table4=rsof.Mix_Value_To_Table(flag_param,flag_str_list,rsflag.flaglist)
	return rsof.Mix_Value_To_Table(flag_param,flag_str_list,rsflag.flaglist)
end
rsflag.GetRegisterProperty=rsef.GetRegisterProperty
--Effect: Get Category for SetCategory or SetOperationInfo
function rsef.GetRegisterCategory(cate_param)
	local cate_str_list={"des","res","rm","th","td","tg","disd","dish","sum","sp","tk","pos","con","dis","diss","dr","se","eq","dam","rec","atk","def","ct","coin","dice","lg","lv","neg","an","fus","te","ga"}
	return rsof.Mix_Value_To_Table(cate_param,cate_str_list,rscate.catelist)
end
rscate.GetRegisterCategory=rsef.GetRegisterCategory
--Effect: Clone Effect 
function rsef.RegisterClone(reg_list,base_eff,...)
	local clone_list={...}
	local clone_eff=base_eff:Clone()
	for idx,value1 in pairs(clone_list) do 
		if idx&1==1 and type(value1)=="string" then
			local value2=clone_list[idx+1]
			local clone_param_list={"code","type","loc","con","cost","tg","op","label","labobj","value"}
			local effect_set_list={Effect.SetCode,Effect.SetType,Effect.SetRange,Effect.SetCondition,Effect.SetCost,Effect.SetTarget,Effect.SetOperation,Effect.SetLabel,Effect.SetLabelObject,Effect.SetValue}
			local bool,idx2=rsof.Table_List(clone_param_list,value1)
			if bool and idx2 then
				effect_set_list[idx2](clone_eff,value2)
			end
			if value1=="desc" then 
				rsef.RegisterDescription(clone_eff,value2)
			elseif value1=="flag" then 
				clone_eff:SetProperty(rsflag.GetRegisterProperty(value2))
			elseif value1=="cate" then 
				clone_eff:SetCategory(rscate.GetRegisterCategory(value2)) 
			elseif value1=="reset" then 
				rsef.RegisterReset(clone_eff,value2) 
			elseif value1=="timing" then 
				rsef.RegisterTiming(clone_eff,value2) 
			elseif value1=="tgrange" then
				rsef.RegisterTargetRange(clone_eff,value2) 
			end
		end
	end
	local _,clone_fid=rsef.RegisterEffect(reg_list,clone_eff)
	return clone_eff,clone_fid
end 
--Effect: Make Ignition Effect Become Quick Effect
function rsef.RegisterOPTurn(reg_list,base_eff,quick_con,timing_list)
	timing_list=timing_list or {0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE }
	local quick_eff,quick_fid=rsef.RegisterClone(reg_list,base_eff,"type",EFFECT_TYPE_QUICK_O,"code",EVENT_FREE_CHAIN,"timing",timing_list)
	base_con=base_eff:GetCondition() or aux.TRUE 
	base_eff:SetCondition(aux.AND(base_con,aux.NOT(quick_con)))
	quick_eff:SetCondition(aux.AND(base_con,quick_con))
	return quick_eff,quick_fid
end 
rsef.QO_OPPONENT_TURN=rsef.RegisterOPTurn
--Effect: Register Condition, Cost, Target and Operation 
function rsef.RegisterSolve(e,con,cost,tg,op)
	local code=e:GetOwner():GetCode()
	if con then
		if type(con)~="function" then
			Debug.Message(code .. " RegisterSolve con must be function")
		end
		e:SetCondition(con)
	end
	if cost then
		if type(cost)~="function" then
			Debug.Message(code .. " RegisterSolve cost must be function")
		end
		e:SetCost(cost)
	end
	if tg then
		if type(tg)~="function" then
			Debug.Message(code .. " RegisterSolve tg must be function")
		end
		e:SetTarget(tg)
	end
	if op then
		if type(op)~="function" then
			Debug.Message(code .. " RegisterSolve op must be function")
		end
		e:SetOperation(op)
	end
end
Effect.RegisterSolve=rsef.RegisterSolve
--Effect: Register Property and Category
function rsef.RegisterCateFlag(e,cate,flag)
	if cate then
		local cate2=rsef.GetRegisterCategory(cate)
		if cate2>0 then
			e:SetCategory(cate2) 
		end
	end
	if flag then
		local flag2=rsef.GetRegisterProperty(flag)
		if flag2>0 then
			e:SetProperty(flag2) 
		end
	end
end
--Effect: Register Effect Description
function rsef.RegisterDescription(e,desc_list,is_return)
	if desc_list then
		if type(desc_list)=="table" then
			if is_return then return aux.Stringid(desc_list[1],desc_list[2]) end
			e:SetDescription(aux.Stringid(desc_list[1],desc_list[2]))
		else
			if is_return then return desc_list end
			e:SetDescription(desc_list)
		end
	end 
end
--Effect: Register Effect Count limit
function rsef.RegisterCountLimit(e,lim_list,is_return)
	if lim_list then
		local lim_count,lim_code=0,0
		if type(lim_list)=="table" then
			if #lim_list==1 then
				if lim_list[1]<=100 then
					lim_count=lim_list[1]
				else
					lim_count=1
					lim_code=lim_list[1]
				end
			elseif #lim_list==2 then
				lim_count=lim_list[1]
				if value==3 or value==0x1 then
					lim_code=EFFECT_COUNT_CODE_SINGLE 
				else
					lim_code=lim_list[2]
				end
			elseif #lim_list==3 then
				lim_count=lim_list[1]
				lim_code=lim_list[2]
				local value=lim_list[3]
				if value==1 then 
					lim_code=lim_code+EFFECT_COUNT_CODE_OATH 
				elseif value==2 then
					lim_code=lim_code+EFFECT_COUNT_CODE_DUEL 
				else 
					lim_code=lim_code+value
				end
			end
		else
			if lim_count<=100 then
				lim_count=lim_list
			else
				lim_count=1
				lim_code=lim_list
			end
		end
		if is_return then return lim_count,lim_code end
		e:SetCountLimit(lim_count,lim_code)
	end
end
--Effect: Register Effect Target range
function rsef.RegisterTargetRange(e,tg_range_list)
	if tg_range_list then
		if type(tg_range_list)=="table" then
			if #tg_range_list==1 then
				e:SetTargetRange(tg_range_list[1],tg_range_list[1]) 
			else
				e:SetTargetRange(tg_range_list[1],tg_range_list[2])
			end
		else
			e:SetTargetRange(tg_range_list) 
		end
	end
end
--Effect: Register Effect Timing 
function rsef.RegisterTiming(e,timing_list)
	if timing_list then
		if type(timing_list)=="table" then
			if #timing_list==1 then
				e:SetHintTiming(timing_list[1]) 
			else
				e:SetHintTiming(timing_list[1],timing_list[2])
			end
		else
			e:SetHintTiming(timing_list) 
		end
	end
end
--Effect: Register Effect Reset way 
function rsef.RegisterReset(e,reset_list,is_return)
	if reset_list then 
		if type(reset_list)=="table" then
			if #reset_list==1 then
				if is_return then return reset_list[1],1 end
				e:SetReset(reset_list[1]) 
			else
				if is_return then return reset_list[1],reset_list[2] end
				e:SetReset(reset_list[1],reset_list[2])
			end
		else
			if is_return then return reset_list,1 end
			e:SetReset(reset_list) 
		end
	end
end
--Effect: Register Effect Final
function rsef.RegisterEffect(reg_list,e)
	local tc1,val2,ignore=rsef.GetRegisterCard(reg_list)
	if type(val2)=="number" and (val2==0 or val2==1) then
		Duel.RegisterEffect(e,val2)
	else
		val2:RegisterEffect(e,ignore)
	end
	local fid=e:GetFieldID()
	return e,fid
end
--Effect: Register Effect Attributes
function rsef.Register(reg_list,EFFECT_TYPE,eff_code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,val,tg_range_list,timing_list,reset_list)
	local reg_owner,reg_handler,is_ignore=rsef.GetRegisterCard(reg_list)
	local e
	if rsof.Check_Boolean(reg_owner,true) then
		e=Effect.GlobalEffect()
	else
		e=Effect.CreateEffect(reg_owner)
	end
	if EFFECT_TYPE then
		e:SetType(EFFECT_TYPE)
	end
	if eff_code then
		e:SetCode(eff_code)
	end
	rsef.RegisterDescription(e,desc_list)
	rsef.RegisterCountLimit(e,lim_list)
	rsef.RegisterCateFlag(e,cate,flag)
	if range then
		e:SetRange(range)
	end
	rsef.RegisterSolve(e,con,cost,tg,op)
	if val then
		e:SetValue(val)
	end
	rsef.RegisterTargetRange(e,tg_range_list)
	rsef.RegisterTiming(e,timing_list)
	rsef.RegisterReset(e,reset_list)
	local _,fid=rsef.RegisterEffect(reg_list,e)
	return e,fid
end

-------------------"Part_Effect_SingleValue"-------------------

--Single Val Effect: Base set
function rsef.SV(reg_list,code,val,range,con,reset_list,flag,desc_list,lim_list)
	local tc1,tc2=rsef.GetRegisterCard(reg_list)
	local flag2=rsef.GetRegisterProperty(flag)
	local flag_list1={ EFFECT_IMMUNE_EFFECT,EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET,EFFECT_CHANGE_CODE,EFFECT_ADD_CODE,EFFECT_CHANGE_RACE,EFFECT_ADD_RACE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_ADD_ATTRIBUTE,EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,rscode.Utility_Xyz_Material,rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL }
	local flag_list2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_RANK,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK }
	local tf1=rsof.Table_List(flag_list1,code)
	local tf2=rsof.Table_List(flag_list2,code)
	if (tf1 and tc1==tc2 and not reset_list) or (tf2 and not reset_list and tc1~=tc2) then 
		flag2=flag2|EFFECT_FLAG_SINGLE_RANGE 
	end
	if desc_list then flag2=flag2|EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(reg_list,EFFECT_TYPE_SINGLE,code,desc_list,lim_list,nil,flag2,range,con,nil,nil,nil,val,nil,nil,reset_list)
end
--Single Val Effect: attribute base set (new)
function rsef.SV_ATTRIBUTE(reg_list,att_list,val_list,con,reset_list,flag,desc_list,lim_list)
	local c1,c2=rsef.GetRegisterCard(reg_list)
	--case set 
	local code_list_set={"atk","def","atkf","deff","batk","bdef"}  
	local code_list_set2={EFFECT_SET_ATTACK,EFFECT_SET_DEFENSE,EFFECT_SET_ATTACK_FINAL,EFFECT_SET_DEFENSE_FINAL,EFFECT_SET_BASE_ATTACK,EFFECT_SET_BASE_DEFENSE }
	--case change 
	local code_list_change={"lv","rk","ls","rs","code","att","race","type","fusatt"}
	local code_list_change2={EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_RANK,EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE,EFFECT_CHANGE_CODE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_RACE,EFFECT_CHANGE_TYPE,EFFECT_CHANGE_FUSION_ATTRIBUTE }
	--case updata
	local code_list_up={"atk+","def+","lv+","rk+","ls+","rs+"}
	local code_list_up2={EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE }
	--case add 
	local code_list_add={"code+","att+","race+","set+","type+","fusatt+","fuscode+","fusset+","linkatt+","linkrace+","linkcode+","linkset+"}
	local code_list_add2={EFFECT_ADD_CODE,EFFECT_ADD_ATTRIBUTE,EFFECT_ADD_RACE,EFFECT_ADD_SETCODE,EFFECT_ADD_TYPE,EFFECT_ADD_FUSION_ATTRIBUTE,EFFECT_ADD_FUSION_CODE,EFFECT_ADD_FUSION_SETCODE,EFFECT_ADD_LINK_ATTRIBUTE,EFFECT_ADD_LINK_RACE,EFFECT_ADD_LINK_CODE,EFFECT_ADD_LINK_SETCODE }

	local totallist=rsof.Table_Mix(code_list_set,code_list_change,code_list_up,code_list_add)
	local totallist2=rsof.Table_Mix(code_list_set2,code_list_change2,code_list_up2,code_list_add2)

	local code_list,val_list=rsof.Table_Suit(att_list,totallist,totallist2,val_list)   
	local effect_list={}
	local rangelist={}
	rangelist["pzone"]={EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE }
	rangelist["nil"]={table.unpack(code_list_set2)}
	for k,effectcode in ipairs(code_list) do
		local range=rsef.GetRegisterRange(reg_list)
		if rsof.Table_List(rangelist["pzone"],effectcode) then range=LOCATION_PZONE end
		--if rsof.Table_List(rangelist["nil"],effectcode) then range=nil end 
		if val_list[k] then
			local e1=nil
			if type(val_list[k])~="string" then
				e1=rsef.SV(reg_list,effectcode,val_list[k],range,con,reset_list,flag,desc_list)
			else -- use for set code
				e1=rsef.SV(reg_list,effectcode,0,range,con,reset_list,flag,desc_list)
				rsval.valinfo[e1]=val_list[k]
				if c2:GetFlagEffect(rscode.Previous_Set_Code)==0 then
					local e2=rsef.SC({c2,true},EVENT_LEAVE_FIELD_P,nil,nil,"cd,uc",nil,rsef.presetop)
					c2:RegisterFlagEffect(rscode.Previous_Set_Code,0,0,1)
				end
			end
			table.insert(effect_list,e1)
		end
	end
	return table.unpack(effect_list)   
end 
function rsef.presetop(e,tp)
	local c=e:GetHandler()
	rscf.Previous_Set_Code_List[c]={c:IsHasEffect(EFFECT_ADD_SETCODE)} 
end
--Single Val Effect: Cannot destroed 
function rsef.SV_INDESTRUCTABLE(reg_list,inds_list,val_list,con,reset_list,flag,desc_list,lim_list)
	local code_list_1={"battle","effect","ct","all"}
	local code_list_2={ EFFECT_INDESTRUCTABLE_BATTLE,EFFECT_INDESTRUCTABLE_EFFECT,EFFECT_INDESTRUCTABLE_COUNT,EFFECT_INDESTRUCTABLE }
	local code_list,val_list=rsof.Table_Suit(inds_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list)
	for k,effectcode in ipairs(code_list) do 
		local val=val_list[k]
		if not val then
			if effectcode~=EFFECT_INDESTRUCTABLE_COUNT then
				val=1
			else
				val=rsval.indbae()
			end
		end
		if indstype==EFFECT_INDESTRUCTABLE_COUNT and not lim_list then
			lim_list=1
		end
		local e1=rsef.SV(reg_list,effectcode,val,range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Single Val Effect: Immue effects
function rsef.SV_IMMUNE_EFFECT(reg_list,val,con,reset_list,flag,desc_list)
	if not val then val=rsval.imes end
	local range=rsef.GetRegisterRange(reg_list)
	return rsef.SV(reg_list,EFFECT_IMMUNE_EFFECT,val,range,con,reset_list,flag,desc_list)
end
--Single Val Effect: Directly set ATK & DEF 
function rsef.SV_SET(reg_list,set_list,val_list,con,reset_list,flag,desc_list)
	return rsef.SV_ATTRIBUTE(reg_list,set_list,val_list,con,reset_list,flag,desc_list)
end
--Single Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.SV_CHANGE(reg_list,change_list,val_list,con,reset_list,flag,desc_list)
	return rsef.SV_ATTRIBUTE(reg_list,change_list,val_list,con,reset_list,flag,desc_list)
end
--Single Val Effect: Update attribute 
function rsef.SV_UPDATE(reg_list,up_list,val_list,con,reset_list,flag,desc_list)
	local str_list=rsof.String_Number_To_Table(up_list)
	local str_list2={}
	for _,string in pairs(str_list) do
		table.insert(str_list2,string.."+")
	end
	return rsef.SV_ATTRIBUTE(reg_list,str_list2,val_list,con,reset_list,flag,desc_list)
end 
--Single Val Effect: Add attribute
function rsef.SV_ADD(reg_list,add_list,val_list,con,reset_list,flag,desc_list)
	return rsef.SV_UPDATE(reg_list,add_list,val_list,con,reset_list,flag,desc_list)
end
--Single Val Effect: Material lim_
function rsef.SV_CANNOT_BE_MATERIAL(reg_list,mat_list,val_list,con,reset_list,flag,desc_list)
	local code_list_1={"fus","syn","xyz","link"}
	local code_list_2={ EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL }
	if not val_list then val_list=1 end
	local code_list,val_list=rsof.Table_Suit(mat_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.SV(reg_list,effectcode,val_list[k],nil,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Single Val Effect: Cannot be battle or card effect target
function rsef.SV_CANNOT_BE_TARGET(reg_list,tg_list,val_list,con,reset_list,flag,desc_list)
	local code_list_1={"battle","effect"}
	local code_list_2={ EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	local code_list,val_list=rsof.Table_Suit(tg_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	for k,effectcode in ipairs(code_list) do
		local val=val_list[k]
		if not val then
			if effectcode==EFFECT_CANNOT_BE_BATTLE_TARGET then
				val=aux.imval1
			else
				val=1
			end
		end
		local e1=rsef.SV(reg_list,effectcode,val,range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Single Val Effect: Other Limit
function rsef.SV_LIMIT(reg_list,lim_list,val_list,con,reset_list,flag,desc_list) 
	local code_list_1={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp","cost"}
	local code_list_2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION,EFFECT_CANNOT_USE_AS_COST }
	local code_list,val_list=rsof.Table_Suit(lim_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.SV(reg_list,effectcode,val_list[k],range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Single Val Effect: Leave field redirect 
function rsef.SV_REDIRECT(reg_list,leave_list,val_list,con,reset_list,flag,desc_list) 
	local code_list_1={"tg","td","th","leave"}
	local code_list_2={ EFFECT_TO_GRAVE_REDIRECT,EFFECT_TO_DECK_REDIRECT,EFFECT_TO_HAND_REDIRECT,EFFECT_LEAVE_FIELD_REDIRECT }
	if not val_list then val_list={ LOCATION_REMOVED } end
	local code_list,val_list=rsof.Table_Suit(leave_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	--if not reset_list then reset_list=rsreset.ered end
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.SV(reg_list,effectcode,val_list[k],nil,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Single Val Effect: Extra Procedure Materials
function rsef.SV_EXTRA_MATERIAL(reg_list,mat_list,val_list,con,reset_list,flag,desc_list,lim_list,range)
	local code_list_1={"syn","xyz","link"}
	local code_list_2={ rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL } 
	range = range or LOCATION_HAND 
	val_list = val_list or { aux.TRUE } 
	local code_list,val_list=rsof.Table_Suit(mat_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.SV(reg_list,effectcode,val_list[k],range,con,reset_list,flag,desc_list,lim_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end

--Single Val Effect: Utility Procedure Materials
function rsef.SV_Utility_Xyz_Material(reg_list,val,con,reset_list,flag,desc_list,lim_list,range)
	val = val or 2
	range = range or LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_DECK+LOCATION_GRAVE 
	local e1=rsef.SV(reg_list,rscode.Utility_Xyz_Material,val,range,con,reset_list,flag,desc_list,lim_list)
	return e1
end

-------------------"Part_Effect_FieldValue"-------------------

--Field Val Effect: Base set
function rsef.FV(reg_list,code,val,tg,tg_range_list,range,con,reset_list,flag,desc_list,lim_list)
	local flag2=rsef.GetRegisterProperty(flag)
	if desc_list then flag2=flag2|EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(reg_list,EFFECT_TYPE_FIELD,code,desc_list,lim_list,nil,flag2,range,con,nil,tg,nil,val,tg_range_list,nil,reset_list)
end
--Field Val Effect: Updata some card attributes
function rsef.FV_UPDATE(reg_list,up_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list)
	local code_list_1={"atk","def","lv","rk","ls","rs"}
	local code_list_2={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE } 
	local code_list,val_list=rsof.Table_Suit(up_list,code_list_1,code_list_2,val_list)
	if not tg_range_list then tg_range_list={ LOCATION_MZONE,LOCATION_MZONE } end
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list)
	for k,effectcode in ipairs(code_list) do 
		if val_list[k] and val_list[k]~=0 then
			local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list,range,con,reset_list,flag,desc_list)
			table.insert(effect_list,e1)
		end
	end
	return table.unpack(effect_list)  
end
--Field Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.FV_CHANGE(reg_list,change_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list)
	local code_list_1={"lv","lvf","rk","rkf","code","att","race","type","fusatt","ls","rs"}
	local code_list_2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_LEVEL_FINAL,EFFECT_CHANGE_RANK,EFFECT_CHANGE_RANK_FINAL,EFFECT_CHANGE_CODE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_RACE,EFFECT_CHANGE_TYPE,EFFECT_CHANGE_FUSION_ATTRIBUTE,EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE } 
	local code_list,val_list=rsof.Table_Suit(change_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list)
	local tg_range_list2=tg_range_list
	for k,effectcode in ipairs(code_list) do 
		if val_list[k] and val_list[k]~=0 then
			if effectcode==EFFECT_CHANGE_LSCALE or effectcode==EFFECT_CHANGE_RSCALE then tg_range_list2={ LOCATION_PZONE,LOCATION_PZONE } 
			else
				if not tg_range_list then
					tg_range_list2={ LOCATION_MZONE,LOCATION_MZONE } 
				end
			end
			local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list2,range,con,reset_list,flag,desc_list)
			table.insert(effect_list,e1)
		end
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.FV_ADD(reg_list,add_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list)
	local code_list_1={"code","set","att","race","fuscode","fusset","fusatt","linkcode","linkset","linkatt","linkrace"}
	local code_list_2={ EFFECT_ADD_CODE,EFFECT_ADD_SETCODE,EFFECT_ADD_ATTRIBUTE,EFFECT_ADD_RACE,EFFECT_ADD_FUSION_CODE,EFFECT_ADD_FUSION_SETCODE,EFFECT_ADD_FUSION_ATTRIBUTE,EFFECT_ADD_LINK_CODE,EFFECT_ADD_LINK_SETCODE,EFFECT_ADD_LINK_ATTRIBUTE,EFFECT_ADD_LINK_RACE } 
	local code_list,val_list=rsof.Table_Suit(add_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list)
	local tg_range_list2=tg_range_list or { LOCATION_MZONE,LOCATION_MZONE }
	for k,effectcode in ipairs(code_list) do 
		local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list2,range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Cannot Disable 
function rsef.FV_CANNOT_DISABLE(reg_list,dis_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list) 
	local code_list_1={"dis","dise","act","sum","sp"} 
	local code_list_2={EFFECT_CANNOT_DISABLE,EFFECT_CANNOT_DISEFFECT,EFFECT_CANNOT_INACTIVATE,EFFECT_CANNOT_DISABLE_SUMMON,EFFECT_CANNOT_DISABLE_SPSUMMON }
	local code_list,val_list=rsof.Table_Suit(dis_list,code_list_1,code_list_2,val_list,true)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	local flag2=rsef.GetRegisterProperty(flag)
	if not tg_range_list then tg_range_list={ LOCATION_MZONE,0 } end
	for k,effectcode in ipairs(code_list) do 
		local tg2=tg
		local tg_range_list2=tg_range_list 
		local val=nil
		if effectcode==EFFECT_CANNOT_DISABLE_SUMMON or EFFECT_CANNOT_DISABLE_SPSUMMON then
			flag2=flag2|EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE 
			tg_range_list2=nil
		end
		if effectcode==EFFECT_CANNOT_DISEFFECT or effectcode==EFFECT_CANNOT_INACTIVATE then
			tg2=nil
			tg_range_list2=nil
			val=val_list[k]
			if not val then
				val=rsval.cdisneg()
			end
		end
		local e1=rsef.FV(reg_list,effectcode,val,tg2,tg_range_list2,range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Cannot be battle or card effect target
function rsef.FV_CANNOT_BE_TARGET(reg_list,tg_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list)
	local code_list_1={"battle","effect"}
	local code_list_2={ EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	local code_list,val_list=rsof.Table_Suit(tg_list,code_list_1,code_list_2,val_list,true)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE 
	if not tg_range_list then tg_range_list={ LOCATION_MZONE,0 } end
	for k,effectcode in ipairs(code_list) do 
		local val=val_list[k]
		if not val then
			if effectcode==EFFECT_CANNOT_BE_BATTLE_TARGET then
				val=aux.imval1
			else
				val=1
			end
		end
		local e1=rsef.FV(reg_list,effectcode,val,tg,tg_range_list,range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Cannot destroed 
function rsef.FV_INDESTRUCTABLE(reg_list,inds_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list)
	local code_list_1={"battle","effect","ct","all"}
	local code_list_2={ EFFECT_INDESTRUCTABLE_BATTLE,EFFECT_INDESTRUCTABLE_EFFECT,EFFECT_INDESTRUCTABLE_COUNT,EFFECT_INDESTRUCTABLE }
	local code_list,val_list=rsof.Table_Suit(inds_list,code_list_1,code_list_2,val_list,true)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	if not tg_range_list then tg_range_list={ LOCATION_MZONE,0 } end
	for k,effectcode in ipairs(code_list) do 
		local val=val_list[k]
		if not val then
			if effectcode~=EFFECT_INDESTRUCTABLE_COUNT then
				val=1
			else
				val=rsval.indct()
			end
		end
		local e1=rsef.FV(reg_list,effectcode,val,tg,tg_range_list,range,con,reset_list,flag,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Other Limit
function rsef.FV_LIMIT(reg_list,lim_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list) 
	local code_list_1={"dis","dise","tri","atk","atkan","datk","res","ress","resns","td","th","cp","cpe"}
	local code_list_2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_CANNOT_RELEASE,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION,EFFECT_CANNOT_CHANGE_POS_E }
	local code_list,val_list=rsof.Table_Suit(lim_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	if not tg_range_list then tg_range_list={ 0,LOCATION_MZONE } end
	for k,effectcode in ipairs(code_list) do 
		local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_SET_AVAILABLE 
		flag2=effectcode==EFFECT_CANNOT_CHANGE_POSITION and flag2 or flag2|EFFECT_FLAG_IGNORE_IMMUNE 
		local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list,range,con,reset_list,flag2,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Other Limit (affect Player)
function rsef.FV_LIMIT_PLAYER(reg_list,lim_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list) 
	local code_list_1={"act","sum","sp","th","dr","td","tg","res","rm","sbp","sm1","sm2","sdp","ssp","sset","mset","dish","disd","fp","cp"}
	local code_list_2={ EFFECT_CANNOT_ACTIVATE,EFFECT_CANNOT_SUMMON,EFFECT_CANNOT_SPECIAL_SUMMON,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_DRAW,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_GRAVE,EFFECT_CANNOT_RELEASE,EFFECT_CANNOT_REMOVE,EFFECT_CANNOT_BP,EFFECT_SKIP_M1,EFFECT_SKIP_M2,EFFECT_SKIP_DP,EFFECT_SKIP_SP,EFFECT_CANNOT_SSET,EFFECT_CANNOT_MSET,EFFECT_CANNOT_DISCARD_HAND,EFFECT_CANNOT_DISCARD_DECK,EFFECT_CANNOT_FLIP_SUMMON,EFFECT_CANNOT_CHANGE_POSITION }
	local code_list,val_list=rsof.Table_Suit(lim_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list) 
	if not tg_range_list then tg_range_list={ 0,1 } end
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_PLAYER_TARGET 
	for k,effectcode in ipairs(code_list) do 
		local tg2=tg
		local val=nil
		if effectcode==EFFECT_CANNOT_ACTIVATE then 
			if val_list[k] then val=val_list[k] 
			--[[else 
				val=function(e,re,rp)
					return not re:GetHandler():IsImmuneToEffect(e)
				end--]]
			end
			tg2=nil
		end
		local e1=rsef.FV(reg_list,effectcode,val,tg2,tg_range_list,range,con,reset_list,flag2,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Immue effects
function rsef.FV_IMMUNE_EFFECT(reg_list,val,tg,tg_range_list,con,reset_list,flag,desc_list)
	if not val then val=rsval.imes end
	local range=rsef.GetRegisterRange(reg_list)
	if not tg_range_list then tg_range_list={ LOCATION_MZONE,0 } end
	return rsef.FV(reg_list,EFFECT_IMMUNE_EFFECT,val,tg,tg_range_list,range,con,reset_list,flag,desc_list)
end
--Field Val Effect: Leave field redirect 
function rsef.FV_REDIRECT(reg_list,leave_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list) 
	local code_list_1={"tg","td","th","leave"}
	local code_list_2={ EFFECT_TO_GRAVE_REDIRECT,EFFECT_TO_DECK_REDIRECT,EFFECT_TO_HAND_REDIRECT,EFFECT_LEAVE_FIELD_REDIRECT }
	if not val_list then val_list={ LOCATION_REMOVED } end
	local code_list,val_list=rsof.Table_Suit(leave_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	local range=rsef.GetRegisterRange(reg_list)
	if not tg_range_list then tg_range_list={ 0,0xff } end
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE 
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list,range,con,reset_list,flag2,desc_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)
end
--Field Val Effect: Extra Procedure Materials
function rsef.FV_EXTRA_MATERIAL(reg_list,mat_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list,lim_list,range) 
	local code_list_1={"syn","xyz","link"}
	local code_list_2={ rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL } 
	range = range or rsef.GetRegisterRange(reg_list) 
	val_list = val_list or { aux.TRUE }
	tg_range_list  =   tg_range_list or {LOCATION_HAND,0}
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE 
	local code_list,val_list=rsof.Table_Suit(mat_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list,range,con,reset_list,flag2,desc_list,lim_list)
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)	
end
--Field Val Effect: Extra Procedure Materials for self
function rsef.FV_EXTRA_MATERIAL_SELF(reg_list,mat_list,val_list,tg,tg_range_list,con,reset_list,flag,desc_list,lim_list) 
	local code_list_1={"syn","xyz","link"}
	local code_list_2={ rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL } 
	val_list = val_list or { function(e,c,mg) return c==e:GetHandler() end }
	tg_range_list  =   tg_range_list or {LOCATION_HAND,0}
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE + EFFECT_FLAG_UNCOPYABLE 
	local code_list,val_list=rsof.Table_Suit(mat_list,code_list_1,code_list_2,val_list)
	local effect_list={}
	for k,effectcode in ipairs(code_list) do
		local e1=rsef.FV(reg_list,effectcode,val_list[k],tg,tg_range_list,LOCATION_EXTRA,con,reset_list,flag2,desc_list,lim_list) 
		table.insert(effect_list,e1)
	end
	return table.unpack(effect_list)	 
end
--Field Val Effect: Utility Procedure Materials
function rsef.FV_Utility_Xyz_Material(reg_list,val,tg,tg_range_list,con,reset_list,flag,desc_list,lim_list,range)
	val = val or 2
	tg_range_list  =   tg_range_list or {LOCATION_MZONE,0}
	range = range or rsef.GetRegisterRange(reg_list) 
	local e1=rsef.FV(reg_list,rscode.Utility_Xyz_Material,val,tg,tg_range_list,range,con,reset_list,flag2,desc_list,lim_list)
	return e1   
end

-------------------"Part_Effect_Activate"-------------------

--Activate Effect: Base set
function rsef.ACT(reg_list,code,desc_list,lim_list,cate,flag,con,cost,tg,op,timing_list,reset_list)
	local _,tc=rsef.GetRegisterCard(reg_list)
	if tc:IsType(TYPE_TRAP+TYPE_QUICKPLAY) and not timing_list then
		timing_list={0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE }
	end
	if not desc_list then desc_list=rshint.act end
	if not code then code=EVENT_FREE_CHAIN end
	return rsef.Register(reg_list,EFFECT_TYPE_ACTIVATE,code,desc_list,lim_list,cate,flag,nil,con,cost,tg,op,nil,nil,timing_list,reset_list)
end  
--Activate Effect: Equip Spell
function rsef.ACT_EQUIP(reg_list,eqfilter,desc_list,lim_list,con,cost) 
	desc_list=desc_list or rshint.eq
	eqfilter=eqfilter or Card.IsFaceup 
	local eqfilter2=eqfilter
	eqfilter=function(c,e,tp)
		return c:IsFaceup() and eqfilter2(c,tp)
	end
	local e1=rsef.ACT(reg_list,nil,desc_list,lim_list,"eq","tg",con,cost,rstg.target({eqfilter,"eq",LOCATION_MZONE,LOCATION_MZONE,1}),rsef.ACT_EQUIP_Op)
	local e2=rsef.SV(reg_list,EFFECT_EQUIP_LIMIT,rsef.ACT_EQUIP_Val(eqfilter),nil,nil,nil,"cd")
	return e1,e2
end
function rsef.ACT_EQUIP_Op(e,tp,eg,ep,ev,re,r,rp) 
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if e:GetHandler():IsRelateToEffect(e) and tc then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function rsef.ACT_EQUIP_Val(eqfilter) 
	return function(e,c)
		local tp=e:GetHandlerPlayer()
		return eqfilter(c,tp)
	end
end

-------------------"Part_Effect_SingleTigger"-------------------

--Self Tigger Effect No Force: Base set
function rsef.STO(reg_list,code,desc_list,lim_list,cate,flag,con,cost,tg,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE,code,desc_list,lim_list,cate,flag,nil,con,cost,tg,op,nil,nil,nil,reset_list)
end 
--Self Tigger Effect Force: Base set
function rsef.STF(reg_list,code,desc_list,lim_list,cate,flag,con,cost,tg,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE,code,desc_list,lim_list,cate,flag,nil,con,cost,tg,op,nil,nil,nil,reset_list)
end
--Field Tigger Effect No Force: Base set
function rsef.FTO(reg_list,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,nil,nil,nil,reset_list)
end
--Field Tigger Effect Force: Base set
function rsef.FTF(reg_list,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,nil,nil,nil,reset_list)
end

---------------------"Part_Effect_Ignition"---------------------

--Ignition Effect: Base set
function rsef.I(reg_list,desc_list,lim_list,cate,flag,range,con,cost,tg,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_IGNITION,nil,desc_list,lim_list,cate,flag,range,con,cost,tg,op,nil,nil,nil,reset_list)
end

----------------------"Part_Effect_Qucik"-----------------------

--Quick Effect No Force: Base set
function rsef.QO(reg_list,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,timing_list,reset_list)
	if not code then code=EVENT_FREE_CHAIN end
	if not timing_list and code==EVENT_FREE_CHAIN then timing_list={0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE } end
	return rsef.Register(reg_list,EFFECT_TYPE_QUICK_O,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,nil,nil,timing_list,reset_list)
end 
--Quick Effect: negate effect/activation/summon/spsummon
function rsef.QO_NEGATE(reg_list,negtype,lim_list,waystring,range,con,cost,desc_list,cate,flag,reset_list)
	local waylist={"des","rm","th","td","tg","set","nil"}
	local catelist={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,CATEGORY_TOGRAVE,0,0}
	local cate2=rsef.GetRegisterCategory(cate)
	local _,_,cate3=rsof.Table_Suit(waystring,waylist,catelist)
	if cate3 and cate3>0 then
		cate2=cate2|cate3
	end
	if not range then range=rsef.GetRegisterRange(reg_list) end
	if not negtype then negtype="neg" end
	if negtype=="dis" or nettype=="effect" then
		if not desc_list then desc_list=rshint.diseffect end
		local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP  
		cate2=cate2|CATEGORY_DISABLE 
		if not con then con=rscon.negcon(0) end 
		return rsef.QO(reg_list,EVENT_CHAINING,desc_list,lim_list,cate2,flag2,range,con,cost,rstg.distg(waystring),rsop.disop(waystring),nil,reset_list)   
	elseif negtype=="neg" or nettype=="act" then
		if not desc_list then desc_list=rshint.negeffect end
		local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP  
		cate2=cate2|CATEGORY_NEGATE  
		if not con then con=rscon.discon(0) end
		return rsef.QO(reg_list,EVENT_CHAINING,desc_list,lim_list,cate2,flag2,range,con,cost,rstg.negtg(waystring),rsop.negop(waystring),nil,reset_list)  
	elseif negtype=="sum" then
		if not desc_list then desc_list=rshint.negsum end
		cate2=cate2|CATEGORY_DISABLE_SUMMON  
		return rsef.QO(reg_list,EVENT_SUMMON,desc_list,lim_list,cate2,flag2,range,con,cost,rstg.negsumtg(waystring),rsop.negsumop(waystring),nil,reset_list)  
	elseif negtype=="sp" then
		if not desc_list then desc_list=rshint.negsp end
		cate2=cate2|CATEGORY_DISABLE_SUMMON  
		return rsef.QO(reg_list,EVENT_SPSUMMON,desc_list,lim_list,cate2,flag2,range,con,cost,rstg.negsumtg(waystring),rsop.negsumop(waystring),nil,reset_list) 
	elseif negtype=="sum,sp" then
		if not desc_list then desc_list=rshint.negsum end
		cate2=cate2|CATEGORY_DISABLE_SUMMON  
		local e1=rsef.QO(reg_list,EVENT_SUMMON,desc_list,lim_list,cate2,flag2,range,con,cost,rstg.negsumtg(waystring),rsop.negsumop(waystring),nil,reset_list)  
		local e2=rsef.RegisterClone(reg_list,e1,"code",EVENT_SPSUMMON)
		return e1,e2
	end
end 
--Quick Effect Force: Base set
function rsef.QF(reg_list,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_QUICK_F,code,desc_list,lim_list,cate,flag,range,con,cost,tg,op,nil,nil,nil,reset_list)
end

-----------------"Part_Effect_FieldContinues"-----------------

--Field Continues: Base set
function rsef.FC(reg_list,code,desc_list,lim_list,flag,range,con,op,reset_list)
	if not range then range=rsef.GetRegisterRange(reg_list) end
	return rsef.Register(reg_list,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,code,desc_list,lim_list,nil,flag,range,con,nil,nil,op,nil,nil,nil,reset_list)
end 
--Field Continues: Attach an extra effect when base effect is activating
function rsef.FC_AttachEffect_Activate(reg_list,desc_list,lim_list,flag,range,attachcon,attachop,reset_list,force)
	return rsef.FC_AttachEffect(reg_list,force,0x1,desc_list,lim_list,flag,range,attachcon,attachop,reset_list) 
end
--Field Continues: Attach an extra effect before the base effect solving
function rsef.FC_AttachEffect_BeforeResolve(reg_list,desc_list,lim_list,flag,range,attachcon,attachop,reset_list,force)
	return rsef.FC_AttachEffect(reg_list,force,0x2,desc_list,lim_list,flag,range,attachcon,attachop,reset_list) 
end
--Field Continues: Attach an extra effect after the base effect solving
function rsef.FC_AttachEffect_Resolve(reg_list,desc_list,lim_list,flag,range,attachcon,attachop,reset_list,force)
	return rsef.FC_AttachEffect(reg_list,force,0x4,desc_list,lim_list,flag,range,attachcon,attachop,reset_list) 
end
function rsef.FC_AttachEffect(reg_list,force,attachtime,desc_list,lim_list,flag,range,attachcon,attachop,reset_list) 
	local c1,var2=rsef.GetRegisterCard(reg_list)
	range=range or rsef.GetRegisterRange(reg_list)
	local attachcode=rscode.Extra_Effect_Activate 
	if attachtime==0x2 then attachcode=rscode.Extra_Effect_BSolve end
	if attachtime==0x4 then attachcode=rscode.Extra_Effect_ASolve end
	local e0=rsef.I(reg_list,nil,lim_list,nil,flag,range,aux.FALSE,nil,nil,nil,reset_list)
	local e1=rsef.FC(reg_list,attachcode,desc_list,nil,flag,range,rsef.FC_AttachEffect_Con(e0,attachcon),rsef.FC_AttachEffect_Op(e0,force),reset_list)
	e1:SetValue(attachop)
	e1:SetLabelObject(e0)
	local desc=not desc_list and 0 or rsef.RegisterDescription(nil,desc_list,true)
	if aux.GetValueType(var2)=="Card" then
		var2:RegisterFlagEffect(attachcode,reset,EFFECT_FLAG_CLIENT_HINT,reset_tct,e1:GetFieldID(),desc)
	else
		local e1=Effect.CreateEffect(c1)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(0x10000000+attachcode)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(desc)
		e1:SetTargetRange(1,0)
		e1:SetReset(reset,reset_tct)
		Duel.RegisterEffect(e1,var2)
	end
	if rsef.FC_AttachEffect_Switch then return e1 end
	rsef.FC_AttachEffect_Switch=true
	for p=0,1 do
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetOperation(rsef.FC_AttachEffect_ChangeOp)
		e2:SetOwnerPlayer(p)
		Duel.RegisterEffect(e2,p)
	end 
	rsef.ChangeChainOperation=Duel.ChangeChainOperation
	Duel.ChangeChainOperation=rsef.ChangeChainOperation2	
	return e1
end
function rsef.FC_AttachEffect_Con(e0,attachcon)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if not e0:CheckCountLimit(tp) then return false end
		return not attachcon or attachcon(e,tp,eg,ep,ev,re,r,rp)
	end
end
function rsef.FC_AttachEffect_Op(e0,force)
	return function(e,tp,eg,ep,ev,re,r,rp)
		rsef.attacheffect[ev]=rsef.attacheffect[ev] or {}
		rsef.attacheffectf[ev]=rsef.attacheffectf[ev] or {}
		if force then table.insert(rsef.attacheffectf[ev],e)
		else
			table.insert(rsef.attacheffect[ev],e)
		end
	end
end
function rsef.FC_AttachEffect_GetGroup(selectlist)
	local attachgroup=Group.CreateGroup()
	local attacheffectlist={}
	for _,ae in pairs(selectlist) do
		local tc=ae:GetOwner()
		attachgroup:AddCard(tc)
		attacheffectlist[tc]=attacheffectlist[tc] or {}
		table.insert(attacheffectlist[tc],ae)
	end
	return attachgroup,attacheffectlist
end
function rsef.ChangeChainOperation2(ev,changeop,ischange)
	rsef.ChangeChainOperation(ev,changeop)
	if ischange then return end
	rsop.baseop[ev]=changeop
end
function rsef.FC_AttachEffect_ChangeOp(e,tp,eg,ep,ev,re,r,rp)
	local baseop=re:GetOperation() or aux.TRUE 
	baseop=rsop.baseop[ev] or baseop
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_CHAIN)
	e1:SetOperation(rsef.FC_AttachEffect_Reset(re,baseop))
	Duel.RegisterEffect(e1,0)
	rsef.ChangeChainOperation2(ev,rsef.FC_AttachEffect_ChangeOp2(baseop),true)
end
function rsef.FC_AttachEffect_Reset(re1,baseop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if re1~=re then return end
		rsef.attacheffect[ev]=nil
		rsef.attacheffectf[ev]=nil
		rsef.solveeffect[ev]=nil
		rsop.baseop[ev]=nil
		local rc=re:GetHandler()
		local res1=re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsType(TYPE_PENDULUM+TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP)
		local res2=#({rc:IsHasEffect(EFFECT_REMAIN_FIELD)})>0
		if (res1 or res2) and not rsop.baseop[ev2] then
			re:SetOperation(baseop)
			rc:CancelToGrave(true)
		end
	end
end
function rsef.FC_AttachEffect_Solve(solveeffectlist,attachtime,e,tp,eg,ep,ev,re,r,rp)
	local actuselist={}
	local ev2=Duel.GetCurrentChain()
	local attachcode=rscode.Extra_Effect_Activate 
	if attachtime==0x2 then attachcode=rscode.Extra_Effect_BSolve end
	if attachtime==0x4 then attachcode=rscode.Extra_Effect_ASolve end
	Duel.RaiseEvent(e:GetHandler(),attachcode,e,0,tp,tp,ev2)
	local forcelist=rsef.attacheffectf[ev2] or {}
	local selectablelist=rsef.attacheffect[ev2] or {}
	for _,ae in pairs(forcelist) do
		local tc=ae:GetOwner()
		if tc:IsOnField() then
			Duel.HintSelection(rsgf.Mix2(tc))
		else
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCodeRule())
		end
		Duel.Hint(HINT_OPSELECTED,1-tp,ae:GetDescription())
		table.insert(actuselist,ae)
		ae:GetLabelObject():UseCountLimit(tp,1)
		if attachtime~=0x1 then
			table.insert(solveeffectlist,ae)
			ae:GetValue()(e,tp,eg,ep,ev,re,r,rp)
		end
	end
	local attachgroup,attacheffectlist=rsef.FC_AttachEffect_GetGroup(selectablelist)
	local selecthint=8
	if attachtime==0x2 then selecthint=9 end
	if attachtime==0x4 then selecthint=10 end
	if #attachgroup>0 and Duel.SelectYesNo(tp,aux.Stringid(m,selecthint)) then
		::Select::
		rshint.Select(tp,HINTMSG_TARGET)
		local tc=attachgroup:Select(tp,1,1,nil):GetFirst()
		if tc:IsOnField() then
			Duel.HintSelection(rsgf.Mix2(tc))
		else
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCodeRule())
		end
		local hint_list={}
		for _,ae in pairs(attacheffectlist[tc]) do
			local hint=ae:GetDescription()
			table.insert(hint_list,hint)
		end
		local opt=Duel.SelectOption(tp,table.unpack(hint_list))+1
		local ae=attacheffectlist[tc][opt]
		Duel.Hint(HINT_OPSELECTED,1-tp,ae:GetDescription())
		table.insert(actuselist,ae)
		ae:GetLabelObject():UseCountLimit(tp,1)
		if attachtime~=0x1 then
			table.insert(solveeffectlist,ae)
			ae:GetValue()(e,tp,eg,ep,ev,re,r,rp)
		end
		local _,idx=rsof.Table_List(selectablelist,ae)
		table.remove(selectablelist,idx)
		attachgroup,attacheffectlist=rsef.FC_AttachEffect_GetGroup(selectablelist)
		if #attachgroup>0 and Duel.SelectYesNo(tp,aux.Stringid(m,11)) then goto Select end
	end
	rsef.attacheffect[ev2]=nil
	rsef.attacheffectf[ev2]=nil
	return actuselist
end
function rsef.FC_AttachEffect_ChangeOp2(baseop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local ev2=Duel.GetCurrentChain()
		local c=e:GetHandler()
		if (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS) or c:IsLocation(LOCATION_PZONE)) and not c:IsRelateToEffect(e) then
			return
		end
		rsef.solveeffect[ev2]={}
		--baseop record
		table.insert(rsef.solveeffect[ev2],baseop)
		--activate select
		local actuselist=rsef.FC_AttachEffect_Solve(rsef.solveeffect[ev2],0x1,e,tp,eg,ep,ev,re,r,rp)
		--before solve
		rsef.FC_AttachEffect_Solve(rsef.solveeffect[ev2],0x2,e,tp,eg,ep,ev,re,r,rp)  
		--baseop solve
		baseop(e,tp,eg,ep,ev,re,r,rp)
		--activate solve 
		for _,ae in pairs(actuselist) do
			table.insert(rsef.solveeffect[ev2],ae)
			ae:GetValue()(e,tp,eg,ep,ev,re,r,rp)
			ae:GetLabelObject():UseCountLimit(tp,1)
		end
		--after solve 
		rsef.FC_AttachEffect_Solve(rsef.solveeffect[ev2],0x4,e,tp,eg,ep,ev,re,r,rp)  
	end
end

--Effect Function:XXX card/group will leave field in XXX Phase , often use in special summon
function rsef.FC_PHASELEAVE(reg_list,sg,times,whos,phase,leaveway,reset_list)
	--times: nil  every phase 
	--   0  next  phase
	--   1 or +  times  phase 
	--whos:  nil  each player 
	--   0  yours phase (tp)
	--   1  your opponent's phase (1-tp)
	local c1,var2=rsef.GetRegisterCard(reg_list)
	local cphase=Duel.Getcurr_ph()
	local turnctlist={Duel.GetTurnCount(),Duel.GetTurnCount(var2),Duel.GetTurnCount(1-var2)}
	local turnp=Duel.GetTurnPlayer()
	phase=phase or PHASE_END 
	leaveway=leaveway or "des"   
	if times==0 and whos==0 and turnp==tp then 
		times=cphase<=phase and 2 or 1
	end
	if times==0 and whos==1 and turnp~=tp then 
		times=cphase<=phase and 2 or 1
	end
	local fid=c1:GetFieldID()
	for tc in aux.Next(sg) do
		tc:RegisterFlagEffect(rscode.Phase_Leave_Flag,rsreset.est+RESET_PHASE+phase,0,0,fid)
	end
	local e1=rsef.FC(reg_list,EVENT_PHASE+phase,rshint.epleave,1,"ii",nil,rsef.FC_PhaseLeave_Con(cphase,turnctlist,turnp,fid,times,whos),rsef.FC_PhaseLeave_Op(leaveway,fid),reset_list)
	sg:KeepAlive()
	e1:SetLabelObject(sg)
	return e1
end
function rsef.FC_PhaseLeave_Filter(c,fid)
	return c:GetFlagEffectLabel(rscode.Phase_Leave_Flag)==fid
end 
function rsef.FC_PhaseLeave_Con(cphase,turnctlist,turnp,fid,times,whos)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local ecphase=Duel.Getcurr_ph()
		local eturnp=Duel.GetTurnPlayer()
		local eturnct,eturncttp,eturnctop=Duel.GetTurnCount(),Duel.GetTurnCount(tp),Duel.GetTurnCount()
		local turnct,turncttp,turnctop=turnctlist[1],turnctlist[2],turnctlist[3]
		local g=e:GetLabelObject()
		local rg=g:Filter(rsef.FC_PhaseLeave_Filter,nil,fid)
		local reset=false
		local solve=false
		if #rg<=0 then reset=true end
		if times and times>0 and not whos then 
			if eturnct>turnct+(times-1) then reset=true end
			if eturnct==turnct+(times-1) then solve=true end
		end
		if times and times>0 and whos==0 and eturnp==tp then
			if eturncttp>turncttp+(times-1) then reset=true end
			if eturncttp==turncttp+(times-1) then solve=true end
		end
		if times and times>0 and whos==0 and eturnp~=tp then
			if eturnctop>turnctop+(times-1) then reset=true end
			if eturnctop==turnctop+(times-1) then solve=true end
		end
		if not times then 
			solve=true
		end
		if reset then
			g:DeleteGroup() 
			e:Reset() 
			return false 
		end
		return solve
	end
end
function rsef.FC_PhaseLeave_Op(way,fid)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetOwner()
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		local g=e:GetLabelObject()
		local rg=g:Filter(rsef.FC_PhaseLeave_Filter,nil,fid)
		if type(way)=="function" then way(rg,e,tp,eg,ep,ev,re,r,rp)
		elseif way=="des" then Duel.Destroy(rg,REASON_EFFECT)
		elseif way=="th" then Duel.SendtoHand(rg,nil,REASON_EFFECT)
		elseif way=="td" then Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		elseif way=="tdt" then Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
		elseif way=="tdb" then Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)
		elseif way=="rm" then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		elseif way=="tg" then Duel.SendtoGrave(rg,REASON_EFFECT)
		end
	end
end 
----------------"Part_Effect_SingleContinuous"----------------

--Single Continues: Base set
function rsef.SC(reg_list,code,desc_list,lim_list,flag,con,op,reset_list)
	return rsef.Register(reg_list,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,code,desc_list,lim_list,nil,flag,nil,con,nil,nil,op,nil,nil,nil,reset_list)
end 


-------------------"Part_Summon_Function"---------------------
--Summon Function: Set Default Parameter
function rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	sstype= sstype or 0 
	ssplayer=ssplayer or Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER) 
	tplayer=tplayer or ssplayer
	ignorecon=ignorecon or false
	ignorerevie=ignorerevie or false
	pos=pos or POS_FACEUP
	return sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos
end
--Summon Function: Duel.SpecialSummon + buff
function rssf.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumcardfun,sumgroupfun)
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local ct=0
	local g=Group.CreateGroup()
	local sg=rsgf.Mix2(ssgorc)
	for sc in aux.Next(sg) do
		if rssf.SpecialSummonStep(sc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumcardfun) then
			ct=ct+1
			g:AddCard(sc)
		end
	end
	if ct>0 then
		Duel.SpecialSummonComplete()
	end
	for sc in aux.Next(g) do
		if sc:GetFlagEffect(rscode.Pre_Complete_ploc)>0 then
			sc:CompleteProcedure()
			sc:ResetFlagEffect(rscode.Pre_Complete_ploc)
		end
	end
	local e=g:GetFirst():GetReasonEffect()
	local tp=e:GetHandlerPlayer()
	local c=g:GetFirst():GetReasonEffect():GetHandler()
	if #g>0 and sumgroupfun then
		if type(sumgroupfun)=="table" then 
			rsef.FC_PHASELEAVE({c,tp},g,table.unpack(sumgroupfun))
		elseif type(sumgroupfun)=="string" then
			rsef.FC_PHASELEAVE({c,tp},g,nil,nil,PHASE_END,sumgroupfun)
		elseif type(sumcardfun)=="function" then
			sumgroupfun(g,c,e,tp)
		end
	end
	return ct,g,g:GetFirst()
end 
--Summon Function: Duel.SpecialSummonStep + buff 
function rssf.SpecialSummonStep(sc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumcardfun) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local tf=false
	if zone then
		tf=Duel.SpecialSummonStep(sc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		tf=Duel.SpecialSummonStep(sc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	if tf and sumcardfun then
		local e=sc:GetReasonEffect()
		local tp=e:GetHandlerPlayer()
		local c=sc:GetReasonEffect():GetHandler()
		if type(sumcardfun)=="table" then 
			rscf.QuickBuff({c,sc,true},table.unpack(sumcardfun))
		elseif type(sumcardfun)=="function" then
			sumcardfun(c,sc,e,tp,g)
		end
	end
	return tf,sscard
end
--Summon Function: Duel.SpecialSummon to either player's field + buff
function rssf.SpecialSummonEither(ssgorc,e,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone2,sumfun) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	if not e then e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT) end
	local tp=ssplayer
	local zone={}
	local flag={}
	if not zone2 then
		zone2={[0]=0x1f,[1]=0x1f}
	end
	local ssg=rsgf.Mix2(ssgorc)
	for sscard in aux.Next(ssg) do 
		local ava_zone=0
		for p=0,1 do
			zone[p]=zone2[p]&0xff
			local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
			flag[p]=(~flag_tmp)&0x7f
		end
		for p=0,1 do
			if sscard:IsCanBeSpecialSummoned(e,sstype,ssplayer,ignorecon,ignorerevie,pos,p,zone[p]) then
				ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16))
			end
		end
		if ava_zone<=0 then return 0,nil end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
		local sump=0
		if sel_zone&0xff>0 then
			sump=tp
		else
			sump=1-tp
			sel_zone=sel_zone>>16
		end
		if rssf.SpecialSummonStep(sscard,sstype,ssplayer,sump,ignorecon,ignorerevie,pos,sel_zone,sumfun) then
			ssg:AddCard(sscard)
		end
	end
	if #ssg>0 then
		Duel.SpecialSummonComplete()
	end
	return #ssg,ssg,ssg:GetFirst()
end

-------------------"Part_Value_Function"---------------------

--value: SF_SSConditionValue - can only be special summoned from Extra Deck (if can only be XXX summoned from Extra Deck, must use aux.OR(xxxval,rsval.spconfe), but not AND)
function rsval.spconfe(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
--value: SummonConditionValue - can only be special summoned by self effects
function rsval.spcons(e,se,sp,st)
	return se:GetHandler()==e:GetHandler() and se:IsHasType(EFFECT_TYPE_ACTIONS) 
end
--value: reason by battle or card effects
function rsval.indbae(string1,string2)
	return function(e,re,r,rp)
		if not string1 and not string2 then return r&REASON_BATTLE+REASON_EFFECT ~=0 end
		return ((string1=="battle" or string2=="battle") and r&REASON_BATTLE ~=0 ) or ((string1=="effect" or string2=="effect") and r&REASON_EFFECT ~=0 )
	end
end
--value: reason by battle or card effects, EFFECT_INDESTRUCTABLE_COUNT
function rsval.indct(string1,string2)
	return function(e,re,r,rp)
		if ((string1=="battle" or string2=="battle") and r&REASON_BATTLE ~=0 ) or ((string1=="effect" or string2=="effect") and r&REASON_EFFECT ~=0 ) or (not string1 and not string2 and r&REASON_BATTLE+REASON_EFFECT ~=0) then
			return 1
		else return 0 
		end
	end
end
--value: unaffected by opponent's card effects
function rsval.imoe(e,re)
	return e:GetOwnerPlayer()~=re:GetHandlerPlayer()
end
--value: unaffected by other card effects 
function rsval.imes(e,re)
	return re:GetOwner()~=e:GetOwner()
end
--value: unaffected by other card effects that do not target it
function rsval.imntg1(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetOwner()==e:GetOwner() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: unaffected by opponent's card effects that do not target it
function rsval.imntg2(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetHandlerPlayer()==e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: EFFECT_CANNOT_INACTIVATE,EFFECT_CANNOT_DISEFFECT
function rsval.cdisneg(filter)
	return function(e,ct)
		local p=e:GetHandlerPlayer()
		local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
		return (not filter and p==tp) or (filter and filter(e,p,te,tp,loc))
	end
end

-------------------"Part_Target_Function"---------------------

--Card target: do not have an effect target it
function rstg.neftg(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end 
--Effect Target: Negative Effect/Activate
function rstg.disnegtg(disorneg,waystring)
	local dncate=0
	if disorneg=="dis" then dncate=CATEGORY_DISABLE 
	elseif disorneg=="neg" then dncate=CATEGORY_NEGATE 
	elseif disorneg=="sum" then dncate=CATEGORY_DISABLE_SUMMON 
	end
	local setfun=function(setc,setignore)
		return setc:IsSSetable(true)
	end
	local waylist={"des","rm","th","td","tg","set","nil"}
	local waylist2={aux.TRUE,Card.IsAbleToRemove,Card.IsAbleToHand,Card.IsAbleToDeck,Card.IsAbleToGrave,setfun,aux.TRUE }
	local waylist3={Card.IsDestructable,Card.IsAbleToRemove,Card.IsAbleToHand,Card.IsAbleToDeck,Card.IsAbleToGrave,setfun,aux.TRUE }
	local catelist={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,CATEGORY_TOGRAVE,0,0}
	if type(waystring)==nil then waystring="des" end
	if not waystring then waystring="nil" end
	local _,_,filterfun=rsof.Table_Suit(waystring,waylist,waylist2)
	local _,_,filterfun2,cate=rsof.Table_Suit(waystring,waylist,waylist3,catelist)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local rc=re:GetHandler()
		if chk==0 then return 
			--filterfun(rc) 
			waystring~="rm" or aux.nbcon(tp,re) 
		end
		Duel.SetOperationInfo(0,dncate,eg,1,0,0)
		if cate and cate~=0 then 
			if disorneg=="sum" or (filterfun2(rc) and rc:IsRelateToEffect(re)) then
				Duel.SetOperationInfo(0,cate,eg,1,0,0)
			end
		end
		if c:IsType(TYPE_CONTINUOUS+TYPE_FIELD+TYPE_PENDULUM) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsOnField() and c:IsRelateToEffect(e) then
			rsef.relationinfo[Duel.GetCurrentChain()]=true
		else
			rsef.relationinfo[Duel.GetCurrentChain()]=false
		end
	end
end 
function rstg.distg(waystring)
	return function(...)
		return rstg.disnegtg("dis",waystring)(...)
	end
end
function rstg.negtg(waystring)
	return function(...)
		return rstg.disnegtg("neg",waystring)(...)
	end
end
function rstg.negsumtg(waystring)
	return function(...)
		return rstg.disnegtg("sum",waystring)(...)
	end
end
--Effect target: Target Cards Main Set 
--effect parameter table main set
function rsef.list(list_type_str,parameter1,...)
	--{cfilter,gfilter}, if you use table, gfilter must be function, if you use gfilter, loc1 must be number !!!!!!!!!
	local parameter2,parameter3=({...})[1],({...})[2]
	local mix_list={parameter1,...}
	local len=#mix_list
	local target_list_total={}  
	--1.  cfilter,category,loc1 
	if type(parameter1)~="table" then 
		target_list_total={{parameter1,...}} 
	--2. { cfilter,gfilter }, { category_fun,category_str,select_hint } ,loc1 
	elseif type(parameter1)=="table" and len>1 and type(parameter1[1])=="function" and (type(parameter1[2])=="nil" or type(parameter1[2])=="function") and (type(parameter1[2])~="function" or type(parameter3)=="number") then
		target_list_total={{parameter1,...}}
	--3. {A,B,C},{{D,E,F}} OR {A,B,C},{D,E,F} OR {{A,B,C}},{D,E,F}, to {{A,B,C},{D,E,F}}
	else
		for _,mix_parammeter in pairs(mix_list) do 
			if rsof.Check_Boolean(mix_parammeter[0],true) then
				for idx,mix_parammeter2 in pairs(mix_parammeter) do
					if idx~=0 then
						table.insert(target_list_total,mix_parammeter2)
					end
				end 
			else
				table.insert(target_list_total,mix_parammeter)
			end
		end
	end
	for _,target_list in pairs(target_list_total) do 
		target_list[0]=target_list[0] or list_type_str
	end  
	target_list_total[0]=true
	return target_list_total
end
--cost parameter table
function rscost.list(valuetype,...)
	return rsef.list("cost",valuetype,...)
end
--target parameter table has card target 
function rstg.list(valuetype,...)
	return rsef.list("target",valuetype,...)
end
--operation check parameter table don't have card target
function rsop.list(valuetype,...)
	return rsef.list("opcheck",valuetype,...)
end

--targetvalue1={filter_card,category,loc1,loc2,minct,maxct,except_fun,select_hint}
function rstg.target0(checkfun,target_fun,...)
	local target_list=rstg.list(...)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc or chk==0 then 
			return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,target_list) and (not checkfun or checkfun(e,tp,eg,ep,ev,re,r,rp))
		end
		local target_group=rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,target_list)
		if target_fun then
			target_fun(target_group,e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function rstg.target(...)
	return rstg.target0(nil,nil,...)
end
function rstg.target2(target_fun,...)
	return rstg.target0(nil,target_fun,...)
end
function rstg.target3(checkfun,...)
	return rstg.target0(checkfun,nil,...)
end
function rsop.target0(checkfun,endfun,...)
	return rstg.target0(checkfun,endfun,rsop.list(...))
end
function rsop.target(...)
	return rstg.target(rsop.list(...))
end
function rsop.target2(endfun,...)
	return rstg.target2(endfun,rsop.list(...))
end
function rsop.target3(checkfun,...)
	return rstg.target2(checkfun,rsop.list(...))
end
--Target function: Get target attributes
function rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list)
	if not target_list then return 0,0,0,0,nil end
	--0.List type  ("cost","target","opcheck")
	local list_type=target_list[0] or "target" 
	--1.Filter
	local filter_function = target_list[1] or aux.TRUE 
	filter_function = type(filter_function)=="table" and filter_function or {filter_function}
	local filter_card,filter_group = table.unpack(filter_function)
	--2.Category  (categroy string,solve function,hint for select )
	local category_val=type(target_list[2])=="table" and target_list[2] or {target_list[2]}
	local category_str_list0,category_fun,select_hint=table.unpack(category_val)
	local _,category_list,category_str_list=rsef.GetRegisterCategory(category_str_list0)
	--3.Locaion Self
	local loc1,loc2=target_list[3],target_list[4]
	local loc1=type(loc1)=="function" and loc1(e,tp,eg,ep,ev,re,r,rp) or loc1
	--4.Locaion Opponent
	local loc2=type(loc2)=="function" and loc2(e,tp,eg,ep,ev,re,r,rp) or loc2
	--5.Minum Count
	local minct,maxct=target_list[5],target_list[6]
	minct=type(minct)=="nil" and 1 or minct
	minct=type(minct)=="function" and minct(e,tp,eg,ep,ev,re,r,rp) or minct
	minct=minct==0 and 999 or minct
	--6.Max Count
	maxct=type(maxct)=="nil" and minct or maxct 
	maxct=type(maxct)=="function" and maxct(e,tp,eg,ep,ev,re,r,rp) or maxct
	--7.Except Group 
	local except_fun=target_list[7]

	--8.specially player target effect value
	local player_list1={ CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES,CATEGORY_DRAW,CATEGORY_HANDES }
	if rsof.Table_Intersection(category_list,player_list1) then 
		if type(filter_card)=="number" then 
			minct = filter_card
			maxct = filter_card
			filter_card = aux.TRUE 
		elseif type(filter_card)=="function" then
			minct = filter_card(e,tp,eg,ep,ev,re,r,rp)
			maxct = filter_card(e,tp,eg,ep,ev,re,r,rp)
			filter_card = aux.TRUE 
		end
		if not rsof.Table_List(category_list,CATEGORY_HANDES) then
			if not loc1 and not loc2 then loc1=0xff end
			if loc1 and type(loc1)=="number" and loc1>0 then loc1=0xff end
			if loc2 and type(loc2)=="number" and loc2>0 then loc2=0xff end
		end
	end
	--9.Fix for solve self 
	if not loc1 and not loc2 then loc1=true end
	return list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun
end
--Get except group use for Duel.IsExistingMatchingCard, eg
function rsgf.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,exceptvalue)
	local c=e:GetHandler()
	local excepttype=aux.GetValueType(exceptvalue)
	local except_group=Group.CreateGroup()
	if excepttype=="Card" or excepttype=="Group" then 
		rsgf.Mix(except_group,exceptvalue)
	elseif excepttype=="boolean" then 
		rsgf.Mix(except_group,c)
	elseif excepttype=="function" then
		rsgf.Mix(except_group,except_fun(e,tp,eg,ep,ev,re,r,rp))
	end
	return except_group,#except_group
end
--Effect target: Check chkc & chk
function rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,target_list_total)
	local c=e:GetHandler()
	--1. Get the first target list parameter
	local list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun= rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list_total[1])
	--2. Get except group
	local except_group=rsgf.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,except_fun)
	--3. Check 1 Target Card (chkc)
	if chkc then
		--3.1. Check Self
		if type(loc1)=="boolean" then 
			return chkc==c and (not filter_card or filter_card(chkc,e,tp,eg,ep,ev,re,r,rp))
		end
		--3.2. Check if target are 2 or more 
		for idx=2,#target_list_total do 
			local target_list=target_list_total[idx]
			if target_list and target_list[0]=="target" then 
				return false
			end
		end
		--3.3. Check if there are 2 or more target cards
		if minct>1 then return false end
		--3.4. Check if meet the conditions 
		if not chkc:IsLocation(loc1+loc2) then return false end 
		if loc1==0 and loc2>0 and chkc:IsControler(tp) then return false end
		if loc2==0 and loc1>0 and chkc:IsControler(1-tp) then return false end
		if #except_group>0 and except_group:IsContains(chkc) then return false end
		if filter_card and not filter_card(chkc,e,tp,eg,ep,ev,re,r,rp) then return false end
		return true
	end 
	--4. Check if meet the conditions 
	if chk==0 then 
		local player_list1={ CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES,CATEGORY_DRAW }
		--4.1. Ignore check (Force Effects)
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) then return true end
		--4.2. Creat used check 
		local used_group=Group.CreateGroup()
		local used_count_list={[0]=0,[1]=0,[1]=0,[2]=0}
		--4.3. Checking 
		--4.3.1. Get check main function 
		local target_fun=list_type=="target" and Duel.IsExistingTarget or Duel.IsExistingMatchingCard 
		--4.3.2. Formally checking
		--4.3.2.1 Checking self
		if type(loc1)=="boolean" then 
			return not except_group:IsContains(c) and rstg.TargetFilter(c,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,table.unpack(target_list_total))
		--4.3.2.2 Checking not self
		else 
			local minct2=(type(minct)~="number" or minct==0) and 1 or minct
			if rsof.Table_Intersection(category_list,player_list1) then 
				minct2=1
			end
			if minct2==999 then return false end
			if not filter_group then
				local res=target_fun(rstg.TargetFilter,tp,loc1,loc2,minct2,except_group,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,table.unpack(target_list_total))
				return res
			else
				local target_group=Duel.GetMatchingGroup(filter_card,tp,loc1,loc2,except_group,e,tp,eg,ep,ev,re,r,rp)
				if list_type=="target" then target_group=target_group:Filter(Card.IsCanBeEffectTarget,nil,e) end
				return target_group:CheckSubGroup(rstg.GroupFilter,minct2,maxct,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,table.unpack(target_list_total))
			end
		end
	end
end
--Effect target: Select Cards
function rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,target_list_total)
	local c=e:GetHandler()
	local player_target_list={ CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES,CATEGORY_DRAW,CATEGORY_HANDES }
	local player_target_list1={ CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES,CATEGORY_DRAW }
	--1. Creat used check
	local used_group=Group.CreateGroup()
	local used_count_list={[0]=0,[1]=0,[1]=0,[2]=0}
	local info_list={}
	local selected_group_total_list={}
	--2. Selecting 
	--for idx,target_list in pairs(target_list_total) do 
	--cannot use above method because may have target_list_total[0]
	for idx=1,#target_list_total do 
		local target_list=target_list_total[idx]
		--2.0. Get Next target_list
		local target_list_next={}
		for idx2,target_list_next_par in pairs(target_list_total) do 
			if idx2>idx then
				table.insert(target_list_next,target_list_next_par)
			end
		end
		--2.1. Get target list parameter
		local list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list)
		--2.2. Get except group
		local except_group=rsgf.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,except_fun)
		except_group:Merge(used_group)
		--2.3. Set must select group  
		local must_select_group=Group.CreateGroup()
		--2.4. Formally Selecting
		--Check Sub Group 
		if filter_group then 
			must_select_group=Duel.GetMatchingGroup(filter_card,tp,loc1,loc2,except_group,e,tp,eg,ep,ev,re,r,rp)
		end
		--2.4.1. Special case - Tribute 
		if rsof.Table_List(category_list,CATEGORY_RELEASE) then
			--2.4.1.1 Tribute self 
			if type(loc1)=="number" then
				local rg0=Group.CreateGroup()
				local rg=Duel.GetReleaseGroup(tp,true)
				local rg2=Duel.GetReleaseGroup(1-tp,true)
				--2.4.1.2.1. Tribute from hand or Mzone 
				if loc1 & LOCATION_MZONE ~=0 then
					must_select_group:Merge(rg:Filter(Card.IsLocation,nil,LOCATION_MZONE))
				end
				if loc1 & LOCATION_HAND ~=0 then
					must_select_group:Merge(rg:Filter(Card.IsLocation,nil,LOCATION_HAND))
				end
				--[[
				if loc2 & LOCATION_MZONE ~=0 then
					must_select_group:Merge(rg2:Filter(Card.IsLocation,nil,LOCATION_MZONE))
				end
				if loc2 & LOCATION_HAND ~=0 then
					must_select_group:Merge(rg2:Filter(Card.IsLocation,nil,LOCATION_HAND))
				end
				]]--
			end
			--2.4.1.2.2. Tribute from other zone
			if loc2 and loc2 & 0xff-LOCATION_HAND+LOCATION_MZONE ~=0 then
				local rg3=Duel.GetMatchingGroup(Card.IsReleasable,tp,loc1,loc2,except_group)
				must_select_group:Merge(rg3)
			end
		end
		--Self
		if type(loc1)=="boolean" then
			must_select_group=Group.FromCards(c)
		end
		--Check Sub Group 2
		if filter_group then 
			must_select_group=must_select_group:Filter(filter_card,nil,e,tp,eg,ep,ev,re,r,rp)
		else
			must_select_group=must_select_group:Filter(rstg.TargetFilter,nil,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,target_list,table.unpack(target_list_next))
		end
		if list_type=="target" then must_select_group=must_select_group:Filter(Card.IsCanBeEffectTarget,nil,e) end
		--2.4.2. Base Selecting
		local select_fun=list_type=="target" and Duel.SelectTarget or Duel.SelectMatchingCard 
		local select_hint2=rsef.GetDefaultHintString(category_list,loc1,loc2,select_hint)   
		local selected_group	 
		Duel.Hint(HINT_SELECTMSG,tp,hint)
		--2.4.2.1. Select from must select group
		if #must_select_group>0 then
			if filter_group then 
				if list_type~="opcheck" then
					selected_group=must_select_group:SelectSubGroup(tp,rstg.GroupFilter,false,minct,maxct,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,target_list,table.unpack(target_list_next))
				end
			else
				--2.4.2.1.1. Select whole group
				if type(loc1)=="boolean" or type(minct)=="boolean" then
					selected_group=must_select_group
				--2.4.2.1.2. Select from group
				elseif type(loc1)=="number" and type(minct)~="boolean" and list_type~="opcheck" then
					selected_group=must_select_group:Select(tp,minct,maxct,nil)
				end
			end
			--Set target card
			if list_type=="target" and selected_group and #selected_group>0 then  
				Duel.SetTargetCard(selected_group)
			end 
		--2.4.2.2. Directly select
		elseif type(loc1)=="number" then
			--2.4.2.2.1. Select whole group , or not select but for register operation_info_card_or_group
			if ((type(minct)=="boolean" or list_type=="opcheck")) and not rsof.Table_Intersection(category_list,player_target_list1) then 
				selected_group=Duel.GetMatchingGroup(rstg.TargetFilter,tp,loc1,loc2,except_group,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,target_list,table.unpack(target_list_next))
				if type(minct)=="boolean" then
					used_group:Merge(selected_group)
				end
				if list_type=="target" and selected_group and #selected_group>0 then  
					Duel.SetTargetCard(selected_group)
				end
			--2.4.2.2.2. Player target 
			elseif rsof.Table_Intersection(category_list,player_target_list1) then 
				local val_player=loc1>0 and tp or 1-tp
				selected_group={[val_player]=minct,[val_player+2]=maxct,[1-val_player]=0,[1-val_player+2]=0}			   
			--2.4.2.2.3. Select 
			elseif list_type~="opcheck" and not rsof.Table_Intersection(category_list,player_target_list1) then
				selected_group=select_fun(tp,rstg.TargetFilter,tp,loc1,loc2,minct,maxct,except_group,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,target_list,table.unpack(target_list_next))  
				used_group:Merge(selected_group)
			end
		end  
		--2.5. Solve cost to selected_group   
		if list_type=="cost" then
			local cost_result=rscost.CostSolve(selected_group,category_str_list,category_fun,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list)   
			if not cost_result or (aux.GetValueType(costres)=="Group" and #cost_result<=0) then return end
		end
		--2.6. Register Operationinfo for target
		if list_type~="cost" then 
			for _,category in pairs(category_list) do 
				local is_player = rsof.Table_List(player_target_list,category)
				local info_card_or_group,info_count,info_player,info_loc_or_paramma = nil,0,0,0
				info_card_or_group = aux.GetValueType(selected_group)=="Group" and selected_group or nil
				if not is_player then 
					info_count = type(minct)=="number" and minct or #selected_group
				end
				if aux.GetValueType(selected_group)~="Group" then
					if (type(loc1)=="number" and loc1>0) and (type(loc2)=="number" and loc2>0) then
						info_player = PLAYER_ALL 
					elseif (type(loc1)=="number" and loc1>0) and (type(loc2)~="number" or loc2<=0) then
						info_player = tp 
					elseif (type(loc1)=="number" or loc1<=0) and (type(loc2)=="number" and loc2>0) then 
						info_player = 1-tp 
					end
				end
				if is_player then 
					info_loc_or_paramma = minct
				else
					if aux.GetValueType(selected_group)~="Group" then 
						info_loc_or_paramma = info_loc_or_paramma|(loc1|loc2)
					end
				end
				Duel.SetOperationInfo(0,category,info_card_or_group,info_count,info_player,info_loc_or_paramma)
				if is_player and e:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) then 
					Duel.SetTargetPlayer(info_player)
					Duel.SetTargetParam(info_loc_or_paramma)
				end
			end
		end
		if selected_group and #selected_group>0 then 
			table.insert(selected_group_total_list,selected_group)
		end
	end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return tg,selected_group_total_list
end
--Effect target: Target filter 
function rstg.TargetFilter(c,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,target_list1,target_list2,...)
	local used_group2=used_group:Clone() 
	local used_count_list2=rsof.Table_Clone(used_count_list)
	if target_list1 then
		local list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list1)
		if rsof.Table_List_OR(category_list,CATEGORY_RECOVER,CATEGORY_DAMAGE) then
			--no_use
		elseif rsof.Table_List(category_list,CATEGORY_DECKDES) then 
			local deckdes_player=loc1>0 and tp or 1-tp
			used_count_list2[deckdes_player]=used_count_list2[deckdes_player]+minct  
			if Duel.GetFieldGroupCount(deckdes_player,LOCATION_DECK,0)<used_count_list2[deckdes_player] then return false end
			if list_type=="cost" and not Duel.IsPlayerCanDiscardDeckAsCost(deckdes_player,minct) then return false end
			if list_type~="cost" and not Duel.IsPlayerCanDiscardDeck(deckdes_player,minct) then return false end
		elseif rsof.Table_List(category_list,CATEGORY_DRAW) then 
			local draw_player=loc1>0 and tp or 1-tp
			used_count_list2[draw_player]=used_count_list2[draw_player]+minct  
			if Duel.GetFieldGroupCount(draw_player,LOCATION_DECK,0)<used_count_list2[draw_player] then return false end
			if not Duel.IsPlayerCanDraw(draw_player,minct) then return false end
		elseif rsof.Table_List(category_list,CATEGORY_HANDES) then
			used_group2:AddCard(c) 
			if filter_card and not filter_card(c,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list) then return false end
			if list_type=="cost" and not c:IsDiscardable(REASON_COST) then return false end
			if list_type~="cost" and not c:IsDiscardable(REASON_EFFECT) then return false end
		else
			used_group2:AddCard(c) 
			if filter_card and not filter_card(c,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list) then return false end
		end
	end 
	if target_list2 then
		local player_list1={ CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES,CATEGORY_DRAW }
		local list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list2)
		local target_fun=list_type=="target" and Duel.IsExistingTarget or Duel.IsExistingMatchingCard 
		local except_group=rsgf.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,except_fun)
		except_group:Merge(used_group2)
		if type(loc1)=="boolean" then
			return not except_group:IsContains(e:GetHandler()) and rstg.TargetFilter(e:GetHandler(),e,tp,eg,ep,ev,re,r,rp,used_group2,used_count_list2,target_list2,...) 
		else 
			local minct2=(type(minct)~="number" or minct==0) and 1 or minct
			if rsof.Table_Intersection(category_list,player_list1) then 
				minct2=1
			end
			if minct2==999 then return false end 
			if not filter_group then
				return target_fun(rstg.TargetFilter,tp,loc1,loc2,minct2,except_group,e,tp,eg,ep,ev,re,r,rp,used_group2,used_count_list2,target_list2,...)
			else
				local target_group=Duel.GetMatchingGroup(filter_card,tp,loc1,loc2,except_group,e,tp,eg,ep,ev,re,r,rp)
				if list_type=="target" then target_group=target_group:Filter(Card.IsCanBeEffectTarget,nil,e) end
				return target_group:CheckSubGroup(rstg.GroupFilter,minct2,maxct,e,tp,eg,ep,ev,re,r,rp,used_group2,used_count_list2,target_list2,...)
			end
		end
	end
	return true
end
--Effect target: Group filter 
function rstg.GroupFilter(g,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list,target_list1,target_list2,...)
	local used_group2=used_group:Clone() 
	local used_count_list2=rsof.Table_Clone(used_count_list)
	if target_list1 then
		local list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list1)
		used_group2:Merge(g) 
		if filter_group and not filter_group(g,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list) then return false end
	end   
	if target_list2 then
		local list_type,filter_card,filter_group,category_list,category_str_list,category_fun,select_hint,loc1,loc2,minct,maxct,except_fun = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,target_list2)
		local target_fun=list_type=="target" and Duel.IsExistingTarget or Duel.IsExistingMatchingCard 
		local except_group=rsgf.GetExceptGroup(e,tp,eg,ep,ev,re,r,rp,except_fun)
		except_group:Merge(used_group2)
		if type(loc1)=="boolean" then 
			return not except_group:IsContains(e:GetHandler()) and rstg.TargetFilter(e:GetHandler(),e,tp,eg,ep,ev,re,r,rp,used_group2,used_count_list2,target_list2,...) 
		else 
			local minct2=(type(minct)~="number" or minct==0) and 1 or minct
			local player_list1={ CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES,CATEGORY_DRAW }
			if rsof.Table_Intersection(category_list,player_list1) then 
				minct2=1
			end
			if minct2==999 then return false end 
			if not filter_group then
				return target_fun(rstg.TargetFilter,tp,loc1,loc2,minct2,except_group,e,tp,eg,ep,ev,re,r,rp,used_group2,used_count_list2,target_list2,...)
			else
				local target_group=Duel.GetMatchingGroup(filter_card,tp,loc1,loc2,except_group,e,tp,eg,ep,ev,re,r,rp)
				if list_type=="target" then target_group=target_group:Filter(Card.IsCanBeEffectTarget,nil,e) end
				return target_group:CheckSubGroup(rstg.GroupFilter,minct2,maxct,e,tp,eg,ep,ev,re,r,rp,used_group2,used_count_list2,target_list2,...)
			end
		end
	end
	return true  
end
--cost solve
function rscost.CostSolve(selected_group,category_str_list,category_fun,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list)
	local cost_sucess_group
	local cost_sucess_count=0
	if category_fun then
		local value=category_fun(selected_group,e,tp,eg,ep,ev,re,r,rp,used_group,used_count_list)
		if aux.GetValueType(value)=="Card" or aux.GetValueType(value)=="Group" then
			cost_sucess_group=rsgf.Mix2(value)
		else
			cost_sucess_group=Duel.GetOperatedGroup()
		end
		return cost_sucess_group,#cost_sucess_group
	end
	if not category_str_list or #category_str_list==0 then return true end
	return rsop.operationcard(selected_group,category_str_list[1],REASON_COST,e,tp,eg,ep,ev,re,r,rp)
end
--cost: togarve/remove/discard/release/tohand/todeck as cost
function rscost.cost0(checkfun,costfun,...)
	local cost_list=rscost.list(...)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then 
			return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,nil,cost_list) and (not checkfun or checkfun(e,tp,eg,ep,ev,re,r,rp))
		end
		local cost_group=rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,cost_list)
		if costfun then
			costfun(cost_group,e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
--cost check
function rscost.CostCheck(e,tp,eg,ep,ev,re,r,rp,chk,costlist)
	return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,nil,costlist)
end
--operation/cost function: do operation in card/group
function rsop.operationcard(selected_group,category_str,reason,e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local og
	if type(selected_group)=="table" then 
		if category_str=="dr" then 
			for p=0,1 do 
				local minct=selected_group[p]
				local maxct=selected_group[p+2]
				local dct=minct
				if maxct < minct then return nil,0 end 
				if maxct > minct then 
					local ct_list={}
					for i=minct,maxct do 
						if Duel.IsPlayerCanDraw(p,i) then
							table.insert(ct_list,i)
						end
					end
					rshint.Select(p,rshint.drct)
					dct=Duel.AnnounceNumber(p,table.unpack(ct_list))
				end
				if dct>0 then
					ct=ct+Duel.Draw(p,dct,reason)
				end 
			end
		elseif category_str=="rec" then 
			for p=0,1 do 
				local minct=selected_group[p]
				if minct>0 then 
					ct=ct+Duel.Recover(p,minct,reason,true)
				end
			end
			Duel.RDComplete()
		elseif category_str=="dam" then
			for p=0,1 do 
				local minct=selected_group[p]
				if minct>0 then 
					ct=ct+Duel.Damage(p,minct,reason,true)
				end
			end
			Duel.RDComplete()
		elseif category_str=="disd" then
			for p=0,1 do 
				local minct=selected_group[p]
				local maxct=selected_group[p+2]
				local dct=minct
				if maxct < minct then return nil,0 end 
				if maxct > minct then 
					local ct_list={}
					for i=minct,maxct do 
						if ( reason==REASON_COST and Duel.IsPlayerCanDiscardDeckAsCost(p,i) ) 
							or ( reason~=REASON_COST and Duel.IsPlayerCanDiscardDeck(p,i) ) then
							table.insert(ct_list,i)
						end
					end
					rshint.Select(p,rshint.tgct)
					dct=Duel.AnnounceNumber(p,table.unpack(ct_list))
				end
				if dct>0 then
					ct=ct+Duel.DiscardDeck(p,dct,reason)
				end 
			end
		end
		return ct>0,ct
	end
	if category_str=="des" then ct=Duel.Destroy(selected_group,reason)
	elseif category_str=="des_rm" then ct=Duel.Destroy(selected_group,reason,LOCATION_REMOVED)
	elseif category_str=="rm" then ct=Duel.Remove(selected_group,POS_FACEUP,reason)
	elseif category_str=="rm_d" then ct=Duel.Remove(selected_group,POS_FACEDOWN,reason)
	elseif category_str=="th" then 
		ct=Duel.SendtoHand(selected_group,nil,reason)
		local f=function(c)
			return (c:IsPreviousLocation(LOCATION_REMOVED) and c:IsFacedown()) or c:IsPreviousLocation(LOCATION_EXTRA+LOCATION_DECK)
		end
		if ct>0 and selected_group:IsExists(f,1,nil) then
			Duel.ConfirmCards(1-tp,selected_group)
		end
	elseif category_str=="td" or category_str=="te" then ct=Duel.SendtoDeck(selected_group,nil,2,reason)
	elseif category_str=="te_u" then ct=Duel.SendtoExtraP(selected_group,nil,reason)
	elseif category_str=="td_t" then ct=Duel.SendtoDeck(selected_group,nil,0,reason)
	elseif category_str=="td_b" then ct=Duel.SendtoDeck(selected_group,nil,1,reason)
	elseif category_str=="tg" then 
		local reason2=selected_group:GetFirst():IsLocation(LOCATION_REMOVED) and reason|REASON_RETURN or reason 
		ct=Duel.SendtoGrave(selected_group,reason2)
	elseif category_str=="tg_r" then 
		ct=Duel.SendtoGrave(selected_group,reason|REASON_RETURN)
	elseif category_str=="dish" then
		ct=Duel.SendtoGrave(selected_group,reason|REASON_DISCARD)
	elseif category_str=="res" then
		ct=Duel.Release(selected_group,reason)
	elseif category_str=="con" then
		if Duel.GetControl(selected_group,tp) then
			 ct=Duel.GetOperatedGroup():GetCount()
		end
	elseif category_str=="con_ep" then
		if Duel.GetControl(selected_group,tp,PHASE_END,1) then
			 ct=Duel.GetOperatedGroup():GetCount()
		end
	elseif category_str=="pos" then ct=Duel.ChangePosition(selected_group,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	elseif category_str=="pos_a" then ct=Duel.ChangePosition(selected_group,POS_FACEUP_ATTACK)
	elseif category_str=="pos_d" then ct=Duel.ChangePosition(selected_group,POS_FACEUP_DEFENSE)
	elseif category_str=="pos_dd" then ct=Duel.ChangePosition(selected_group,POS_FACEDOWN_DEFENSE)
	elseif category_str=="set" then
		local stsetfun=function(stc)
			return (stc:IsStatus(STATUS_LEAVE_CONFIRMED) or stc:IsStatus(STATUS_ACTIVATE_DISABLED)) and stc:IsSSetable(true) 
		end
		local stg=selected_group:Filter(stsetfun,nil)
		if #stg>0 then
			for tc in aux.Next(stg) do
				tc:CancelToGrave(true)
			end
			ct=Duel.ChangePosition(selected_group,POS_FACEDOWN_DEFENSE)
			stg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
			if ct>0 and #stg>0 then
				Duel.RaiseEvent(stg,EVENT_SSET,e,reason,tp,tp,0)
			end
			selected_group:Sub(stg)
		end
		if #corg>0 then
			Duel.SSet(tp,selected_group)
			Duel.ConfirmCards(1-tp,selected_group)
			ct=ct+#selected_group
		end
	elseif category_str=="sp" then
		ct=rssf.SpecialSummon(selected_group)
	end
	local og=ct>0 and Duel.GetOperatedGroup() or Group.CreateGroup()
	return og,ct
end

function rscost.cost(...)
	return rscost.cost0(nil,nil,...)
end
function rscost.cost2(costfun,...)
	return rscost.cost0(nil,costfun,...)
end
function rscost.cost3(checkfun,...)
	return rscost.cost0(checkfun,nil,...) 
end

--Target: cost influence effect (rscost.reglabel)
function rstg.reglabel(nolabeltg,inlabeltg,labelct)
	labelct=labelct or 100
	nolabeltg=nolabeltg or aux.FALSE 
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then
			if e:GetLabel()~=labelct then
				return nolabeltg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
			else
				e:SetLabel(0)
				return inlabeltg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
			end
		end
		if chk==0 then
			if e:GetLabel()~=labelct then
				return nolabeltg(e,tp,eg,ep,ev,re,r,rp,0)
			else
				return inlabeltg(e,tp,eg,ep,ev,re,r,rp,0)
			end
		end
		e:SetLabel(0)
		if e:GetLabel()~=labelct then
			nolabeltg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			inlabeltg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end

-------------------"Part_Cost_Function"---------------------
--cost: remove count form self
function rscost.rmct(cttype,ct1,ct2,issetlabel)
	ct1=ct1 or 1
	ct2=ct2 or ct1
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetCounter(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetCounter(cttype) or ct2
		if chk==0 then return c:IsCanRemoveCounter(tp,cttype,minct,REASON_COST) end
		if maxct>minct then
		   local rmlist={}
		   for i=minct,maxct do
			   table.insert(rmlist,i)
		   end
		   minct=Duel.AnnounceNumber(tp,table.unpack(rmlist))
		end
		c:RemoveCounter(tp,cttype,minct,REASON_COST)
		rscost.costinfo[e]=minct
		if issetlabel then
		   e:SetLabel(minct)
		end
	end
end
--cost: remove count form self field
function rscost.rmct2(cttype,loc1,loc2,ct1,ct2,issetlabel)
	loc1=loc1 or LOCATION_MZONE
	loc2=loc2 or 0
	ct1=ct1 or 1
	ct2=ct2 or ct1
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetCounter(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetCounter(cttype) or ct2
		if chk==0 then return Duel.IsCanRemoveCounter(tp,loc1,loc2,cttype,minct,REASON_COST) end
		if maxct>minct then
		   local rmlist={}
		   for i=minct,maxct do
			   table.insert(rmlist,i)
		   end
		   minct=Duel.AnnounceNumber(tp,table.unpack(rmlist))
		end
		Duel.RemoveCounter(tp,1,0,cttype,minct,REASON_COST)
		rscost.costinfo[e]=minct
		if issetlabel then
		   e:SetLabel(minct)
		end
	end
end
--cost: remove overlay card form self
function rscost.rmxyz(ct1,ct2,issetlabel)
	ct1=ct1 or 1
	ct2=ct2 or ct1
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetOverlayCount(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetOverlayCount() or ct2
		if chk==0 then return c:CheckRemoveOverlayCard(tp,minct,REASON_COST) end
		c:RemoveOverlayCard(tp,minct,maxct,REASON_COST)
		local rct=Duel.GetOperatedGroup():GetCount()
		rscost.costinfo[e]=rct
		if issetlabel then
		   e:SetLabel(rct)
		end
	end
end
--cost: if the cost is relate to the effect, use this (real cost set in the target)
function rscost.reglabel(labelcount)
	labelcount=labelcount or 100
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(labelcount)
		return true
	end
end
--cost: Pay LP
function rscost.lpcost(lp,isdirectly,islabel)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local clp=lp
		if rsof.Check_Boolean(lp) then clp=math.floor(Duel.GetLP(tp)/2) end
		if isdirectly then clp=Duel.GetLP(tp)-clp end
		if chk==0 then 
			return clp>0 and Duel.CheckLPCost(tp,clp)
		end
		Duel.PayLPCost(tp,clp)   
		rscost.costinfo[e]=clp
		if islabel then
			e:SetLabel(clp)
		end
	end
end
--cost: Pay Multiple LP
function rscost.lpcost2(lp,max,islabel)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local maxlp=Duel.GetLP(tp)
		if max and type(max)=="number" then
			maxlp=math.min(maxlp,max)
		end
		if type(islabel)=="nil" then islabel=true end
		if chk==0 then return Duel.CheckLPCost(tp,lp) end
		local costmaxlp=math.floor(maxlp/lp)
		local t={}
		for i=1,costmaxlp do
			t[i]=i*lp
		end
		local cost=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.PayLPCost(tp,cost)
		rscost.costinfo[e]=cost
		if islabel then
			e:SetLabel(cost)
		end
	end
end
--cost: tribute self 
function rscost.releaseself(mzone,exmzone)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsReleasable() and (not mzone or Duel.GetMZoneCount(tp,c,tp)>0) and (not exmzone or Duel.GetLocationCountFromEx(tp,tp,c,exmzone)>0) end
		Duel.Release(c,REASON_COST)
	end
end
--cost: register flag to lim_ activate (Quick Effect activates once per chain,e.g)
function rscost.regflag(flagcode,reset_list)
	if not reset_list then reset_list=RESET_CHAIN end
	if type(reset_list)~="table" then reset_list={reset_list} end
	local resetcount= reset_list[2]
	if not resetcount then resetcount=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		flagcode = flagcode or code
		if chk==0 then return c:GetFlagEffect(flagcode)==0 end
		c:RegisterFlagEffect(flagcode,reset_list[1],0,resetcount)
	end
end
function rscost.regflag2(flagcode,reset_list)
	if not reset_list then reset_list=RESET_CHAIN end
	if type(reset_list)~="table" then reset_list={reset_list} end
	local resetcount= reset_list[2]
	if not resetcount then resetcount=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		flagcode = flagcode or code
		if chk==0 then return Duel.GetFlagEffect(tp,flagcode)==0 end
		Duel.RegisterFlagEffect(tp,flagcode,RESET_CHAIN,0,1)
	end
end
-------------------"Part_Condition_Function"---------------------

--Condition in Self Turn
function rscon.turns(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end 
--Condition in Oppo Turn
function rscon.turno(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end 
--Condition in Phase
function rscon.phase(p1,...)
	local parlist={p1,...}
	--phase pass: PHASE_DRAW - PHASE_STANDBY - PHASE_MAIN1 - PHASE_BATTLE_START - PHASE_BATTLE_STEP - PHASE_DAMAGE (start) - PHASE_DAMAGE_CAL (before dcal - dcaling - after dcal) - PHASE_DAMAGE (end) - PHASE_BATTLE - PHASE_MAIN2 - PHASE_END
	return function(e,p)
		local tp=p or e:GetHandlerPlayer()
		local turnp=Duel.GetTurnPlayer()
		local phase_bp=function()
			return Duel.Getcurr_ph()>=PHASE_BATTLE_START and Duel.Getcurr_ph()<=PHASE_BATTLE 
		end
		local phase_dam=function()
			return Duel.Getcurr_ph()==PHASE_DAMAGE or Duel.Getcurr_ph()==PHASE_DAMAGE_CAL 
		end
		local phase_dambdcal=function()
			return Duel.Getcurr_ph()==PHASE_DAMAGE and not Duel.IsDamageCalculated()
		end
		local phase_ndcal=function()
			return Duel.Getcurr_ph()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
		end
		local phase_mp=function()
			return Duel.Getcurr_ph()==PHASE_MAIN1 or Duel.Getcurr_ph()==PHASE_MAIN2
		end
		local str_list={"dp","sp","mp1","bp","bsp","dam","damndcal","dambdcal","dcal","ndcal","mp2","ep","mp"} 
		local phaselist={PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,phase_bp,PHASE_BATTLE_STEP,phase_dam,PHASE_DAMAGE,phase_dambdcal,PHASE_DAMAGE_CAL,phase_ndcal,PHASE_MAIN2,PHASE_END,phase_mp } 
		local mainstr_list={}
		local turnplayerlist={}
		local parlist2=rsof.String_Number_To_Table(parlist) 
		for _,pstring in pairs(parlist2) do
			local mainstring,splitstring=rsof.String_NoSymbol(pstring)
			table.insert(mainstr_list,mainstring)
			table.insert(turnplayerlist,splitstring)
		end
		local phaselist2=rsof.Table_Suit(mainstr_list,str_list,phaselist) 
		for idx,phase in pairs(phaselist2) do 
			if turnplayerlist[idx] then
				if (turnplayerlist[idx]=="_s" and turnp~=tp) or (turnplayerlist[idx]=="_o" and turnp==tp ) then return false end
			end
			if type(phase)=="number" and Duel.Getcurr_ph()==phase then return true 
			elseif type(phase)=="function" and phase() then return true 
			end
		end 
		return false 
	end
end
--Condition in Main Phase
function rscon.phmp(e)
	return rscon.phase("mp1,mp2")(e)
end 
--Condition: Phase no damage calculate , for change atk/def
function rscon.adcon(e)
	return rscon.phase("ndcal")(e)
end
--Condition: Battle Phase 
function rscon.phbp(e)
	return rscon.phase("bp")(e)
end
--Condition: Phase damage calculate,but not calculate 
function rscon.dambdcal(e)
	return rscon.phase("dambdcal")(e)
end
--Condition in ADV or SP Summon Sucess
function rscon.sumtype(sum_list,sumfilter,matchall)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		sumfilter=sumfilter or aux.TRUE 
		local code=e:GetCode()
		local fieldres=(code==EVENT_SUMMON_SUCCESS or code==EVENT_SPSUMMON_SUCCESS or code==EVENT_FLIP_SUMMON_SUCCESS ) and e:IsHasType(EFFECT_TYPE_FIELD)
		local checkg=not fieldres and rsgf.Mix2(c) or eg:Clone()
		sum_list=sum_list or "sp"
		local tf=false
		local code_list_1={"sp","adv","rit","fus","syn","xyz","link","pen"}
		local code_list_2={ SUMMON_TYPE_SPECIAL,SUMMON_TYPE_ADVANCE,SUMMON_TYPE_RITUAL,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_PENDULUM }
		local stype_list=rsof.Table_Suit(sum_list,code_list_1,code_list_2)
		local stypeg=Group.CreateGroup()
		local filterg=Group.CreateGroup()
		for tc in aux.Next(checkg) do
			for _,stype in pairs(stype_list) do
				if tc:IsSummonType(stype) then
					stypeg:AddCard(tc)
				end
			end 
			local mat=tc:GetMaterial()
			if sumfilter then
				local res=sumfilter(tc,e,tp,re,rp,mat)
				if res then filterg:AddCard(tc) end
			end
		end
		if #stypeg<=0 or (matchall and not stypeg:Equal(checkg)) then
			return false
		end
		if #filterg<=0 or (matchall and not filterg:Equal(checkg)) then
			return false
		end
		return true 
	end
end 
--Condition: Negate Effect/Activation
function rscon.disnegcon(disorneg,filterfun,playerfun)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		local seq=nil
		if loc&LOCATION_MZONE ~=0 or loc&LOCATION_SZONE ~=0 then
			seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)
		end
		local tg=nil
		if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		end
		if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
		if filterfun then 
			if type(filterfun)=="function" and not filterfun(e,tp,re,rp,tg,loc,seq) then return false end
			if type(filterfun)=="number" then
				if filterfun==1 and not (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end 
				if filterfun==2 and not re:IsActiveType(TYPE_MONSTER) then return false end
				if filterfun==3 and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
				if filterfun==4 and not re:IsActiveType(TYPE_TRAP+TYPE_SPELL) then return false end
			end
		end
		if playerfun and tp==rp then return false end
		return (disorneg=="dis" and Duel.IsChainDisablable(ev)) or (disorneg=="neg" and Duel.IsChainNegatable(ev))
	end 
end
function rscon.discon(filterfun,playerfun)
	return function(...)
		return rscon.disnegcon("dis",filterfun,playerfun)(...)
	end
end
function rscon.negcon(filterfun,playerfun)
	return function(...)
		return rscon.disnegcon("neg",filterfun,playerfun)(...)
	end
end
--Condition: Is exisit matching card
function rscon.excardfilter(filter,varlist,e,tp,eg,ep,ev,re,r,rp)
	return function(c)
		if not filter then return true end
		if #varlist==0 then return filter(c,e,tp,eg,ep,ev,re,r,rp) end
		return filter(c,table.unpack(rsof.Table_Mix(varlist,{e,tp,eg,ep,ev,re,r,r})))
	end
end
function rscon.excard(filter,loc1,loc2,ct,except_group,...)
	local varlist={...}
	return function(e,tp,eg,ep,ev,re,r,rp)
		filter=filter or aux.TRUE 
		loc1=loc1 or LOCATION_MZONE 
		loc2=loc2 or 0
		ct= ct or 1
		tp= type(tp)=="number" and tp or e:GetHandlerPlayer()
		return Duel.IsExistingMatchingCard(rscon.excardfilter(filter,varlist,e,tp,eg,ep,ev,re,r,rp),tp,loc1,loc2,ct,except_group)
	end
end 
-- rscon.excard + Card.IsFaceup 
function rscon.excard2(filter,loc1,loc2,ct,except_group,...)
	local filter2=aux.AND(filter,Card.IsFaceup)
	return rscon.excard(filter2,loc1,loc2,ct,except_group,...)
end
--Condition: Summon monster to a link zone
function rscon.sumtolz(linkmfilter,summfilter)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local zone=0
		local lmg=Group.CreateGroup()
		if rsof.Check_Boolean(linkmfilter) then
			lmg=rsgf.Mix2(c)
		else
			lmg=Duel.GetMatchingGroup(linkmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp,eg,ep,ev,re,rp)
		end
		for tc in aux.Next(lmg) do
			zone=zone|tc:GetLinkedZone(tp)
		end
		return eg:IsExists(rscon.sumtolz_filter,1,nil,zone,summfilter,e,tp,eg,ep,ev,re,rp)
	end
end 
function rscon.sumtolz_filter(c,zone,summfilter,e,tp,eg,ep,ev,re,rp)
	if summfilter and not summfilter(c,e,tp,eg,ep,ev,re,rp) then return false end
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1-tp then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end

-----------------"Part_Operation_Function"-------------------
--Operation: Negative Effect/Activate/Summon/SpSummon
function rsop.disnegop(disorneg,waystring)
	local fun=nil
	if disorneg=="dis" then fun=Duel.NegateEffect
	elseif disorneg=="neg" then fun=Duel.NegateActivation
	else fun=Duel.NegateSummon
	end
	local setfun=function(setc,setignore)
		return setc:IsSSetable(true)
	end
	if type(waystring)==nil then waystring="des" end
	if not waystring then waystring="nil" end
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local relate=rsef.relationinfo[Duel.GetCurrentChain()] 
		if relate and not c:IsRelateToEffect(e) then return end
		local ct=0
		local rc=re:GetHandler()
		if disorneg=="sum" then 
			fun(eg)
			_,ct=rsop.operationcard(eg,waystring,REASON_EFFECT,e,tp,eg,ep,ev,re,r,rp)
		else
			if fun(ev) and re:GetHandler():IsRelateToEffect(re) and waystring~="nil" then
				_,ct=rsop.operationcard(eg,waystring,REASON_EFFECT,e,tp,eg,ep,ev,re,r,rp)
			end
		end
		return ct
	end
end
function rsop.disop(waystring)
	return function(...)
		return rsop.disnegop("dis",waystring)(...)
	end
end
function rsop.negop(waystring)
	return function(...)
		return rsop.disnegop("neg",waystring)(...)
	end
end
function rsop.negsumop(waystring)
	return function(...)
		return rsop.disnegop("sum",waystring)(...)
	end
end
--Operation: Select Card
function rsop.SelectCheck_Solve(solvefun)
	local solveparlist={}
	local len=0
	if type(solvefun)=="table" then
		for idx,par in pairs(solvefun) do
			if idx>=2 then
				len=len+1
				--table.insert(solveparlist,par)
				solveparlist[len]=par
			end
		end
		solvefun=solvefun[1]
	end
	return solvefun,solveparlist,len
end
--Function:outer case function for SelectSolve 
function rsop.SelectOC(checkhint,isbreak,selecthint)
	rsop.SelectOC_checkhint=checkhint
	rsop.SelectOC_isbreak=isbreak
	rsop.SelectOC_selecthint=selecthint
	return true
end
--Function:Select card by filter and do operation on it
function rsop.SelectSolve(selecthint,sp,filter,tp,loc1,loc2,minct,maxct,except_group,solvefun,...)
	minct=minct or 1 
	maxct=maxct or minct
	local checkhint,isbreak,selecthint2=rsop.SelectOC_checkhint,rsop.SelectOC_isbreak,rsop.SelectOC_selecthint
	rsop.SelectOC(nil,nil,nil)
	local solvefun2,solvefunpar,len=rsop.SelectCheck_Solve(solvefun)
	if rsof.Check_Boolean(minct) then
		local g=Duel.GetMatchingGroup(sp,filter,tp,loc1,loc2,except_group,...)
		return rsgf.SelectSolve(g,hintpar,sp,filter,minct,maxct,except_group,solvefun,...)
	else
		if not Duel.IsExistingMatchingCard(filter,tp,loc1,loc2,minct,except_group,...) then 
			return 0,Group.CreateGroup(),nil
		end
		if checkhint and not rsop.SelectYesNo(sp,checkhint) then 
			return 0,Group.CreateGroup(),nil
		end
		rshint.Select(sp,selecthint2 or selecthint)
		local g=Duel.SelectMatchingCard(sp,filter,tp,loc1,loc2,minct,maxct,except_group,...)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not rsop.nohint then
			Duel.HintSelection(g)
		end
		if isbreak then
			Duel.BreakEffect()
		end
		--under bitch function because of lua table's last element cannot be "nil" ,but last solve parameter will often be "nil" 
		local solveparlist={}
		local len2=0
		for idx,solvepar in pairs(solvefunpar) do 
			len2=len2+1
			solveparlist[len2]=solvepar
		end
		if rsop.solveprlen and rsop.solveprlen>len then
			for i=1,rsop.solveprlen-len do 
				len2=len2+1
				solveparlist[len2]=nil
			end
		end
		local solveparlen=select("#",...)
		for idx=1,solveparlen do
			len2=len2+1
			solveparlist[len2]=({...})[idx]
		end
		local res=not solvefun and {g,g:GetFirst()} or {solvefun2(g,table.unpack(solveparlist))}
		rsop.solveprlen=nil
		rsop.nohint=false
		return table.unpack(res)
	end
end
function rsop.GetFollowingSolvepar(solvepar,parlen)
	solvepar=type(solvepar)=="table" and solvepar or {solvepar}
	rsop.solveprlen=parlen
	return solvepar
end
--Function:Select card and send to hand
function rsop.SelectToHand(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	rsop.nohint=true
	return rsop.SelectSolve("th",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.SendtoHand,table.unpack(solvepar)},...)
end
--Function:Select card and send to grave
function rsop.SelectToGrave(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsop.SelectSolve("tg",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.SendtoGrave,table.unpack(solvepar)},...)
end
--Function:Select card and release
function rsop.SelectRelease(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsop.SelectSolve("tg",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.Release,table.unpack(solvepar)},...)
end
--Function:Select card and send to deck
function rsop.SelectToDeck(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	rsop.nohint=true
	return rsop.SelectSolve("td",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.SendtoDeck,table.unpack(solvepar)},...)
end
--Function:Select card and destroy
function rsop.SelectDestroy(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsop.SelectSolve("des",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.Destroy,table.unpack(solvepar)},...)
end
--Function:Select card and remove
function rsop.SelectRemove(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,3)
	rsop.nohint=true
	return rsop.SelectSolve("rm",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.Remove,table.unpack(solvepar)},...)
end
--Function:Select card and special summon
function rsop.SelectSpecialSummon(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=type(solvepar)=="table" and solvepar or {solvepar} 
	local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local parlen=select("#",...)
	if parlen==0 then
		return rsop.SelectSolve("sp",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,rsop.SelectSpecialSummon_Operation(solvepar),e,sp)
	else
		return rsop.SelectSolve("sp",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,rsop.SelectSpecialSummon_Operation(solvepar),...)
	end
end
function rsop.SelectSpecialSummon_Operation(sumfunvarlist)
	return function(tg)
		if #tg<=0 then return 0,tg end
		return rssf.SpecialSummon(tg,table.unpack(sumfunvarlist)) 
	end
end
--Function:Select card and move to field
function rsop.SelectMoveToField(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,8)
	solvepar[1]=solvepar[1] or sp
	rsop.nohint=true
	return rsop.SelectSolve(HINTMSG_TOFIELD,sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.MoveToField,table.unpack(solvepar)},...)
end 
--Function:Select card and move to field and activate
function rsop.SelectMoveToField_Activate(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,7)
	solvepar[1]=solvepar[1] or sp
	maxct=1
	rsop.nohint=true
	return rsop.SelectSolve(rshint.act2,sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.MoveToField_Activate,table.unpack(solvepar)},...)
end 
--Function:Select card and SSet
function rsop.SelectSSet(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	rsop.nohint=true
	return rsop.SelectSolve(HINTMSG_SET,sp,filter,tp,loc1,loc2,minct,maxct,exceptg,rsop.SelectSSet_Operation(sp,solvepar),...)
end
function rsop.SelectSSet_Operation(sp,solvepar)
	return function(tg,...)
		local setp,targetp,confirm,hint=table.unpack(solvepar)
		setp=setp or sp 
		targetp=targetp or setp 
		confirm=confirm or true
		--hint=hint or true 
		if #tg<=0 then return 0,tg end
		--rsop.CheckOperationHint(tg,hint)
		--because Duel.SSet use confirm as parameter, so, i have no choice but directly make it hint.(in other solvefun, the order is first hint and second confirm)
		rsop.CheckOperationHint(tg)
		local ct=Duel.SSet(setp,tg,targetp,confirm)
		local og=Duel.GetOperatedGroup()
		return ct,og,og:GetFirst()
	end
end 
--Operation: Equip 
function rsop.eqop(e,eqc,eqtc,pos,opside)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if opside then tp=1-tp end
	if type(pos)=="nil" then pos=true end
	local vtype=aux.GetValueType(eqlist1)
	if rsof.Check_Boolean(eqlist1) then 
		eqc=rscf.GetRelationThisCard(e)
	elseif vtype=="Card" then
		eqc=eqlist1
	end
	vtype=aux.GetValueType(eqlist2)
	if rsof.Check_Boolean(eqlist2) then 
		eqtc=rscf.GetRelationThisCard(e)
	elseif vtype=="Card" then
		eqtc=eqlist2
	end
	if eqc==eqtc then return false end
	if eqc then
		if not ((eqc:IsLocation(LOCATION_SZONE) and eqc:IsControler(tp)) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (eqc:IsFacedown() and not pos) or not eqtc or eqtc:IsFacedown() then
			Duel.SendtoGrave(eqc,REASON_EFFECT)
		return false
		end
		local eqlim_fun=function(ee,ec)
			return ec==ee:GetLabelObject()
		end
		if Duel.Equip(tp,eqc,eqtc,pos)~=0 then
			local e1=nil
			if eqc:GetOriginalType()&TYPE_EQUIP ==0 then
				local flag=(eqc==c and EFFECT_FLAG_CANNOT_DISABLE or nil)
				e1=rsef.SV({c,eqc},EFFECT_EQUIP_LIMIT,eqlim_fun,nil,nil,rsreset.est,flag)
				e1:SetLabelObject(eqtc)
			else
				local elist={eqc:IsHasEffect(EFFECT_EQUIP_LIMIT)}
				e1=elist[1]
			end
			return true,eqc,eqtc,e1
		end
	end
	return false
end
--Operation function: for following operation, check hint 
function rsop.CheckOperationHint(g,hint,confirm)
	local ishint,isconfirm=false
	if rsof.Check_Boolean(hint,true) then ishint=true end
	if type(hint)=="nil" then ishint=g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)==#g end
	if rsof.Check_Boolean(confirm,true) then isconfirm=true end
	if type(confirm)=="nil" then isconfirm=g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)~=#g end
	if ishint then 
		Duel.HintSelection(g)
	end
	return ishint,isconfirm
end
--Operation function:Send to hand and confirm or hint 
function rsop.SendtoHand(corg,p,reason,hint,confirm)
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	reason= reason or REASON_EFFECT 
	local ishint,isconfirm=rsop.CheckOperationHint(g,hint,confirm)
	local ct=Duel.SendtoHand(g,p,reason)
	if ct>0 and isconfirm then
		p=p or g:GetFirst():GetControler()
		Duel.ConfirmCards(1-p,g)
	end
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:Send to deck and hint 
--if you don't neet hint, best use normal Duel.SendtoDeck
function rsop.SendtoDeck(corg,p,seq,reason,hint)
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local ct=Duel.SendtoDeck(g,p,seq,reason)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end 
--Operation function:Send to grave and hint 
--if you don't neet hint, best use normal Duel.SendtoDeck
function rsop.SendtoGrave(corg,reason,hint)
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		reason=reason|REASON_RETURN 
	end
	local ct=Duel.SendtoGrave(g,reason)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:Release and hint 
--if you don't neet hint, best use normal Duel.SendtoDeck
function rsop.Release(corg,reason,hint)
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local f=function(c)
		return (c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsOnField()) or c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
	end
	local ct=0
	if g:IsExists(f,1,nil,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND) then
		ct=Duel.SendtoGrave(g,reason|REASON_RELEASE)
	else
		ct=Duel.Release(g,reason)
	end
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:destroy and hint
--if you don't neet hint, best use normal Duel.Destroy
function rsop.Destroy(corg,reason,desloc,hint)
	reason= reason or REASON_EFFECT 
	desloc= desloc or LOCATION_GRAVE 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local ct=Duel.Destroy(g,reason,desloc)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:Remove and hint 
--if you don't neet hint, best use normal Duel.Remove
function rsop.Remove(corg,pos,reason,hint)
	pos= pos or POS_FACEUP 
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local ct=Duel.Remove(g,pos,reason)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:MoveToField and hint 
--if you don't neet hint, best use normal Duel.MoveToField
function rsop.MoveToField(corg,movep,targetp,loc,pos,enable,zone,hint,confirm)
	local g=rsgf.Mix2(corg)
	targetp=targetp or movep 
	pos= pos or POS_FACEUP 
	if #g<=0 then return false end
	local correctg=Group.CreateGroup()
	rsop.CheckOperationHint(g,hint)
	for tc in aux.Next(g) do 
		if tc:IsType(TYPE_PENDULUM) then 
			ploc=loc or LOCATION_PZONE 
		else
			ploc=loc or rsef.GetRegisterRange(tc)  
		end
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc and ploc==LOCATION_FZONE then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local bool=false
		if zone then
			bool=Duel.MoveToField(tc,movep,targetp,ploc,pos,enable,zone)
		else
			bool=Duel.MoveToField(tc,movep,targetp,ploc,pos,enable)
		end
		if bool then
			correctg:AddCard(tc)
		end
	end
	local facedowng=correctg:Filter(Card.IsFacedown,nil)
	if confirm then
		Duel.ConfirmCards(1-movep,facedowng)
	end
	return #correctg,correctg,correctg:GetFirst()
end
--Operation function:MoveToField and treat activate and hint 
--if you don't neet hint, best use normal Duel.MoveToField
function rsop.MoveToField_Activate(tc,movep,targetp,loc,pos,enable,zone,hint)
	if aux.GetValueType(tc)~="Card" then
		Debug.Message("rsop.Activate can only activate 1 card, don't use group as the first parameter!")
		return false
	end
	targetp=targetp or movep 
	pos=POS_FACEUP 
	rsop.CheckOperationHint(g,hint)
	if tc:IsType(TYPE_PENDULUM) then 
		ploc=loc or LOCATION_PZONE 
	else
		ploc=loc or rsef.GetRegisterRange(tc)  
	end
	if ploc==LOCATION_MZONE then
		Debug.Message("rsop.Activate can only activate Spell/Trap!")
		return false
	end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc and ploc==LOCATION_FZONE then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	local bool=false
	if zone then 
		bool=Duel.MoveToField(tc,movep,targetp,ploc,pos,enable,zone)
	else
		bool=Duel.MoveToField(tc,movep,targetp,ploc,pos,enable)
	end
	if bool then
		local te=tc:GetActivateEffect()
		if te then
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
		if ploc==LOCATION_FZONE then
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		return true,tc
	end
	return false
end
--Function: Select Yes or No
function rsop.SelectYesNo(p,par,hintcode)
	local string=type(par)=="table" and aux.Stringid(par[1],par[2]) or par
	local res=Duel.SelectYesNo(p,string)
	if res and type(hintcode)=="number" then
		rshint.Card(hintcode)
	end
	return res
end
--Function: N effects select 1
function rsop.SelectOption(p,...)
	local functionlist={...}
	local off=1
	local ops={}
	local opval={}
	for k,v in pairs(functionlist) do
		if rsof.Check_Boolean(v) and k~=#functionlist then
			local selecthint=functionlist[k+1]
			if type(selecthint)=="table" then ops[off]=aux.Stringid(selecthint[1],selecthint[2])
			else
				ops[off]=selecthint
			end
			opval[off-1]=(k+1)/2
			off=off+1
		end
	end
	if #ops<=0 then 
		return nil
	else
		local final=functionlist[#functionlist]
		if #ops==1 and rsof.Check_Boolean(final) then
			return opval[0]
		else
			local op=Duel.SelectOption(p,table.unpack(ops))
			return opval[op]
		end
	end
end
--Function: Select many options (nexpage and lastpage)
function rsop.SelectOption_Page(p,hint_list1,...)
	local hint_list={hint_list1,...}
	local nextpage={m+1,4}
	local lastpage={m+1,5}
	local null={m+1,6}
	local agree={m+1,7}
	local op,currentpage=0,1
	local len=#hint_list
	local maxpage=len<=4 and 1 or math.ceil((len-1)/3)
	local pagehint={}
	for page=1,maxpage do 
		pagehint[page]={}
		if page==1 then
			pagehint[page]={hint_list[1],hint_list[2] or null,hint_list[3] or null,hint_list[4] or null}
		elseif page>1 then
			local idx=page*3-1
			pagehint[page]={hint_list[idx] or null,hint_list[idx+1] or null,hint_list[idx+2] or null}
		end
		if page~=1 then 
			table.insert(pagehint[page],1,lastpage)
		end
		if page~=maxpage then 
			table.insert(pagehint[page],5,nextpage)
		end
		if page==maxpage then 
			table.insert(pagehint[page],5,agree)
		end
	end
	local currentpage=1 
	repeat 
		op=Duel.SelectOption(p,rsof.Table_To_Desc(pagehint[currentpage]))+1
		--null
		if type(pagehint[currentpage][op])=="table" and pagehint[currentpage][op][1]==null[1] and pagehint[currentpage][op][2]==null[2] then op=0 end
		--action agree
		local res1=currentpage==maxpage and op==5
		--action selected
		local res2=op~=1 and op~=5
		--action selected first page
		local res3=op==1 and currentpage==1 
		--next page
		if op==5 and currentpage<maxpage then currentpage=currentpage+1 end
		--last page
		if op==1 and currentpage>1 then currentpage=currentpage-1 end
	until op~=0 and (res1 or res2 or res3)
	if op~=5 and op~=1 and currentpage~=1 then 
		op=3*currentpage+op-3
	end
	local isfinsh=currentpage==maxpage and op==5
	return isfinsh and 0 or op
end
--Function: Select number options
function rsop.AnnounceNumber(tp,maxdigit)
	maxdigit=maxdigit or 7
	if maxdigit>7 then maxdigit=7 end
	local selectnum={m+1,8}
	local confirm={m+1,9}
	local clear={m+1,10}
	local agree={m+1,7}
	local op,isfinsh=0,false
	local num,digitlevel,digitidx=0,1,maxdigit
	for digit=1,maxdigit do 
		digitlevel=digitlevel*(digit==1 and 1 or 10)
	end
	repeat 
		op=rsop.SelectOption_Page(tp,selectnum,confirm,nil,clear)
		if op==2 then
			Debug.Message("Confirm select number:" .. num)
		elseif op==3 then
			num=0
		elseif op==1 then
			for digit=1,maxdigit do
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m+2,7-digitidx))
				num=num+Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,0)*digitlevel
				digitlevel=digitlevel/10
				digitidx=digitidx-1
			end
		end
		digitlevel,digitidx=1,maxdigit
		for digit=1,maxdigit do 
			digitlevel=digitlevel*(digit==1 and 1 or 10)
		end
	until op==0
	return num
end
--Function: Select number options 2
function rsop.AnnounceNumber_List(tp,num1,...)
	local selectnum={m+1,8}
	local add={m+1,11}
	local confirm={m+1,9}
	local clear={m+1,10}
	local agree={m+1,7}   
	local num=0
	repeat 
		op=rsop.SelectOption_Page(tp,selectnum,add,confirm,clear)
		if op==3 then
			Debug.Message("Confirm select number:" .. num)
		elseif op==4 then
			num=0
		elseif op==1 then
			num=Duel.AnnounceNumber(tp,num1,...)
		elseif op==2 then
			num=num+Duel.AnnounceNumber(tp,num1,...)
		end
	until op==0
	return num
end

----------------"Part_ZoneSequence_Function"------------------

--get excatly colomn zone, import the seq
--zone[1][1] means your colomn Mzone, zone[1][2] means your colomn Szone, zone[1][3] means your colomn Mzone+Szone
--zone[2] is the same, zone[3] is zone[1]+zone[2] (all players)
--seq must use rsv.GetExcatlySequence to Get true sequence
function rszsf.GetExcatlyColumnZone(seq)
	local zone={}
	for i=0,1 do
		zone[i]={}
		if i==1 then seq=seq+16 end
		zone[i][1]=2^seq 
		zone[i][2]=(2^seq)*0x100
		zone[i][3]=zone[i][1]+zone[i][2]
	end 
	zone[3]={}
	zone[3][1]=zone[1][1]+zone[2][1]
	zone[3][2]=zone[1][2]+zone[2][2]
	zone[3][3]=zone[1][3]+zone[2][3]
	return zone
end
--Get Surrounding Zone (up,down,left & right zone)
--p:Use this player's camera to see the sequence, default cp
--contains: Include itself's zone(mid)
--truezone: 1-p's zone must * 0x10000
function rszsf.GetSurroundingZone(c,p,truezone,contains)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rszsf.GetSurroundingZone2(seq,loc,cp,p,truezone,contains)
end
----Get Surrounding Zone (up,down,left & right zone)
--Use sequence to get Surrounding Zone
--p: p's sequence
--contains: Include itself's zone(mid)
--truezone: 1-p's zone must * 0x10000
function rszsf.GetSurroundingZone2(seq,loc,cp,p,truezone,contains)
	local nozone={[0]=0,[1]=0}
	if not p then p=cp end
	if not rsof.Check_Boolean(truezone,false) then truezone=true end
	if not rsof.Check_Boolean(contains,false) then contains=true end
	if loc==LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND then
		Debug.Message("rszsf.GetSurroundingZone2: Location is not on field")
		return nozone,nozone,nozone 
	end
	if loc==LOCATION_PZONE or (loc==LOCATION_SZONE and seq>4) then
		return nozone,nozone,nozone
	end
	if loc==LOCATION_SZONE and seq>4 then 
		return nozone,nozone,nozone 
	end
	local mzone={[0]=0,[1]=0}
	local szone={[0]=0,[1]=0}
	if loc==LOCATION_MZONE then
		if seq==0 or seq==5 then mzone[cp]=mzone[cp]+0x2 end
		if seq==4 or seq==6 then mzone[cp]=mzone[cp]+0x8 end
		if seq>0 and seq<4 then mzone[cp]=mzone[cp]+2^(seq-1)+2^(seq+1) end
		if seq==5 then mzone[1-cp]=mzone[1-cp]+0x8 end
		if seq==6 then mzone[1-cp]=mzone[1-cp]+0x2 end
		if seq==1 then 
			mzone[cp]=mzone[cp]+0x20 
			mzone[1-cp]=mzone[1-cp]+0x40 
		end
		if seq==3 then 
			mzone[cp]=mzone[cp]+0x40 
			mzone[1-cp]=mzone[1-cp]+0x20 
		end
		if seq<5 then szone[cp]=szone[cp]+2^seq end
		if contains then mzone[cp]=mzone[cp]+2^seq end
	elseif loc==LOCATION_SZONE then
		if seq==0 then szone[cp]=szone[cp]+0x2 end
		if seq==4 then szone[cp]=szone[cp]+0x8 end   
		if seq>0 and seq<4 then szone[cp]=szone[cp]+2^(seq-1)+2^(seq+1) end
		mzone[cp]=mzone[cp]+2^seq
		if contains then szone[cp]=szone[cp]+2^seq end
	end
	szone[0]=szone[0]*0x100
	szone[1]=szone[1]*0x100
	if truezone then
		mzone[1-p]=mzone[1-p]*0x10000
		szone[1-p]=szone[1-p]*0x10000
	end
	local ozone={}
	for i=0,1 do
		ozone[i]=mzone[i]+szone[i]
	end
	return mzone,szone,ozone
end

-------------------"Part_Group_Function"---------------------
--Filter group : check different player 
function rsgf.dnpcheck(g)
	return g:GetClassCount(Card.GetControler)==#g
end
--Get Surrounding Group (up,down,left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup(c,contains)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rsgf.GetSurroundingGroup2(seq,loc,cp,contains)
end
--Get Surrounding Group (up,down,left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup2(seq,loc,cp,contains)
	local f=function(c)
		return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
	end
	local mzone,szone,ozone=rszsf.GetSurroundingZone2(seq,loc,cp,cp,true,contains)
	local g=Duel.GetMatchingGroup(f,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=Group.CreateGroup()
	local zone=ozone[0]+ozone[1]
	for tc in aux.Next(g) do 
		local seq=tc:GetSequence()
		if not tc:IsControler(cp) then seq=seq+16 end
		local tczone=2^seq
		if tc:IsLocation(LOCATION_SZONE) then tczone=tczone*0x100 end
		if tczone&zone ~=0 then 
			sg:AddCard(tc)
		end
	end
	return sg
end
--Group effect: get adjacent group
function rsgf.GetAdjacentGroup(c,contains)
	return rsgf.GetAdjacentGroup2(c:GetSequence(),c:GetLocation(),c:GetControler(),contains)
end 
--Group effect: get adjacent group (use sequence)
function rsgf.GetAdjacentGroup2(seq,loc,tp,contains)
	local g=Group.CreateGroup()
	if seq>0 and seq<5 then
		rsgf.Mix(g,Duel.GetFieldCard(tp,loc,seq-1))
	end
	if seq<4 then
		rsgf.Mix(g,Duel.GetFieldCard(tp,loc,seq+1))
	end
	if contains then rsgf.Mix(g,Duel.GetFieldCard(tp,loc,seq)) end
	return g
end
--Group effect: Get Target Group for Operations
function rsgf.GetTargetGroup(targetfilter,...)
	local g,e,tp=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tg=g:Filter(rscf.TargetFilter,nil,e,tp,targetfilter,...)
	return tg,tg:GetFirst()
end
--Group effect: Mix Card & Group,add to the first group
function rsgf.Mix(g,...)
	local list={...} 
	for _,val in pairs(list) do
		if aux.GetValueType(val)=="Group" then
			g:Merge(val)
		elseif aux.GetValueType(val)=="Card" then
			g:AddCard(val)
		end
	end
	return g,#g 
end
Group.Mix=rsgf.Mix
--Group effect: Mix Card & Group,return new group
function rsgf.Mix2(...)
	local g=Group.CreateGroup()
	local list={...}
	for _,val in pairs(list) do
		if aux.GetValueType(val)=="Group" then
			g:Merge(val)
		elseif aux.GetValueType(val)=="Card" then
			g:AddCard(val)
		end
	end
	return g,#g
end
--Group effect:Change Group to Table
function rsgf.Group_To_Table(g)
	local cardlist={}
	for tc in aux.Next(g) do
		table.insert(cardlist,tc)
	end
	return cardlist
end
--Group effect:Change Group to Table
function rsgf.Table_To_Group(list)
	local group=Group.CreateGroup()
	for _,value in pairs(list) do
		if aux.GetValueType(value)=="Card" or aux.GetValueType(value)=="Group" then
			rsgf.Mix(group,value)
		end
	end
	return group 
end
--Group:Select card from group and do operation on it
function rsgf.SelectSolve(g,selecthint,sp,filter,minct,maxct,exceptg,solvefun,...)
	minct=minct or 1 
	maxct=maxct or minct
	local checkhint,isbreak,selecthint2=rsop.SelectOC_checkhint,rsop.SelectOC_isbreak,rsop.SelectOC_selecthint
	rsop.SelectOC(nil,nil,nil)
	local solvefun2,solvefunpar,len=rsop.SelectCheck_Solve(solvefun)
	local tg=g:Filter(filter,exceptg,...)
	if #tg<=0 or (type(minct)=="number" and #tg<minct) then
		return 0,Group.CreateGroup(),nil
	end
	if checkhint and not Duel.SelectYesNo(sp,checkhint) then 
		return 0,Group.CreateGroup(),nil
	end 
	if not rsof.Check_Boolean(minct) then
		rshint.Select(sp,selecthint2 or selecthint)
		tg=tg:Select(sp,minct,maxct,exceptg,...)
		if tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not rsop.nohint then
			Duel.HintSelection(tg)
		end
	end 
	if isbreak then
		Duel.BreakEffect()
	end
	--under bitch function because of lua table's last element cannot be "nil" ,but last solve parameter will often be "nil" 
	local solveparlist={}
	local len2=0
	for idx,solvepar in pairs(solvefunpar) do 
		len2=len2+1
		solveparlist[len2]=solvepar
	end
	if rsop.solveprlen and rsop.solveprlen>len then
		for i=1,rsop.solveprlen-len do 
			len2=len2+1
			solveparlist[len2]=nil
		end
	end
	local solveparlen=select("#",...)
	for idx=1,solveparlen do
		len2=len2+1
		solveparlist[len2]=({...})[idx]
	end
	local res=not solvefun and {tg,tg:GetFirst()} or {solvefun2(tg,table.unpack(solveparlist))}   
	rsop.solveprlen=nil
	rsop.nohint=false
	return table.unpack(res) 
end
Group.SelectSolve=rsgf.SelectSolve
--Group:Select card from group and send to hand
function rsgf.SelectToHand(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	rsop.nohint=true
	return rsgf.SelectSolve(g,"th",sp,filter,minct,maxct,exceptg,{rsop.SendtoHand,table.unpack(solvepar)},...)
end
Group.SelectToHand=rsgf.SelectToHand
--Group:Select card from group and send to grave
function rsgf.SelectToGrave(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsgf.SelectSolve(g,"tg",sp,filter,minct,maxct,exceptg,{rsop.SendtoGrave,table.unpack(solvepar)},...)
end
Group.SelectToGrave=rsgf.SelectToGrave
--Group:Select card from group and release
function rsgf.SelectRelease(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsgf.SelectSolve(g,"tg",sp,filter,minct,maxct,exceptg,{rsop.Release,table.unpack(solvepar)},...)
end
Group.SelectRelease=rsgf.SelectRelease
--Group:Select card from group and send to deck
function rsgf.SelectToDeck(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	rsop.nohint=true
	return rsgf.SelectSolve(g,"td",sp,filter,minct,maxct,exceptg,{rsop.SendtoDeck,table.unpack(solvepar)},...)
end
Group.SelectToDeck=rsgf.SelectToDeck
--Group:Select card from group and destroy
function rsgf.SelectDestroy(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsgf.SelectSolve(g,"des",sp,filter,minct,maxct,exceptg,{rsop.Destroy,table.unpack(solvepar)},...)
end
Group.SelectDestroy=rsgf.SelectDestroy
--Group:Select card from group and remove
function rsgf.SelectRemove(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,3)
	rsop.nohint=true
	return rsgf.SelectSolve(g,"rm",sp,filter,minct,maxct,exceptg,{rsop.Remove,table.unpack(solvepar)},...)
end
Group.SelectRemove=rsgf.SelectRemove
--Group:Select card from group and special summon
function rsgf.SelectSpecialSummon(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	--solvepar=rsop.GetFollowingSolvepar(solvepar,8)
	solvepar = type(solvepar)=="table" and solvepar or {solvepar}
	local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local parlen=select("#",...)
	if parlen==0 then
		return rsgf.SelectSolve(g,"sp",sp,filter,minct,maxct,exceptg,rsop.SelectSpecialSummon_Operation(solvepar),e,sp)
	else
		return rsgf.SelectSolve(g,"sp",sp,filter,minct,maxct,exceptg,rsop.SelectSpecialSummon_Operation(solvepar),...)
	end
end
Group.SelectSpecialSummon=rsgf.SelectSpecialSummon
--Group:Select card and move to field
function rsgf.SelectMoveToField(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,8)
	solvepar[1]=solvepar[1] or sp
	rsop.nohint=true
	return rsgf.SelectSolve(g,HINTMSG_TOFIELD,sp,filter,minct,maxct,exceptg,{rsop.MoveToField,table.unpack(solvepar)},...)
end 
Group.SelectMoveToField=rsgf.SelectMoveToField
--Function:Select card and move to field and activate
function rsgf.SelectMoveToField_Activate(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,7)
	solvepar[1]=solvepar[1] or sp
	maxct=1
	rsop.nohint=true
	return rsgf.SelectSolve(g,rshint.act2,sp,filter,minct,maxct,exceptg,{rsop.MoveToField_Activate,table.unpack(solvepar)},...)
end 
Group.SelectMoveToField_Activate=rsgf.SelectMoveToField_Activate
--Function:Select card and SSet
function rsgf.SelectSSet(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	rsop.nohint=true
	return rsgf.SelectSolve(g,HINTMSG_SET,sp,filter,minct,maxct,exceptg,rsop.SelectSSet_Operation(sp,solvepar),...)
end
Group.SelectSSet=rsgf.SelectSSet

-------------------"Part_Card_Function"---------------------

--Card function: local m and cm and cm.rssetcode 
function rscf.DefineCard(code,setcode)
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]   
	if setcode and not ccodem.rssetcode then
		ccodem.rssetcode=setcode
	end
	return code,ccodem
end
--Card function: rsxx.IsXSetXX
function rscf.DefineSet(setmeta,seriesstring,suffix)
	local prefixlist1={"","Fus","Link","Pre","Ori"} 
	local prefixlist1_fun={"","Fusion","Link","Previous","Original"}
	local prefixlist2={"","M","S","T","ST"} 
	local prefixlist2_fun={ nil,TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP,TYPE_SPELL+TYPE_TRAP }
	suffix=suffix or "" 
	for idx1,prefix1 in pairs(prefixlist1) do 
		for idx2,prefix2 in pairs(prefixlist2) do
			setmeta["Is"..prefix1.."Set"..prefix2..suffix]=rscf.DefineSet_Fun(prefixlist1_fun[idx1],prefixlist2_fun[idx2],seriesstring)
		end
	end
end
function rscf.DefineSet_Fun(prefix1,prefix2,seriesstring)
	return function(c)
		return rscf["Check"..prefix1.."SetCard"](c,seriesstring) and (not prefix2 or c:IsType(prefix2))
	end
end
--Register qucik attribute buff in cards
function rscf.QuickBuff(reglist,...)
	local bufflist={...}  
	local c1,c2=rsef.GetRegisterCard(reglist)
	local reset,reset2
	if not rsof.Table_List(bufflist,"reset") then
		table.insert(bufflist,"reset")
		table.insert(bufflist,rsreset.est)
	end
	local _,ct=rsof.Table_List(bufflist,"reset")
	local resetval=bufflist[ct+1]
	if resetval and type(resetval)~="string" then
		reset=resetval  
		if c1==c2 then
			reset2=type(resetval)=="table" and {resetval[1]|RESET_DISABLE,resetval[2] } or resetval|RESET_DISABLE 
		else
			reset2=resetval
		end
	end
	local setlist={"atk","def","batk","bdef","atkf","deff"} 
	local uplist={"atk+","def+","lv+","rk+"}
	local changelist={"lv","rk","code","set","att","race"} 
	local addlist={"code+","set+","att+","race+"}
	local lim_list={"dis","dise","tri~","atk~","atkan~","datk~","ress~","resns~","td~","th~","cp~","cost~"} 
	local matlim_list={"fus~","syn~","xyz~","link~"}
	local leavelist={"leave"}
	local splist={"mat","cp"} 
	--local phaselist={"ep","sp"}
	local funlist=rsof.Table_Mix(setlist,uplist,changelist,addlist,lim_list,matlim_list,leavelist,splist)
	local funlistatt=rsof.Table_Mix(setlist,uplist,changelist,addlist)
	--local nulllist={}
	--for i=1,#str_list do 
		--table.insert(nulllist,"hape")
	--end
	local effectlist={}
	for idx,par in pairs(bufflist) do
		local vtype=type(par)
		local parnext=bufflist[idx+1]
		local vtypenext=type(parnext)
		if vtype=="string" and par~="reset" then
			local vallist
			if not parnext or vtypenext=="string" then 
				vallist={}
			end
			if parnext and vtypenext~="string" then
				vallist=vtypenext~="table" and {parnext} or parnext
			end
			local str_list=rsof.String_Number_To_Table(par)
			local _,effectval_list=rsof.Table_Suit(par,funlist,{},vallist)
			for k,codestring in pairs(str_list) do
				if rsof.Table_List(funlistatt,codestring) then
					e1=rsef.SV_ATTRIBUTE(reglist,codestring,effectval_list[k],nil,reset2)
				end
				local mainstring,splitstring=rsof.String_NoSymbol(codestring)
				if rsof.Table_List(lim_list,mainstring) then
					local differentlist={"atk"}
					if not rsof.Table_List(differentlist,mainstring) or (splitstring and splitstring=="~") then
						e1=rsef.SV_LIMIT(reglist,mainstring,effectval_list[k],nil,reset,"cd")
					end
				end
				if rsof.Table_List(matlim_list,mainstring) then
					e1=rsef.SV_CANNOT_BE_MATERIAL(reglist,mainstring,effectval_list[k],nil,reset,"cd")
				end
				if rsof.Table_List(leavelist,codestring) then
					e1=rsef.SV_REDIRECT(reglist,codestring,effectval_list[k],nil,rsreset.ered,"cd")
				end 
				if rsof.Table_List(splist,codestring) then
					if codestring=="mat" then
						c2:SetMaterial(effectval_list[k])
					end
					if codestring=="cp" then
						c2:RegisterFlagEffect(rscode.Pre_Complete_ploc,rsreset.est,0,1)
					end
				else
					table.insert(effectlist,e1)  
				end
			end
		end
	end
	return table.unpack(effectlist)
end
--Card effect:Auxiliary.ExceptThisCard 
function rscf.GetSelf(e) 
	if not e then e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT) end
	return aux.ExceptThisCard(e)
end
--Card effect:Auxiliary.ExceptThisCard + Card.IsFaceup()
function rscf.GetFaceUpSelf(e) 
	local c=rscf.GetSelf(e) 
	return c:IsFaceup() and c or nil
end

--Card/Summon effect: Set Special Summon Produce
function rscf.SetSpecialSummonProduce(reg_list,range,con,op,desc_list,lim_list,reset_list)
	local tc1,tc2,ignore=rsef.GetRegisterCard(reg_list)
	if not desc_list then desc_list=rshint.spproc end
	local flag=not tc2:IsSummonableCard() and "uc,cd" or "uc" 
	local e1=rsef.Register(reg_list,EFFECT_TYPE_FIELD,EFFECT_SPSUMMON_plOC,desc_list,lim_list,nil,flag,range,rscf.SetSpecialSummonProduce_con(con),nil,nil,op,nil,nil,nil,reset_list)
	return e1
end
rssf.SetSpecialSummonProduce=rscf.SetSpecialSummonProduce
function rscf.SetSpecialSummonProduce_con(con)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return con(e,c,tp)
	end
end
--Card/Summon effect: Is monster can normal or special summon
function rscf.SetSummonCondition(reg_list,isnsable,sumvalue,iseffectspsum,reset_list)
	local tc1,tc2,ignore=rsef.GetRegisterCard(reg_list)
	if tc2:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not isnsable then
		if iseffectspsum or (sumvalue and sumvalue==rsval.spcons) then
			--tc2:EnableUnsummonable()
		else
			tc2:EnableReviveLimit()
		end
	end
	sumvalue = sumvalue or aux.FALSE 
	local e1=rsef.SV(reg_list,EFFECT_SPSUMMON_CONDITION,sumvalue,nil,nil,reset_list,"uc,cd,sr")
	return e1
end 
rssf.SetSummonCondition=rscf.SetSummonCondition
--Check Built-in SetCode / Series Main Set
function rscf.CheckSetCardMainSet(c,settype,series1,...) 
	local serieslist={series1,...}
	local seriesnormallist={}
	local seriescustomlist={}
	for _,series in pairs(serieslist) do 
		if type(series)=="number" then
			table.insert(seriesnormallist,series) 
		else
			table.insert(seriescustomlist,series) 
		end
	end
	local str_list=rsof.String_Number_To_Table(seriescustomlist)
	local codelist={}
	local effectlist={}
	local addcodelist={}
	if settype=="base" then
		if #seriesnormallist>0 and c:IsSetCard(table.unpack(seriesnormallist)) then return true end
		codelist={c:GetCode()} 
		effectlist={c:IsHasEffect(EFFECT_ADD_SETCODE)} 
	elseif settype=="fus" then
		if #seriesnormallist>0 and c:IsFusionSetCard(table.unpack(seriesnormallist)) then return true end
		codelist={c:GetFusionCode()}
		effectlist={c:IsHasEffect(EFFECT_ADD_FUSION_SETCODE),c:IsHasEffect(EFFECT_ADD_SETCODE)} 
	elseif settype=="link" then
		if #seriesnormallist>0 and c:IsLinkSetCard(table.unpack(seriesnormallist)) then return true end
		codelist={c:GetLinkCode()}
		effectlist={c:IsHasEffect(EFFECT_ADD_LINK_SETCODE),c:IsHasEffect(EFFECT_ADD_SETCODE)} 
	elseif settype=="org" then
		if #seriesnormallist>0 and c:IsOriginalSetCard(table.unpack(seriesnormallist)) then return true end
		codelist={c:GetOriginalCode()}
		effectlist={}
	elseif settype=="pre" then
		if #seriesnormallist>0 and c:IsPreviousSetCard(table.unpack(seriesnormallist)) then return true end
		codelist={c:GetPreviousCodeOnField()}
		effectlist=rscf.Previous_Set_Code_List
	end
	for _,effect in pairs(effectlist) do
		local string=rsval.valinfo[effect]
		if type(string)=="string" then 
			table.insert(addcodelist,string)
		end
	end
	for _,code in ipairs(codelist) do 
		local setcodestring
		local res=not _G["c"..code] and true or false
		if res then _G["c"..code]={} end
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			setcodestring=_G["c"..code].rssetcode
		end
		if res then _G["c"..code]=nil end
		if setcodestring then
			local setcodelist=rsof.String_Number_To_Table(setcodestring)
			for _,string in pairs(str_list) do 
				for _,setcode in pairs(setcodelist) do
					local setcodelist2=rsof.String_Split(setcode, '_')
					if rsof.Table_List(setcodelist2,string) then return true end
				end
			end
		end
	end
	if #addcodelist>0 then
		for _,string in pairs(str_list) do 
			for _,setcode in pairs(addcodelist) do
				local addcodelist2=rsof.String_Split(setcode, '_')
				if rsof.Table_List(addcodelist2,string) then return true end
			end
		end
	end
	return false 
end 
--Check Built-in Base SetCode / Series
function rscf.CheckSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"base",series1,...) 
end
Card.CheckSetCard=rscf.CheckSetCard
--Check Built-in Fusion SetCode / Series
function rscf.CheckFusionSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"fus",series1,...) 
end
Card.CheckFusionSetCard=rscf.CheckFusionSetCard
--Check Built-in Link SetCode / Series
function rscf.CheckLinkSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"link",series1,...) 
end
Card.CheckLinkSetCard=rscf.CheckLinkSetCard
--Check Built-in Original SetCode / Series
function rscf.CheckOriginalSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"org",series1,...)
end
Card.CheckOriginalSetCard=rscf.CheckOriginalSetCard
--Check Built-in Previous SetCode / Series
function rscf.CheckPreviousSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"pre",series1,...)
end
Card.CheckPreviousSetCard=rscf.CheckPreviousSetCard
--Card/Summon effect:Record Summon Procedure
function rscf.RecordSummonProcedure()
	if rscf.RecordSummonProcedure_Switch then return end
	rscf.RecordSummonProcedure_Switch=true
	local f=Effect.CreateEffect
	Effect.CreateEffect=function(c)
		local e0=f(c)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(rscf.RecordSummonProcedure_Operation)
		Duel.RegisterEffect(e1,0)
		Effect.CreateEffect=f
		return e0
	end
end
rssf.RecordSummonProcedure=rscf.RecordSummonProcedure
--directly enable will cause bugs, but i am lazy to find what cards i have used this function
--rssf.RecordSummonProcedure()
function rscf.RecordSummonProcedure_Operation(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,0,0xff,0xff,nil,rscf.extype)
	local f6=aux.AddSynchroProcedure
	local f7=aux.AddSynchroMixProcedure
	local f8=aux.AddXyzProcedure
	local f9=aux.AddXyzProcedureLevelFree
	local f10=aux.AddLinkProcedure
	aux.AddSynchroProcedure=rscf.GetBaseSynchroProduce1
	aux.AddSynchroMixProcedure=rscf.GetBaseSynchroProduce2
	aux.AddXyzProcedure=rscf.GetBaseXyzProduce1
	aux.AddXyzProcedureLevelFree=rscf.GetBaseXyzProduce2
	aux.AddLinkProcedure=rscf.GetBaseLinkProduce1
	for tc in aux.Next(g) do
		--Method ResetEffect/ReplaceEffect will cause issue at Raise Event
		tc:ReplaceEffect(80316585,0)
		local mt=getmetatable(tc)
		if mt.initial_effect then
			mt.initial_effect(tc) 
		end
		
	end
	aux.AddSynchroProcedure=f6
	aux.AddSynchroMixProcedure=f7
	aux.AddXyzProcedure=f8
	aux.AddXyzProcedureLevelFree=f9
	aux.AddLinkProcedure=f10
	e:Reset()
end 
function rscf.GetBaseSynchroProduce1(c,f1,f2,minc,maxc)
	if c.dark_synchro==true then
		rscf.AddSynchroProcedureSpecial(c,aux.NonTuner(f1),nil,nil,rscf.DarkTuner(f2),minc,maxc or 99)
	else
		rscf.AddSynchroProcedureSpecial(c,aux.Tuner(f1),nil,nil,f2,minc,maxc or 99)
	end
end
function rscf.GetBaseSynchroProduce2(c,f1,f2,f3,f4,minc,maxc,gc)
	rscf.AddSynchroProcedureSpecial(c,f1,f2,f3,f4,minc,maxc or 99,gc)
end
function rscf.XyzProcedure_TransformLv(xyzc,lv)
	return  function(g)
				return g:FilterCount(Card.IsXyzLevel,nil,xyzc,lv)==#g
			end
end
function rscf.GetBaseXyzProduce1(c,f,lv,ct,alterf,desc,maxct,op)
	rscf.AddXyzProcedureSpecial(c,f,rscf.XyzProcedure_TransformLv(c,lv),ct,maxct or ct,alterf,desc,op)
end 
function rscf.GetBaseXyzProduce2(c,f,gf,minc,maxc,alterf,desc,op)
	rscf.AddXyzProcedureSpecial(c,f,gf,minc,maxc or minc,alterf,desc,op)
end
function rscf.GetBaseLinkProduce1(c,f,min,max,gf)
	rscf.AddLinkProcedureSpecial(c,f,min,max,gf)
end
--Check is matg exist syncard's right materials
function rscf.GetLocationCountFromEx(...)
	return 1
end
function rscf.CheckSynchroMaterial(sync,tp,smat,matg,min,max,checkft,checkmust,checkpend)
	max=max or 99
	local proce=sync.rs_synchro_parammeter[1]
	if not proce then return false end
	local con=proce:GetCondition()
	local f=Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx=checkft and Duel.GetLocationCountFromEx or rscf.GetLocationCountFromEx 
	local f2=aux.MustMaterialCheck 
	aux.MustMaterialCheck=checkmust and aux.MustMaterialCheck or aux.TRUE 
	local ctype = TYPE_PENDULUM 
	TYPE_PENDULUM = checkpend and TYPE_PENDULUM or TYPE_SPELL  
	local res= not con or con(nil,sync,smat,matg,min,max)   
	Duel.GetLocationCountFromEx=f
	aux.MustMaterialCheck=f2
	TYPE_PENDULUM = ctype
	return res
end
--Select syncard's right materials 
function rsgf.SelectSynchroMaterial(sync,tp,smat,matg,min,max,checkft,checkmust,checkpend)
	max=max or 99
	local proce=sync.rs_synchro_parammeter[1]
	if not proce then return false end
	local tg=proce:GetTarget()
	local f=Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx=checkft and Duel.GetLocationCountFromEx or rscf.GetLocationCountFromEx 
	local f2=aux.MustMaterialCheck 
	local ctype = TYPE_PENDULUM 
	TYPE_PENDULUM = checkpend and TYPE_PENDULUM or TYPE_SPELL
	aux.MustMaterialCheck=checkmust and aux.MustMaterialCheck or aux.TRUE   
	local e1=rsef.SV({sync,true},rscode.Synchro_Material,nil,0xff) 
	tg(e1,tp,nil,nil,nil,nil,nil,nil,1,sync,smat,matg,min,max)
	local g=e1:GetLabelObject()
	Duel.GetLocationCountFromEx=f
	aux.MustMaterialCheck=f2  
	TYPE_PENDULUM = ctype  
	if not g then e1:Reset() return false end
	local og=g:Clone()
	og:KeepAlive()
	e1:Reset()
	return og
end
--Card/Summon function: Custom Synchro Procedure 
rscf.AddSynchroProcedure=aux.AddSynchroProcedure
function rscf.AddSynchroProcedureSpecial(c,f1,f2,f3,f4,minc,maxc,gc)
	local mt=getmetatable(c)
	if not rscf.AddSynchroProcedureSpecial_Switch then
		rscf.AddSynchroProcedureSpecial_Switch=true
		rscf.GetSynMaterials	=   aux.GetSynMaterials
		aux.GetSynMaterials  =  rscf.GetSynMaterials2
		rscf.SynMixCheckGoal	=   aux.SynMixCheckGoal
		aux.SynMixCheckGoal  =  rscf.SynMixCheckGoal2
		rscf.SynMixCondition	=   aux.SynMixCondition
		aux.SynMixCondition  =  rscf.SynMixCondition2
		rscf.SynMixTarget   =   aux.SynMixTarget
		aux.SynMixTarget  =  rscf.SynMixTarget2
		rscf.SynMixFilter4  = aux.SynMixFilter4
		aux.SynMixFilter4   = rscf.SynMixFilter42
		rscf.SynMixOperation	=   aux.SynMixOperation
		aux.SynMixOperation = rscf.SynMixOperation2  
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_plOC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rscf.SynMixCondition2(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetTarget(Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetOperation(Auxiliary.SynMixOperation(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_synchro_parammeter then
		mt.rs_synchro_parammeter={e1,f1,f2,f3,f4,minc,maxc or minc,gc}
	end
	return e1
end
--Get synchro materials, fix for special material
function rscf.GetSynMaterials2(tp,syncard)
	local mg1=rscf.GetSynMaterials(tp,syncard)
	local mg2=Duel.GetMatchingGroup(rscf.ExtraSynMaterialsFilter,tp,0xff,0xff,mg1,syncard,tp)
	if #mg2>0 then mg1:Merge(mg2) end
	return mg1
end
function rscf.ExtraSynMaterialsFilter(c,sc,tp)
	if c:IsOnField() and not c:IsFaceup() then return false end
	return c:IsHasEffect(rscode.Extra_Synchro_Material,tp) and c:IsCanBeSynchroMaterial(sc) 
end
function rscf.SCheckOtherMaterial(c,mg,sc,tp)
	local le={c:IsHasEffect(rscode.Extra_Synchro_Material,tp)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,sc,mg) then return true end
	end
	return false
end
function rscf.SUncompatibilityFilter(c,sg,sc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not rscf.SCheckOtherMaterial(c,mg,sc,tp)
end
function rscf.SynMixCheckGoal2(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	mgchk= mgchk or rssf.synchro_material_group_check
	local mg=rsgf.Mix2(sg,sg1)
	--step 1, check extra material
	if mg:IsExists(rscf.SUncompatibilityFilter,1,nil,mg,syncard,tp) then return false end
	--step 2, check material group filter function
	if syncard.rs_synchro_material_check and not syncard.rs_synchro_material_check(mg,syncard,tp) then return false end
	--step 3, check level fo dark_synchro and non-level_synchro 
	local f=Card.GetLevel
	local darktunerg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
	local darktunerlv=darktunerg:GetSum(Card.GetSynchroLevel,syncard)
	Card.GetLevel=function(sc)
		if syncard.dark_synchro and syncard==sc then
			return darktunerlv*2-f(sc)
		end
		if sc.rs_synchro_level then return sc.rs_synchro_level
		else return f(sc)
		end
	end
	--step 4, check Ladian 1, use material's custom lv (if any)
	local f2=Card.GetSynchroLevel
	Card.GetSynchroLevel=function(sc,sc2)
		local lvcheck=syncard.rs_synchro_ladian 
		if type(lvcheck)=="number" then return lvcheck
		elseif type(lvcheck)=="function" then 
			local lv=lvcheck(sc,mg,sc2,tp)
			if type(lv)=="number" then return lv 
			else return f2(sc,sc2) 
			end
		end
	end
	local bool1=rscf.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	Card.GetSynchroLevel=f2
	--step 5, check Ladian 2, use material's base lv
	local bool2=rscf.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	Card.GetLevel=f
	return bool1 or bool2
end
function rscf.SynMixCondition2(f1,f2,f3,f4,minc,maxc,gc)
	return function(e,c,smat,mg1,min,max)
		if mg1 and aux.GetValueType(mg1)~="Group" then return false end
		return rscf.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)(e,c,smat,mg1,min,max)
	end
end
function rscf.SynMixTarget2(f1,f2,f3,f4,minc,maxc,gc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
		rssf.synchro_material_group_check=nil
		if mg1 then
			rssf.synchro_material_group_check=true
		end
		return rscf.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	end
end
function rscf.SynMixFilter42(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	return rscf.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
end
function rscf.SynMixOperation2(f1,f2,f3,f4,minct,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				rscf.SynchroCustomOperation(g,c,e,tp)
				g:DeleteGroup()
			end
end
function rscf.SynchroCustomOperation(mg,c,e,tp)
	c:SetMaterial(mg)  
	rscf.SExtraMaterialCount(mg,sync,tp)
	--case 1, Summon Effect Custom
	if rssf.SynchroMaterialAction then
		rssf.SynchroMaterialAction(mg,c,e,tp)
		rssf.SynchroMaterialAction=nil
	--case 2, Summon Procedure Custom 
	elseif c.rs_synchro_material_action then
		c.rs_synchro_material_action(mg,c,e,tp)
	--case 3, Base Summon Procedure
	else
		Duel.SendtoGrave(mg,REASON_SYNCHRO+REASON_MATERIAL)
	end
end
function rscf.SExtraMaterialCount(mg,sync,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(rscode.Extra_Synchro_Material,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			if not f or f(te,sync,sg) then
				te:UseCountLimit(tp)
			end
		end
	end
end
--Card/Summon function: Special Synchro Summon Procedure
--Force a synchro level for a synchro monster's synchro procedure
function rscf.AddSynchroProcedureSpecial_SynchroLevel(c,lv,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_level then
		local mt=getmetatable(c)
		mt.rs_synchro_level=lv 
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end
--Dark Synchro Procedure
function rscf.AddSynchroProcedureSpecial_DarkSynchro(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.dark_synchro then
		local mt=getmetatable(c)
		mt.dark_synchro=true
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end
--Ladian's Synchro Procedure (treat tuner as another lv)
function rscf.AddSynchroProcedureSpecial_Ladian(c,f1,lv,f2,f3,f4,minc,maxc,extrafilter)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_ladian then
		local mt=getmetatable(c)
		mt.rs_synchro_ladian={lv,extrafilter}
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,f1,f2,f3,f4,minc,maxc)
	return e1
end
--Check Synchro Material Group for Synchro Procedure
function rscf.AddSynchroProcedureSpecial_MaterialCheck(c,checkfilter,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_material_check then
		local mt=getmetatable(c)
		mt.rs_synchro_material_check=checkfilter
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end

--Custom Synchro Materials' Action
function rscf.AddSynchroProcedureSpecial_CustomAction(c,actionfun,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_material_action then
		local mt=getmetatable(c)
		mt.rs_synchro_material_action=actionfun
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end 

--Card/Summon function: Custom Xyz Procedure 
function rscf.AddXyzProcedureSpecial(c,f,gf,minc,maxc,alterf,desc,op)
	local mt=getmetatable(c)
	if not rscf.AddXyzProcedureSpecial_Switch then
		rscf.AddXyzProcedureSpecial_Switch=true
		rscf.XyzLevelFreeCondition2  =  aux.XyzLevelFreeCondition2
		aux.XyzLevelFreeCondition2  =  rscf.XyzLevelFreeCondition22
		rscf.XyzLevelFreeTarget2  =  aux.XyzLevelFreeCondition2
		aux.XyzLevelFreeTarget2  =  rscf.XyzLevelFreeTarget22
		rscf.XyzLevelFreeOperation2  =  aux.XyzLevelFreeOperation2
		aux.XyzLevelFreeOperation2  =  rscf.XyzLevelFreeOperation22
		rscf.XyzLevelFreeGoal  =  aux.XyzLevelFreeGoal
		rscf.XyzLevelFreeFilter =   aux.XyzLevelFreeFilter
		aux.XyzLevelFreeFilter  =   rscf.XyzLevelFreeFilter2
	end
	--aux.XyzLevelFreeGoal  =  rscf.XyzLevelFreeGoal2(minc,maxc or minc)
	alterf = alterf or aux.FALSE 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_plOC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	--if alterf then
		maxc= maxc or minc
		e1:SetCondition(rscf.XyzLevelFreeCondition22(f,gf,minc,maxc,alterf,desc,op))
		e1:SetTarget(rscf.XyzLevelFreeTarget22(f,gf,minc,maxc,alterf,desc,op))
		e1:SetOperation(rscf.XyzLevelFreeOperation22(f,gf,minc,maxc,alterf,desc,op))
	--[[else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f,gf,minc,maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f,gf,minc,maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f,gf,minc,maxc))--]]
	--end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_xyz_parammeter then
		mt.rs_xyz_parammeter={e1,f1,f2,f3,f4,maxc,gc}
	end
	return e1
end
function rscf.XCheckUtilityMaterial(c,mg,xyzc,tp)
	local le={c:IsHasEffect(rscode.Utility_Xyz_Material,tp)}
	if #le==0 then return 1,{1} end
	local maxreduce=1
	local reducelist={1}
	for _,te in pairs(le) do
		local val=te:GetValue()
		local reduce=1
		if type(val)=="number" then reduce=val end
		if type(val)=="function" then reduce=val(te,xyzc,mg,tp) end
		maxreduce=math.max(maxreduce,reduce or 2) 
		table.insert(reducelist,reduce or 2)
	end
	return maxreduce,reducelist
end
function rscf.XUncompatibilityFilter(c,sg,xyzc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not rscf.XCheckOtherMaterial(c,mg,xyzc,tp,sg)
end
function rscf.XCheckOtherMaterial(c,mg,xyzc,tp,sg)
	local le={c:IsHasEffect(rscode.Extra_Xyz_Material,tp)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,xyzc,mg,sg) then return true end
	end
	return false
end
function rscf.IsCanBeXyzMaterial(c,xyzc)
	if c:IsType(TYPE_TOKEN) then return false end
	if c:IsType(TYPE_MONSTER) then return c:IsCanBeXyzMaterial(xyzc) end
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		local elist={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
		for _,e in pairs(elist) do
			local val=e:GetValue()
			if not val or val(e,xyzc) then return false end
		end
	end
	return true
end
function rscf.XyzLevelFreeFilter2(c,xyzc,f)
	return (not c:IsOnField() or c:IsFaceup()) and rscf.IsCanBeXyzMaterial(c,xyzc) and (not f or f(c,xyzc))   
end
function rscf.ExtraXyzMaterialsFilter(c,xyzc,tp,f)
	if c:IsType(TYPE_TOKEN) then return false end
	if c:IsOnField() and not c:IsFaceup() then return false end
	return c:IsHasEffect(rscode.Extra_Xyz_Material,tp) and rscf.IsCanBeXyzMaterial(c,xyzc) and (not f or f(c))
end
function rscf.XyzLevelFreeGoal2(minct,maxct,og)
	return function(g,tp,xyzc,gf)
		--case 1, extra material check 
		if not og and g:IsExists(rscf.XUncompatibilityFilter,1,nil,g,xyzc,tp) then return false end
		--case 2, normal check
		if (gf and not gf(g,og,tp,xyzc)) or Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
		--if #g<minct then return false end
		if #g>maxct then return false end
		--case 3, utility check, separate mg and ug for easy calculate
		local ug=g:Filter(Card.IsHasEffect,nil,rscode.Utility_Xyz_Material,tp)
		local mg=g:Clone()
		mg:Sub(ug)
		local totalreducelist={}
		local sumlist={#mg}
		for tc in aux.Next(ug) do 
			local ct=0
			local sumlist2=rsof.Table_Clone(sumlist)
			local _,reducelist=rscf.XCheckUtilityMaterial(tc,g,xyzc,tp)
			for i,reduce in pairs(reducelist) do 
				ct=ct+1
				for j,prereduce in pairs(sumlist2) do 
					if j>1 then
						ct=ct+1
					end
					sumlist[ct]=prereduce+reduce
				end
			end
		end
		for _,matct in pairs(sumlist) do
			if matct>=minct and matct<=maxct then return true end
		end
		return false
	end
end
function rscf.XyzLevelFreeCondition22(f,gf,minct,maxct,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				--other material
				local mgextra=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
					mgextra=Duel.GetMatchingGroup(rscf.ExtraXyzMaterialsFilter,tp,0xff,0xff,mg,c,tp,f)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,op):Filter(Auxiliary.MustMaterialCheck,nil,tp,EFFECT_MUST_BE_XMATERIAL)
				if (not min or min<=1) and altg:GetCount()>0 then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					--if minc>maxc then return false end
				end
				mg=mg:Filter(rscf.XyzLevelFreeFilter2,nil,c,f)
				if mgextra and #mgextra>0 then mg:Merge(mgextra) end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				--minc to 1 for utility xyz material
				local res=mg:CheckSubGroup(rscf.XyzLevelFreeGoal2(minc,maxc,og),1,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function rscf.XyzLevelFreeTarget22(f,gf,minct,maxct,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				--other material
				local mg3=nil
				if og then
					mg=og
					mg3=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
					mg3=Duel.GetMatchingGroup(rscf.ExtraXyzMaterialsFilter,tp,0xff,0xff,mg,c,tp,f)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				local mg2=mg:Filter(rscf.XyzLevelFreeFilter2,nil,c,f)
				mg3:Merge(mg2)
				--other material
				Duel.SetSelectedCard(sg)
				local b1=mg3:CheckSubGroup(rscf.XyzLevelFreeGoal2(minc,maxc,og),1,maxc,tp,c,gf)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local cancel=Duel.IsSummonCancelable()
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg3:SelectSubGroup(tp,rscf.XyzLevelFreeGoal2(minc,maxc,og),cancel,1,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function rscf.XyzLevelFreeOperation22(f,gf,minct,maxct,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					rscf.XyzCustomOperation(og,c,e,tp,false)
				else
					local mg=e:GetLabelObject()
					rscf.XyzCustomOperation(mg,c,e,tp,true)
				end
			end
end
function rscf.XyzCustomOperation(mg,c,e,tp,checkog)
	c:SetMaterial(mg)
	if checkog then
		rscf.XExtraMaterialCount(mg,c,tp)
	end
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
	tc=mg:GetNext()
	end 
	--case 1, Summon Effect Custom (Book of Cain)
	if rssf.XyzMaterialAction then
		rssf.XyzMaterialAction(mg,sg,c,e,tp)
		rssf.XyzMaterialAction=nil
	--case 2, Summon Procedure Custom 
	elseif c.rs_xyz_material_action then
		c.rs_xyz_material_action(mg,sg,c,e,tp)
	--case 3, Base Alterf Xyz Procedure
	elseif e:GetLabel()==1 then
		if #sg>0 then
			Duel.Overlay(c,sg)
		end
		Duel.Overlay(c,mg)
	--case 4, Base Normal Xyz Procedure
	else
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Overlay(c,mg)
	end
	--if used hand material, shuffle hand
	if mg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.ShuffleHand(tp)	
	end
	mg:DeleteGroup()
end
function rscf.XExtraMaterialCount(mg,xyzc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(rscode.Extra_Xyz_Material,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			if not f or f(te,xyzc,sg,mg) then
				te:UseCountLimit(tp)
			end
		end
	end
end
--Card/Summon function: Special Xyz Summon Procedure
--Custom Xyz Materials' Action
function rscf.AddXyzProcedureSpecial_CustomAction(c,actionfun,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_xyz_material_action then
		local mt=getmetatable(c)
		mt.rs_xyz_material_action=actionfun
	end
	local e1=rscf.AddXyzProcedureSpecial(c,...)
	return e1
end
function rscf.XyzMaterialAction(c,actionfun)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_xyz_material_action then
		local mt=getmetatable(c)
		mt.rs_xyz_material_action=actionfun
	end
end


--Card/Summon function: Custom Link Procedure 
function rscf.AddLinkProcedureSpecial(c,f,min,max,gf)
	if not rscf.AddLinkProcedureSpecial_Switch then
		rscf.AddLinkProcedureSpecial_Switch=true
		rscf.LCheckOtherMaterial   =   aux.LCheckOtherMaterial 
		aux.LCheckOtherMaterial =   rscf.LCheckOtherMaterial2
		rscf.GetLinkMaterials   =   aux.GetLinkMaterials
		aux.GetLinkMaterials	=   rscf.GetLinkMaterials2
		rscf.LinkOperation  =  aux.LinkOperation
		aux.LinkOperation  =  rscf.LinkOperation2
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_plOC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max,gf))
	e1:SetOperation(rscf.LinkOperation2(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_link_parammeter then
		local mt=getmetatable(c)
		mt.rs_link_parammeter={e1,f,min,max,gf}
	end
	return e1
end
function rscf.GetLinkMaterials2(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,0xff,0xff,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function rscf.LinkOperation2(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				rscf.LinkCustomOperation(g,c,e,tp,og)
				g:DeleteGroup()
			end
end
function rscf.LinkCustomOperation(mg,c,e,tp,checkog)
	c:SetMaterial(mg)
	if checkog then
		Auxiliary.LExtraMaterialCount(mg,c,tp)
	end
	--case 1, Summon Effect Custom
	if rssf.LinkMaterialAction then
		rssf.LinkMaterialAction(mg,c,e,tp,checkog)
		rssf.LinkMaterialAction=nil
	--case 2, Summon Procedure Custom 
	elseif c.rs_link_material_action then
		c.rs_link_material_action(mg,c,e,tp,checkog)
	--case 3, Base Summon Procedure
	else
		Duel.SendtoGrave(mg,REASON_LINK+REASON_MATERIAL)
	end
end
--Change aux function to repair bug in multiple other material link
function rscf.LCheckOtherMaterial2(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,lc,mg) then return true end
	end
	return false
end
--Card/Summon function: Special Link Summon Procedure
--Custom Link Materials' Action
function rscf.AddLinkProcedureSpecial_CustomAction(c,actionfun,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_link_material_action then
		local mt=getmetatable(c)
		mt.rs_link_material_action=actionfun
	end
	local e1=rscf.AddLinkProcedureSpecial(c,...)
	return e1
end
function rscf.LinkMaterialAction(c,actionfun)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_link_material_action then
		local mt=getmetatable(c)
		mt.rs_link_material_action=actionfun
	end
end

--Card effect: Set field info
function rscf.SetFieldInfo(c)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	if loc==LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND then
		Debug.Message("rscf.SetFieldInfo: Location is not on field.")
	else
		rscf.fieldinfo[c]={seq,loc,cp}
	end
end
--Card effect: Get field info
function rscf.GetFieldInfo(c)
	if not rscf.fieldinfo[c] or not rscf.fieldinfo[c][1] then
		Debug.Message("rscf.GetFieldInfo: Didn't use rscf.SetFieldInfo set field information")
		return nil
	end
	return rscf.fieldinfo[c][1],rscf.fieldinfo[c][2],rscf.fieldinfo[c][3]
end
--Card effect: Check if c is surrounding to tc 
function rscf.IsSurrounding(c,tc)
	if not tc:IsOnField() then return false end
	local g=rsgf.GetSurroundingGroup(tc,true)
	return g:IsContains(c)
end
--Card effect: Check if c is surrounding to tc, c is previous on field
function rscf.IsPreviousSurrounding(c,tc)
	local seq,loc,p=c:GetPreviousSequence(),c:GetPreviousLocation(),c:GetPreviousControler()
	if loc&LOCATION_ONFIELD==0 or not tc:IsOnField() then
		return false
	end
	local mzone,szone,ozone=rszsf.GetSurroundingZone(tc)
	local zone=ozone[0]+ozone[1]
	if p~=tc:GetControler() then seq=seq+16 end
	local czone=2^seq
	if loc==LOCATION_SZONE then czone=czone*0x100 end
	return czone&zone ~=0   
end
--Card effect: Get First Target Card for Operations
function rscf.TargetFilter(c,e,tp,filter,...)
	local varlist={...}
	if not c:IsRelateToEffect(e) then return false end
	if not filter then return true end
	if not ... then return filter(c,e,tp) 
	else
		return filter(c,table.unpack(rsof.Table_Mix(varlist,{e,tp})))
	end
end
function rscf.GetTargetCard(targetfilter,...)
	local tc=Duel.GetFirstTarget()
	if not tc then return nil end
	local e,tp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	if rscf.TargetFilter(tc,e,tp,targetfilter,...) then return tc 
	else return nil
	end
end
--Card effect: qucik register dark_synchro type 
function rscf.EnableDarkSynchroAttribute(reg_list,reset_list)
	local c1,val2=rsef.GetRegisterCard(reg_list)
	if not reset_list and c1==val2 and not val2:IsStatus(STATUS_COPYING_EFFECT) and not c1.dark_synchro then 
		local mt=getmetatable(val2) 
		mt.dark_synchro=true
	end
	if reset_list then 
		local e1=rsef.SV_ADD(reg_list,"type","TYPE_DARKSYNCHRO",nil,reset_list,"cd,ch",rshint.darksynchro)
		return e1
	end
end
--Card effect: qucik register dark_tuner type 
function rscf.EnableDarkTunerAttribute(reg_list,reset_list)
	local c1,val2=rsef.GetRegisterCard(reg_list)
	if not reset_list and c1==val2 and not val2:IsStatus(STATUS_COPYING_EFFECT) and not c1.dark_tuner then 
		local mt=getmetatable(val2) 
		mt.dark_tuner=true
	end
	if reset_list then 
		local e1=rsef.SV_ADD(reg_list,"type","TYPE_DARKTUNER",nil,reset_list,"cd,ch",rshint.darktuner)
		return e1
	end
end
--Card filter: Is Dark Synchro
function rscf.IsDarkSynchro(c)
	return c.dark_synchro==true
end
--Card filter: Is Dark Tuner 
function rscf.IsDarkTuner(c)
	return rscf.DarkTuner(nil)(c)
end
--Card filter: Dark Tuner for Dark Synchro Summon
function rscf.DarkTuner(f,...)
	local ext_paramms={...}
	return  function(target)
				local typelist={target:IsHasEffect(EFFECT_ADD_TYPE)}
				local bool=false
				for _,e in pairs(typelist) do
					if rsval.valinfo[e]=="TYPE_DARKTUNER" then
						bool=true
					break 
					end
				end
				return (target.dark_tuner or bool) and aux.Tuner(f,table.unpack(ext_paramms))(target)
			end
end
--Card filter: face up + filter
function rscf.fufilter(f,...)
	local ext_paramms={...}
	return  function(target)
				return f(target,table.unpack(ext_paramms)) and target:IsFaceup()
			end
end
--Card filter function: Special Summon Filter
function rscf.spfilter(f,...)
	local ext_paramms={...}
	return function(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not f or f(c,table.unpack(rsof.Table_Mix(ext_paramms,{e,tp}))))
	end
end
function rscf.spfilter2(f,...)
	local ext_paramms={...}
	return function(c,e,tp)
		if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return false end
		if not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not f or f(c,table.unpack(rsof.Table_Mix(ext_paramms,{e,tp}))))
	end
end
--Card function: Get same type base set
function rscf.GetSameType_Base(c,waystring,type1,...)
	local gettypefun=Card.GetType
	if waystring=="previous" 
		then gettypefun=Card.GetPreviousTypeOnField 
	elseif waystring=="original" 
		then gettypefun=Card.GetOriginalType
	end
	local typelist= type1 and {type1,...} or { TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP } 
	local typetotal=0
	local typetotallist={}
	for _,ctype in pairs(typelist) do
		if gettypefun(c)&ctype==ctype then
			typetotal=typetotal|ctype
			if not rsof.Table_List(typetotallist,ctype) then
				table.insert(typetotallist,ctype) 
			end
		end
	end
	return typetotal,typetotallist
end
--Card function: Get same type 
function rscf.GetSameType(c,...)
	return rscf.GetSameType_Base(c,nil,...)
end
--Card function: Get same previous type 
function rscf.GetPreviousSameType(c,...)
	return rscf.GetSameType_Base(c,"previous",...)
end
--Card function: Get same original type 
function rscf.GetOriginalSameType(c,...)
	return rscf.GetSameType_Base(c,"original",...)
end
--Card Funcion: Check complex card type base set
function rscf.IsComplexType_Base(c,waysting,type1,type2,...)
	local gettypefun=Card.GetType
	if waystring=="previous" 
		then gettypefun=Card.GetPreviousTypeOnField 
	elseif waystring=="original" 
		then gettypefun=Card.GetOriginalType
	end
	local typelist={type1,type2,...}
	local publictype=0
	if rsof.Check_Boolean(type2) then
		publictype=type1
		typelist={...}
	end
	for _,ctype in pairs(typelist) do 
		if type(ctype)=="string" then
			if ctype=="TYPE_SPELL" then
				if gettypefun(c)==TYPE_SPELL then return true end
			elseif ctype=="TYPE_TRAP" then
				if gettypefun(c)==TYPE_TRAP then return true end
			end
		else
			if gettypefun(c)&(ctype|publictype)==(ctype|publictype) then return true end
		end
	end 
	return false
end
--Card Funcion: Check Complex card type
function rscf.IsComplexType(c,...)
	return rscf.IsComplexType_Base(c,nil,...)
end
Card.IsComplexType=rscf.IsComplexType
--Card Funcion: Check Complex card previous type
function rscf.IsPreviousComplexType(c,...)
	return rscf.IsComplexType_Base(c,"previous",...)
end
Card.IsPreviousComplexType=rscf.IsPreviousComplexType
--Card Funcion: Check Complex card original type
function rscf.IsOriginalComplexType(c,...)
	return rscf.IsComplexType_Base(c,"original",...)
end
Card.IsOriginalComplexType=rscf.IsOriginalComplexType
--Card Funcion: Check complex card reason 
function rscf.IsComplexReason(c,reason1,reason2,...)
	local reasonlist={reason1,reason2,...}
	local publicreason=0
	if rsof.Check_Boolean(reason2) then
		publicreason=reason1
		reasonlist={...}
	end
	for _,reason in pairs(reasonlist) do
		if c:GetReason()&(reason|publicreason)==(reason|publicreason) then return true end
	end
	return false 
end
Card.IsComplexReason=rscf.IsComplexReason

-------------------"Part_Hint_Function"---------------------

--Hint function: HINT_SELECTMSG
function rshint.Select(p,cate)
	local hintstring=nil
	if type(cate)~="string" then hintstring=cate end
	local _,category_list=rsef.GetRegisterCategory(cate)
	local hintmsg=rsef.GetDefaultHintString(category_list,nil,nil,hintstring)
	Duel.Hint(HINT_SELECTMSG,p,hintmsg) 
end
--Hint function: HINT_CARD
function rshint.Card(code)
	Duel.Hint(HINT_CARD,0,code) 
end

-------------------"Part_Other_Function"---------------------

--split the string, ues "," as delim_er
function rsof.String_Split(stringinput,delim_er)  
	delim_er=delim_er or ',' 
	local pos,arr = 0, {}  
	--case string list 
	if delim_er==',' then
		for st,sp in function() return string.find(stringinput, delim_er, pos, true) end do  
			table.insert(arr, string.sub(stringinput, pos, st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr, string.sub(stringinput, pos)) 
		return arr
	--case set code
	elseif delim_er=='_' then
		for st,sp in function() return string.find(stringinput, delim_er, pos, true) end do  
			table.insert(arr, string.sub(stringinput, pos, st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr, string.sub(stringinput, pos)) 
		local arr2={}
		local string2=arr[1]
		for k,v in ipairs(arr) do 
			if k==1 then table.insert(arr2, string2) 
			else
				string2=string2 .. "_" .. v
				table.insert(arr2, string2)
			end
		end
		return arr2
	end 
end  
--get no symbol string (for rscf.ComplexFilter and rscon.phmp)
function rsof.String_NoSymbol(string)
	local len=string.len(string)
	local symbolist1={"+","-","~","="}
	local symbolist2={"++","--"}
	local symbolist3={"_s","_o"}
	local string2=string.sub(string,-2)
	local string3=string.sub(string,-2)
	local string1=string.sub(string2,-1)
	if rsof.Table_List(symbolist2,string2) then
		return string.sub(string,1,len-2),string2
	elseif rsof.Table_List(symbolist1,string1) then
		return string.sub(string,1,len-1),string1
	elseif rsof.Table_List(symbolist3,string3) then
		return string.sub(string,1,len-2),string3
	else
		return string
	end
end
--Sting to Table (for different formats)
--you can use "a,b,c" or {"a,b,c"} or {"a","b","c"} as same
--return {"a","b","c"}
function rsof.String_Number_To_Table(value)
	local table1={}
	if type(value)=="string" then
		table1=rsof.String_Split(value)
	elseif type(value)=="number" then
		table1={value}
	elseif type(value)=="table" then
		for _,v in ipairs(value) do
			if type(v)=="string" then
				local table2=rsof.String_Split(v)
				for _,v2 in ipairs(table2) do
					table.insert(table1,v2) 
				end
			else 
				table.insert(table1,v)
			end
		end
	end
	return table1
end
--suit 2 tables (for rsv_E_SV)
function rsof.Table_Suit(value1,value2,value3,value4,value4nosuit)
	local table1=rsof.String_Number_To_Table(value1)
	local table2=rsof.String_Number_To_Table(value2)
	local table3=value3
	local table4=value4
	if type(value4)~="table" then
		table4={value4}
	end
	local result_list1,result_list2={},{}
	for k1,v1 in ipairs(table1) do
		for k2,v2 in ipairs(table2) do
			if v1==v2 then
				table.insert(result_list1,value3[k2]) 
				if #table4==1 and not value4nosuit then
				   table.insert(result_list2,table4[1])
				else
				   table.insert(result_list2,table4[k1])
				end
			end
		end
	end
	return result_list1,result_list2,result_list1[1],result_list2[1]
end
--other function: Find correct element in table
function rsof.Table_List_Single(base_table,check_val)
	local exist_res,exist_idx=false,0
	for idx,val in pairs(base_table) do 
		if val==check_val then
			exist_res = true
			exist_idx = idx 
			break
		end
	end
	return exist_res,exist_idx
end
function rsof.Table_List_Base(check_type,base_table,check_val1,...)
	local check_list={check_val1,...}
	local result_list={}
	for idx,check_val in pairs(check_list) do 
		local exist_res,exist_idx=rsof.Table_List_Single(base_table,check_val)
		if check_type=="normal" then
			table.insert(result_list,exist_res)
		elseif check_type=="or" then
			result_list[1]=result_list[1] or exist_res
		elseif check_type=="all" then
			result_list[1]=result_list[1] and exist_res
		end 
		table.insert(result_list,exist_idx)
	end
	return table.unpack(result_list)
end
--other function: Find correct element in table
function rsof.Table_List(base_table,check_val1,...)
	return rsof.Table_List_Base("normal",base_table,check_val1,...)
end
--other function: Find correct element in table(match 1)
function rsof.Table_List_OR(base_table,check_val1,...)
	return rsof.Table_List_Base("or",base_table,check_val1,...)
end
--other function: Find correct element in table(match all)
function rsof.Table_List_AND(base_table,check_val1,...)
	return rsof.Table_List_Base("and",base_table,check_val1,...)
end
--other function: Find Intersection element in 2 table2
function rsof.Table_Intersection(table1,...)
	local intersection_list={}
	local table_list={...}
	for _,element1 in pairs(table1) do 
		table.insert(intersection_list,element1)
		for _,table2 in pairs(table_list) do
			if not rsof.Table_List(table2,element1) then 
				table.remove(intersection_list)
			break 
			end
		end
	end
	return #intersection_list>0,intersection_list
end
--Other function: make mix type val_list1 (can be string, table or string+table) become int table, string will be suitted with val_listall and str_listall to idx the correct int 
function rsof.Mix_Value_To_Table(val_list1,str_list_idx,val_list_idx)
	val_list1 = type(val_list1)=="table" and val_list1 or {val_list1}
	local num_val=0  --1+2+3=6
	local num_val_list={}   --{1,2,3}
	local mix_str_list={}  --{"td_t,se,th"}
	local str_list={}  --{"td_t","se","th"}
	for _,mix_val in pairs(val_list1) do
		if type(mix_val)=="number" then 
			if num_val&mix_val==0 then
				num_val=num_val|mix_val
				table.insert(num_val_list,num_val)
				local _,_,string=rsof.Table_Suit(mix_val,val_list_idx,str_list_idx) 
				if string then
					table.insert(str_list,string)   
				end
			end   
		elseif type(mix_val)=="string" and not rsof.Table_List(mix_str_list,mix_val) then
			table.insert(mix_str_list,mix_val)
		end
	end
	for _,mix_str in pairs(mix_str_list) do 
		local mix_str_list2=rsof.String_Split(mix_str) 
		for _,mix_str2 in pairs(mix_str_list2) do
			local mix_str_list3=rsof.String_Split(mix_str2,'_')
			local _,_,num_val2=rsof.Table_Suit(mix_str_list3[1],str_list_idx,val_list_idx) 
			if num_val2 and num_val&num_val2==0 then
				num_val=num_val|num_val2
				table.insert(num_val_list,num_val2)
			end
			if not rsof.Table_List(str_list,mix_str2) then
				table.insert(str_list,mix_str2)   
			end
		end
	end
	return num_val,num_val_list,str_list
end
--other function: Clone Table
function rsof.Table_Clone(table)
	local t2 = {}
	for k,v in pairs(table) do
		t2[k] = v
	end
	return t2
end
--other function: Mix Table
--error at "nil" value !!!!!!!!!
--error at no number key !!!!!!!!!
function rsof.Table_Mix(table1,...)
	local resultlist={}
	local list={table1,...}
	local len=0
	for _,tab in pairs(list) do
		for _,value in pairs(tab) do 
			--table.insert(resultlist,value)
			
			len=len+1
			resultlist[len]=value
		end
	end
	return resultlist
end
--other function: table to desc ({m,1} to aux.Stringid(m,1))
function rsof.Table_To_Desc(hint_list)
	local newlist={}
	for _,hint in pairs(hint_list) do
		if type(hint)=="table" then
			table.insert(newlist,aux.Stringid(hint[1],hint[2]))
		elseif type(hint)=="number" then
			table.insert(newlist,hint)
		end
	end
	return table.unpack(newlist)
end
--other function: Count for table value 
function rsof.Table_Count(list,cval)
	local ctlist={}
	for idx,value in pairs(list) do
		if value==cval then
			table.insert(ctlist,idx)
		end
	end
	return #ctlist,ctlist
end
--other function: check a value is true or false
function rsof.Check_Boolean(value,booleanvaule)
	if type(booleanvaule)=="nil" or booleanvaule==true then return 
		type(value)=="boolean" and value==true
	else
		return type(value)=="boolean" and value==false
	end
end 
-------------------"Hape"---------------------
rsof.Escape_Old_Functions()