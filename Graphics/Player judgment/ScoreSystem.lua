	-- K-Pump scoring system - Chrissy573
local TapNoteScorePoints = {
	TapNoteScore_CheckpointHit = 1000;	-- HOLD PERFECT
	TapNoteScore_W1 = 1000;				-- SUPERB
	TapNoteScore_W2 = 1000;				-- PERFECT
	TapNoteScore_W3 = 500;				-- GREAT
	TapNoteScore_W4 = 100;				-- GOOD
	TapNoteScore_W5 = -200;				-- BAD
	TapNoteScore_Miss = -500;			-- MISS
	TapNoteScore_CheckpointMiss = -500;	-- HOLD MISS
	TapNoteScore_None =	0;
	TapNoteScore_HitMine =	-500;
	TapNoteScore_AvoidMine = 0;
};

local TapNoteExScorePoints = {
	TapNoteScore_CheckpointHit = 5;		-- HOLD PERFECT
	TapNoteScore_W1 = 5;				-- SUPERB
	TapNoteScore_W2 = 4;				-- PERFECT
	TapNoteScore_W3 = 2;				-- GREAT
	TapNoteScore_W4 = 0;				-- GOOD
	TapNoteScore_W5 = -6;				-- BAD
	TapNoteScore_Miss = -12;			-- MISS
	TapNoteScore_CheckpointMiss = -12;	-- HOLD MISS
	TapNoteScore_None =	0;
	TapNoteScore_HitMine =	-6;
	TapNoteScore_AvoidMine = 0;
};

if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
	TapNoteExScorePoints["TapNoteScore_CheckpointHit"] = 4;
	TapNoteExScorePoints["TapNoteScore_W1"] = 4;
end;

local PlayerScores = {
	PlayerNumber_P1 = 300000;
	PlayerNumber_P2 = 300000;
	PlayerNumber_Invalid = 300000;
};

local PlayerAccuracy = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

local PlayerExScores = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

local PlayerMaxExScores = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

local GradeBonusW3 = {
	PlayerNumber_P1 = false;
	PlayerNumber_P2 = false;
	PlayerNumber_Invalid = false;
};

local GradeBonusW4 = {
	PlayerNumber_P1 = false;
	PlayerNumber_P2 = false;
	PlayerNumber_Invalid = false;
};

local GradeBonusMiss = {
	PlayerNumber_P1 = false;
	PlayerNumber_P2 = false;
	PlayerNumber_Invalid = false;
};

return Def.ActorFrame {
		JudgmentMessageCommand=function(self,params)
			local Notes = {};
			local Holds = {};
			local iStepsCount = 0;
			local Player = params.Player;
			local TapNoteScore = params.TapNoteScore;
			local StepData = GAMESTATE:GetCurrentSteps(Player);
			local StepLevel = StepData:GetMeter();
			local StepType = StepData:GetStepsType();
			local State = GAMESTATE:GetPlayerState(Player);
			local PlayerType = State:GetPlayerController();
			
			-- first of all get the combo
			local CSS = STATSMAN:GetCurStageStats();
			local PSS = CSS:GetPlayerStageStats(Player);
			local iCombo = PSS:GetCurrentCombo();
			
			if true then
				-- now we can safely calculate the number of arrows in this tapnote
				Holds = params.Holds;
				Notes = params.Notes;
				iStepsCount = getNumberOfElements(Holds) + getNumberOfElements(Notes);
				local PlayerScore = PlayerScores[Player];
				
				-- combo score: self explanatory tbh
				local ComboScore = 0;
				if iCombo > 50 and TapNoteScore <= "TapNoteScore_W3" then 
					if iStepsCount <= 2 then 
						ComboScore = 1000;
					elseif iStepsCount == 3 then 
						ComboScore = 1500;
					else
						ComboScore = 2000;
					end;
				end;
				
				-- note score: same with here I guess
				local NoteScore = TapNoteScorePoints[TapNoteScore];	
				if TapNoteScore <= "TapNoteScore_W3" and iStepsCount >= 3 then
					if iStepsCount == 3 then
						NoteScore = NoteScore * 1.5;
					else
						NoteScore = NoteScore * 2;
					end;
				end;
				
				-- level constant: the multipler utilized to increase scores with more difficult charts and doubles
				local LevelConstant = 1;
				if (StepType == "StepsType_Pump_Double" or 
					StepType == "StepsType_Pump_Halfdouble" or 
					StepType == "StepsType_Pump_Routine") then
					if StepLevel > 10 then
						LevelConstant = (StepLevel / 10) * 1.2
					else
						LevelConstant = 1.2
					end;
				else
					if StepLevel > 10 then
						LevelConstant = StepLevel / 10
					end;
				end;
				
				-- grade bonus: granted for full combos:
				-- perfect: 300000 points
				-- great: 150000 points
				-- good: 150000 points
				-- score is predefined with the extra 300000 and gets subtracted whenever penalties are set
				local GradeBonus = 0;
				if (TapNoteScore == "TapNoteScore_Miss" or 
					TapNoteScore == "TapNoteScore_CheckpointMiss" or
					TapNoteScore == "TapNoteScore_HitMine") and GradeBonusMiss[Player] == false then
					if GradeBonusW4 == true then
						GradeBonus = -100000;
					elseif GradeBonusW3 == true then
						GradeBonus = -150000;
					else
						GradeBonus = -300000;
					end;
					GradeBonusMiss[Player] = true;
					GradeBonusW4[Player] = true;
					GradeBonusW3[Player] = true;
				elseif TapNoteScore == "TapNoteScore_W4" and GradeBonusW4[Player] == false then
					if GradeBonusW3 == true then
						GradeBonus = -50000;
					else
						GradeBonus = -200000;
					end;
					GradeBonusW4[Player] = true;
					GradeBonusW3[Player] = true;
				elseif TapNoteScore == "TapNoteScore_W3" and GradeBonusW3[Player] == false then
					GradeBonus = -150000;
					GradeBonusW3[Player] = true;
				end;
				
				-- !!! hack: removes extra combo/score count from the end of hold arrows !!!
				if params.TapNote and params.TapNote:GetTapNoteType() ~= "TapNoteType_HoldTail" then
					PlayerScore = PlayerScore;
				else
					PlayerScore = PlayerScore + ((NoteScore + ComboScore) * LevelConstant) + GradeBonus;
				end;
				
				-- we don't want negative scores
				if PlayerScore <= 0 then
					PlayerScores[Player] = 0;
				else
					PlayerScores[Player] = PlayerScore;
				end;
				
				PSS:SetScore(PlayerScores[Player]);
				
				--[[
				-- ex scoring for accuracy/percentage calculation!
				local PlayerExScore = PlayerExScores[Player];
				PlayerExScore = PlayerExScore + TapNoteExScorePoints[TapNoteScore];
				if PlayerExScore <= 0 then
					PlayerExScores[Player] = 0;
				else
					PlayerExScores[Player] = PlayerExScore;
				end;
				
				local PlayerMaxExScore = PlayerMaxExScores[Player];
				PlayerMaxExScore = PlayerMaxExScore + TapNoteExScorePoints["TapNoteScore_W1"];
				PlayerMaxExScores[Player] = PlayerMaxExScore;
				
				PlayerAccuracy[Player] = tonumber(string.format("%.02f", ((PlayerExScores[Player] / PlayerMaxExScores[Player]) * 100))) or 0;
				setAccuracy(PlayerAccuracy);
				]]
			end;
		end;
};
