local PlayerScores = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

local t = Def.ActorFrame{};

	--[[
	t[#t+1] = Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("1,0,0,0");blend,Blend.Multiply);
		OnCommand=cmd(diffuse,color("0.75,0,0,0.75");decelerate,1.75;diffuse,color("0,0,0,1"));
	};
	
	]]--
	t[#t+1] = LoadActor("iwbtg")..{
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
	
	t[#t+1] = Def.Quad {
		InitCommand=cmd(blend,Blend.Add;Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("1,1,1,0");sleep,3;playcommand,"Off");
		OffCommand=function(self)
			for Player in ivalues(GAMESTATE:GetHumanPlayers()) do
				local StepData = GAMESTATE:GetCurrentSteps(Player);
				local StepLevel = StepData:GetMeter();
				local StepType = StepData:GetStepsType();
				
				local CSS = STATSMAN:GetCurStageStats();
				local PSS = CSS:GetPlayerStageStats(Player);
				
				-- level constant: the multipler utilized to increase scores with more difficult charts and doubles
				local LevelConstant = 1;
				if (StepType == "StepsType_Pump_Double" or 
					StepType == "StepsType_Pump_Halfdouble" or 
					StepType == "StepsType_Pump_Routine") then
					if StepLevel > 10 then
						LevelConstant = (StepLevel / 10) * 1.2;
					else
						LevelConstant = 1.2;
					end;
				else
					if StepLevel > 10 then
						LevelConstant = StepLevel / 10;
					end;
				end;
				
				-- no grade bonus with a fail :(
				
				-- replace the current stepmania score with ours + zero out the last two digits
				local PlayerScore = getScores()[Player];
				if PlayerScore <= 0 then
					PlayerScores[Player] = 0;
				else
					PlayerScores[Player] = PlayerScore * LevelConstant;
					PlayerScores[Player] = PlayerScores[Player] - (PlayerScores[Player] % 100);
				end;
				PSS:SetScore(PlayerScores[Player]);
			end;
			self:accelerate(0.325);
			self:diffusealpha(1);
		end;
	};
	
	t[#t+1] = LoadActor(THEME:GetPathS( Var "LoadingScreen", "failed" ) ) .. {
		StartTransitioningCommand=cmd(play);
	};

return t;
