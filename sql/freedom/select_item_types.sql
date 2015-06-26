SELECT 
	CASE class
		WHEN 0 THEN 'Consumable'
		WHEN 1 THEN 'Container'
		WHEN 2 THEN 'Weapon'
		WHEN 3 THEN 'Gem'
		WHEN 4 THEN 'Armor'
		WHEN 5 THEN 'Reagent'
		WHEN 6 THEN 'Projectile'
		WHEN 7 THEN 'Trade Goods'
		WHEN 8 THEN 'Generic(OBSOLETE)'
		WHEN 9 THEN 'Recipe'
		WHEN 10 THEN 'Money(OBSOLETE)'
		WHEN 11 THEN 'Quiver'
		WHEN 12 THEN 'Quest'
		WHEN 13 THEN 'Key'
		WHEN 14 THEN 'Permanent(OBSOLETE)'
		WHEN 15 THEN 'Miscellaneous'
		WHEN 16 THEN 'Glyph'
		ELSE CONCAT('UNKNOWN CLASSIFIER: ', class)
	END AS `ITEM CLASS`,
	
	CASE class
		WHEN 0 THEN
			CASE subclass
				WHEN 0 THEN 'Consumable'
				WHEN 1 THEN 'Potion'
				WHEN 2 THEN 'Elixir'
				WHEN 3 THEN 'Flask'
				WHEN 4 THEN 'Scroll'
				WHEN 5 THEN 'Food & Drink'
				WHEN 6 THEN 'Item Enhancement'
				WHEN 7 THEN 'Bandage'
				WHEN 8 THEN 'Other'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 1 THEN
			CASE subclass
				WHEN 0 THEN 'Bag'
				WHEN 1 THEN 'Soul Bag'
				WHEN 2 THEN 'Herb Bag'
				WHEN 3 THEN 'Enchanting Bag'
				WHEN 4 THEN 'Engineering Bag'
				WHEN 5 THEN 'Gem Bag'
				WHEN 6 THEN 'Mining Bag'
				WHEN 7 THEN 'Leatherworking Bag'
				WHEN 8 THEN 'Inscription Bag'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 2 THEN
			CASE subclass
				WHEN 0 THEN 'Axe - One Handed'
				WHEN 1 THEN 'Axe - Two Handed'
				WHEN 2 THEN 'Bow'
				WHEN 3 THEN 'Gun'
				WHEN 4 THEN 'Mace - One Handed'
				WHEN 5 THEN 'Mace - Two Handed'
				WHEN 6 THEN 'Polearm'
				WHEN 7 THEN 'Sword - One Handed'
				WHEN 8 THEN 'Sword - Two Handed'
				WHEN 9 THEN 'Obsolete'
				WHEN 10 THEN 'Staff'
				WHEN 11 THEN 'Exotic'
				WHEN 12 THEN 'Exotic'
				WHEN 13 THEN 'Fist Weapon'
				WHEN 14 THEN 'Miscellaneous'
				WHEN 15 THEN 'Dagger'
				WHEN 16 THEN 'Thrown'
				WHEN 17 THEN 'Spear'
				WHEN 18 THEN 'Crossbow'
				WHEN 19 THEN 'Wand'
				WHEN 20 THEN 'Fishing Pole'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 3 THEN
			CASE subclass
				WHEN 0 THEN 'Red'
				WHEN 1 THEN 'Blue'
				WHEN 2 THEN 'Yellow'
				WHEN 3 THEN 'Purple'
				WHEN 4 THEN 'Green'
				WHEN 5 THEN 'Orange'
				WHEN 6 THEN 'Meta'
				WHEN 7 THEN 'Simple'
				WHEN 8 THEN 'Prismatic'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 4 THEN
			CASE subclass
				WHEN 0 THEN 'Miscellaneous'
				WHEN 1 THEN 'Cloth'
				WHEN 2 THEN 'Leather'
				WHEN 3 THEN 'Mail'
				WHEN 4 THEN 'Plate'
				WHEN 5 THEN 'Buckler(OBSOLETE)'
				WHEN 6 THEN 'Shield'
				WHEN 7 THEN 'Libram'
				WHEN 8 THEN 'Idol'
				WHEN 9 THEN 'Totem'
				WHEN 10 THEN 'Sigil'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 5 THEN
			CASE subclass
				WHEN 0 THEN 'Reagent'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 6 THEN
			CASE subclass
				WHEN 0 THEN 'Wand(OBSOLETE)'
				WHEN 1 THEN 'Bolt(OBSOLETE)'
				WHEN 2 THEN 'Arrow'
				WHEN 3 THEN 'Bullet'
				WHEN 4 THEN 'Thrown(OBSOLETE)'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 7 THEN
			CASE subclass
				WHEN 0 THEN 'Trade Goods'
				WHEN 1 THEN 'Parts'
				WHEN 2 THEN 'Explosives'
				WHEN 3 THEN 'Devices'
				WHEN 4 THEN 'Jewelcrafting'
				WHEN 5 THEN 'Cloth'
				WHEN 6 THEN 'Leather'
				WHEN 7 THEN 'Metal & Stone'
				WHEN 8 THEN 'Meat'
				WHEN 9 THEN 'Herb'
				WHEN 10 THEN 'Elemental'
				WHEN 11 THEN 'Other'
				WHEN 12 THEN 'Enchanting'
				WHEN 13 THEN 'Materials'
				WHEN 14 THEN 'Armor Enchantment'
				WHEN 15 THEN 'Weapon Enchantment'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 8 THEN
			CASE subclass
				WHEN 0 THEN 'Generic(OBSOLETE)'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 9 THEN
			CASE subclass
				WHEN 0 THEN 'Book'
				WHEN 1 THEN 'Leatherworking'
				WHEN 2 THEN 'Tailoring'
				WHEN 3 THEN 'Engineering'
				WHEN 4 THEN 'Blacksmithing'
				WHEN 5 THEN 'Cooking'
				WHEN 6 THEN 'Alchemy'
				WHEN 7 THEN 'First Aid'
				WHEN 8 THEN 'Enchanting'
				WHEN 9 THEN 'Fishing'
				WHEN 10 THEN 'Jewelcrafting'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 10 THEN
			CASE subclass
				WHEN 0 THEN 'Money(OBSOLETE)'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 11 THEN
			CASE subclass
				WHEN 0 THEN 'Quiver(OBSOLETE)'
				WHEN 1 THEN 'Quiver(OBSOLETE)'
				WHEN 2 THEN 'Quiver - Arrows'
				WHEN 3 THEN 'Quiver - Bullets'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 12 THEN
			CASE subclass
				WHEN 0 THEN 'Quest'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 13 THEN
			CASE subclass
				WHEN 0 THEN 'Key'
				WHEN 1 THEN 'Lockpick'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 14 THEN
			CASE subclass
				WHEN 0 THEN 'Permanent'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 15 THEN
			CASE subclass
				WHEN 0 THEN 'Junk'
				WHEN 1 THEN 'Reagent'
				WHEN 2 THEN 'Pet'
				WHEN 3 THEN 'Holiday'
				WHEN 4 THEN 'Other'
				WHEN 5 THEN 'Mount'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		WHEN 16 THEN
			CASE subclass
				WHEN 1 THEN 'Warrior'
				WHEN 2 THEN 'Paladin'
				WHEN 3 THEN 'Hunter'
				WHEN 4 THEN 'Rogue'
				WHEN 5 THEN 'Priest'
				WHEN 6 THEN 'Death Knight'
				WHEN 7 THEN 'Shaman'
				WHEN 8 THEN 'Mage'
				WHEN 9 THEN 'Warlock'
				WHEN 11 THEN 'Druid'
				ELSE CONCAT('UNKNOWN SUBCLASSIFIER: ', subclass)
			END
		ELSE CONCAT('UNKNOWN CLASSIFIER: ', class)
	END AS `ITEM SUBCLASS`,

	COUNT(*) `ITEM COUNT`
FROM world.item_template
GROUP BY class, subclass;