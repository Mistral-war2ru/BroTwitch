this.fire_noble_arbalester <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Arbalester;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Arbalester.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_ranged_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Arbalester);
		b.TargetAttractionMult = 1.1;
		b.IsSpecializedInCrossbows = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_military");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
	}

	function assignRandomEquipment()
	{
		local r;
		local banner = 4;

		this.m.Surcoat = banner;

		if (this.Math.rand(1, 100) <= 80)
		{
			this.getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));
		}

		if (this.Math.rand(1, 100) <= 66)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/crossbow"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/weapons/heavy_crossbow"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/gambeson"));
		}

		local r = this.Math.rand(1, 5);
		local helmet;

		if (r == 1)
		{
			helmet = this.new("scripts/items/helmets/aketon_cap");
		}
		else if (r == 2)
		{
			helmet = this.new("scripts/items/helmets/full_aketon_cap");
		}
		else if (r == 3)
		{
			helmet = this.new("scripts/items/helmets/mail_coif");
		}
		else if (r == 4)
		{
			helmet = this.new("scripts/items/helmets/headscarf");
		}

		if (helmet != null)
		{
			helmet.setPlainVariant();
			this.m.Items.equip(helmet);
		}
	}

});

