this.twitch_boss_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test",
		ptype = 0,
		diff = 1,
		prop = 0
	},
	function create()
	{
		this.m.ID = "event.twitch_boss";
		this.m.Title = "Suddenly...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Wild %dude% %party% appears!\nCurrent battle difficulty: %diff%}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Charge!",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(_event.m.prop, false, false, false);
						return 0;
					}

				},
				{
					Text = "Retreat!",
					function getResult( _event )
					{
						return "B";
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
						p.IsUsingSetPlayers = false;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];
						
						local diff = _event.m.diff;
						local gt = this.getroottable();
						
						//nomads
						if (_event.m.ptype == 0)
						{
							gt.tnf_debug.add_boss0(p, _event.m.diff, _event.m.Name);
						}
						//beastmaster
						if (_event.m.ptype == 1)
						{
							gt.tnf_debug.add_boss1(p, _event.m.diff, _event.m.Name);
						}
						//gachi
						if (_event.m.ptype == 2)
						{
							gt.tnf_debug.add_boss2(p, _event.m.diff, _event.m.Name);
						}
						//snake
						if (_event.m.ptype == 3)
						{
							gt.tnf_debug.add_boss3(p, _event.m.diff, _event.m.Name);
						}
						//skeleton
						if (_event.m.ptype == 4)
						{
							gt.tnf_debug.add_boss4(p, _event.m.diff, _event.m.Name);
						}
						//barbarian
						if (_event.m.ptype == 5)
						{
							gt.tnf_debug.add_boss5(p, _event.m.diff, _event.m.Name);
						}
						
						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- this.Const.Faction.Enemy;
						}
				
				_event.m.prop = p;
				
				local entityTypes = [];
				entityTypes.resize(this.Const.EntityType.len(), 0);
				
				foreach( t in p.Entities )
				{
					if (t.Variant == 0)
					{
						++entityTypes[t.ID];
					}
				}
				
				this.List.push({
						id = 1,
						icon = "ui/icons/miniboss.png",
						text = _event.m.Name
					});
				
				local ek = 0;
				local k = 1;
				for( local i = 0; i < entityTypes.len(); i = ++i )
				{
					if (entityTypes[i] > 0)
					{
						ek = ek + entityTypes[i];
						if (entityTypes[i] == 1)
						{
							this.logDebug(this.Const.EntityIcon[i]);
							k = k + 1;
							this.List.push({
								id = k,
								icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
								text = this.Const.Strings.EntityName[i]
							});
						}
						else
						{
							this.logDebug(this.Const.EntityIcon[i]);
							k = k + 1;
							local nume = this.Const.Strings.EngageEnemyNumbers[this.Math.max(0, this.Math.floor(this.Math.minf(1.0, entityTypes[i] / 14.0) * (this.Const.Strings.EngageEnemyNumbers.len() - 1)))];
							this.List.push({
								id = k,
								icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
								text = nume + " " + this.Const.Strings.EntityNamePlural[i]
							});
						}
					}
				}
				
					if ( ek > 30)
					{
						local pr = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pr.CombatID = "Event";
						pr.Music = this.Const.Music.ArenaTracks;
						pr.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
						pr.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
						pr.AmbienceMinDelay[0] = 0;
						if ( ek <= 70)
						{
							pr.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
							pr.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						}
						else
						{
							if ( ek <= 95)
							{
								pr.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
								pr.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
							}
							else
							{
								pr.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
								pr.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
							}
						}
						pr.IsUsingSetPlayers = false;
						pr.IsFleeingProhibited = true;
						pr.IsLootingProhibited = false;
						pr.IsWithoutAmbience = true;
						pr.IsFogOfWarVisible = false;
						pr.IsArenaMode = false;
						pr.IsAutoAssigningBases = false;
						
						pr.Entities = [];
						foreach( t in p.Entities )
						{
							pr.Entities.push(t);
						}
						
						_event.m.prop = pr;
					}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You run away in horror!}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Looks like we got away!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local bros = roster.getAll();          
				for( local i = 0; i < bros.len(); i = ++i )
				{
					bros[i].worsenMood(0.5, "The squad fled from the battle with " + _event.m.Name);
					if (bros[i].getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bros[i].getMoodState()],
						text = bros[i].getName() + this.Const.MoodStateEvent[bros[i].getMoodState()]
						});
					}
				}
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
		if (this.m.ptype == 0)_vars.push(["party","Desert warrior"]);
		else if (this.m.ptype == 1)_vars.push(["party","Beastmaster"]);
		else if (this.m.ptype == 2)_vars.push(["party","The Gachimartyr"]);
		else if (this.m.ptype == 3)_vars.push(["party","Snake charmer"]);
		else if (this.m.ptype == 4)_vars.push(["party","Bonedance"]);
		else if (this.m.ptype == 5)_vars.push(["party","North Guardian"]);
		else _vars.push(["party"," "]);
		_vars.push([
			"diff",
			this.m.diff + " awesomeness points"
		]);
	}

	function onClear(){}
});