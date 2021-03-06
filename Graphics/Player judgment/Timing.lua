local c = {};
local player,judgmentType = ...;
local Pulse = THEME:GetMetric("Combo", "JudgmentPulseCommand");
local AllowSuperb = (PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere');
local t = Def.ActorFrame {

	Def.ActorFrame {
		Name="JudgmentFrame";
		LoadActor("ScoreSystem");
		LoadActor(judgmentType) .. {
			Name="Judgment";
			InitCommand=cmd(pause;y,30;visible,false);
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
	};
	
};

--Specifies which frame is for which grading in the node judgment sprites
local TNSFrames = {
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
	TapNoteScore_CheckpointHit = (AllowSuperb and 0 or 1);
	TapNoteScore_CheckpointMiss = 5;
	TapNoteScore_AvoidMine = 0;
};

t.InitCommand = function(self)
	c.JudgmentFrame = self:GetChild("JudgmentFrame");
	c.Judgment = c.JudgmentFrame:GetChild("Judgment");
end;

t.OnCommand = function(self)
	local player = self:GetParent();
	altcombo = 0;
--	player:SetActorWithJudgmentPosition( c.JudgmentFrame );
end;

t.JudgmentMessageCommand=function(self, param)

	if param.Player ~= player then return end;
	if not param.TapNoteScore then return end;
	if param.HoldNoteScore then return end;	

	local iNumStates = c.Judgment:GetNumStates();
	local iFrame = TNSFrames[param.TapNoteScore];

	if iNumStates == 12 then
		iFrame = iFrame * 2;
		if not param.Early then
			iFrame = iFrame + 1;
		end
	end
	
	c.Judgment:visible( true );
	c.Judgment:setstate( iFrame );
	--(cmd(stoptweening;diffusealpha,1;zoom,0.875;linear,0.05;zoom,0.625;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))(c.Judgment);
	
	if judgmentType == "NX" then
		(cmd(stoptweening;y,24;diffusealpha,1;zoomx,0.85;zoomy,0.8;linear,0.075;y,30;zoomx,0.6;zoomy,0.55;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))( c.Judgment, param );
	elseif judgmentType == "FIESTA 2" then
--[[		(cmd(stoptweening;y,34;diffusealpha,1;zoomx,0.85;zoomy,0.75;linear,0.075;y,26;zoomx,1.4;zoomy,1.2;linear,0.075;y,34;diffusealpha,1;zoomx,0.85;zoomy,0.75;sleep,0.3;linear,0.175;diffusealpha,0;zoomx,1.2,zoomy,0.2))( c.Judgment, param );]]--
		(cmd(stoptweening;y,18;diffusealpha,1;zoomx,1.35;zoomy,1;linear,0.075;y,32;zoomx,0.8;zoomy,0.8;sleep,0.3;linear,0.175;diffusealpha,0;zoomx,1.5;zoomy,0.05))( c.Judgment, param );
	elseif judgmentType == "Delta LED" then
--[[		(cmd(stoptweening;y,16;diffusealpha,0.6;zoomx,0.65;zoomy,0.7;linear,0.075;y,0;diffusealpha,0.9;zoomx,1.3;zoomy,1.3;sleep,0.3;linear,0.175;y,30;diffusealpha,0;zoomx,1.3;zoomy,0.2))( c.Judgment, param );]]--
		(cmd(stoptweening;y,0;diffusealpha,1;zoom,.5;linear,0.075;y,16;zoom,.4;sleep,0.3;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))( c.Judgment, param );
	else --if GetUserPref("UserPrefJudgmentType") == "Normal" or GetUserPref("UserPrefJudgmentType") == "Deviation" then
		Pulse( c.Judgment, param );
	end
	
--	JudgeCmds[param.TapNoteScore](c.Judgment);

	c.JudgmentFrame:stoptweening();

end;

return t;
