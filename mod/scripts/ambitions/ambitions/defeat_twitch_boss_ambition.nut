this.defeat_twitch_boss_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_twitch_boss";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Your twitch viewers said you can find some super strong bosses, if we can defeat them we will become incredibly famous for sure!";
		this.m.UIText = "Defeat special boss";
		this.m.TooltipText = "Defeat special boss, you can find it on contract or it can be summoned by twitch chat.";
		this.m.SuccessText = "[img]gfx/ui/events/event_89.png[/img]Very good! We actually was able to beat special boss!";
		this.m.SuccessButtonText = "This is success, this is victory!";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.twitch")
		{
			return;
		}
		
		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Flags.get("IsTwitchBossDefeated"))
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}
	
	function onReward()
	{
		this.World.Assets.addMoney(1000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "You got [color=" + this.Const.UI.Color.PositiveEventValue + "]1000[/color] moneys"
		});
	}
	
	function onStart()
	{
		this.World.Flags.set("IsTwitchBossSearch", true);
	}

	function onCheckSuccess()
	{
		if (this.World.Flags.get("IsTwitchBossDefeated"))
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

