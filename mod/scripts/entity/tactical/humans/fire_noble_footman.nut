this.fire_noble_footman <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Footman;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Footman.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Footman);
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_military");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_shield_expert"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
	}

	function assignRandomEquipment()
	{
		local r;
		local banner = 4;

		this.m.Surcoat = banner;

		if (this.Math.rand(1, 100) <= 90)
		{
			this.getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/military_pick"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/arming_sword"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/morning_star"));
		}

		r = this.Math.rand(1, 2);
		local shield;

		if (r == 1)
		{
			shield = this.new("scripts/items/shields/faction_kite_shield");
		}
		else if (r == 2)
		{
			shield = this.new("scripts/items/shields/faction_heater_shield");
		}

		shield.setFaction(banner);
		this.m.Items.equip(shield);
		r = this.Math.rand(1, 3);

		if (r == 1)
		{
			local armor = this.new("scripts/items/armor/mail_hauberk");
			armor.setVariant(28);
			this.m.Items.equip(armor);
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}

		local helmet;

			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				helmet = this.new("scripts/items/helmets/kettle_hat");
			}
			else if (r == 2)
			{
				helmet = this.new("scripts/items/helmets/padded_kettle_hat");
			}
			else if (r == 3)
			{
				helmet = this.new("scripts/items/helmets/kettle_hat_with_mail");
			}
			else
			{
				helmet = this.new("scripts/items/helmets/mail_coif");
			}

		if (helmet != null)
		{
			helmet.setPlainVariant();
			this.m.Items.equip(helmet);
		}
	}

});

