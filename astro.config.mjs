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
			logo: {
				src: "./src/assets/wth-logo.png",
			},
			social: [
				{
					icon: "github",
					label: "GitHub",
					href: "https://github.com/wthgame/kitnomicon",
				},
			],
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
			customCss: [
				"./src/styles/global.css",
				"@fontsource/merriweather/300.css",
				"@fontsource/merriweather/400.css",
				"@fontsource/merriweather/500.css",
				"@fontsource/merriweather/600.css",
				"@fontsource/merriweather/700.css",
				"@fontsource/merriweather/800.css",
				"@fontsource/merriweather/900.css",
			],
		}),
	],

	vite: {
		plugins: [tailwindcss()],
	},
});
