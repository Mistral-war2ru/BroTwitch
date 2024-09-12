this.pasha_castle_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.pasha_castle_enter";
		this.m.Title = "Suddenly...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_57.png[/img]{You approach a majestic castle, on each tower of which a huge fire burns. Its grandeur amazes you.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Only forward!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}
						
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "TwitchLegendaryBossLoc";
						p.TerrainTemplate = "tactical.plains";
						p.LocationTemplate.Template[0] = "tactical.human_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.WallsAndPalisade;
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];
						
						local gt = this.getroottable();
						gt.tnf_debug.add_sboss5(p, gt.tnf_debug.calc_diff(), "Ser Pavel the Burning");
						
						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- this.Const.Faction.Enemy;
						}
						
						p.Loot = [
							"scripts/items/loot/silverware_item",
							"scripts/items/loot/silver_bowl_item",
							"scripts/items/loot/signet_ring_item",
							"scripts/items/loot/golden_chalice_item",
							"scripts/items/loot/ancient_gold_coins_item",
							"scripts/items/loot/ancient_gold_coins_item",
							"scripts/items/loot/ornate_tome_item",
							"scripts/items/supplies/wine_item",
							"scripts/items/supplies/wine_item",
							"scripts/items/supplies/wine_item",
							"scripts/items/supplies/wine_item"
						];
						
						this.World.State.getMenuStack().pop(true);
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "Retreat!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}
	
	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

