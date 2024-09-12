this.hoples_boss <- this.inherit("scripts/entity/tactical/human", {
	m = {
		Info = null,
		dog1 = null,
		dog2 = null,
		dog3 = null,
		dog4 = null,
		dog5 = null
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.MasterArcher;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.MasterArcher.XP + 500;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_ranged_agent");
		this.m.AIAgent.setActor(this);
		
		local SoundOnUse = [
					"sounds/combat/unleash_wardog_01.wav",
					"sounds/combat/unleash_wardog_02.wav",
					"sounds/combat/unleash_wardog_03.wav",
					"sounds/combat/unleash_wardog_04.wav"
				];
		foreach( r in SoundOnUse )
		{
			this.Tactical.addResource(r);
		}
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.MasterArcher);
		b.DamageDirectMult = 1.25;
		b.IsSpecializedInBows = true;
		b.Vision = 8;
		b.ActionPoints = b.ActionPoints + 7;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_militia");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_flow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
	}
	
	function onTurnEnd()
	{
		this.human.onTurnEnd();//onAttacked
		
		if (this.m.dog1 == null || this.m.dog2 == null || this.m.dog3 == null || this.m.dog4 == null || this.m.dog5 == null)
		{
			this.m.Info = {
				Tile = this.getTile(),
				Faction = this.getFaction()
			};
			local mapSize = this.Tactical.getMapSize();
			local attempts = 0;
			local n = 0;
			local rd = 2;
			
			while (attempts++ < 50)
			{
				local x = this.Math.rand(this.Math.max(0, this.m.Info.Tile.SquareCoords.X - rd), this.Math.min(mapSize.X - 1, this.m.Info.Tile.SquareCoords.X + rd));
				local y = this.Math.rand(this.Math.max(0, this.m.Info.Tile.SquareCoords.Y - rd), this.Math.min(mapSize.Y - 1, this.m.Info.Tile.SquareCoords.Y + rd));

				if (!this.Tactical.isValidTileSquare(x, y))
				{
					continue;
				}

				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty || tile.ID == this.m.Info.Tile.ID)
				{
					continue;
				}

				local e = this.Tactical.spawnEntity("scripts/entity/tactical/hellhound", tile.Coords);
				e.setFaction(this.m.Info.Faction);
				e.m.Name = "Who's That Pokémon?";
				//e.assignRandomEquipment();
				n = ++n;
				
				local SoundOnUse = [
					"sounds/combat/unleash_wardog_01.wav",
					"sounds/combat/unleash_wardog_02.wav",
					"sounds/combat/unleash_wardog_03.wav",
					"sounds/combat/unleash_wardog_04.wav"
				];
				
				this.Sound.play(SoundOnUse[this.Math.rand(0, SoundOnUse.len() - 1)], 1.0, tile.Coords);
				
				if (this.m.dog1 == null){this.m.dog1 = e;break;}
				if (this.m.dog2 == null){this.m.dog2 = e;break;}
				if (this.m.dog3 == null){this.m.dog3 = e;break;}
				if (this.m.dog4 == null){this.m.dog4 = e;break;}
				if (this.m.dog5 == null){this.m.dog5 = e;break;}
				
				break;
			}
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
		
		local tile = _tile;//this.getTile();
		local dog = this.new("scripts/items/hellhound_item")
		tile.Items.push(dog);
		tile.IsContainingItems = true;
		dog.m.Tile = tile;
		dog.onDrop(tile);
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{
		local weap = this.new("scripts/items/weapons/named/named_warbow");
		weap.m.Name = "Bow of Lost Hopes";
		this.m.Items.equip(weap);
		
		local helm = this.new("scripts/items/helmets/named/wolf_helmet");
		helm.m.Name = "Desperate wolf";
		this.m.Items.equip(helm);
		
		local armr = this.new("scripts/items/armor/named/black_leather_armor");
		armr.m.Name = "Forgotten Veil";
		this.m.Items.equip(armr);
		
		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/scramasax"));
	}

});

