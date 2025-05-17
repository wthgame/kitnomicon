---
title: Activation
description: A guide in my new Starlight docs site.
---

Many kit objects need to wait for the player to activate it. For example, the
Damager only damages the player when the player touches it.

## Usage

## Implementation

A naive implementation would be:

```luau
Damager:onLoaded(function(trove, dmg)
    -- When the Damager is touched...
    trove:connect(dmg.Touched, function(toucher)
        -- Check if it is the player character...
        local player = Players:GetPlayerFromCharacter(toucher.Parent)
        if player == Players.LocalPlayer then
           -- Take damage!
        end
    end)
end)
```

Later on however, one might want to add more ways of activating this Mechanic,
such as when a box touches it.

Again, a naive implementation would be:

```luau
Damager:onLoaded(function(trove, dmg)
    -- When the Damager is touched...
    trove:connect(dmg.Touched, function(toucher)
        -- Check if it is the player character OR a box...
        local player = Players:GetPlayerFromCharacter(toucher.Parent)
        if
            player == Players.LocalPlayer
            or toucher:HasTag("Box") and toucher:IsDescendantOf(kit.mechanics)
        then
           -- Take damage!
        end
    end)
end)
```

Then, again, one might only want the player or boxes to activate it, on a per
case basis.

Another naive implementation would be:

```luau
local SupportsCharacter = utils.attribute("SupportsCharacter", utils.t.boolean)
local SupportsBox = utils.attribute("SupportsBox", utils.t.boolean)

-- ...

Damager:onLoaded(function(trove, dmg)
    -- When the Damager is touched...
    trove:connect(dmg.Touched, function(toucher)
        -- Check if it is the player character OR a box...
        local player = Players:GetPlayerFromCharacter(toucher.Parent)
        if
            SupportsCharacter(dmg) and player == Players.LocalPlayer
            or SupportsBox(dmg) andtoucher:HasTag("Box") and toucher:IsDescendantOf(kit.mechanics)
        then
           -- Take damage!
        end
    end)
end)
```

One will realize this gets increasingly complex and hard to maintain, especially
if more kinds of activation should be implemented.

### connectActivation

The standard library package exports a `connectActivation` function. This takes
in an instance that should be activated, and a callback to call when it is
activated:

```luau
function std.connectActivation<T: Instance>(
    trove: Trove,
    connectTo: T,
    onActivated: (trove: Trove, instance: T, activationTrove: Trove) -> ()
): ()
```

While connected, `connectActivation` implements the following attributes:

- `Active` for activation
- `ActivationMode`, with `Touch`, `Prompt`, `Click`, and `KeyCode`
- `ActivationKeyCode`, if `ActivationMode(connectedTo) == "KeyCode"`
- `ActivationsRequired`
- `BoxRequiresId` and `RequiredBoxId`

Earlier, the Damager can be refactored as:

```luau
Damager:onLoaded(function(trove, dmg)
    utils.connectActivation(trove, dmg, function()
        -- Take damage!
    end)
end)
```

For ergonomics, the `onActivated` also receives the trove and the instance.

This let's one abstract the `onActivated` callback into it's own function:

```luau
local function takeDamage(trove, dmg, _)
    -- Take damage!
end

Damager:onLoaded(function(trove, dmg)
    utils.connectActivation(trove, dmg, takeDamage)
end)
```

The 3rd argument will be elaborated in the next section.

### One-time Activation

Some Mechanics can be activated once before a cooldown, such as Buttons.

The `onActivated` callback also receives the `activationTrove` as the 3rd
argument, which handles activation.

Simply clean the `activationTrove` to cease activation:

```luau
local function takeDamage(trove, dmg, activationTrove)
    activationTrove:clean()
    -- Take damage!
end

Damager:onLoaded(function(trove, dmg)
    utils.connectActivation(trove, dmg, takeDamage)
end)
```

Later, usually after a cooldown, one might want to make it activatable again.

One can just re`connectActivation`:

```luau
-- Define a cooldown...
local Cooldown = utils.attribute("Cooldown", utils.t.numberPositive, 0)

local function takeDamage(trove, dmg, activationTrove)
    activationTrove:clean()

    -- Take damage!

    -- Once the cooldown finishes...
    task.delay(Cooldown(dmg), function(trove, dmg)
        -- Reconnect activation!
        utils.connectActivation(trove, dmg, takeDamage)
    end, trove, dmg)
end

Damager:onLoaded(function(trove, dmg)
    utils.connectActivation(trove, dmg, takeDamage)
end)
```

### onActivated

Using the `onActivated` tag lifecycle, the below code:

```luau
Damager:onLoaded(function(trove, dmg)
    utils.connectActivation(trove, dmg, takeDamage)
end)
```

Can be shortened as:

```luau
Damager:onActivated(takeDamage)
```

Note that one will still need to reconnect activation if one needs to cease
activation.
