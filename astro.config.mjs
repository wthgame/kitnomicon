// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

import tailwindcss from "@tailwindcss/vite";

// https://astro.build/config
export default defineConfig({
	site: "https://wthgame.github.io/kitnomicon",
	base: "kitnomicon",

	integrations: [
		starlight({
			title: "The Kitnomicon",
			sidebar: [
				{
					label: "Intro",
					items: [{ label: "Installation", slug: "intro/installation" }],
				},
				{
					label: "Guides",
					items: [
						{ label: "Example Guide", slug: "guides/example" },
						{ label: "Writing KitTagObjects", slug: "guides/writing-tag-objects" },
					],
				},
				{
					label: "Objects",
					autogenerate: { directory: "objects" },
				},
				{
					label: "Standard Library",
					autogenerate: { directory: "std" },
				},
			],
			customCss: ["./src/styles/global.css"],
		}),
	],

	vite: {
		plugins: [tailwindcss()],
	},
});
