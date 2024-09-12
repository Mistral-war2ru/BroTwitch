this.twitch_add_player_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test"
	},
	function create()
	{
		this.m.ID = "event.twitch_add_player";
		this.m.Title = "New member of squad";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%dude% joins the party.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome!",
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
	}

	function onClear(){}
});