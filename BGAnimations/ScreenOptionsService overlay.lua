return Def.ActorFrame{
    LoadFont("venacti/_venacti 26px bold diffuse")..{
        Text="Delta NEX Rebirth "..tostring(themeVersion);
        InitCommand=cmd(horizalign,center;vertalign,top;xy,SCREEN_CENTER_X,15;diffusebottomedge,Color("HoloDarkPurple"));
    };
    
    LoadFont("venacti/_venacti 15px bold")..{
		InitCommand=cmd(vertalign,top;xy,SCREEN_CENTER_X,45);
		OnCommand=function(self)
			--Fix for people stuck in the command window since set_input_redirected doesn't turn off
			SCREENMAN:set_input_redirected(PLAYER_1, false)
			SCREENMAN:set_input_redirected(PLAYER_2, false)
			if string.find(ProductVersion(), "5%.0") then
				self:settextf(THEME:GetString("ScreenOptionsService","VersionWarning"),ProductVersion());
				self:diffuse(Color("Red"));
			else
    			self:settext("StepMania "..ProductVersion());
				self:diffuse(Color("HoloGreen"));
			end;
		end;
    };

}
