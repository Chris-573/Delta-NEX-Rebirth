--LoadActor("file.lua", argument) -> arguments are passed in as "...". As in literally, the variable is named "..." (without the quotes)
local player = ...;

--in normal syntax, style = (GetStyle() == "OnePlayerTwoSides") ? "Single" : "Double")
local style = (ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType()) == "OnePlayerTwoSides") and "Double" or "Single";
--SCREENMAN:SystemMessage(style);

--Size of frame (just the inner part of the lifebar)
local LIFEBAR_WIDTH = SCREEN_WIDTH-130

--Size of the actual lifebar. Yes I know this is terrible code I'll fix it later I swear
local LIFEBAR_REALWIDTH = LIFEBAR_WIDTH+60

return Def.ActorFrame{
	--DANGER
	LoadActor("danger") .. {
		InitCommand=cmd(y,6;zoomtowidth,LIFEBAR_REALWIDTH;zoomy,0.5); 
		OnCommand=cmd(effectclock,"bgm";diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF66"));
		LifeChangedMessageCommand=function(self,params)		
			if params.Player == player then
				local lifeP1 = params.LifeMeter:GetLife();
				if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
					self:diffusealpha(1);
						
				else
					self:diffusealpha(0);
				end;	
			end;
		end;
	};
	
	--Wavy line
	LoadActor("hot_lores") .. {
		OnCommand=cmd(zoomtowidth,LIFEBAR_REALWIDTH;texcoordvelocity,0.1,0;queuecommand,"Begin");
		BeginCommand=function(self)
			local move = GAMESTATE:GetSongBPS()/2
			if GAMESTATE:GetSongFreeze() then 
				move = 0; 
			end
			self:texcoordvelocity(move,0);
			self:sleep(0.03);
			self:queuecommand("Begin");
		end;
		
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then
				local lifeP1=params.LifeMeter:GetLife();
				if lifeP1>=THEME:GetMetric("LifeMeterBar", "HotValue") then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(0);
				end;
			end;
		end;
	};

	---basemeter masked P1
	LoadActor("basemeter") .. {
		InitCommand=cmd(zoomy,.5;zoomtowidth,LIFEBAR_REALWIDTH;y,6;blend,Blend.Add;horizalign,left;x,-LIFEBAR_REALWIDTH/2);
		--InitCommand=cmd(valign,0.5;xy,-LIFEBAR_REALWIDTH/2,6;horizalign,left;zoomy,0.5;blend,Blend.Add); 
		OnCommand=cmd(--[[bounce;effectmagnitude,-40,0,0;effectclock,"bgm";effecttiming,1,0,0,0;]]);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then	
				local lifeP1 = params.LifeMeter:GetLife();
				if GAMESTATE:IsHumanPlayer(player)==true then
					if lifeP1==0 then
						self:visible(false);
					else
						if lifeP1==1 then
							self:effectmagnitude(0,0,0);
						else
							self:effectmagnitude(-40,0,0);
						end;
						self:visible(true);
					end
				end
				self:zoomtowidth((LIFEBAR_REALWIDTH)*lifeP1)		
			end;
		end;
	};
	
	-- Left Corner
	LoadActor("mask") .. {
		--Zoom 0.45 does strange things to positioning...
		InitCommand=cmd(x,(-LIFEBAR_WIDTH/2)+80;horizalign,right;zoom,0.45;);
	};
	
	
	-- Left Corner
	LoadActor("begin") .. {
		InitCommand=cmd(x,-LIFEBAR_WIDTH/2;horizalign,right;zoom,0.75;);
	};
	
	-- Center
	LoadActor("frame") .. {
		OnCommand=cmd(zoomtowidth,LIFEBAR_WIDTH;zoomy,0.75;);
	};
	
	-- Right Corner
	LoadActor("mask") .. {
		--Zoom 0.45 does strange things to positioning...
		InitCommand=cmd(x,(LIFEBAR_WIDTH/2)-80;horizalign,right;zoom,0.45;rotationy,180);
	};
	
	
	-- Right Corner
	LoadActor("begin") .. {
		InitCommand=cmd(x,LIFEBAR_WIDTH/2;horizalign,right;zoom,0.75;rotationy,180);
	};
	
	--SCORE
	LoadFont("venacti/_venacti_outline 26px bold monospace numbers") .. {
		InitCommand=cmd(zoom,0.45;uppercase,true;shadowlength,1;);
		ComboChangedMessageCommand=function(self)
			self:settext(string.format("%.02f",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints()*100).."%");
		end;
	};
	
	LoadActor("tip") .. {	
		InitCommand=cmd(zoom,0.5;y,6;blend,Blend.Add;);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then	
				local style = GAMESTATE:GetCurrentStyle();		
				local lifeP1 = params.LifeMeter:GetLife();
						
				if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
					self:diffusecolor(1,0.7,0.7,0.7);
				else
					self:diffusecolor(1,1,1,1);
				end
				
				if GAMESTATE:IsHumanPlayer(player)==true then
					if lifeP1==0 then
						self:visible(false);
					else
						self:visible(true);
					end
				end
				--Need to offset it by half the lifebar width since otherwise it would be starting at the lifebar's center and going way off
				self:x(LIFEBAR_REALWIDTH*lifeP1-(LIFEBAR_REALWIDTH/2));	
			end;
		end;
	};
};
