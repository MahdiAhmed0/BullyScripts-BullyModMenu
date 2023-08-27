
--- All of those codes were inside a main function called Main(), and another main function called MissionSetup(). These are the only functions that the game can recognize and run....
-- and for sure you can run another undircted function from a Main() or MissionSetup().
-- you can learn a lot by understanding the code, it's a small chunk of script but has a few concepts that can help you out in any future project, really good concepts.

--- missing parts
SimpleMenu = {
    {text = "Reset Camera", Func = testingBro1},
    {text = "Health", Func = testingBro2},
    {text = "Get Spud Gun", Func = testingBro3},
    {text = "Punishment Toggle", Func = testingBro4},
    {text = "Kill Ped", Func = testingBro5},
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
--- missing parts
--- 
--- 
--- 
function testingBro4()
if PunishmentV < 1 then
    PunishmentV = 1
    DisablePunishmentSystem(true)
    PedSetPunishmentPoints(gPlayer, 0)
elseif PunishmentV > 0 then
    PunishmentV = 0
    DisablePunishmentSystem(false)
end
end
PunishmentV = 0

--- missing parts

-- The story behind this script: I was developing a script called 'Mission,' and there was too much to debug. So, I built this menu to assist me with debugging my 'Mission'.
-- The most helpful debugging feature was the 'Reset Camera' option because the camera was glitching all the time. As a result, I had to debug the camera most of the time.

-- IMPORTANT: There is no license for this script. A lot of its original code is missing, and it was testing code not intended to be published by any means.
-- Developed By : Fibonacci