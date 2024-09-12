this.nerh_monolith <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A monument hidden for many centuries. What secrets does it hold?";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.nerh_monolith";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 1.0;
        this.m.OnEnter = "event.location.nerh_monolith_enter";
		this.m.Resources = 0;
	}
	
	function onSpawned()
	{
		this.m.Name = "Nerh Monolith";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("monolith_nerh");
	}

});