this.kosa <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.kosa";
		this.m.Name = "Death reaper";
		//this.m.NameList = this.Const.Strings.SwordlanceNames;
		//this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		//this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "Death is coming for you...";
		this.m.Categories = "Special";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = true;
		this.m.Value = 20000;
		this.m.ShieldDamage = 24;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -27;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 80;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.5;
		//this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/kosa.png";
		this.m.Icon = "weapons/melee/kosa_70x70.png";
		this.m.ArmamentIcon = "kosa";
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_200.png";
		strike.m.IconDisabled = "skills/active_200_sw.png";
		strike.m.Overlay = "active_200";
		this.addSkill(strike);
		
		//local reap = this.new("scripts/skills/actives/swing");
		local reap = this.new("scripts/skills/actives/reap_skill");
		reap.m.Icon = "skills/active_201.png";
		reap.m.IconDisabled = "skills/active_201_sw.png";
		reap.m.Overlay = "active_201";
		this.addSkill(reap);
		
		local roun = this.new("scripts/skills/actives/round_swing");
		roun.m.Icon = "skills/active_06.png";
		roun.m.IconDisabled = "skills/active_06_sw.png";
		roun.m.Overlay = "active_06";
		this.addSkill(roun);
		
		local shld = this.new("scripts/skills/actives/split_shield");
		shld.setFatigueCost(shld.getFatigueCostRaw() + 5);
		this.addSkill(shld);
	}

});

