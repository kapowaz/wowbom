Wowbom Plans
============

General, unstructured plans and ideas for future development of wowbom.

Blizzard API
------------

  Public Key: YQJ061E0S00W
  Private Key: 9CLT03T3PVB1

Branding, Look and Feel
-----------------------
* Different name? wowstreet, wowtrader, bro.kr etc.?
* iPhone stylesheet
* Polish pass on overall aesthetic
* Browser testing

Resque Workers
--------------

* Auction House Data
* Items
* Recipes
* Realms
* Think about ideal scheduling for all of the above

Registered Users
----------------

* Authentication using [Warden](http://upperfloor.posterous.com/sinatra-warden) and [dm-is-authenticatable](https://github.com/postmodern/dm-is-authenticatable)
* Preferences
  - Realm
  - Faction
  - Characters and professions
* Recipes you know ([for example](http://eu.battle.net/api/wow/character/Alonsus/Elethiomel?fields=professions); [docs](http://blizzard.github.com/api-wow-docs/#id3682393))
* Automatically tell you most profitable recipes based on current market data and item availability

Generic Functionality
---------------------

* Add a selection of popular item recipes to the homepage
* Add a route for items by name ([see here](https://gist.github.com/47648fb3fb87fa2cd531#file_wowhead.textile))
* Indicate the source (i.e. rarity) of the recipe itself
* Automatically determine if an item would be cheaper to craft using sub-materials (e.g. ore instead of bars etc.)
  - Expand each item in a recipe to provide controls for pricing that way
  - Add options to choose whether to determine: overall cheapest / cheapest I can make an item / cheapest using direct materials
* Find-as-you-type for search box
* Trends graphs to show how prices of a given item have fluctuated using [Raphael](http://g.raphaeljs.com/)

Refactoring
-----------

* Refine existing JS to be fit for purpose (i.e. remove extraneous stuff)

Future Architecture
-------------------

* Determine average value based on all realms as well as per realm/faction
* Auction Alerts!
* Full DM-powered ORM interface to the auction house -> maybe a separate project entirely with restful interface?

Food for thought
----------------

* Adverts?
* How else to make this profitable — mailing list signups

IOU Beer
--------

* khaase (Konstantin Haase)
* Mon_Ouie (?)
* solnic (Piotr Solnica)
* dkubb (Dan Kubb)