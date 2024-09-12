this.necromancer_boss <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Necromancer.XP + 400;
		this.human.create();
		this.m.Faces = this.Const.Faces.Necromancer;
		this.m.Hairs = this.Const.Hair.Necromancer;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.ConfidentMoraleBrush = "icon_confident_undead";
		this.m.SoundPitch = 0.9;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/necromancer_boss_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		
		//b.setValues(this.Const.Tactical.Actor.Necromancer);
		//b.setValues(prop);
		b.ActionPoints = 13;
		b.Hitpoints = 170;
		b.Bravery = 99;
		b.Stamina = 220;
		b.MeleeSkill = 100;
		b.RangedSkill = 100;
		b.MeleeDefense = 85;
		b.RangedDefense = 55;
		b.Initiative = 90;
		b.Armor[0] = 20;
		b.Armor[1] = 0;
		b.ArmorMax = [20, 0];
		b.FatigueEffectMult = 1.0;
		b.MoraleEffectMult = 1.0;
		
		b.TargetAttractionMult = 3.0;
		b.IsAffectedByNight = false;
		b.Vision = 8;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_undead");
		this.getSprite("head").Color = this.createColor("#ffffff");
		this.getSprite("head").Saturation = 1.0;
		this.getSprite("body").Saturation = 0.6;
		this.m.Skills.add(this.new("scripts/skills/actives/raise_undead"));
		this.m.Skills.add(this.new("scripts/skills/actives/possess_undead_skill"));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (this.World.Flags.get("IsTwitchBossSearch"))
		{
			this.World.Flags.set("IsTwitchBossDefeated", true);
		}

		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		local gt = this.getroottable();
		local axe = this.new("scripts/items/named_throwing_axe_boss");
		axe.m.Name = "Darkest " + gt.tnf_debug.BossName + " Necro axe";
		this.m.Items.equip(axe);

		local r = this.Math.rand(1, 2);

		if (r <= 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		}

		r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/dark_cowl"));
		}
		else if (r == 3)
		{
			local hood = this.new("scripts/items/helmets/hood");
			hood.setVariant(63);
			this.m.Items.equip(hood);
		}
	}

});

