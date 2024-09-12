this.skeleton_priest_boss <- this.inherit("scripts/entity/tactical/skeleton", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.SkeletonPriest;
		this.m.XP = this.Const.Tactical.Actor.SkeletonPriest.XP + 400;
		this.m.ResurrectionValue = 10.0;
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/skeleton_priest_boss";
		this.skeleton.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_priest_boss_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.skeleton.onInit();
		this.getSprite("body").setBrush("bust_skeleton_body_02");
		this.setDirty(true);
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.SkeletonPriest);
		b.Hitpoints = 220;
		b.ActionPoints = 13;
		b.Stamina = 500;
		b.TargetAttractionMult = 3.0;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Skills.add(this.new("scripts/skills/actives/horror_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/miasma_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/hex_skill"));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (this.World.Flags.get("IsTwitchBossSearch"))
		{
			this.World.Flags.set("IsTwitchBossDefeated", true);
		}
		
		this.skeleton.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/armor/named/lindwurm_armor"));
		
		local gt = this.getroottable();
		local laurel = this.new("scripts/items/ancient_laurels_boss");
		laurel.m.Name = "Ancient " + gt.tnf_debug.BossName + " golder laurels";
		this.m.Items.equip(laurel);
	}
	
	function onAfterDeath( _tile )
	{
		if (this.World.Flags.get("IsTwitchBossSearch"))
		{
			this.World.Flags.set("IsTwitchBossDefeated", true);
		}
	}

});

