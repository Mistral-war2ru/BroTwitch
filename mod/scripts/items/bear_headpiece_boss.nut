this.bear_headpiece_boss <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.bear_headpiece_boss";
		this.m.Name = "Bear Headpiece";
		this.m.Description = "The skin of a great northern bear, reinforced with obsidian inserts.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.IsIndestructible = true;
		local variants = [
			190
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		
		this.m.Sprite = "bear_boss_helmet";
		this.m.SpriteDamaged = "bear_boss_helmet_damaged";
		this.m.SpriteCorpse = "bear_boss_helmet_dead";
		this.m.Icon = "helmets/bear_headpiece_boss.png";
		
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 3000;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = 15;
		this.m.Vision = 0;
	}
	
	function updateVariant()
	{
		this.m.Sprite = "bear_boss_helmet";
		this.m.SpriteDamaged = "bear_boss_helmet_damaged";
		this.m.SpriteCorpse = "bear_boss_helmet_dead";
		this.m.Icon = "helmets/bear_headpiece_boss.png";
	}
	
	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		if (this.m.StaminaModifier > 0)
		{
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Stamina [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}
		return result;
	}

});

