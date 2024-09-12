this.diff_tester <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.diff_tester";
		this.m.Name = "Check boss battles difficulty";
		this.m.Description = "";
		this.m.Icon = "loot/diff_tester.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Loot;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1;
	}

				function calc_diff()
				{
					local gt = this.getroottable();
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();
					local maxlvl = 1;
					local lvl = 0;
					for( local i = 0; i < bros.len(); i = ++i )
					{
						local blvl = bros[i].getLevel();
						if (blvl > 12) blvl = 12;
						lvl = lvl + blvl;
						if (blvl > maxlvl)maxlvl = blvl;
					}
					lvl = lvl + maxlvl;
					lvl = (lvl + 0.0) / (bros.len() + 1);
						
					local diff = 1.05;//this.World.Assets.m.CombatDifficulty;
					//if (diff < 1)diff = 1;
					//diff = diff * (this.World.getTime().Days / 100);
					//if (diff < 0.5)diff = 0.5;
					
					diff = gt.tnf_debug.diff * 0.1 * diff * 1.5 * (bros.len() * lvl + maxlvl);
					
					return diff;
				}
	
	function getTooltip()
	{
		local diff = calc_diff();
		
		this.m.Description = "Current difficulty: "+diff;
		
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		return result;
	}

});

