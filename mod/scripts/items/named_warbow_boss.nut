this.named_warbow_boss <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_warbow_boss";
		this.m.NameList = this.Const.Strings.BowNames;
		this.m.Description = "This bow uses the life force of the owner to form arrows.";
		this.m.Categories = "Bow, spirit arrows";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4600;
		this.m.RangeMin = 2;
		this.m.RangeMax = 7;
		this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -20;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 10;
		this.m.RegularDamageMax = 16;
		this.m.ArmorDamageMult = 0.0;
		this.m.DirectDamageMult = 2.0;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/ranged/bow_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/ranged/bow_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_bow_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();

		this.addSkill(this.new("scripts/skills/actives/aimed_shot_boss"));
	}

});

