this.twitch_duel_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test",
		Name2 = "test"
	},
	function create()
	{
		this.m.ID = "event.twitch_duel";
		this.m.Title = "Suddenly...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You see a duel starting between %dude% and %dude2%.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let's see who wins!",
					function getResult( _event )
					{
						local gt = this.getroottable();
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.IsFogOfWarVisible = false;
						properties.IsUsingSetPlayers = true;
						properties.IsLootingProhibited = true;
						properties.Entities = [];
						properties.Players = [];
								
						local roster = this.World.getPlayerRoster();
						local bros = roster.getAll();          
							foreach( bro in bros )
							{
								if (bro.getNameOnly() == _event.m.Name)
								{
									//bro.getSkills().add(this.new("scripts/skills/effects_world/twitch_knowledge_potion_effect"));
									gt.tnf_debug.CloneName <- _event.m.Name;
									local unit = clone this.Const.World.Spawn.Troops.BountyHunter;
									unit.Faction <- this.Const.Faction.PlayerAnimals;
									unit.Script = "scripts/entity/tactical/humans/twitchbroclone";
									unit.Strength = bro.getLevel() * 5;
									unit.Cost = unit.Strength;
									properties.Entities.push(unit);
								}
								if (bro.getNameOnly() == _event.m.Name2)
								{
									gt.tnf_debug.CloneName2 <- _event.m.Name2;
									local unit2 = clone this.Const.World.Spawn.Troops.BountyHunter;
									unit2.Faction <- this.Const.Faction.Enemy;
									unit2.Script = "scripts/entity/tactical/humans/twitchbroclone2";
									unit2.Strength = bro.getLevel() * 5;
									unit2.Cost = unit2.Strength;
									properties.Entities.push(unit2);
								}
							}
						
						local roster2 = this.World.getTemporaryRoster();
						local Dude = roster2.create("scripts/entity/tactical/player");
						Dude.setStartValuesEx(["historian_background"]);
						Dude.getBackground().m.RawDescription = "?";
						Dude.getBackground().buildDescription(true);
						Dude.setName("Observer");
						Dude.setPlaceInFormation(4);
						
						properties.Players.push(Dude);
						
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(properties, false, false, false);
						
						return 0;
					}

				},
				{
					Text = "Stop at once!",
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
				foreach( bro in bros )
				{
					if (bro.getNameOnly() == _event.m.Name)
					{
						this.Characters.push(bro.getImagePath());
					}
					if (bro.getNameOnly() == _event.m.Name2)
					{
						this.Characters.push(bro.getImagePath());
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
		_vars.push([
			"dude2",
			this.m.Name2
		]);
	}

	function onClear(){}
});