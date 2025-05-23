---
title: MovingTexture
description: Continuously moves a Texture horizontally and vertically, also known as
---

<!-- This file was @generated by `just docgen-kit-objects`. -->

Continuously moves a Texture horizontally and vertically, also known as
it's UV coordinates.

```luau
MovingTexture = {
	-- Attributes
	HorizontalLoop: std.Attribute<boolean>,
	HorizontalOffset: std.Attribute<number>,
	HorizontalSpeed: std.Attribute<number>,
	Synchronized: std.Attribute<boolean>,
	VerticalLoop: std.Attribute<boolean>,
	VerticalOffset: std.Attribute<number>,
	VerticalSpeed: std.Attribute<number>,
}
```



## Attributes



### HorizontalLoop

```luau
MovingTexture.HorizontalLoop: std.Attribute<boolean>

```

If enabled, the MovingTexture will loop back to it's `HorizontalOffset` once
it exceeds the `StudsPerTileU` value. May help prevent floating point
errors.





### HorizontalOffset

```luau
MovingTexture.HorizontalOffset: std.Attribute<number>

```

The initial or current horizontal offset, or the U-coordinate, of the
texture. Defaults to the Texture's `OffsetStudsU` when loaded.





### HorizontalSpeed

```luau
MovingTexture.HorizontalSpeed: std.Attribute<number>

```

The speed, in studs per second, at which the texture moves horizontally
along its U-coordinate. A positive value moves it right, a negative value
moves it left.





### Synchronized

```luau
MovingTexture.Synchronized: std.Attribute<boolean>

```

If enabled, MovingTexture will be offsetted based on the kit's loaded
lifetime, therefore never desyncing. If not, MovingTexture will increment
it's offset every frame.
Synchronized should be used when MovingTextures are being chained to create
one continous patterns, so it doesn't desync.
Synchronized should not be used when the speed of MovingTextures
will change, or else it looks jittery. Disabling Synchronized will allow the
MovingTexture to adopt the new texture speed.





### VerticalLoop

```luau
MovingTexture.VerticalLoop: std.Attribute<boolean>

```

If enabled, the MovingTexture will loop back to it's `VerticalOffset` once
it exceeds the `StudsPerTileV` value. May help prevent floating point
errors.





### VerticalOffset

```luau
MovingTexture.VerticalOffset: std.Attribute<number>

```

The initial or current vertical offset, or the V-coordinate, of the texture.
Defaults to the Texture's `OffsetStudsV` when loaded.





### VerticalSpeed

```luau
MovingTexture.VerticalSpeed: std.Attribute<number>

```

The speed, in studs per second, at which the texture moves vertically
along its V-coordinate. A positive value moves it up, a negative value
moves it down.

