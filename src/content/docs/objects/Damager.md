---
title: Damager
description: Deals damage to characters that come into contact with them. Damagers
---

<!-- This file was @generated by `just docgen-kit-objects`. -->

Deals damage to characters that come into contact with them. Damagers
typically use fixed values.

```luau
Damager = {
	-- Attributes
	Damage: std.Attribute<Damage>,
}
```



## Attributes



### Damage

```luau
Damager.Damage: std.Attribute<Damage>

```

Amount of Damage that should be dealt. See the `Damage` type.



## API



### Types



#### Damage

```luau
export type Damage = number | "Normal" | "Double" | "Quadruple" | "Lethal"

```

Defines the amounts of Damage to be dealt. Positive number can be used to
define variable damage values. Otherwise, the following is used:
| ------------- | -------- |
| Name          | Amount   |
| ------------- | -------- |
| `"Normal"`    | `10`     |
| `"Double"`    | `20`     |
| `"Quadruple"` | `40`     |
| `"Lethal"`    | Infinite |

