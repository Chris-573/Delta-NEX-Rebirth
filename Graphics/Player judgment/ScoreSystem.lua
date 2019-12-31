	-- K-Pump scoring system - Chris573
local TapNoteScorePoints = {
	TapNoteScore_CheckpointHit = 1000;	-- HOLD PERFECT
	TapNoteScore_W1 = 1000;				-- SUPERB
	TapNoteScore_W2 = 1000;				-- PERFECT
	TapNoteScore_W3 = 500;				-- GREAT
	TapNoteScore_W4 = 100;				-- GOOD
	TapNoteScore_W5 = -200;				-- BAD
	TapNoteScore_Miss = -500;			-- MISS
	TapNoteScore_CheckpointMiss = -300;	-- HOLD MISS
	TapNoteScore_None =	0;
	TapNoteScore_HitMine = 0;
	TapNoteScore_AvoidMine = 0;
};

local PlayerScores = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

return Def.ActorFrame {
		JudgmentMessageCommand=function(self,params)
			local Notes = {};
			local Holds = {};
			local iStepsCount = 0;
			local Player = params.Player;
			local TapNoteScore = params.TapNoteScore;
			local State = GAMESTATE:GetPlayerState(Player);
			
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
					ComboScore = 1000;
				end;
				
				-- note score: same with here I guess
				local NoteScore = TapNoteScorePoints[TapNoteScore];	
				if iStepsCount > 2 then
					NoteScore = NoteScore * (iStepsCount / 2);
				end;
				
				-- !!! hack: removes extra combo/score count from the end of hold arrows !!!
				if params.TapNote and params.TapNote:GetTapNoteType() ~= "TapNoteType_HoldTail" then
					PlayerScore = PlayerScore;
				else
					PlayerScore = PlayerScore + NoteScore + ComboScore;
				end;
				
				-- we don't want negative scores
				if PlayerScore <= 0 then
					PlayerScores[Player] = 0;
				else
					PlayerScores[Player] = PlayerScore;
				end;
				
				setScores(PlayerScores);
				
				-- PSS:SetScore(PlayerScores[Player]);
			end;
		end;
};
