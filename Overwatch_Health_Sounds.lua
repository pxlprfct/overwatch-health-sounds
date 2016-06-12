--  MIT License
--  Copyright (c) 2016 - Oliver Williams
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.



-- Make a frame to catch the API events
local OHS_eventFrame = CreateFrame("Frame", nil, UIParent)
OHS_eventFrame:RegisterEvent("UNIT_HEALTH")
OHS_eventFrame:RegisterEvent("VARIABLES_LOADED")
OHS_eventFrame:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end)

-- VARIABLE_LOADED: Prepare SavedVariables
function OHS_eventFrame:VARIABLES_LOADED()
	if (not OHSDB) then
		OHSDB = {}
        -- Default OHSDB Values
		OHSDB["threshold"] = 30         -- Health Sound fires at x% health threshold
        OHSDB["frequency"] = 5          -- Frequency Health Sound will fire (seconds)
        OHSDB["voice"] = "Genji.mp3"    -- Voice Line that plays on 'low' health
	end
end

-- UNIT_HEALTH 
local ready = true;
function OHS_eventFrame:UNIT_HEALTH(_, arg1)
	if arg1 == "player" then        
        local currentPercentHealth = (UnitHealth("player") / UnitHealthMax("player") * 100)

        if currentPercentHealth <= OHSDB["threshold"] and ready then
            -- .mp3 handle is gross and needs relooking at, but it's a quick fix
            PlaySoundFile("Interface\\AddOns\\Overwatch_Health_Sounds\\Sounds\\" ..OHSDB["voice"].. ".mp3")
            
            -- Frequency of trigger
            ready = false;
            C_Timer.After(OHSDB["frequency"], function() ready = true; end)
        end 
	end
end

-- Create the /slash command
SLASH_OHS1 = '/ohs';

-- Parse /slash commands' arguements
local function handler(msg, editbox)
    -- Any leading non-whitespace is captured into 'command' with the remainder (minus leading whitespace) in 'rest'
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    
    -- /ohs threshold
    if command == "threshold" then
		local newThreshold = tonumber(rest)
        
		if not newThreshold or newThreshold < 0 or newThreshold > 100 then
			DEFAULT_CHAT_FRAME:AddMessage("Example: |cFFF99E1A/ohs|r |cFF59E2FAthreshold|r |cFF33FA7030|r - The sound will play once you fall below |cFF33FA7030%|r health")
			 DEFAULT_CHAT_FRAME:AddMessage("The current health |cFF59E2FAthreshold|r is |cFF33FA70" ..OHSDB["threshold"].. "%|r health")
		else
			DEFAULT_CHAT_FRAME:AddMessage("New |cFF59E2FAthreshold|r set to |cFF33FA70" ..newThreshold.. "%|r health")
			OHSDB["threshold"] = newThreshold
		end
        
                
    -- /ohs frequency
    elseif command == "frequency" then
       local newFrequency = tonumber(rest)
        
		if not newFrequency or newFrequency < 0 or newFrequency > 31 then
			DEFAULT_CHAT_FRAME:AddMessage("Example: |cFFF99E1A/ohs|r |cFF59E2FAfrequency |cFF33FA70|r - The sound will only play once every |cFF01C6AD5|r seconds (prevents spam)")
			DEFAULT_CHAT_FRAME:AddMessage("The current |cFF59E2FAfrequency|r is |cFF33FA70" ..OHSDB["frequency"].."|r seconds")
		else
			DEFAULT_CHAT_FRAME:AddMessage("New |cFF59E2FAfrequency|r set to |cFF33FA70" ..newFrequency.. "|r seconds")
			OHSDB["frequency"] = newFrequency
		end
        
     -- /ohs voice
    elseif command == "voice" then
        -- Following Voice lines are missing - Bastion, Hanzo, McCree, Pharah, Reinhardt
    
        -- Before
        oldvoice = OHSDB["voice"];
    
        -- Seems like the easiest way to handle duplicates - although it's super messy      

        -- Bastion
        if      rest == "D.va" or 
                rest == "Dva" or 
                rest == "Diva"          then OHSDB["voice"] = "D.va"
        elseif  rest == "Genji"         then OHSDB["voice"] = "Genji"
        -- Hanzo
        elseif  rest == "Junkrat"       then OHSDB["voice"] = "Junkrat"
        elseif  rest == "Lucio" or 
                rest == "Lúcio"         then OHSDB["voice"] = "Lúcio"
        -- McCree
        elseif  rest == "Mei"           then OHSDB["voice"] = "Mei"
        elseif  rest == "Mercy"         then OHSDB["voice"] = "Mercy"
        -- Pharah
        elseif  rest == "Reaper"        then OHSDB["voice"] = "Reaper"
        -- Reinhardt
        elseif  rest == "Roadhog"       then OHSDB["voice"] = "Roadhog"
        elseif  rest == "Solider: 76" or 
                rest == "Soldier 76" or 
                rest == "76" or 
                rest == "Soldier"       then OHSDB["voice"] = "76"
        elseif  rest == "Symmetra"      then OHSDB["voice"] = "Symmetra"
        elseif  rest == "Torbjorn" or 
                rest == "Torbjörn"      then OHSDB["voice"] = "Torbjörn"
        elseif  rest == "Tracer"        then OHSDB["voice"] = "Tracer"
        elseif  rest == "Widowmaker"    then OHSDB["voice"] = "Widowmaker"
        elseif  rest == "Winston"       then OHSDB["voice"] = "Winston"
        elseif  rest == "Zarya"         then OHSDB["voice"] = "Zarya"
        elseif  rest == "Zenyatta"      then OHSDB["voice"] = "Zenyatta"
        else    
                DEFAULT_CHAT_FRAME:AddMessage("Example: |cFFF99E1A/ohs|r |cFF59E2FAvoice |cFF33FA70Torbjörn|r - Torbjörn's voice will play when on low-health")
			    DEFAULT_CHAT_FRAME:AddMessage("The current |cFF59E2FAvoice|r is |cFF33FA70" ..OHSDB["voice"])
                DEFAULT_CHAT_FRAME:AddMessage("Available Voices - |cFF33FA70D.va, Genji, Junkrat, Lúcio, Mei, Mercy, Reaper, Roadhog, Solider: 76, Symmetra, Torbjörn, Tracer, Widowmaker, Winston, Zarya, Zenyatta")
        end

        -- After
        newvoice = OHSDB["voice"];
        -- Compare Before and After - and check for differences
        if oldvoice ~= newvoice then DEFAULT_CHAT_FRAME:AddMessage("New voice set to " ..OHSDB["voice"])
        end
                
    -- /ohs 
    else
        DEFAULT_CHAT_FRAME:AddMessage("Overwatch Health Sounds - |cFFF99E1A/ohs|r");
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF99E1A/ohs |cFF59E2FAthreshold |cFF33FA70" ..OHSDB["threshold"].."%|r")
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF99E1A/ohs |cFF59E2FAfrequency |cFF33FA70" ..OHSDB["frequency"].."|r")
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF99E1A/ohs |cFF59E2FAvoice |cFF33FA70" ..OHSDB["voice"].."|r")
    end
end

SlashCmdList["OHS"] = handler;