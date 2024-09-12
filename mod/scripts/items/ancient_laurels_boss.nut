this.ancient_laurels_boss <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.ancient_laurels_boss";
		this.m.Name = "Ancient Laurels";
		this.m.Description = "Ancient golden laurels. Represents greatness.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.IsIndestructible = true;
		local variants = [
			153
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.Icon = "helmets/ancient_laurels_boss.png";
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = 5;
		this.m.Vision = 1;
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

