this.twitch_secret_boss_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test",
		ptype = 0,
		diff = 1,
		prop = 0,
		option1 = "Charge!",
		option2 = "Retreat!"
	},
	function create()
	{
		this.m.ID = "event.twitch_secret_boss";
		this.m.Title = "Suddenly...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%texted%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{%option1%}",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(_event.m.prop, false, false, false);
						return 0;
					}

				},
				{
					Text = "{%option2%}",
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
						
						local gt = this.getroottable();
						
						//big ed
						if (_event.m.ptype == 0)
						{
							gt.tnf_debug.add_sboss0(p);
							
							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = "Edo"
							});
						}
						//frukt
						if (_event.m.ptype == 1)
						{
							gt.tnf_debug.add_sboss1(p);
							
							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = "Fruto Knight"
							});
							
							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = "Fruto Archer"
							});
							
							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = "Fruto Thief"
							});
							
							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = "Fruto Berserker"
							});
							
							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = "Fruto Bard"
							});
						}
						//nerh
						if (_event.m.ptype == 2)
						{
							_event.m.Name = "Nerh - Shiny Head";
							gt.tnf_debug.add_sboss2(p, _event.m.diff, _event.m.Name);
						}
						//mike
						if (_event.m.ptype == 3)
						{
							_event.m.Name = "MAD Mike";
							gt.tnf_debug.add_sboss3(p, _event.m.diff, _event.m.Name);
						}
						//hoples archer
						if (_event.m.ptype == 4)
						{
							_event.m.Name = "Hopeless";
							gt.tnf_debug.add_sboss4(p, _event.m.diff, _event.m.Name);
						}
						//gor
						if (_event.m.ptype == 5)
						{
							_event.m.Name = "Ser Pavel the Burning";
							gt.tnf_debug.add_sboss5(p, _event.m.diff, _event.m.Name);

							this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = _event.m.Name
							});
							
							this.List.push({
								id = 2,
								icon = "ui/icons/miniboss.png",
								text = "Sir De La Crom"
							});
						}
						//kosa
						if (_event.m.ptype == 6)
						{
							_event.m.Name = "Death hermit";
							gt.tnf_debug.add_sboss6(p, _event.m.diff, _event.m.Name);
						}
						//all
						if (_event.m.ptype == 7)
						{
							gt.tnf_debug.add_sboss0(p);
							gt.tnf_debug.add_sboss1(p);
							
							gt.tnf_debug.add_sboss2(p, _event.m.diff, "Nerh - Shiny Head");
							gt.tnf_debug.add_sboss3(p, _event.m.diff, "MAD Mike");
							gt.tnf_debug.add_sboss4(p, _event.m.diff, "Hopeless");
							gt.tnf_debug.add_sboss5(p, _event.m.diff, "Ser Pavel the Burning");
							
							gt.tnf_debug.add_sboss6(p, _event.m.diff, "Death hermit");
							
							_event.m.Name = "All bosses !";
						}
						//pizdets
						if (_event.m.ptype == 8)
						{
							_event.m.Name = "pizdets";
							gt.tnf_debug.addToCombat(p.Entities, this.Const.World.Spawn.Troops.TricksterGod, 300, true, true);
						}
						
						
					for( local i = 0; i < p.Entities.len(); i = ++i )
					{
						p.Entities[i].Faction <- this.Const.Faction.Enemy;
					}
				
				_event.m.prop = p;
				
				if (_event.m.ptype > 1)
				{
					local entityTypes = [];
					entityTypes.resize(this.Const.EntityType.len(), 0);
					
					foreach( t in p.Entities )
					{
						if (t.Variant == 0)
						{
							++entityTypes[t.ID];
						}
					}
					
					if (_event.m.ptype != 5)
					{
						this.List.push({
								id = 1,
								icon = "ui/icons/miniboss.png",
								text = _event.m.Name
							});
					}
					
					local ek = 0;
					if (_event.m.ptype == 8)ek = 300;
					local k = 2;
					if (_event.m.ptype == 5)k = 3;
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
		this.m.option1 = "Charge!";
		this.m.option2 = "Retreat!";
		
		if (this.m.ptype == 0)_vars.push(["texted","Secret Boss Big Ed Appears!"]);
		else if (this.m.ptype == 1)_vars.push(["texted","The Secret Fruit Squad Appears!"]);
		else if (this.m.ptype == 2)
		{
			_vars.push(["texted","Nerh - Shiny Head has risen from the grave again!" + 
			"\nCurrent battle difficulty: "+ this.m.diff+" awesomeness points!"]);
			this.m.option1 = "Let's drive him back!";
		}
		else if (this.m.ptype == 3)
		{
			_vars.push(["texted","MAD Mike is furious again!" + 
			"\nCurrent battle difficulty: "+ this.m.diff+" awesomeness points!"]);
			this.m.option1 = "We need to calm him down!";
		}
		else if (this.m.ptype == 4)
		{
			_vars.push(["texted","Hopeless emerges from the forest thicket!" + 
			"\nCurrent battle difficulty: "+ this.m.diff+" awesomeness points!"]);
		}
		else if (this.m.ptype == 5)
		{
			_vars.push(["texted","Ser Pavel the Burning plays with fire again!" + 
			"\nCurrent battle difficulty: "+ this.m.diff+" awesomeness points!"]);
			this.m.option1 = "It's time to put him out!";
		}
		else if (this.m.ptype == 6)
		{
			_vars.push(["texted","There is a man with a scythe wandering nearby"]);
			this.m.option1 = "We could use this scythe!";
		}
		else if (this.m.ptype == 7)
		{
			_vars.push(["texted","All bosses" + 
			"\nCurrent battle difficulty: "+ this.m.diff+" awesomeness points!"]);
			this.m.option1 = "A great battle awaits us!";
		}
		else if (this.m.ptype == 8)
		{
			_vars.push(["texted","You see pizdets approaching"]);
			this.m.option1 = "Well, seems like we all dead";
		}
		else _vars.push(["texted"," "]);
		
		_vars.push(["option1", this.m.option1]);
		_vars.push(["option2", this.m.option2]);
	}

	function onClear(){}
});