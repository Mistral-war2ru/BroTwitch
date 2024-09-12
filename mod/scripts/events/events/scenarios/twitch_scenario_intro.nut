this.twitch_scenario_intro <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.twitch_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_twitch_intro.png[/img] New stream, new adventure. Will be able the streamer and his chat survive in this dangerous world of battle bros?",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, go ahead and be a hero!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Twitch Chat Integration";
	}


	function onClear()
	{
	}

});
