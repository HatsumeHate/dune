---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Stasik.
--- DateTime: 23.02.2020 22:42
---

do

    local InitGlobalsOrigin = InitGlobals


    function InitGlobals()
        InitGlobalsOrigin()

        ShakerInit()
        UnitDataInit()
        UnitRotationInit()
        HarvestInit()
        print("ok")

    end


end