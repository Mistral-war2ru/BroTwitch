this.twitch_raid_event <- this.inherit("scripts/events/event", {
	m = {
		prop = 0
	},
	function create()
	{
		this.m.ID = "event.twitch_raid";
		this.m.Title = "Suddenly...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Twitch viewers are raiding your squad!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fight bravely!",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(_event.m.prop, false, false, false);
						return 0;
					}

				},
				{
					Text = "Accept death!",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(_event.m.prop, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
			
							function addToCombat( _list, _entityType, _diff, _need1, _champion = false, _name = "", _script = "")
							{
								local ecost = _entityType.Cost;
								if (ecost < 1)ecost = 1;
								local chek = ecost;
								if (_need1)chek = 0;
								for( local cost = _diff; cost >= chek; cost = cost - ecost )
								{
									local c = clone _entityType;
									
									c.Name <- _name;
									if (_script != "")c.Script <- _script;
									
									if (_champion)
									{
										c.Variant = 1;
									}
									else
									{
										c.Variant = 0;
									}

									_list.push(c);
								}
							}
						
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Event";
						p.Music = this.Const.Music.BanditTracks;
						p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
						p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
						p.AmbienceMinDelay[0] = 0;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.IsUsingSetPlayers = false;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = false;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];
						
						local gt = this.getroottable();
						foreach( raider in gt.tnf_debug.raiders )
						{
							addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider, 1, true , true, raider);
						}
						
						
					for( local i = 0; i < p.Entities.len(); i = ++i )
					{
						p.Entities[i].Faction <- this.Const.Faction.Enemy;
					}
				
					local entityTypes = [];
					entityTypes.resize(this.Const.EntityType.len(), 0);
					
					foreach( t in p.Entities )
					{
						if (t.Variant == 0)
						{
							++entityTypes[t.ID];
						}
					}
					
					local ek = 0;
					local k = 2;
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
					
					if ( ek > 80)
					{
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
					}
					
				_event.m.prop = p;
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Score = -100;
	}

	function onPrepare(){}

	function onPrepareVariables( _vars ){}

	function onClear(){}
});