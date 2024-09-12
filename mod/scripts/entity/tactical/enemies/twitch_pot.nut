this.twitch_pot <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Info = null
	},
	function create()
	{
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = false;
		this.m.IsShakingOnHit = false;
		this.m.Type = this.Const.EntityType.SkeletonPhylactery;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = 0;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc6/phylactery_death_01.wav",
			"sounds/enemies/dlc6/phylactery_death_02.wav",
			"sounds/enemies/dlc6/phylactery_death_03.wav",
			"sounds/enemies/dlc6/phylactery_death_04.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(0, 100) < 50;

		if (_tile != null)
		{
			local effect = {
				Delay = 0,
				Quantity = 10,
				LifeTimeQuantity = 10,
				SpawnRate = 100,
				Brushes = [
					"bust_lich_aura_01"
				],
				Stages = [
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff2f"),
						ColorMax = this.createColor("ffffff2f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -0.5),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(-10, -10),
						SpawnOffsetMax = this.createVec(10, 10),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff1f"),
						ColorMax = this.createColor("ffffff1f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -0.5),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("ffffff00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -0.5),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			};

			if (_tile.IsVisibleForPlayer)
			{
				this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
			}

			_tile.spawnDetail("phylactery_destroyed", this.Const.Tactical.DetailFlag.Corpse, flip);
			this.spawnTerrainDropdownEffect(_tile);
		}
        this.m.Info = {
			Tile = this.getTile(),
			Faction = this.getFaction(),
			Killer = _killer
		
		};
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

  function onAfterDeath( _tile )
	{
	local type = this.Math.rand(1,10);
	 if(type<=4)
	 {
	 this.createEntity(this.m.Info);
     }
     if(type==5||type==6)
     {
     local lootTable = [];
     lootTable.push(this.new("scripts/items/loot/signet_ring_item"));
     lootTable.push(this.new("scripts/items/loot/golden_chalice_item"));
     lootTable.push(this.new("scripts/items/loot/ancient_gold_coins_item"));
     lootTable.push(this.new("scripts/items/loot/gemstones_item"));
     lootTable.push(this.new("scripts/items/loot/silverware_item"));
     lootTable.push(this.new("scripts/items/loot/silver_bowl_item"));
     lootTable.push(this.new("scripts/items/loot/jeweled_crown_item"));
     if(this.Math.rand(1,100)<=10)
     {
        local potential = [];
	    foreach(item in this.Const.Items.NamedMeleeWeapons)
	    {
	    potential.push(item);
	    }
	    foreach(item in this.Const.Items.NamedRangedWeapons)
	    {
	    potential.push(item);
	    }
	    foreach(item in this.Const.Items.NamedOrcWeapons)
	    {
	    potential.push(item);
	    }
	     foreach(item in this.Const.Items.NamedGoblinWeapons)
	    {
	    potential.push(item);
	    }
	     foreach(item in this.Const.Items.NamedUndeadWeapons)
	    {
	    potential.push(item);
	    }
	     foreach(item in this.Const.Items.NamedBarbarianWeapons)
	    {
	    potential.push(item);
	    }
	    local id = potential[this.Math.rand(1, potential.len() - 1)];
	    local newobject = this.new("scripts/items/"+(id));
	   
	    if(newobject != null)
	    {
	     
	    newobject.drop(_tile);
	    }
	    
     }
     local loot = lootTable[this.Math.rand(0, lootTable.len() - 1)];
     if(loot!=null)
     {
	 loot.drop(_tile);
     }
     }
     if(type==7||type == 8)
     {
     for( local i = 0; i < 6; i = ++i )
			{
				if (!_tile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = _tile.getNextTile(i);

					if (this.Math.abs(_tile.Level - nextTile.Level) <= 1 && nextTile.IsOccupiedByActor)
					{
						local target = nextTile.getEntity();

						if (!target.isAlive() || target.isDying())
						{
						}
						else
						{
						
							local hitInfo = clone this.Const.Tactical.HitInfo;
							hitInfo.DamageRegular = this.Math.rand(30, 40);
							hitInfo.DamageArmor = hitInfo.DamageRegular * 0.75;
							hitInfo.DamageDirect = 0.3;
							hitInfo.BodyPart = 0;
							hitInfo.FatalityChanceMult = 0.0;
							hitInfo.Injuries = this.Const.Injury.PiercingBody;
							target.onDamageReceived(this.m.Info.Killer, null, hitInfo);
						}
					}
				}
			}
     }
    
     
    }
    function createEntity(_info)
    {
    local rand= this.Math.rand(1,12);
    local faction = _info.Faction;
    local entity;
    switch(rand)
    {
    case 1:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/humans/barbarian_thrall", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 2:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/humans/peasant", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 3:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/orc_young_low", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 4:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/goblin_ambusher_low", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 5:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/ghost", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    break;
    case 6:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_light", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 7:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/spider", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    break;
    case 8:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/vampire", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 9:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    entity.assignRandomEquipment();
    break;
    case 10:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/hexe", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    break;
     case 11:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/alp", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    break;
     case 12:
    entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/direwolf", _info.Tile.Coords.X, _info.Tile.Coords.Y);
    break;
    }
	
	entity.setFaction(_info.Faction);
    //this.Tactical.TurnSequenceBar.removeEntity(entity);
    //entity.m.IsActingImmediately = true;
    //entity.m.IsTurnDone = false;
    //this.Tactical.TurnSequenceBar.insertEntity(entity);
	
    }
	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.SkeletonPhylactery);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.TargetAttractionMult = 1.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local flip = this.Math.rand(0, 1) == 1;
		local body = this.addSprite("body");
		body.setBrush("phylactery");
		body.setHorizontalFlipping(flip);
		this.addDefaultStatusSprites();
		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.update();
	}

});