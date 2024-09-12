this.barbarian_beastmaster_boss <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.BarbarianBeastmaster;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BarbarianBeastmaster.XP + 400;
		this.human.create();
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.SoundPitch = 0.95;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/barbarian_beastmaster_boss_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local tattoos = [
			3,
			4,
			5,
			6
		];

		if (this.Math.rand(1, 100) <= 66)
		{
			local tattoo_body = this.actor.getSprite("tattoo_body");
			local body = this.actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			local tattoo_head = this.actor.getSprite("tattoo_head");
			tattoo_head.setBrush("tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_head");
			tattoo_head.Visible = true;
		}

		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BarbarianBeastmaster);
		
		b.ActionPoints = 12;
		b.Hitpoints = 220;
		b.Stamina = 320;
		
		b.TargetAttractionMult = 1.1;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.Skills.update();
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_wildmen_01");
		this.m.Skills.add(this.new("scripts/skills/actives/barbarian_fury_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_recover"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		//this.m.Skills.add(this.new("scripts/skills/actives/crack_the_whip_skill"));
		this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
	}

	function assignRandomEquipment()
	{
		local gt = this.getroottable();
		local whip = this.new("scripts/items/named_battle_whip_boss");
		whip.m.Name = "Wriggling " + gt.tnf_debug.BossName + " whip of pain";
		this.m.Items.equip(whip);
		
		this.m.Items.equip(this.new("scripts/items/armor/barbarians/thick_plated_barbarian_armor"));
		this.m.Items.equip(this.new("scripts/items/helmets/barbarians/beastmasters_headpiece"));
	}
	
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (this.World.Flags.get("IsTwitchBossSearch"))
		{
			this.World.Flags.set("IsTwitchBossDefeated", true);
		}

		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

