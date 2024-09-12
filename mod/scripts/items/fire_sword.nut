this.fire_sword <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.fire_sword";
		this.m.NameList = this.Const.Strings.SwordNames;
		this.m.Description = "The four nations used to live in peace until the Fire Nation started a war...";
		this.m.Categories = "Fire sword";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Condition = 78.0;
		this.m.ConditionMax = 78.0;
		this.m.StaminaModifier = -13;
		this.m.Value = 6200;
		this.m.RegularDamage = 34;
		this.m.RegularDamageMax = 42;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.33;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/fire_sword.png";
		this.m.Icon = "weapons/melee/fire_sword_70x70.png";
		this.m.ArmamentIcon = "fire_sword";
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/fire_slash"));
	}

});

