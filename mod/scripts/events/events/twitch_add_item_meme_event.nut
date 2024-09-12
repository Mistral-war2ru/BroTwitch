this.twitch_add_item_meme_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test"
		Name2 = "test"
		Icon = "ui/items/slots/inventory_slot_offhand_unavailable.png"
	},
	function create()
	{
		this.m.ID = "event.twitch_add_item_meme";
		this.m.Title = "During a rest stop...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%dude% comes out in front of the entire squad and takes out his\n %item%}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, its started again!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local bros = roster.getAll();          
				foreach( bro in bros )
				{
					if (bro.getNameOnly() == _event.m.Name)
					{
						this.Characters.push(bro.getImagePath());
					}
				}
				this.List.push({
					id = 10,
					icon = _event.m.Icon,
					text = "You gain " + _event.m.Name2
					});
			}

		});
	}

	function onUpdateScore()
	{
		this.m.Score = -100;
	}

	function onPrepare(){}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Name
		]);
		_vars.push([
			"item",
			this.m.Name2
		]);
	}

	function onClear(){}
});