this.twitch_add_perk_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test"
		Name2 = "test"
		Icon = "ui/items/slots/inventory_slot_offhand_unavailable.png"
	},
	function create()
	{
		this.m.ID = "event.twitch_add_perk";
		this.m.Title = "During a rest stop...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{As %dude% approaches the fire, your squad notices that something has changed about him.\nYes, indeed, he is now %item%}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, it happens to everyone.",
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
					text = _event.m.Name + " receives perk " + _event.m.Name2
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