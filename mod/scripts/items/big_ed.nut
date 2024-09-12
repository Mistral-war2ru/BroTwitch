this.big_ed <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.big_ed";
		this.m.IsDroppedAsLoot = false;
		//this.m.NameList = this.Const.Strings.MaceNames;
		//this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		//this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "";
		this.m.Categories = "";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 9000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 164.0;
		this.m.ConditionMax = 164.0;
		this.m.StaminaModifier = -1;
		this.m.RangeMin = 1;
		this.m.RangeMax = 10;
		this.m.RangeIdeal = 8;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 15;
		//this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/polemace_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/polemace_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "big_ed";
	}

	function onEquip()
	{
		//this.named_weapon.onEquip();
		this.weapon.onEquip();
		this.setName("ed");
		local skill = this.new("scripts/skills/actives/crumble_big_ed_skill");
		this.addSkill(skill);
	}

});

