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
			social: [
				{
					icon: "github",
					label: "GitHub",
					href: "https://github.com/wthgame/kitnomicon",
				},
			],
			title: "The Kitnomicon",
			sidebar: [
				{
					label: "Intro",
					items: [
						{
							label: "The Kitnomicon",
							slug: "",
						},
						{
							label: "Installation",
							slug: "installation",
						},
					],
				},
				{
					label: "Guides",
					autogenerate: { directory: "guides" },
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
