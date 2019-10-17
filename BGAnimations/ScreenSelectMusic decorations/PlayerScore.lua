local player = ...
assert(player, "SSM PlayerScore: Need a player, dingus");
return Def.ActorFrame{

	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.8");setsize,110,15;fadeleft,.1;faderight,.1;y,-26);
	};
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		Text=THEME:GetString("ScreenSelectMusic","YourBest");
		InitCommand=cmd(shadowlength,0.8;y,-27;zoom,.45);
	};
	

	Def.Sprite{
		InitCommand=cmd(skewx,-0.1;x,-65;horizalign,left;zoom,0.525;fadetop,0;);
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:diffusealpha(1);
				profile = PROFILEMAN:GetProfile(player);
				steps = GAMESTATE:GetCurrentSteps(player);
				if not steps then return end;
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),steps);
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

					if topscore then

						local dancepoints = topscore:GetPercentDP()*100
						local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
						local grade = GetGradeFromDancePoints(dancepoints);
						--SCREENMAN:SystemMessage(grade);
						self:Load(THEME:GetPathG("","GradeDisplayPane/"..grade));
				else
					--if no score
					self:diffusealpha(0);
				end
			else
				--if no song
				self:diffusealpha(0);
			end;
		end;
	};



	--Bar
	Def.Quad {
		InitCommand=cmd(diffuse,color("1,1,1,0.2");zoomto,110,1;y,20);
	};

	LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
		InitCommand=cmd(shadowlength,0.8;horizalign,right;x,50;y,-8;zoom,.4;queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song and GAMESTATE:GetCurrentSteps(player) then
				profile = PROFILEMAN:GetProfile(player);
				scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(player));
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

				if topscore then
					text = scorecap(topscore:GetScore())

				else
					text = "0";
				end
				self:diffusealpha(1);
				self:settext(text);


			else
				self:settext("0");
				self:diffusealpha(0.4);
			end

		end
	};

	LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
		InitCommand=cmd(shadowlength,0.8;horizalign,right;x,50;y,8;zoom,.4;queuecommand,"Set");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		['CurrentSteps'..ToEnumShortString(player)..'ChangedMessageCommand']=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song and GAMESTATE:GetCurrentSteps(player) then
				profile = PROFILEMAN:GetProfile(player);
				scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(player));
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];

				if topscore then
					text = tonumber(string.format("%.02f",(topscore:GetPercentDP()*100))).."%";
				else
					text = "0.00%";
				end;
				self:diffusealpha(1);
				self:settext(text);
			else
				self:settext("0.00%");
				self:diffusealpha(0.4);
			end;

		end;
	};
};
