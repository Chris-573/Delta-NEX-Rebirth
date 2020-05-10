return Def.ActorFrame {
	Def.Quad {
		OffCommand=function(self)
			SCREENMAN:set_input_redirected(PLAYER_1, false)
			SCREENMAN:set_input_redirected(PLAYER_2, false)
		end
	}
}