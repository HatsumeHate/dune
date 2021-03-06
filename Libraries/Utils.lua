
	do
		hash         = InitHashtable()
		udg_SimError = nil
		Stop         = false
		Loc 		 = Location(0., 0.)
		ForFilter1   = nil
		ForFilter2   = nil
		IGNORE_ID    = 'A00Z'
		local SOURCE_UNIT

		-- cjass legacy support
		function GetHp(u)
			return GetUnitState(u, ConvertUnitState(0))
		end

		function GetMp(u)
			return GetUnitState(u, ConvertUnitState(2))
		end

		function SetHp(u, n)
			SetUnitState(u, ConvertUnitState(0), n)
		end

		function SetMp(u, n)
			SetUnitState(u, ConvertUnitState(2), n)
		end

		function GetMaxHp(u)
			return GetUnitState(u, ConvertUnitState(1))
		end

		function GetMaxMp(u)
			return GetUnitState(u, ConvertUnitState(3))
		end

		function SetMaxHp(u, n)
			SetUnitState(u, ConvertUnitState(1), n)
		end

		function SetMaxMp(u, n)
			SetUnitState(u, ConvertUnitState(3), n)
		end

		function Chance(ch)
			return GetRandomReal(0.01, 100.) <= ch
		end

		function Clear(h)
			FlushChildHashtable(hash, GetHandleId(h))
		end

		function GetData(v)
			return GetUnitUserData(v)
		end

		function SetData(v, d)
			return SetUnitUserData(v, d)
		end

		function GetTimerAttach(h)
			return LoadInteger(hash, GetHandleId(h), 0)
		end

		function TimerStartEx(whichTimer, period, handlefunc, userdata)
			SaveInteger(hash, GetHandleId(whichTimer), userdata)
			TimerStart(whichTimer, period, false, handlefunc)
		end

		function SaveUnit(h, d)
			return SaveUnitHandle(hash, GetHandleId(h), 0, d)
		end

		function LoadUnit(h)
			return LoadUnitHandle(hash, GetHandleId(h), 0)
		end

		function SaveEffect(h, d)
			return SaveEffectHandle(hash, GetHandleId(h), 0, d)
		end

		function LoadEffect(h)
			return LoadEffectHandle(hash, GetHandleId(h), 0)
		end

		function Erase(h)
			FlushChildHashtable(hash, GetHandleId(h))
		end

		function H2I(h)
			return GetHandleId(h)
		end

		function CT()
			return CreateTimer()
		end

		function CG()
			return CreateGroup()
		end

		function DG(g)
			DestroyGroup(g)
		end

		function GC()
			GroupClear(g)
		end

		function PT(t)
			PauseTimer(t)
		end

		function DT(t)
			DestroyTimer(t)
		end

		function GC()
			GroupClear(g)
		end

		function Gx(a)
			return GetUnitX(a)
		end

		function Gy(a)
			return GetUnitY(a)
		end

		function Ga(a)
			return GetUnitFacing(a)
		end

		function Rx(x, a)
			return x * Cos(a * bj_DEGTORAD)
		end

		function Ry(x, a)
			return x * Sin(a * bj_DEGTORAD)
		end

		function RndAng()
			return GetRandomReal(0., 360.)
		end

		function RndR(l, h)
			return GetRandomReal(l, h)
		end

		function RndI(l, h)
			return GetRandomInt(l, h)
		end

		function AllFilter()
			return (GetUnitState(GetFilterUnit(), UNIT_STATE_LIFE) > 0.045)
		end

		function EnemiesFilter()
			bj_lastReplacedUnit = GetFilterUnit()
			return (IsUnitEnemy(bj_lastReplacedUnit, GetOwningPlayer(ForFilter1)) and IsUnitVisible(bj_lastReplacedUnit, GetOwningPlayer(ForFilter1)) and GetUnitState(bj_lastReplacedUnit, UNIT_STATE_LIFE) > 0.045 and GetUnitAbilityLevel(bj_lastReplacedUnit, 'Avul') == 0)
		end

		function EnemiesFilterEx()
			return (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(ForFilter1)) and GetUnitState(GetFilterUnit(), UNIT_STATE_LIFE) > 1. and IsUnitVisible(GetFilterUnit(), GetOwningPlayer(ForFilter1)) and not IsUnitInvisible(GetFilterUnit(), GetOwningPlayer(ForFilter1)))
		end

		function AllyFilter()
			return (not IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(ForFilter1)) and GetUnitState(GetFilterUnit(), UNIT_STATE_LIFE) > 0.045 and ForFilter1 ~= GetFilterUnit() and GetUnitAbilityLevel(GetFilterUnit(), IGNORE_ID) == 0)
		end

		function nearest_filt()
			return (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(SOURCE_UNIT)) and GetUnitState(GetFilterUnit(), UNIT_STATE_LIFE) > 0.045)
		end

		function GetMaxAvailableDistanceFilter()
			if (GetDestructableTypeId(GetFilterDestructable()) == 'YTfb' or GetDestructableTypeId(GetFilterDestructable()) == 'YTab' or GetDestructableTypeId(GetFilterDestructable()) == 'YTpc' or GetDestructableTypeId(GetFilterDestructable()) == 'CTtr' or GetDestructableTypeId(GetFilterDestructable()) == 'CTtc' or GetDestructableTypeId(GetFilterDestructable()) == 'ATtr' or GetDestructableTypeId(GetFilterDestructable()) == 'ATtc') then
				Stop = true
			end
			return false
		end
	end


	---@param a table
	---@param b table
	function MergeTables(a, b)
		if b == nil then return a end
		for k, v in pairs(b) do
			if type(v) == "table" then
				a[k] = MergeTables({}, v)
			else
				a[k] = v
			end
		end
		return a
	end


	function ValidateNumber(num, list)

		for i = 1, #list do
			if num == list[i] then
				return false
			end
		end

		return true
	end


	function GenerateInt(min, max, list)
		local num = GetRandomInt(min, max)

			while(not ValidateNumber(num, list) ) do
				num = GetRandomInt(min, max)
			end

		return num
	end


	---@param min integer
	---@param max integer
	---@param count integer
	function GetRandomIntTable(min, max, count)

		if min > max then min, max = max, min end

		if max < min then max = min end
		if count > (max - min + 1) then count = max - min + 1 end

		local numbers = {}

			for i = 1, count do
				numbers[i] = GenerateInt(min, max, numbers)
			end

		return numbers
	end


	---@param min integer
	---@param max integer
	---@param count integer|nil
	function GetRandomIntTableFast(min, max, count)
		local keys = {}
		local out  = {}

		if min == max then return { min } end
		if max < min then min, max = max, min end
		local limit = math.abs(max - min) + 1
		count       = count == nil and limit or math.min(limit, count)
			
			if limit <= count then
				local ints = {}
				for i = min, max do
					table.insert(ints, i)
				end
				for _ = 1, limit do
					table.insert(out, table.remove(ints, math.random(1, #ints)))
				end
				return out
			else
				while true do
					if #out >= count then return out end
					local i = math.random(min, max)
					if keys[i] == nil then
						keys[i] = true
						table.insert(out, i)
					end
				end
			end

	end

	---@param duration real
	---@param callback function
	function DelayAction(duration, callback)
		TimerStart(CreateTimer(), duration or 0., false, function ()
			callback()
			DestroyTimer(GetExpiredTimer())
		end)
	end



	---@param command string
	---@param callback function
	function RegisterTestCommand(command, callback)
		local trigger = CreateTrigger()
		TriggerRegisterPlayerChatEvent(trigger, Player(0), command, false)
		TriggerAddAction(trigger, callback)
	end

	function RegisterOrderDetect(myfunc)
		local OrderDetect = CreateGroup()
		local Trigger = CreateTrigger()
		TriggerRegisterAnyUnitEventBJ(Trigger, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
		TriggerRegisterAnyUnitEventBJ(Trigger, EVENT_PLAYER_UNIT_ISSUED_ORDER)
		TriggerRegisterAnyUnitEventBJ(Trigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
		TriggerRegisterAnyUnitEventBJ(Trigger, EVENT_PLAYER_UNIT_DEATH)
		TriggerAddAction(Trigger, function()
			if IsUnitInGroup(GetTriggerUnit(), OrderDetect) then
				GroupRemoveUnit(OrderDetect, GetTriggerUnit())
				myfunc()
			end
		end)
		return OrderDetect
	end
	---@param unit unit
	---@param range real
	---@param ang real
	function GetMaxAvailableDistanceEx(unit, range, ang)
		local curRange = 25
		local steps    = R2I(range / curRange)

		local x, y     = GetUnitX(unit), GetUnitY(unit)

		local rct      = Rect(x - 50, y - 50, x + 50, y + 50)

		while (steps ~= 0) do
			MoveRectTo(rct, GetPolarOffsetX(GetRectCenterX(rct), 25., ang), GetPolarOffsetY(GetRectCenterY(rct), 25., ang))


			Stop = false


			EnumDestructablesInRect(rct, Filter(GetMaxAvailableDistanceFilter))
			if Stop then break end

			curRange = curRange + 25.
			steps    = steps - 1
		end

		Stop = false
		RemoveRect(rct)

		if steps == 0 then
			curRange = range
		end

		return curRange
	end

	---@param a unit
	---@param b unit
	function AngleBetweenUnits (a, b)
		return Atan2(GetUnitY(b) - GetUnitY(a), GetUnitX(b) - GetUnitX(a)) * bj_RADTODEG
	end

	---@param u unit
	---@param x real
	---@param y real
	---@return real
	function AngleBetweenUnitXY (u, x, y)
		return Atan2(y - GetUnitY(u), x - GetUnitX(u)) * bj_RADTODEG
	end

    function AngleBetweenXY_DEG( A_x,  A_y,  B_x,  B_y)
        return Atan2(B_y - A_y, B_x - A_x) * bj_RADTODEG
    end

	---@param a unit
	---@param b unit
	---@return real
	function DistanceBetweenUnits (a, b)
		local dx, dy = GetUnitX(b) - GetUnitX(a), GetUnitY(b) - GetUnitY(a)
		return math.sqrt((dx * dx) + (dy * dy))
	end

	---@param u unit
	---@param x real
	---@param y real
	---@return real
	function DistanceBetweenUnitXY (u, x, y)
		local dx, dy = x - GetUnitX(u), y - GetUnitY(u)
		return math.sqrt((dx * dx) + (dy * dy))
	end

	---@param u unit
	---@param x real
	---@param y real
	---@return real
	function DistanceBetweenUnitXY_Ex (u, x, y)
		local dx, dy = x - GetUnitX(u), y - GetUnitY(u)
		return GetMaxAvailableDistanceEx(u, math.sqrt((dx * dx) + (dy * dy)), AngleBetweenUnitXY(u, x, y))
	end


    function TimeBetweenXY(x1, y1, x2, y2, speed)
        local dx = x2 - x1
        local dy = y2 - y1
        return (SquareRoot((dx * dx) + (dy * dy)) / speed)
    end


	---@param xa real
	---@param ya real
	---@param za real
	---@param xb real
	---@param yb real
	---@param zb real
	function GetDistance3D(xa, ya, za, xb, yb, zb)
		local dx, dy, dz = xb - xa, yb - ya, zb - za
		return math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
	end

	---@param A unit
	---@param B unit
	---@param speed real
	function TimeBetweenUnits (A, B, speed)
		local dx = GetUnitX(B) - GetUnitX(A)
		local dy = GetUnitY(B) - GetUnitY(A)
		return (SquareRoot((dx * dx) + (dy * dy)) / speed)
	end

	function TimeBetweenUnitXY (A, B_x, B_y, speed)
		local dx = B_x - GetUnitX(A)
		local dy = B_y - GetUnitY(A)
		return (SquareRoot((dx * dx) + (dy * dy)) / speed)
	end

	---@param A unit
	---@param B_x real
	---@param B_y real
	---@param speed real
	function TimeBetweenUnitXY_Ex (A, B_x, B_y, speed)
		local dx = B_x - GetUnitX(A)
		local dy = B_y - GetUnitY(A)
		return (GetMaxAvailableDistanceEx(A, SquareRoot((dx * dx) + (dy * dy)), AngleBetweenUnitXY(A, B_x, B_y)) / speed)
	end

	function ParabolaZ(h, d, x)
		return (4 * h / d) * (d - x) * (x / d)
	end

	---@param current_angle real
	---@param angle_between_unit_and_bound real
	---@param range real
	function GetAngleOfRebound(current_angle, angle_between_unit_and_bound, range)
		return (-current_angle + 180. + 2. * angle_between_unit_and_bound) + GetRandomReal(-range, range)
	end

	---@param uF unit
	---@param uWhichBack unit
	function IsUnitBack (uF, uWhichBack)
		local r1 = bj_RADTODEG * Atan2(GetUnitY(uWhichBack) - GetUnitY(uF), GetUnitX(uWhichBack) - GetUnitX(uF)) + 360.
		local r2 = GetUnitFacing(uWhichBack) + 360.
		if GetUnitY(uWhichBack) < GetUnitY(uF) then
			r1 = r1 + 360.
		end
		return r1 <= (r2 + 45.) and r1 >= (r2 - 45.)
	end

	---@param ataker unit
	---@param victim unit
	function IsUnitAtSide(ataker, victim)
		local angle1 = GetUnitFacing(victim)
		local angle2 = AngleBetweenUnits(ataker, victim)

		if not (GetUnitY(victim) > GetUnitY(ataker)) then
			angle1 = angle1 - 360
		end

		if (angle2 <= (angle1 + 135.00) and angle2 >= (angle1 + 45.00))
				or (angle2 <= (angle1 - 45.00) and angle2 >= (angle1 - 135.00))
				or (GetUnitY(victim) > GetUnitY(ataker) and GetUnitX(victim) > GetUnitX(ataker) and angle2 <= (angle1 - 225.00) and angle2 >= (angle1 - 315.00))
				or (GetUnitY(victim) < GetUnitY(ataker) and GetUnitX(victim) > GetUnitX(ataker) and angle2 >= (angle1 + 225.00) and angle2 <= (angle1 + 315.00)) then
			return true
		end
		return false
	end

	---@param x real
	---@param y real
	---@param victim unit
	function IsUnitAtSideXY(x, y, victim)
		local angle1 = GetUnitFacing(victim)
		local angle2 = AngleBetweenUnitXY(x, y, Gx(victim), Gy(victim))

		if not (GetUnitY(victim) > y) then angle1 = angle1 - 360. end

		if (angle2 <= (angle1 + 180.00) and angle2 >= (angle1 + 90.00)) or (GetUnitY(victim) > y and GetUnitX(victim) > x and angle2 <= (angle1 - 180.00) and angle2 >= (angle1 - 360.00)) then
			return 1
		elseif (angle2 <= (angle1 - 90.00) and angle2 >= (angle1 - 180.00)) or (GetUnitY(victim) < y and GetUnitX(victim) > x and angle2 >= (angle1 + 180.00) and angle2 <= (angle1 + 360.00)) then
			return 2
		end

		return 0
	end

	---@param b unit
	---@param a unit
	function IsRight(b, a)
		local f   = GetUnitFacing(a)
		local ang = AngleBetweenUnits(a, b)

		if not (GetUnitY(b) > GetUnitY(a)) then f = f - 360. end

		if ((ang <= (f + 135.00) and ang >= (f + 45.00)) or (GetUnitY(b) > GetUnitY(a) and GetUnitX(b) > GetUnitX(a) and ang <= (f - 225.00) and ang >= (f - 315.00))) then
			return false
		end

		return true
	end

	---@param a unit
	---@param x real
	---@param y real
	function WhichSide(a, x, y)
		local facing = GetUnitFacing(a)
		local angle  = AngleBetweenUnitXY(a, x, y)
		local float_angle

		if angle < 0. then
			angle = angle + 360.
		end

		float_angle = facing - angle

		if float_angle < 0. then
			float_angle = float_angle + 360.
		end

		return float_angle < 180.
	end

	---@param a unit
	---@param x real
	---@param y real
	function IsFront(a, x, y)
		local left  = (GetUnitFacing(a) - 90) + 360
		local right = (GetUnitFacing(a) + 90) + 360
		local angle = AngleBetweenUnitXY(a, x, y)

		if angle < 0 then angle = angle + 360 end
		angle = angle + 360

		return (angle >= left and angle <= right)
	end

	---@param source_unit unit
	---@param w real
	---@param x real
	---@param y real
	---@param back boolean
	function IsAngleInFace(source_unit, w, x, y, back)
		local facing = GetUnitFacing(source_unit)
		local angle  = AngleBetweenUnitXY(source_unit, x, y)
		local float_angle

		if angle < 0. then angle = angle + 360. end

		if back then
			facing = facing + 180.
			if facing > 360. then facing = facing - 360. end
		end

		if facing < angle then
			float_angle = angle - facing
			if float_angle > 180. then float_angle = (facing - angle + 360.) end
		else
			float_angle = facing - angle
			if float_angle > 180. then float_angle = (angle - facing + 360.) end
		end


		return float_angle <= w
	end


	function IsPointInAngleWindow(facing, window, start_x, start_y, point_x, point_y)
		local angle  = AngleBetweenXY_DEG(start_x, start_y, point_x, point_y)
		local float_angle

		if angle < 0. then angle = angle + 360. end


		if facing < angle then
			float_angle = angle - facing
			if float_angle > 180. then float_angle = (facing - angle + 360.) end
		else
			float_angle = facing - angle
			if float_angle > 180. then float_angle = (angle - facing + 360.) end
		end

		return float_angle <= window
	end

	function GetDirection(u, targ)
		local alpha = GetUnitFacing(u)
		local gamma = bj_RADTODEG * Atan2(GetUnitY(targ) - GetUnitY(u), GetUnitX(targ) - GetUnitX(u))

		if gamma < 0 then
			gamma = 360. + gamma
		end

		if (alpha < 180. and not (gamma > alpha and gamma < alpha + 180.)) or (alpha > 180. and gamma > alpha - 180. and gamma < alpha) then
			return 2
		end

		return 1
	end

	---@param source unit
	---@param x real
	---@param y real
	function SetUnitPositionSmooth(source, x, y)
		local last_x = GetUnitX(source)
		local last_y = GetUnitY(source)
		local bx
		local by

		SetUnitPosition(source, x, y)

		if (RAbsBJ(GetUnitX(source) - x) > 0.5) or (RAbsBJ(GetUnitY(source) - y) > 0.5) then

			SetUnitPosition(source, x, last_y)
			bx = RAbsBJ(GetUnitX(source) - x) <= 0.5
			SetUnitPosition(source, last_x, y)
			by = RAbsBJ(GetUnitY(source) - y) <= 0.5

			if bx then
				SetUnitPosition(source, x, last_y)
			elseif by then
				SetUnitPosition(source, last_x, y)
			else
				SetUnitPosition(source, last_x, last_y)
			end

		end
	end

	---@param x real
	---@param y real
	function GetZ(x, y)
		MoveLocation(Loc, x, y)
		return GetLocationZ(Loc)
	end

	function GetUnitZ(u)
		MoveLocation(Loc, GetUnitX(u), GetUnitY(u))
		return GetLocationZ(Loc) + GetUnitFlyHeight(u)
	end



	---@param msg1 string
	---@param p integer
	function SimError(msg1, p)

		if udg_SimError == nil then
			udg_SimError = CreateSoundFromLabel("InterfaceError", false, false, false, 10, 10)
		end

		if (GetLocalPlayer() == Player(p)) then
			DisplayTimedTextToPlayer(Player(p), 0.52, -1.00, 2.00, "|cffffcc00" .. msg1 .. "|r")
			StartSound(udg_SimError)
		end

	end



	function CopyGroup (g)
		bj_groupAddGroupDest = CreateGroup()
		ForGroup(g, GroupAddGroupEnum)
		return bj_groupAddGroupDest
	end

	function GroupPickRandom()
		if (GetRandomInt(1, bj_groupRandomConsidered) == 1) then
			bj_groupRandomCurrentPick = GetEnumUnit()
		end
	end

	function RandomFromGroup (whichGroup)
		bj_groupRandomConsidered  = 0
		bj_groupRandomCurrentPick = nil
		ForGroup(whichGroup, GroupPickRandomUnitEnum)
		return bj_groupRandomCurrentPick
	end

	function IsUnitInHeight(A, B)
		local loc = Location(0., 0.)
		local min_h_A, max_h_A, min_h_B, max_h_B

		MoveLocation(loc, Gx(A), Gy(A))
		min_h_A = GetLocationZ(loc) + GetUnitFlyHeight(A) - 15.
		max_h_A = GetLocationZ(loc) + GetUnitFlyHeight(A) + 15.
		MoveLocation(loc, Gx(B), Gy(B))
		min_h_B = GetLocationZ(loc) + GetUnitFlyHeight(B)
		max_h_B = min_h_B + 80.
		RemoveLocation(loc)

		loc = nil
		return ((min_h_A >= min_h_B and min_h_A <= max_h_B) or (max_h_A <= max_h_B and max_h_A >= min_h_B))
	end

	function SetTexture(u, texture_id)
		bj_lastCreatedDestructable = CreateDestructable(texture_id, Gx(u) + Rx(10., GetUnitFacing(u)), Gy(u) + Ry(10., GetUnitFacing(u)), 0., 1., 0)
		UnitAddAbility(u, 'Agra')
		IssueTargetOrderById(u, order_grabtree, bj_lastCreatedDestructable)
		UnitRemoveAbility(u, 'Agra')
		RemoveDestructable(bj_lastCreatedDestructable)
		SetUnitAnimation(u, "stand")
	end
