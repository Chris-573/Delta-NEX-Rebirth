local t=Def.ActorFrame{};

t[#t+1]=Def.ActorFrame{
  FOV=90;
  InitCommand=cmd(Center);
	LoadActor("Diagonal") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT);
	};
};

return t;
