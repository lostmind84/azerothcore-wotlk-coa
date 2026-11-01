-- Worldforged Death Trophy (#10553): rev_20261031_01_death_trophy.sql raised the Zul'Kunda pickup (gameobject guid
-- 6941373, entry 95732) out of the floor (#10507), but rev_20261031_01_death_trophy_revert.sql sorts after it and
-- put the old height back (49.808, 0.11 yd under the terrain). Raise it again, in a file that sorts after the revert.
UPDATE `gameobject` SET `position_z` = 50.16064 WHERE `guid` = 6941373 AND `id` = 95732 AND `map` = 0;
