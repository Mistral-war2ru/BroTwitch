this.nerh_khopesh <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.nerh_khopesh";
		//this.m.NameList = this.Const.Strings.CleaverNames;
		//this.m.PrefixList = this.Const.Strings.OldWeaponPrefix;
		//this.m.UseRandomName = false;
		this.m.Description = "A fine jade blade, a legacy of an ancient empire.";
		this.m.Categories = "Single hand";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 5200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 62.0;
		this.m.ConditionMax = 62.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.35;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/nerh_khopesh.png";
		this.m.Icon = "weapons/melee/nerh_khopesh_70x70.png";
		this.m.ArmamentIcon = "nerh_khopesh";
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

