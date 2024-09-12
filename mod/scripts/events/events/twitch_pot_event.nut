this.twitch_pot_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test",
		prop = 0
	},
	function create()
	{
		this.m.ID = "event.twitch_pot";
		this.m.Title = "Suddenly...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%dude% is invited to the casino!}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Great, let's go!",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(_event.m.prop, false, false, false);
						return 0;
					}

				},
				{
					Text = "I forbid it!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.arena_floor";
						p.Music = this.Const.Music.ArenaTracks;
						p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
						p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
						p.AmbienceMinDelay[0] = 0;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsUsingSetPlayers = true;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];
						p.Players = [];
						
						local roster = this.World.getPlayerRoster();
						local bros = roster.getAll();          
							foreach( bro in bros )
							{
								if (bro.getNameOnly() == _event.m.Name)
								{
									p.Players.push(bro);
								}
							}
						
						local gt = this.getroottable();
						
						for( local ii = 0; ii < 10; ii = ++ii )
						{
							gt.tnf_debug.addToCombat(p.Entities, this.Const.World.Spawn.Twitch_Pots.TwitchPot, 1, true, true, "Casino Pot");
						}
						
						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- this.Const.Faction.Enemy;
						}
				
				_event.m.prop = p;
				
				this.List.push({
						id = 1,
						icon = "ui/icons/miniboss.png",
						text = "Casino Pots"
					});
			}

		});
	}

	function onUpdateScore()
	{
		this.m.Score = -100;
	}

	function onPrepare(){}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Name
		]);
	}

	function onClear(){}
});