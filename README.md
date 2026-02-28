
---



CTtTranslate [ctttranslate]

GitHub: https://github.com/crisdan99/ctttranslate

Download: https://content.luanti.org/packages/crisdan99/ctttranslate/

Forum: https://forum.luanti.org/


CTtTranslate is an advanced automatic chat translation mod for Minetest/Luanti servers.
It allows players speaking different languages to communicate seamlessly, while giving full control to the server owner.

Designed to be modular, configurable, and scalable, CTtTranslate is suitable for both small community servers and large multilingual networks.


---

Overview

CTtTranslate dynamically translates chat messages based on each player's selected language.

Instead of using a single global language, every player can configure:

Their target language

Whether translation is enabled

Whether their settings should be saved permanently (if allowed)


When a player sends a message, it is automatically translated per receiver based on their configured language.


---

Features

Automatic real-time chat translation

Per-player language configuration

Supported languages (default):

Spanish

English

Portuguese

Russian


Optional display of original language tag

Configurable chat colors

Global server toggle

Session-based or permanent data storage

API selection (LibreTranslate or Google Translate)

Owner control panel

Modular internal structure



---

Commands

Player Command

/ctt

Opens the personal configuration panel where players can:

Select their language

Enable/disable translation

Choose whether to save their settings (if permitted)



---

Owner Command

/ctranslate

Opens the global configuration panel where the server owner can:

Enable or disable the translator globally

Force language selection on join

Select translation API

Configure Google API key

Toggle original language display

Configure default chat color

Choose session or permanent storage mode

Test translations directly from the panel



---

Storage Modes

CTtTranslate supports two data modes:

Session Mode

Player settings exist only while connected.
All data is removed on disconnect.

Permanent Mode

Player settings are saved inside:

worldpath/Playersct/

Settings are restored automatically on next login.

Storage mode is controlled by the server owner.


---

Translation APIs

Supported APIs:

LibreTranslate

Google Translate (requires API key)


The API can be selected from the owner panel.


---

Configuration

Most settings are managed via the graphical owner panel.

However, advanced configuration can be controlled via minetest.conf (if implemented), including:

Setting	Type	Default	Description

ctt.enabled	bool	true	Enable global translator
ctt.storage_mode	string	session	session or permanent
ctt.show_original	bool	true	Show original language tag
ctt.default_color	string	#FFFFFF	Default chat color



---

How It Works

1. A player sends a chat message.


2. The system detects the sender's language.


3. The message is translated per receiver.


4. Each player sees the message in their configured language.



This ensures multilingual communication without forcing a single global language.


---

Design Goals

CTtTranslate is built to be:

Modular

Cleanly structured

Maintainable

Secure

Expandable

Suitable for long-term server use


The internal architecture avoids improvised or hardcoded systems and is designed for future feature expansion.


---

Installation

1. Place the mod folder inside your mods/ directory.


2. Enable the mod in your world.


3. Configure using /ctranslate.




---

License

GPLv3


---
