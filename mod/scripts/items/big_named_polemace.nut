this.big_named_polemace <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.big_named_polemace";
		this.m.NameList = this.Const.Strings.MaceNames;
		this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "Even a weapon as crude as the polemace can be crafted with passion, skill and attention to detail, as this mace impressively proves.";
		this.m.Categories = "Big polemace";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 6000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -11;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 82;
		this.m.ArmorDamageMult = 1.35;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 5;
		this.m.AdditionalAccuracy = 2;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/polemace_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/polemace_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_polemace_01_named_0" + this.m.Variant;
	}

	function createRandomName()
	{
		if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 40)
		{
			if (this.m.SuffixList.len() == 0 || this.Math.rand(1, 100) <= 80)
			{
				return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.getRandomCharacterName(this.Const.Strings.SouthernNamesLastUnique) + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
		else
		{
			return this.getRandomCharacterName(this.Const.Strings.NomadChampionUnique) + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill = this.new("scripts/skills/actives/crumble_skill");
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/knock_over_skill");
		this.addSkill(skill);
	}

});

