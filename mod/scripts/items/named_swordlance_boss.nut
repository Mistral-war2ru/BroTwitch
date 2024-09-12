this.named_swordlance_boss <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_swordlance_boss";
		//this.m.NameList = this.Const.Strings.SwordlanceNames;
		//this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		//this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "Only the strongest are able to wield this incredibly huge scythe.";
		this.m.Categories = "Big scythe";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 6200;
		this.m.ShieldDamage = 4;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -25;
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 2;
		//this.m.RegularDamage = 75;
		//this.m.RegularDamageMax = 96;
		this.m.RegularDamage = this.Math.round(64 * this.Math.rand(110, 125) * 0.01);
		this.m.RegularDamageMax = this.Math.round(80 * this.Math.rand(110, 120) * 0.01);
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.5;
		//this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/swordlance_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/swordlance_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_swordlance_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		
		local strike1 = this.new("scripts/skills/actives/strike_skill");
		local strike = this.new("scripts/skills/actives/big_strike_skill");
		strike.m.Icon = "skills/active_200.png";
		strike.m.IconDisabled = "skills/active_200_sw.png";
		strike.m.Overlay = "active_200";
		strike.m.Name = strike1.m.Name;
		strike.m.Description = strike1.m.Description;
		this.addSkill(strike);
		
		local reap1 = this.new("scripts/skills/actives/reap_skill");
		local reap = this.new("scripts/skills/actives/big_reap_skill");
		reap.m.Icon = "skills/active_201.png";
		reap.m.IconDisabled = "skills/active_201_sw.png";
		reap.m.Overlay = "active_201";
		reap.m.Name = reap1.m.Name;
		reap.m.Description = reap1.m.Description;
		this.addSkill(reap);
	}

});

