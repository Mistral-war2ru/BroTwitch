this.named_battle_whip_boss <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_battle_whip_boss";
		this.m.NameList = this.Const.Strings.WhipNames;
		this.m.Description = "This whip is much longer than the usual ones. Only skilled warriors will be able to use it.";
		this.m.Categories = "Long whip";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.RangeMin = 1;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 3;
		this.m.Value = 4200;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -16;
		//this.m.RegularDamage = 25;
		//this.m.RegularDamageMax = 55;
		this.m.RegularDamage = this.Math.round(20 * this.Math.rand(110, 125) * 0.01);
		this.m.RegularDamageMax = this.Math.round(40 * this.Math.rand(110, 120) * 0.01);
		this.m.ArmorDamageMult = 0.35;
		this.m.DirectDamageMult = 0.3;
		//this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/whip_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/whip_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_whip_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		
		local skill1 = this.new("scripts/skills/actives/whip_skill");
		local skill = this.new("scripts/skills/actives/big_whip_skill");
		skill.m.Icon = "skills/active_171.png";
		skill.m.IconDisabled = "skills/active_171_sw.png";
		skill.m.Overlay = "active_171";
		skill.m.Name = skill1.m.Name;
		skill.m.Description = skill1.m.Description;
		this.addSkill(skill);
		
		local skill2 = this.new("scripts/skills/actives/disarm_skill");
		local skill = this.new("scripts/skills/actives/big_disarm_skill");
		skill.m.Name = skill2.m.Name;
		skill.m.Description = skill2.m.Description;
		this.addSkill(skill);
	}

});

