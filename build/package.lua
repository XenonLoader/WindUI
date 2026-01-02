-- Generated from package.json | build/build.sh

return [[
{
    "name": "windui",
    "version": "1.6.64",
    "main": "./dist/main.lua",
    "repository": "https://github.com/Footagesus/WindUI",
    "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
    "author": "Footagesus",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev src/init.lua",
        "dev:example": "bash build/build.sh dev main_example.lua",
        "build": "bash build/build.sh build",
        "live": "python -m http.server 8642",
        "watch": "chokidar \"src/**/*.lua\" \"main.lua\" -c \"npm run dev\"",
        "watch:example": "chokidar \"src/**/*.lua\" \"main_example.lua\" -c \"npm run dev:example\"",
        "live-build": "concurrently \"npm run live\" \"npm run watch\"",
        "example-live-build": "concurrently \"npm run live\" \"npm run watch:example\"",
        "updater": "python updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}]]
