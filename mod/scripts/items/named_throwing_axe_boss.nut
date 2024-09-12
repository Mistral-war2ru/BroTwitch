this.named_throwing_axe_boss <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function create()
	{
		this.named_weapon.create();
		this.m.Ammo = 12;
		this.m.AmmoMax = 12;
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_throwing_axe_boss";
		//this.m.NameList = this.Const.Strings.ThrowingAxeNames;
		this.m.Description = "Throwing necro axe. Emits dark energy.";
		this.m.Categories = "Throwing.";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 4400;
		this.m.RangeMin = 1;
		this.m.RangeMax = 5;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -25;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.4;
		this.m.ShieldDamage = 0;
		this.m.ChanceToHitHead = 15;
		this.randomizeValues();
	}

	function updateVariant()
	{
		if (this.m.Ammo > 0)
		{
			this.m.IconLarge = "weapons/melee/throwing_axes_01_named_0" + this.m.Variant + ".png";
			this.m.Icon = "weapons/melee/throwing_axes_01_named_0" + this.m.Variant + "_70x70.png";
			this.m.ArmamentIcon = "icon_named_throwing_axes_0" + this.m.Variant;
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.IconLarge = "weapons/ranged/throwing_axes_01_bag.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_bag_70x70.png";
			this.m.ArmamentIcon = "icon_named_throwing_axes_0" + this.m.Variant;
			this.m.ShowArmamentIcon = false;
		}
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/throw_necro_axe"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);
		this.updateVariant();
		this.updateAppearance();
	}

});

