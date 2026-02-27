switch = 0
JimmySpeed = 100
onMission = false
endOfTest = false
FlagHasBeenSet = false
tempFlag = 0

function MissionSetup()
    PlayerSetControl(0)
    PlayerSetPosXYZArea(270, -110, 6, 0)
    repeat
        Wait(0)
    until not AreaIsLoading()
    CameraSetWidescreen(true)
end


function main()
    TextPrintString("Yo ******! Welcome to bully again", 2, 1)
    Wait(2000)
    PlayerSetControl(1)
    CameraSetWidescreen(false)
    TextPrintString("You can move now!", 3, 1)
    CreateThread("menu")
end


function testStim()
    testPed = PedCreateXYZ(31, 270, -110, 6)
    Wait(1000)
    PedWander(testPed, true)
    CreateThread("FlagsMenu")
    repeat
        Wait(0)
    until endOfTest
    TextPrintString("The test is over now!", 3, 1)
    Wait(2000)
    MissionSucceed()

end

function FlagsMenu()
    Selection = 2
    repeat
        TextPrintString("Current Flag ID:" .. Selection, 1, 2)
        if IsButtonBeingPressed(0, 0) then
            Selection = Selection - 1
            if Selection < 1 then
                Selection = 132
            end
        elseif IsButtonBeingPressed(1, 0) then
            Selection = Selection + 1
            if Selection > 132 then
                Selection = 1
            end
        elseif IsButtonBeingPressed(3, 0) then
            if Selection == 1 then
                endOfTest = true
                return
            end
            if FlagHasBeenSet == false then
                tempFlag = Selection
                PedSetFlag(gPlayer, tempFlag, true)
                FlagHasBeenSet = true
                TextPrintString("the flag has been activated!", 3, 1)
            else
                PedSetFlag(gPlayer, tempFlag, false)
                PedSetFlag(gPlayer, Selection, true)
                tempFlag = Selection
                TextPrintString("the flag has been activated! (Deactivated the prev one!)", 3, 1)
            end
        end
        Wait(0)
    until not Alive

end




function StartMission()
    Stage = 1
    Wait(1000)
    TextPrintString("Follow the marks on MiniMap!", 3, 1)
    local blip1 = BlipAddXYZ(302, -72, 5, 0)
    enemies = {}
    for i = 1, 3 do
        enemies[i] = PedCreateXYZ(31, 302 + (i/2), -72, 5)
    end
    CreateThread("Informations")
    local x, y = 302, -72
    local r1 = x + 2
    local r2 = y + 2
    local r3 = x - 2
    local r4 = y - 2
    repeat
        Wait(0)
    until PedInRectangle(gPlayer, r1, r2, r3, r4)
    Stage = 2
    BlipRemove(blip1)
    TextPrintString("Beat those!", 3, 1)
    tempBlips = {}
    for i = 1, 3 do
        PedSetPedToTypeAttitude(enemies[i], 13, 0)
        PedAttackPlayer(enemies[i], 3)
        tempBlips[i] = AddBlipForChar(enemies[i], 0, 26, 4)
    end
    repeat
        Wait(0)
    until PedsIsDead()

    TextPrintString("There is another mark.", 3, 1)
    local blip2 = BlipAddXYZ(323, -98, 6, 0)
    local x, y = 323, -98
    local r1 = x + 2
    local r2 = y + 2
    local r3 = x - 2
    local r4 = y - 2
    repeat
        Wait(0)
    until PedInRectangle(gPlayer, r1, r2, r3, r4)
    Stage = 3
    BlipRemove(blip2)
    TextPrintString("Last mark!!!", 3, 1)
    local blip3 = BlipAddXYZ(472, -89, 5, 0)
    local x, y = 472, -89
    local r1 = x + 2
    local r2 = y + 2
    local r3 = x - 2
    local r4 = y - 2
    repeat
        Wait(0)
    until PedInRectangle(gPlayer, r1, r2, r3, r4)
    MissionSucceed()
end



function PedsIsDead()
    for i = 1, 3 do
        if not PedIsDead(enemies[i]) and PedIsValid(enemies[i]) then
            return false
        end
    end
    return true

end










function Informations()
    while true do
        Wait(0)
        if Stage == 1 then
            if IsButtonBeingPressed(1, 0) then
                TextPrintString("Please don't be 87loon, it's a STAGE 1!", 3, 1)
            end
        elseif Stage == 2 then
            if IsButtonBeingPressed(1, 0) then
                TextPrintString("you are making me tired, it's a STAGE 2!", 3, 1)
            end
        elseif Stage == 3 then
            if IsButtonBeingPressed(1, 0) then
                TextPrintString("SHIIIIIAAAT, it's a STAGE 3!", 3, 1)
            end
        end
    end
end






function menu()
    SimpleMenu = {
        {text = "Say Hi !", Func = testingBro1},
        {text = "Health", Func = testingBro2},
        {text = "Get Spud Gun", Func = testingBro3},
        {text = "Punishment Toggle", Func = testingBro4},
        {text = "Kill Ped", Func = testingBro5},
        {text = "Jimmy's Speed", Func = testingBro6},
        {text = "Start test mission", Func = testingBro7},
        {text = "Start Test Stimulus FUNCTION !", Func = testingBro8},
        {text = "Start Test Vehiacle moving from ped!", Func = testingBro9},
    }
    Selection = 1
    repeat
        if IsButtonBeingPressed(0, 0) then
            Selection = Selection - 1
            if Selection < 1 then
                Selection = table.getn(SimpleMenu)
            end
            TextPrintString(SimpleMenu[Selection].text,4,1)
        elseif IsButtonBeingPressed(1, 0) then
            Selection = Selection + 1
            if Selection > table.getn(SimpleMenu) then
                Selection = 1
            end
            TextPrintString(SimpleMenu[Selection].text,4,1)
        elseif IsButtonBeingPressed(3, 0) then
            SimpleMenu[Selection].Func()
        end
    
        Wait(0)
    until not Alive

end


function testingBro1()
    TextPrintString("HI !", 3, 2)
end

function testingBro2()
    local JimmyHealth = PedGetMaxHealth(gPlayer)
    PlayerSetHealth(JimmyHealth)
end


function testingBro3()
    PedOverrideStat(gPlayer, 45, 305)
end

function testingBro4()
    if switch == 0 then
        DisablePunishmentSystem(true)
        PlayerSetPunishmentPoints(0)
        TextPrintString("Punishment system is disabled", 3, 2)
        switch = 1
    elseif switch == 1 then
        DisablePunishmentSystem(false)
        TextPrintString("Punishment system is enabled", 3, 2)
        switch = 0
    else
        TextPrintString("the function went wrong (Punishment Toggle, Func = testingBro4)", 3, 2)
    end
end

function testingBro5()
    local JimmyTarget = PedGetTargetPed(gPlayer)
    if not PedIsDead(JimmyTarget) then
        PedApplyDamage(JimmyTarget, 100000)
    end
end


function testingBro6()
    JimmySpeed = JimmySpeed + 25
    GameSetPedStat(gPlayer, 20, JimmySpeed)
    if JimmySpeed > 400 then
        JimmySpeed = 100
        GameSetPedStat(gPlayer, 20, JimmySpeed)
    end
    TextPrintString("Speed:" .. JimmySpeed .. "%", 3, 2)
end


function testingBro7()
    if onMission == false then
        onMission = true
        StartMission()
    end
end




function testingBro8()
    if onMission == false then
        onMission = true
        testStim()
    end

end


function testingBro9()
    repeat
        SoundPlay3D(270, -110, 6, 'NavDwn')
        Wait(500)
    until not Alive
end
