this.fire_noble_billman <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Billman;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Billman.XP;
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
		b.setValues(this.Const.Tactical.Actor.Billman);
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
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
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
		
			r = this.Math.rand(0, 3);

			if (r <= 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/billhook"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/pike"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/polehammer"));
			}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/armor/gambeson"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
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

			helmet.setPlainVariant();
			this.m.Items.equip(helmet);
		}
		else
		{
			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/aketon_cap"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/aketon_cap"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/headscarf"));
			}
		}
	}

});

