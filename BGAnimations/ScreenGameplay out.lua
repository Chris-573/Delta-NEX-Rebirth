	-- K-Pump scoring system - Chrissy573
local PlayerScores = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

return Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffusealpha,0;);
		OffCommand=function(self)
			for Player in ivalues(GAMESTATE:GetHumanPlayers()) do
				local StepData = GAMESTATE:GetCurrentSteps(Player);
				local StepLevel = StepData:GetMeter();
				local StepType = StepData:GetStepsType();
				
				local CSS = STATSMAN:GetCurStageStats();
				local PSS = CSS:GetPlayerStageStats(Player);
				local Accuracy = PSS:GetPercentDancePoints() * 100;
				local Greats = 	PSS:GetTapNoteScores("TapNoteScore_W3");
				local Goods = 	PSS:GetTapNoteScores("TapNoteScore_W4");
				local Misses = 	PSS:GetTapNoteScores("TapNoteScore_Miss") +
								PSS:GetTapNoteScores("TapNoteScore_CheckpointMiss") +
								PSS:GetTapNoteScores("TapNoteScore_HitMine");
				
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
				-- good: 100000 points
				local GradeBonus = 0;
				if Misses > 0 then
					GradeBonus = 0;
				elseif Goods > 0 then
					GradeBonus = 100000;
				elseif Greats > 0 then
					GradeBonus = 150000;
				else
					GradeBonus = 300000;
				end;
				
				local PlayerScore = getScores()[Player];
				
				if PlayerScore <= 0 then
					PlayerScores[Player] = 0;
				else
					PlayerScores[Player] = (PlayerScore * LevelConstant) + GradeBonus;
					PlayerScores[Player] = PlayerScores[Player] - (PlayerScores[Player] % 100);
				end;
				
				PSS:SetScore(PlayerScores[Player]);
			end;
			self:sleep(1);
			self:linear(1);
			self:diffusealpha(1);
		end;
	};
};
