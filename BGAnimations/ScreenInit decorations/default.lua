local t = Def.ActorFrame{

	LoadActor("andamiro")..{
	
	};

}

t[#t+1] = Def.ActorFrame{
  FOV=90;
  InitCommand=cmd(Center);
	LoadActor("back") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT;);
		OnCommand=cmd(diffusealpha,0;sleep,7;linear,.3;diffusealpha,1);
	};
	LoadActor("stepmania")..{
		InitCommand=cmd(y,0;diffusealpha,0;zoom,0.3;);
		OnCommand=cmd(sleep,7.7;linear,0.7;diffusealpha,0.8;sleep,2;linear,0.5;y,-50;diffusealpha,0;);
	};
	LoadActor("delta")..{
		InitCommand=cmd(x,-170;y,50;diffusealpha,0;zoom,0.65);
		OnCommand=cmd(sleep,11;linear,0.5;diffusealpha,0.8;y,0;sleep,2;linear,0.5;y,-50;diffusealpha,0;);
	};
	LoadActor("sm-ssc")..{
		InitCommand=cmd(x,170;y,50;diffusealpha,0;zoom,0.65);
		OnCommand=cmd(sleep,11;linear,0.5;diffusealpha,0.8;y,0;sleep,2;linear,0.5;y,-50;diffusealpha,0;);
	};
	LoadActor("author")..{
		InitCommand=cmd(y,50;diffusealpha,0;zoom,0.4);
		OnCommand=cmd(sleep,14;linear,0.5;diffusealpha,0.8;y,0;sleep,2;linear,0.5;zoom,0.45;diffusealpha,0;);
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;diffusealpha,0);
	OnCommand=cmd(sleep,7;linear,3;diffusealpha,1);
	
	Def.Quad{
		InitCommand=cmd(vertalign,bottom;y,SCREEN_BOTTOM;zoomto,SCREEN_WIDTH,50;diffuse,0,0,0,0.5);
	};

	Def.Quad{
		InitCommand=cmd(vertalign,top;y,SCREEN_TOP;zoomto,SCREEN_WIDTH,50;diffuse,0,0,0,0.5);
	};

	Def.Quad{
		InitCommand=cmd(glowshift;vertalign,bottom;y,SCREEN_BOTTOM-50;zoomto,SCREEN_WIDTH,2;diffuse,color("#F54D70"));
	};

	Def.Quad{
		InitCommand=cmd(glowshift;vertalign,top;y,SCREEN_TOP+50;zoomto,SCREEN_WIDTH,2;diffuse,color("#F54D70"));
	};

};

return t