this.twitch_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.twitch";
		this.m.Name = "Twitch Chat Integration";
		this.m.Description = "[p=c][img]gfx/ui/events/event_twitch_start.png[/img][/p][p]The streamer survives in the cruel and dangerous world of battle brothers with his chat.\n\n[color=#bcad8c]Top streamer:[/color]\n Twitch's coolest streamer leads his chat on this difficult journey.\n[color=#bcad8c]Interactive mode:[/color]\n Viewers from twitch chat can independently influence the game world using a huge variety of interactive commands.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 250;	
	}

	function isValid()
	{
		return this.Const.DLC.Unhold;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		
		local bro;
		bro = roster.create("scripts/entity/tactical/player");
		bro.setStartValuesEx(["streamer_background"]);
		bro.getBackground().m.RawDescription = "The top Twitch streamer, ready for dangerous adventures in the world of bros.";
		bro.getBackground().buildDescription(true);
		
        bro.setName("Change name !");
		
		local function replace(str, sub, rep)
		{
		  local s, i;
		  for(i = 0; i < str.len(); )
		  {
			local e = str.find(sub, i);
			if(e == null) break;
			if(s == null) s = "";
			s += str.slice(i, e) + rep;
			i = e + sub.len();
		  }
		  if(s == null) return str;
		  return s + str.slice(i);
		}
		
		local scriptFiles = this.IO.enumerateFiles("twitch");
		if (scriptFiles != null)
		{
			foreach( scriptFile in scriptFiles )
			{
				//twitch/!streamer name
				local e = scriptFile.find("twitch/!streamer ", 0);
				if (e!=null)
				{
					local stname = "" + scriptFile;
					stname = replace(stname, "twitch/!streamer ", "");
					if (stname.len() > 0)
					{
						bro.setName(stname);
					}
				}
			}
		}
		
		bro.getSkills().removeByID("trait.survivor");
		bro.getSkills().removeByID("trait.greedy");
		bro.getSkills().removeByID("trait.loyal");
		bro.getSkills().removeByID("trait.disloyal");
		bro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		bro.setPlaceInFormation(3);
		bro.getFlags().set("IsPlayerCharacter", true);
		bro.m.HireTime = this.Time.getVirtualTimeF();
		bro.improveMood(1.0, "");	
		bro.m.PerkPoints = 1;
		bro.m.LevelUps = 0;
		bro.m.Level = 1;
		bro.getBaseProperties().MeleeSkill += 3;
		bro.getBaseProperties().MeleeDefense += 3;
		bro.m.Talents = [];
		bro.m.Attributes = [];
		local talents = bro.getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeDefense] = 3;
		talents[this.Const.Attributes.Initiative] = 3;
		talents[this.Const.Attributes.MeleeSkill] = 3;
		bro.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local items = bro.getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/armor/noble_tunic"));
		
		local bro2;
		bro2 = roster.create("scripts/entity/tactical/player");
		bro2.setStartValuesEx(["developer_background"]);
		bro2.getBackground().m.RawDescription = "The coolest developer of this mod.";
		bro2.getBackground().buildDescription(true);
        bro2.setName("ed_gorod");
		bro2.getSkills().removeByID("trait.survivor");
		bro2.getSkills().removeByID("trait.greedy");
		bro2.getSkills().removeByID("trait.loyal");
		bro2.getSkills().removeByID("trait.disloyal");
		bro2.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
		bro2.setPlaceInFormation(4);
		bro2.getFlags().set("IsPlayerCharacter", true);
		bro2.m.HireTime = this.Time.getVirtualTimeF();
		bro2.improveMood(1.0, "");	
		bro2.m.PerkPoints = 1;
		bro2.m.LevelUps = 0;
		bro2.m.Level = 1;
		bro2.getBaseProperties().MeleeDefense += 5;
		bro2.getBaseProperties().RangedDefense += 5;
		bro2.m.Talents = [];
		bro2.m.Attributes = [];
		local talents = bro2.getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeDefense] = 3;
		talents[this.Const.Attributes.Fatigue] = 3;
		talents[this.Const.Attributes.RangedDefense] = 3;
		bro2.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local items2 = bro2.getItems();
		items2.unequip(items2.getItemAtSlot(this.Const.ItemSlot.Body));
		items2.unequip(items2.getItemAtSlot(this.Const.ItemSlot.Head));
		items2.unequip(items2.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items2.unequip(items2.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items2.unequip(items2.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items2.equip(this.new("scripts/items/armor/wizard_robe"));
		
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 20);
		this.World.Assets.getStash().add(this.new("scripts/items/diff_tester"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 300 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 100);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts + 10;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine + 5;
		this.World.Assets.m.Ammo = 10;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() <= 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 3), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 3));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 3), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 3));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(9);
		this.World.State.getPlayer().getSprite("body").setBrush("figure_civilian_05");
		this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", randomVillageTile.Coords).setSize(1);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.CivilianTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.twitch_scenario_intro");
		}, null);
	}

	function onInit()
	{
		if (this.World.State.getPlayer() != null)
		{
			this.World.State.getPlayer().m.BaseMovementSpeed = 108;
		}
		this.World.Assets.m.FootprintVision = 1.2;
        this.World.Assets.m.VisionRadiusMult = 1.2;
		this.World.Assets.m.ExtraLootChance = 50;
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 18;
		this.World.Assets.m.BrothersScaleMax = 18;
	}

});
