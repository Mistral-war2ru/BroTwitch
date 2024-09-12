this.skeleton_nerh_boss <- this.inherit("scripts/entity/tactical/skeleton", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.SkeletonBoss;
		this.m.XP = this.Const.Tactical.Actor.SkeletonBoss.XP + 500;
		this.m.ResurrectionValue = 15.0;
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/skeleton_nerh_boss";
		this.m.IsGeneratingKillName = false;
		this.skeleton.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.skeleton.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.SkeletonBoss);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsSpecializedInCleavers = true;
		b.Hitpoints = b.Hitpoints + 100;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
	}

	function assignRandomEquipment()
	{
		local gt = this.getroottable();
		local khopesh = this.new("scripts/items/nerh_khopesh");
		khopesh.m.Name = "Nerh - Shiny Head's Jade Khopesh";
		this.m.Items.equip(khopesh);
		this.m.Items.equip(this.new("scripts/items/nerh_armor"));
		this.m.Items.equip(this.new("scripts/items/nerh_helmet"));
	}

});

